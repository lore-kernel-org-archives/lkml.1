Return-Path: <linux-kernel-owner+w=401wt.eu-S1763701AbXKTXf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763701AbXKTXf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762680AbXKTXfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:35:09 -0500
Received: from waste.org ([66.93.16.53]:49027 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbXKTXfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:35:07 -0500
Date: Tue, 20 Nov 2007 17:34:50 -0600
From: Matt Mackall <mpm@selenic.com>
To: Helge Deller <deller@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
Message-ID: <20071120233450.GF19691@waste.org>
References: <200711182038.22055.deller@gmx.de> <200711202259.58745.deller@gmx.de> <20071120225547.GE19691@waste.org> <200711210011.58196.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711210011.58196.deller@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 12:11:57AM +0100, Helge Deller wrote:
> On Tuesday 20 November 2007, Matt Mackall wrote:
> > On Tue, Nov 20, 2007 at 10:59:58PM +0100, Helge Deller wrote:
> > > > > Current implemenations use userspace-libraries. In userspace you e.g. can't 
> > > > > easily protect the uniquness of a UUID against other running _processes_.
> > > > > If you try do, you'll need to do locking e.g. with shared memory, which can 
> > > > > get very expensive.
> > > > 
> > > > Even with a futex? Or userspace atomics? 
> > > 
> > > Yes, you'll need a futex or similiar.
> > > The problem is then more, where will you put that futex to be able to protect against other processes ? 
> > > Best solution is probably shared memory, but then the question will be, who is allowed to access this memory/futex ?
> > > Will any process (shared library) be allowed to read/write/delete it ?
> > > At this stage you then suddenly run from a locking-problem into a security problem, which is probably equally hard to solve.
> > > Btw, this is how Novell tried to solve the time-based UUID generator problem in SLES and it's still not 100% fixed.
> > > 
> > > > I think something as simple 
> > > > as a server stuffing a bunch of clock sequence numbers into a pipe
> > > > for clients to pop into their generated UUIDs should be plenty fast
> > > > enough.
> > > 
> > > Sounds simple and is probably fast enough.
> > > But do you really want to add then another daemon to the Linux system, just in case "some" application needs somewhen a UUID ?
> > 
> > This really is the crux of the problem. I really don't want to add 1K
> > of unpageable memory to every kernel in the world for a feature that
> > can be implemented in userspace, just in case "some" application needs
> > a UUID.
> 
> Again, it could be made a config option in which case you could disable 
> it if you don't want it.

That's not an argument; it applies to any proposed feature. And it's
largely a no-op because most vendors will turn all potentially useful
features on. So we still end up with 1K of unpageable memory in
approximately every kernel in the world.

We don't like to add things to the kernel that can be done
sufficiently well in userspace. Once it's in the kernel, it's
potentially stuck there for all of time because people may come to
depend on it.

> As you mentioned, you showed here a variant 4 (fully random) version.
> You could have shown this even more easily, without any additional code:
> 
> [deller@halden linux-2.6]$ cat /proc/sys/kernel/random/uuid
> 607e598a-b0f2-4d60-9ca7-22838d2120ba

Quite silly to have put that in the kernel when we could have done it
in userspace for 95 bytes, no? But now we're stuck with it for the
foreseeable future. I'd rather it -not- have any friends to keep it
company.

> > Modern kernels guarantee that simultaneous readers don't see the same
> > pool state, so collisions should be exceedingly rare. While collisions
> > are still possible here, frankly I think they are much less likely
> > than with schemes that involve persistent state, hardware ids, or
> > time. The odds of the persistent state or hardware ids being
> > mismanaged or the clock being off are quite terrestrial rather than
> > astronomical.
> 
> That's only relevant to variant 4, not 1.

Sure it is, I'm quite explicitly saying that variant 1 is less safe
-in practical terms- than variant 4.

-- 
Mathematics is the supreme nostalgia of our time.
