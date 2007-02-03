Return-Path: <linux-kernel-owner+w=401wt.eu-S1422977AbXBCLX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422977AbXBCLX5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 06:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423039AbXBCLX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 06:23:56 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58936 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422977AbXBCLX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 06:23:56 -0500
Date: Sat, 3 Feb 2007 01:17:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, dipankar@in.ibm.com,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070203001745.GB1712@elf.ucw.cz>
References: <20070126112837.059502fc.akpm@osdl.org> <20070130073340.GC30160@elte.hu> <20070130160244.GB2092@linux.vnet.ibm.com> <200701301744.48601.rjw@sisk.pl> <20070130102718.f03f37d8.akpm@osdl.org> <20070130194940.GI2092@linux.vnet.ibm.com> <20070131231017.GA2995@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131231017.GA2995@linux.vnet.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Part of what I need to look at.  ;-)
> 
> OK.  This just might be feasible.  That said, there is a lot of code
> containing PF_NOFREEZE that I am not familiar with.  That said, here
> are my thoughts -- this is in addition to the changes to freeze_processes()
> and thaw_processes() called out earlier.
> 
> Thoughts?

Looks ok to me.

> o	Introduce a mutex to prevent overlapping freezes -- or find
> 	out what the heck prevents them at present!!!  (I don't see
> 	anything.)  

swsusp is protected by some giant "doing suspend" mutex. Other users
may be buggy :-).

> o	Replace all the "current->flags |= PF_NOFREEZE" statements with
> 	"exempt_from_freeze(current, int pfe)" or some such.  This would
> 	set the flags bit and also store the pfe argument into the pf_exempt
> 	field.

I'd suggest step 0, remove as many PF_NOFREEZE as possible... ok, you
seem to be doing that one.

> o	init/do_mounts_initrd.c line 57 handle_initrd().
> 	This looks to be short term anyway, so OK to leave.
> 	But does kernel_execve() clear PF_NOFREEZE?
> 
> 	But it should be OK to freeze the init process when doing CPU
> 	hotplug ops, right?

That looks bogus. If it is short term, it can as well live _without_
PF_NOFREEZE. Noone should suspend system at that stage, right?

> o	kernel/softlockup.c line 88 watchdog().  Well, we wouldn't
> 	want false alarms when freezing for hotplug.  Perhaps
> 	temporarily disabling timestamp checking while doing hotplug
> 	would do the trick.  But if hotplug takes the time required
> 	to trigger softlockup (seconds!), we are broken anyway.
> 	The fix would be to speed up the freezing process.

Freezing _can_ take seconds. We do sync in between freezing userspace
and kernel, for example. We avoid freezing in some difficult situations
by waiting for I/O to complete....

> o	net/bluetooth/bnep/core.c line 476 bnep_session().  Suspending
> 	to a bluetooth device???  These guys got -hair-!!!  I bet this
> 	one can tolerate being frozen for hotplugging CPUs -- though
> 	I could imagine the bluetooth protocol needing some TLC after
> 	such an event.  But I don't know enough about bluetooth to do
> 	more than raise the possibility.

Should be fixed. Someone was probably lazy.

> o	net/bluetooth/cmtp/core.c line 290 cmtp_session().  Same as
> 	for bnep_session(), at least as far as I can tell.
> 
> o	net/bluetooth/hidp/core.c line 476 hidp_session().  Same as
> 	for bnep_session(), AFAICT.
> 
> o	net/bluetooth/rfcomm/core.c line 1940 rfcomm_run(). Same as
> 	for bnep_session(), AFAICT.

Someone was definitely lazy :-).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
