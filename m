Return-Path: <linux-kernel-owner+w=401wt.eu-S965480AbXCVABe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965480AbXCVABe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 20:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965513AbXCVABd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 20:01:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:8562 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965480AbXCVABc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 20:01:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=plFQEc7SQhqvfwMysh8hK1WN3iMk18VUdrVRHtFflfeghT2rwmxy34KIae5wMfRtkNoZhfKXtT4fOgT1pL0JTxVnLhc3UbAeYn/rAhcjRoRP4Q8IlTEJOatULzWmDgdlfSPt/wBEVUiFMWZdQYumE7E45iBtOJOesX8qCf3bBG0=
From: Maxim <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Date: Thu, 22 Mar 2007 02:01:23 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <200703211840.53242.maximlevitsky@gmail.com> <200703220139.25071.maximlevitsky@gmail.com> <200703220053.54671.rjw@sisk.pl>
In-Reply-To: <200703220053.54671.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703220201.23897.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2007 01:53:54 Rafael J. Wysocki wrote:
> On Thursday, 22 March 2007 00:39, Maxim wrote:
> > On Thursday 22 March 2007 01:24:25 Rafael J. Wysocki wrote:
> > > On Thursday, 22 March 2007 00:09, Maxim wrote:
> > > > On Thursday 22 March 2007 00:39:02 you wrote:
> > > > > On Wednesday, 21 March 2007 23:21, Pavel Machek wrote:
> > > > > > Hi!
> > > > > > 
> > > > > > > Starting with 2.6.21-rc1 suspend to ram and disk doesn't work anymore on my system.
> > > > > > > 
> > > > > > > I did a git-bisect and found that those commits break it:
> > > > > > > 
> > > > > > > e3c7db621bed4afb8e231cb005057f2feb5db557 - [PATCH] [PATCH] PM: Change code ordering in main.c
> > > > > > > ed746e3b18f4df18afa3763155972c5835f284c5 - [PATCH] [PATCH] swsusp: Change code ordering in disk.c
> > > > > > > 259130526c267550bc365d3015917d90667732f1 - [PATCH] [PATCH] swsusp: Change code ordering in user.c
> > > > > > > 
> > > > > > 
> > > > > > (Yep, it was in my "to analyze" queue).
> > > > > > 
> > > > > > > I already reported about it, but now i know the reason why suspend breaks.
> > > > > > > 
> > > > > > > The problem is that both cpu_up/cpu_down were allowed to sleep until now, 
> > > > > > > and it did work because those functions could be called only in process context
> > > > > > > (the one that writes to /sys/devices/system/cpu/cpu*/online) or  idle thread  that does smp_init()).
> > > > > > > 
> > > > > > > But now they are called _after_ all tasks were suspended, so if cpu_down tries for example to take a lock
> > > > > > > that is taken by different process, it can't since the different proccess is frozen and can't release the lock.
> > > > > > > 
> > > > > > 
> > > > > > Thanks for detailed explanation.
> > > > > > 
> > > > > > ...but, on my machine suspend works ok in -rc4. I'm not seeing this.
> > > > > > 
> > > > > > ...by design, "frozen" tasks must not hold any locks. If frozen task
> > > > > > holds a lock, that's a bug.
> > > > > > 
> > > > > > > Or, it is also possible to revert this change.
> > > > > > 
> > > > > > Are you using xfs?
> > > > > 
> > > > > Well, this is the only case that can trigger it.  There are no other freezable
> > > > > workqueues.
> > > > > 
> > > > > Greetings,
> > > > > Rafael
> > > > > 
> > > > 
> > > > Hello,
> > > > 
> > > > 	Yes, you are right and it is XFS
> > > > 
> > > > 	System suspends and resumes with xfs and your patch correctly,
> > > 
> > > Could you please sent this information to the list?  I'd like it to reach all
> > > of the CCed parites. ;-)
> > 
> > I did now ( sorry I just keep using this Answer command, instead of Answer to everybody)
> > I didn't intend to send private email.
> > > 
> > > > 	Of course I need to mention that I had to unload microcode update driver because it prevented resume,
> > > > 	because it calls firmware loader helper, and again sleeps on lock
> > > 
> > > This is interesting.  Did it happen before or is it a regression?
> > 
> > It is from the same group of bugs , I mean hang because cpu_up/down is called with frozen tasks
> > Of course it didn't happen before those reordering commits were introduced
> 
> Well, we want cpu_up/down to be called after processes have been frozen, for
> various reasons (one of them being that applications shouldn't see us playing
> with the CPUs).
> 
> Thanks for reporting this, I'll have a look at the microcode update driver.
> 
> > > > 	And also I noticed now that system oopses on second attempt to suspend ether to ram or disk
> > > > 	in pci_restore_msi_state which is called indirectly by ahci_pci_device_resume, I will investigate this soon.
> > > 
> > > Thanks.  We've had such reports earlier, but I think the problem is still unresolved.  Any
> > > additional information will be valuable.
> > 
> > I will do my best,
> > Also I want to note that the above problem is 100% repeatable, and happens independently whenever suspend to disk
> > or suspend to ram was used in first successful try ( or at least, I got back-trace using kdb, after suspend to disk, after
> > suspend to ram system hang, so I assume, that this it is same problem , because it didn't hang of first try)
> 
> Thanks for the information.
> 
> BTW, what's the last kernel you have tested?
> 
> Rafael
> 

Hello, 
	Thanks for quick response, 
	I will continue to test my system

I use literally latest Linus's git tree.

The kernel that works is 2.6.20 , and except very weird hang that happens sometimes (1 in 5~6 times) on resume from ram, everything works
I described it in http://lkml.org/lkml/2007/3/16/126

	Regards,
		Maxim Levitsky
