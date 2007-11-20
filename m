Return-Path: <linux-kernel-owner+w=401wt.eu-S1759528AbXKTXMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbXKTXMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXKTXMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:12:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:49571 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750794AbXKTXME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:12:04 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18Sl5N/CWYSLzda+XfNzO0ZPxs4c05J4DvL+gBKMx
	cQxIr6Gxf+Xkmo
From: Helge Deller <deller@gmx.de>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
Date: Wed, 21 Nov 2007 00:11:57 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>
References: <200711182038.22055.deller@gmx.de> <200711202259.58745.deller@gmx.de> <20071120225547.GE19691@waste.org>
In-Reply-To: <20071120225547.GE19691@waste.org>
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?utf-8?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?utf-8?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?utf-8?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bdc=5E=5FY?=
 =?utf-8?q?=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711210011.58196.deller@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007, Matt Mackall wrote:
> On Tue, Nov 20, 2007 at 10:59:58PM +0100, Helge Deller wrote:
> > > > Current implemenations use userspace-libraries. In userspace you e.g. can't 
> > > > easily protect the uniquness of a UUID against other running _processes_.
> > > > If you try do, you'll need to do locking e.g. with shared memory, which can 
> > > > get very expensive.
> > > 
> > > Even with a futex? Or userspace atomics? 
> > 
> > Yes, you'll need a futex or similiar.
> > The problem is then more, where will you put that futex to be able to protect against other processes ? 
> > Best solution is probably shared memory, but then the question will be, who is allowed to access this memory/futex ?
> > Will any process (shared library) be allowed to read/write/delete it ?
> > At this stage you then suddenly run from a locking-problem into a security problem, which is probably equally hard to solve.
> > Btw, this is how Novell tried to solve the time-based UUID generator problem in SLES and it's still not 100% fixed.
> > 
> > > I think something as simple 
> > > as a server stuffing a bunch of clock sequence numbers into a pipe
> > > for clients to pop into their generated UUIDs should be plenty fast
> > > enough.
> > 
> > Sounds simple and is probably fast enough.
> > But do you really want to add then another daemon to the Linux system, just in case "some" application needs somewhen a UUID ?
> 
> This really is the crux of the problem. I really don't want to add 1K
> of unpageable memory to every kernel in the world for a feature that
> can be implemented in userspace, just in case "some" application needs
> a UUID.

Again, it could be made a config option in which case you could disable 
it if you don't want it.

> 
> > True, but let's look at the facts.
> > 
> > Current libuuid.so (from e2fsprogs) library on Fedora 7 (i386):
> >    text    data     bss     dec     hex filename
> >    8101     368      40    8509    213d /lib/libuuid.so.1
> > 
> > And the kernel implementation:
> >    text    data     bss     dec     hex filename
> >    4877     604    2080    7561    1d89 drivers/char/random.o.without_uuid
> >    5976     752    2080    8808    2268 drivers/char/random.o.withuuid
> 
> I don't think that's a very good comparison. Here's a trivial (but untested)
> implementation of RFC 4122 (variant 4) that's collision-safe and very tiny:
> 
> /* RFC4122-compliant UUID containing 128 - 4 - 2 - 1 = 121 bits of entropy */
> void genrfc4122(char *buf)
> {
>         int f;
>         f = open("/dev/urandom", O_RDONLY);
>         read(f, buf, 16); /* fill our buffer */
> 	close(f);
>         /* sec4.4: set clock_seq_hi_and_reserved bits 6 and 7 to 0 and 1 */
>         buf[8] = (buf[8] & ~0x3f) | 0x80;
>         /* sec4.4: and high nibble of time_hi_and_version to 4 = "random" */
>         buf[6] = (buf[6] & 0xf) | 0x40;
>         /* sec4.5: set multicast bit to indicate random node (lsb of node[0])*/
>         buf[10] |= 1;
> }
> 
> $ size rfc4122.o
>    text    data     bss     dec     hex filename
>      95       0       0      95      5f rfc4122.o

Nice example, but it's not comparable since it's not what this thread is about.
As you mentioned, you showed here a variant 4 (fully random) version.
You could have shown this even more easily, without any additional code:

[deller@halden linux-2.6]$ cat /proc/sys/kernel/random/uuid
607e598a-b0f2-4d60-9ca7-22838d2120ba

This is already in the kernel and it's allocating some non-swapable memory already.

My patch is about variant 1 (time-based), which is not that easy to make unique!
 
> Modern kernels guarantee that simultaneous readers don't see the same
> pool state, so collisions should be exceedingly rare. While collisions
> are still possible here, frankly I think they are much less likely
> than with schemes that involve persistent state, hardware ids, or
> time. The odds of the persistent state or hardware ids being
> mismanaged or the clock being off are quite terrestrial rather than
> astronomical.

That's only relevant to variant 4, not 1.

Helge
