Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbXBDN7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbXBDN7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 08:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXBDN7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 08:59:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58841 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbXBDN7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 08:59:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Date: Sun, 4 Feb 2007 14:59:48 +0100
User-Agent: KMail/1.9.1
Cc: paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, dipankar@in.ibm.com,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
References: <20070126112837.059502fc.akpm@osdl.org> <200702041446.18482.rjw@sisk.pl> <20070204135049.GC1945@elf.ucw.cz>
In-Reply-To: <20070204135049.GC1945@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702041459.49562.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 4 February 2007 14:50, Pavel Machek wrote:
> Hi!
> 
> > > > This is needed so that the _resume_ works, when it's handled from the user land
> > > > by our resume tool.  Currently, the resume code calls
> > > > freeze_processes() too.
> > > 
> > > I do not understand... freeze_processes() always leaves curent process
> > > running... why is it needed?
> > 
> > IIRC, the do_linuxrc thread cannot be frozen (doesn't call try_to_freeze()),
> > so the freeze_processes() during the resume fails and the resume fails as a
> > result.
> 
> Aha, ok. (We still may want to add try_to_freeze there; there's no
> reason to have that running while resuming).
> 
> > Still, I have an idea:
> > 
> > Instead of hunting for PF_NOFREEZE and wondering if the suspend/resume fails
> > when we remove them or replace them with try_to_freeze(), why don't we add
> > an "ignore_pf_nofreeze" argument to freeze_processes() and make it regard
> > _all_ tasks as if they haven't set PF_NOFREEZE when this "ignore_pf_nofreeze"
> > is set?  Of course, additionally we'll have to make everyone call
> > try_to_freeze(), even if they set PF_NOFREEZE anyway.
> > 
> > Then, if freeze_processes() is called with "ignore_pf_nofreeze = 0", it will
> > work just as it does now.  However, if it's called with
> > "ignore_pf_nofreeze = 1", it will try to make all prcesses enter the
> > refrigerator.  The "ignore_pf_nofreeze = 0" version will be suitable for us
> > (ie. suspend etc.) and the "ignore_pf_nofreeze = 1" version will be suitable
> > for the CPU hotplug and such things.
> 
> Yep, something like that will be needed. Probably more finegrained
> (with flags), because CPU hotplug and kprobes may want their own sets
> of unfreezeable processes.

Yes, but for this purpose we'll need to use one more task flag at least, I
think.  Or transform PF_NOFREEZE into a 2-bit field with values from 0 to 3
indicating the "freezing level" at which given task should be frozen and
call freeze_processes() with the level as an argument?

Paul, what is your opnion?

Rafael
