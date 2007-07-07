Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbXGGL4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbXGGL4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 07:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbXGGLzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 07:55:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38266 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753023AbXGGLzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 07:55:53 -0400
Date: Sat, 7 Jul 2007 13:48:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: nigel@suspend2.net, rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, oliver@neukum.org, paulus@samba.org, mingo@elte.hu
Subject: possible solution for problem 2 (was Re: [RFC][PATCH -mm] PM: Do not sync filesystems from within the freezer)
Message-ID: <20070707114856.GB2789@elf.ucw.cz>
References: <200707041658.59588.rjw@sisk.pl> <200707061707.23316.nigel@nigel.suspend2.net> <E1I6i0N-0003CY-00@dorka.pomaz.szeredi.hu> <200707061719.36054.nigel@nigel.suspend2.net> <E1I6iMD-0003Gl-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I6iMD-0003Gl-00@dorka.pomaz.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > To get more serious and practical though, I think the solution is to
> > > > fuzz the userspace/kernelspace distinction. What we really want to
> > > > do is freeze things that submit I/O, then sync, then freeze anything
> > > > that processes I/O and needs to be frozen. In effect, redefine fuse
> > > > processes as freezeable kernel threads.
> > > 
> > > Another myth, that has been debunked already.  The problem is: how do
> > > you define fuse processes?  There's no theoretical or even practial
> > > way to do that.
> > 
> > No theoretical or practical way?! I'll freely admit to being quite ignorant 
> > about fuse, but surely there's some way by which they can be distinguished.
> 
> How?  OK, there are some tasks, that read and/or write /dev/fuse. And
> there are some that just communicate in some way with the above.

(Not that I'm advocating this, but:)

You could ask fused to identify tasks involved in fuse handling. "Hey,
fused, please give me list of PIDs".

Yes, that would be beyond ugly.

(I guess I'm advocating this:)

We probably can do variation on this. Notify fuse early that suspend
is comming, so we can wait for all the fused requests to be flushed
(/fusectl/*/waiting going to 0), and then just trap tasks trying to
communicate with fuse in a sane place (i.e. not a place where VFS
locks are held).

...I'm not saying this is a nice solution, but it should
work... right...? And should work for hibernation, too...?

(at this point, we still have problem 1: something in s2ram path
causes fuse to communicate with its frozen fused. It is not sync, so
what is it?)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
