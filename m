Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339AbXBDNvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbXBDNvI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 08:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbXBDNvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 08:51:08 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38733 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752339AbXBDNvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 08:51:07 -0500
Date: Sun, 4 Feb 2007 14:50:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, dipankar@in.ibm.com,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070204135049.GC1945@elf.ucw.cz>
References: <20070126112837.059502fc.akpm@osdl.org> <200702041208.56466.rjw@sisk.pl> <20070204125316.GA1945@elf.ucw.cz> <200702041446.18482.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702041446.18482.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > This is needed so that the _resume_ works, when it's handled from the user land
> > > by our resume tool.  Currently, the resume code calls
> > > freeze_processes() too.
> > 
> > I do not understand... freeze_processes() always leaves curent process
> > running... why is it needed?
> 
> IIRC, the do_linuxrc thread cannot be frozen (doesn't call try_to_freeze()),
> so the freeze_processes() during the resume fails and the resume fails as a
> result.

Aha, ok. (We still may want to add try_to_freeze there; there's no
reason to have that running while resuming).

> Still, I have an idea:
> 
> Instead of hunting for PF_NOFREEZE and wondering if the suspend/resume fails
> when we remove them or replace them with try_to_freeze(), why don't we add
> an "ignore_pf_nofreeze" argument to freeze_processes() and make it regard
> _all_ tasks as if they haven't set PF_NOFREEZE when this "ignore_pf_nofreeze"
> is set?  Of course, additionally we'll have to make everyone call
> try_to_freeze(), even if they set PF_NOFREEZE anyway.
> 
> Then, if freeze_processes() is called with "ignore_pf_nofreeze = 0", it will
> work just as it does now.  However, if it's called with
> "ignore_pf_nofreeze = 1", it will try to make all prcesses enter the
> refrigerator.  The "ignore_pf_nofreeze = 0" version will be suitable for us
> (ie. suspend etc.) and the "ignore_pf_nofreeze = 1" version will be suitable
> for the CPU hotplug and such things.

Yep, something like that will be needed. Probably more finegrained
(with flags), because CPU hotplug and kprobes may want their own sets
of unfreezeable processes.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
