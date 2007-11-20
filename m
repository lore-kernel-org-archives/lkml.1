Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbXKTW4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbXKTW4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbXKTW4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:56:06 -0500
Received: from waste.org ([66.93.16.53]:47005 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbXKTW4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:56:03 -0500
Date: Tue, 20 Nov 2007 16:55:47 -0600
From: Matt Mackall <mpm@selenic.com>
To: Helge Deller <deller@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
Message-ID: <20071120225547.GE19691@waste.org>
References: <200711182038.22055.deller@gmx.de> <200711182240.35015.deller@gmx.de> <20071120063120.GD17536@waste.org> <200711202259.58745.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711202259.58745.deller@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 10:59:58PM +0100, Helge Deller wrote:
> > > Current implemenations use userspace-libraries. In userspace you e.g. can't 
> > > easily protect the uniquness of a UUID against other running _processes_.
> > > If you try do, you'll need to do locking e.g. with shared memory, which can 
> > > get very expensive.
> > 
> > Even with a futex? Or userspace atomics? 
> 
> Yes, you'll need a futex or similiar.
> The problem is then more, where will you put that futex to be able to protect against other processes ? 
> Best solution is probably shared memory, but then the question will be, who is allowed to access this memory/futex ?
> Will any process (shared library) be allowed to read/write/delete it ?
> At this stage you then suddenly run from a locking-problem into a security problem, which is probably equally hard to solve.
> Btw, this is how Novell tried to solve the time-based UUID generator problem in SLES and it's still not 100% fixed.
> 
> > I think something as simple 
> > as a server stuffing a bunch of clock sequence numbers into a pipe
> > for clients to pop into their generated UUIDs should be plenty fast
> > enough.
> 
> Sounds simple and is probably fast enough.
> But do you really want to add then another daemon to the Linux system, just in case "some" application needs somewhen a UUID ?

This really is the crux of the problem. I really don't want to add 1K
of unpageable memory to every kernel in the world for a feature that
can be implemented in userspace, just in case "some" application needs
a UUID.

> True, but let's look at the facts.
> 
> Current libuuid.so (from e2fsprogs) library on Fedora 7 (i386):
>    text    data     bss     dec     hex filename
>    8101     368      40    8509    213d /lib/libuuid.so.1
> 
> And the kernel implementation:
>    text    data     bss     dec     hex filename
>    4877     604    2080    7561    1d89 drivers/char/random.o.without_uuid
>    5976     752    2080    8808    2268 drivers/char/random.o.withuuid

I don't think that's a very good comparison. Here's a trivial (but untested)
implementation of RFC 4122 (variant 4) that's collision-safe and very tiny:

/* RFC4122-compliant UUID containing 128 - 4 - 2 - 1 = 121 bits of entropy */
void genrfc4122(char *buf)
{
        int f;
        f = open("/dev/urandom", O_RDONLY);
        read(f, buf, 16); /* fill our buffer */
	close(f);
        /* sec4.4: set clock_seq_hi_and_reserved bits 6 and 7 to 0 and 1 */
        buf[8] = (buf[8] & ~0x3f) | 0x80;
        /* sec4.4: and high nibble of time_hi_and_version to 4 = "random" */
        buf[6] = (buf[6] & 0xf) | 0x40;
        /* sec4.5: set multicast bit to indicate random node (lsb of node[0])*/
        buf[10] |= 1;
}

$ size rfc4122.o
   text    data     bss     dec     hex filename
     95       0       0      95      5f rfc4122.o

Modern kernels guarantee that simultaneous readers don't see the same
pool state, so collisions should be exceedingly rare. While collisions
are still possible here, frankly I think they are much less likely
than with schemes that involve persistent state, hardware ids, or
time. The odds of the persistent state or hardware ids being
mismanaged or the clock being off are quite terrestrial rather than
astronomical.

-- 
Mathematics is the supreme nostalgia of our time.
