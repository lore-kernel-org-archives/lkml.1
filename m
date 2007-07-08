Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbXGHU4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbXGHU4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 16:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbXGHUzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 16:55:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55400 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756829AbXGHUzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 16:55:54 -0400
Date: Sun, 8 Jul 2007 22:55:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070708205547.GA5401@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org> <1183871661.3388.282.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183871661.3388.282.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> But in a whole lot of cases, it's, I beleive, perfectly kosher to just
> return an error. You're trying to capture frame from your camera while
> the machine is suspended ? error. At worst, your capture app will be
> unhappy when you wakeup, nothing terrible and totally fixable in
> userland if it's a problem.

Well, that way you'd have to teach applications about suspend... Which
is quite bad.  You mentioned it -- returning random errors will be
very bad for machines like OLPC that want to suspend
automatically. Plus it is a step back from current implementation, and
ABI change, too...

> > So instead, why not have the PM core take care of all this?  There
> > could be a block_task_until_suspend_is_over() routine available for all
> > drivers to use.  Its effect would be exactly the same as sending the
> > current task into the freezer, but it wouldn't be the freezer that
> > exists now.  It would just be some routine that blocks until the system 
> > suspend is over.  We could call it "the icebox" instead of "the 
> > freezer".  :-)
> 
> I'm not totally sure about that. I like some of it, but I think it's
> fairly different conceptually from the freezer (and the implementation
> could be as trivial as a single system wide wait queue). 
> 
> Basically it has a very big difference to the current freezer, and I
> like that, which is that we don't have some 3rd party trying to find out
> what to freeze and what not (the freezer), but instead, we have
> explicitely drivers or kernel threads sending -themselves- to the
> "icebox" when they think it's a good idea. Think of it as lazy
> freezing

Kernel threads already send _themselves_ to the refrigerator. [Plus we
put all the userland there, which is what you don't like, but kernel
can not rely on userland after suspend starts, anyway, so it should
not hurt].

Anyway.. PPC currently suspends without freezer, which puts rules on
drivers. ("Must handle i/o requests after .suspend() method is ran,
must not use GFP_KERNEL to do so, must not try to synchronously
communicate with userspace before _all_ devices are unfrozen") I am
not certain what the exact rules are, but you seem to know them. Could
we get Doc*/power/suspend_wo_freezer.txt describing them for driver
authors? That way we can make sure drivers work on ppc, too, and maybe
get rid of freezer in the long run.

> > You also agree that kernel threads and workqueues must be allowed to 
> > operate during suspend.
> 
> Yes, unless kernel threads explicitely decide to stop themselves (for
> example, khubd is a good candidate for that). Again, not a 3rd party
> trying to decide what to freeze and what not, but the drivers or kernel
> threads themselves deciding it.

This is how it works currently in -mm.

(Plus, the rule is that threads that decide _not to_ stop themselves
should not do any I/O.)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
