Return-Path: <linux-kernel-owner+w=401wt.eu-S1759681AbXGEJPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681AbXGEJPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbXGEJP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:15:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57245 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753638AbXGEJP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:15:27 -0400
Date: Thu, 5 Jul 2007 11:15:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Paul Mackerras <paulus@samba.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: removing refrigerator does not help with s2ram vs. fuse deadlocks (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Message-ID: <20070705091526.GA3084@elf.ucw.cz>
References: <18059.6726.218205.104212@cargo.ozlabs.ibm.com> <Pine.LNX.4.44L0.0707041104140.25704-100000@netrider.rowland.org> <18060.15591.556676.28935@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18060.15591.556676.28935@cargo.ozlabs.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The fact remains that lots of drivers would still need to be changed.  
> > In the read and write methods someone would have to add code amounting
> > to this:
> > 
> > 	if (suspend_is_under_way()) {
> > 		mutex_unlock(...);
> > 		block_until_resume();
> > 		goto restart;
> > 	}
> > 
> > Freezing userspace is a small amount of code by comparison.
> 
> Normally devices have some sort of queue of pending operations.  So
> all that is required on suspend is to stop processing the queue and
> wait for any currently-underway operations to complete.  The blocking
> then happens naturally using the normal I/O wait mechanisms.

So... instead of one big freezer (we know it is problematic), you have
100 small freezers, problematic in same way :-(.

Let's take current FUSE problems, and see if they have problem on PPC,
ok?

Let's say FUSE thread touches one of those "blocking" devices. It is
now in D state, somewhere in kernel.... exactly same way refrigerator
works.

Now, if kernel needs FUSE services for some reason (that's the problem
we hit in s2ram case, right?), we have a deadlock.

So main problem still seems to be "kernel should not depend on
userland services during suspend", refrigerator or not.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
