Return-Path: <linux-kernel-owner+w=401wt.eu-S1752295AbXBDLIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbXBDLIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 06:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbXBDLIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 06:08:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58437 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbXBDLIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 06:08:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Date: Sun, 4 Feb 2007 12:08:55 +0100
User-Agent: KMail/1.9.1
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, dipankar@in.ibm.com,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
References: <20070126112837.059502fc.akpm@osdl.org> <20070203001745.GB1712@elf.ucw.cz> <20070204043929.GG5647@linux.vnet.ibm.com>
In-Reply-To: <20070204043929.GG5647@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702041208.56466.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 4 February 2007 05:39, Paul E. McKenney wrote:
> On Sat, Feb 03, 2007 at 01:17:45AM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > > Part of what I need to look at.  ;-)
> > > 
> > > OK.  This just might be feasible.  That said, there is a lot of code
> > > containing PF_NOFREEZE that I am not familiar with.  That said, here
> > > are my thoughts -- this is in addition to the changes to freeze_processes()
> > > and thaw_processes() called out earlier.
> > > 
> > > Thoughts?
> > 
> > Looks ok to me.
> 
> Cool!
> 
> > > o	Introduce a mutex to prevent overlapping freezes -- or find
> > > 	out what the heck prevents them at present!!!  (I don't see
> > > 	anything.)  
> > 
> > swsusp is protected by some giant "doing suspend" mutex. Other users
> > may be buggy :-).
> 
> Ah!  Any reason not to have locking at the level of the
> freeze_processes()/thaw_processes() functions?

I don't think so.  It just wasn't needed before ...

> > > o	Replace all the "current->flags |= PF_NOFREEZE" statements with
> > > 	"exempt_from_freeze(current, int pfe)" or some such.  This would
> > > 	set the flags bit and also store the pfe argument into the pf_exempt
> > > 	field.
> > 
> > I'd suggest step 0, remove as many PF_NOFREEZE as possible... ok, you
> > seem to be doing that one.
> 
> Well, in my little corner of the kernel, anyway.  ;-)
> 
> > > o	init/do_mounts_initrd.c line 57 handle_initrd().
> > > 	This looks to be short term anyway, so OK to leave.
> > > 	But does kernel_execve() clear PF_NOFREEZE?
> > > 
> > > 	But it should be OK to freeze the init process when doing CPU
> > > 	hotplug ops, right?
> > 
> > That looks bogus. If it is short term, it can as well live _without_
> > PF_NOFREEZE. Noone should suspend system at that stage, right?
>
> I agree that any attempt to freeze that early in boot would be
> at best an act of extreme bravery!

This is needed so that the _resume_ works, when it's handled from the user land
by our resume tool.  Currently, the resume code calls freeze_processes() too.
 
> > > o	kernel/softlockup.c line 88 watchdog().  Well, we wouldn't
> > > 	want false alarms when freezing for hotplug.  Perhaps
> > > 	temporarily disabling timestamp checking while doing hotplug
> > > 	would do the trick.  But if hotplug takes the time required
> > > 	to trigger softlockup (seconds!), we are broken anyway.
> > > 	The fix would be to speed up the freezing process.
> > 
> > Freezing _can_ take seconds. We do sync in between freezing userspace
> > and kernel, for example. We avoid freezing in some difficult situations
> > by waiting for I/O to complete....
> 
> OK.  Point taken.
> 
> > > o	net/bluetooth/bnep/core.c line 476 bnep_session().  Suspending
> > > 	to a bluetooth device???  These guys got -hair-!!!  I bet this
> > > 	one can tolerate being frozen for hotplugging CPUs -- though
> > > 	I could imagine the bluetooth protocol needing some TLC after
> > > 	such an event.  But I don't know enough about bluetooth to do
> > > 	more than raise the possibility.
> > 
> > Should be fixed. Someone was probably lazy.
> > 
> > > o	net/bluetooth/cmtp/core.c line 290 cmtp_session().  Same as
> > > 	for bnep_session(), at least as far as I can tell.
> > > 
> > > o	net/bluetooth/hidp/core.c line 476 hidp_session().  Same as
> > > 	for bnep_session(), AFAICT.
> > > 
> > > o	net/bluetooth/rfcomm/core.c line 1940 rfcomm_run(). Same as
> > > 	for bnep_session(), AFAICT.
> > 
> > Someone was definitely lazy :-).
> > 								Pavel
> 
> OK, so we should think in terms of moving these to try_to_freeze(),
> then.

Definitely.

I think we also should try to use freezeable workqueues wherever possible.

Greetings,
Rafael
