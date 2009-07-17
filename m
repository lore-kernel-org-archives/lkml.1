Return-Path: <linux-kernel-owner+w=401wt.eu-S934102AbZGQDio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbZGQDio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 23:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934085AbZGQDin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 23:38:43 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:45934 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934084AbZGQDin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 23:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=WliBoE6ZHlHUziaiv9/PbKsN1wO6JAYb2AQU4JBBa7Uo1naMWNus86gKdNpnilRiRa
         oikINBcrhRZHVRS+05e37jemc4v2i53Q6NKM+yEiLeP3sUJRc5rpBr7EcUuCbX76bVJp
         do1MjQ3CeCj7LN5JL6jzxF7DIPJL5DlL/8OYs=
Subject: Re: [linux-pm] [PATCH] [suspend] pci_raw_set_power_state: replace
 msleep by udelay in resuming procedure
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org, len.brown@intel.com,
       yanh@lemote.com, linux-kernel@vger.kernel.org, zhangfx@lemote.com,
       pavel@ucw.cz
In-Reply-To: <200907170433.42366.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0907161259510.2952-100000@iolanthe.rowland.org>
	 <1247796643.19112.77.camel@falcon>  <200907170433.42366.rjw@sisk.pl>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Fri, 17 Jul 2009 11:38:33 +0800
Message-Id: <1247801913.19112.96.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 04:33 +0200, Rafael J. Wysocki wrote:
> On Friday 17 July 2009, Wu Zhangjin wrote:
> > Hi,
> > 
> > On Thu, 2009-07-16 at 13:02 -0400, Alan Stern wrote:
> > > On Thu, 16 Jul 2009, Wu Zhangjin wrote:
> > > 
> > > > we can not call msleep() when resuming from STR/Standby: if the
> > > > current_state of the pci device is PCI_D3hot, means we are in the
> > > > procedure of resuming, in this procedure, we can not re-schedule,
> > > > otherwise, there will be a deadlock.
> > > 
> > > I don't understand.
> > > 
> > > First of all, why does current_state == PCI_D3hot mean the system is
> > > resuming from sleep?  Isn't it possible that the PCI device is going
> > > through a runtime resume?
> > > 
> > > Secondly, why will scheduling during a resume cause a deadlock?
> > 
> > Sorry, I'm stupid to make conclusion before describing the problem
> > clearly, here is the problem I encountered:
> > 
> > when I enabled SUSPEND=y in linux-2.6.30.1(with relative patches) on a
> > loongson-based machine(yeeloong laptop,loongson is mips-compatiable), I
> > tried to suspend it via "echo standby > /sys/power/state", with the
> > serial port debugging support, I found it enter into the standby mode
> > successfully. and then, tried to wake it up via the keyboard interrupt,
> > but it stopped at the "Power_up_devices:" of kernel/power/main.c.
> > 
> > here is a short path of this procedure:
> > 
> > suspend_enter:
> > 	...
> > 	device_power_down
> > 	...
> > 	arch_suspend_disable_irqs
> > 	...
> > 	sysdev_suspend
> > 	...
> > 	suspend_ops->enter  (board-specific part)
> > 	...
> > 	sysdev_resume
> > 	...
> > 	arch_suspend_enable_irqs
> > 	...
> > 	device_power_up	 <-----------------------stop here
> > 	...
> > 	
> > and then I continue to trace it:
> > 
> > device_power_up:
> > 	dpm_power_up:
> > 		list_for_each_entry(dev, &dpm_list, power.entry)
> > 			<<DEBUG>>
> >                 if (dev->power.status > DPM_OFF) {
> >                         int error;
> > 
> >                         dev->power.status = DPM_OFF;
> >                         error = resume_device_noirq(dev, state);
> >                         if (error)
> >                                 pm_dev_err(dev, state, " early", error);
> >                 }   
> > 
> > I tried to add prom_putchar() at <<DEBUG>> to print something, and This
> > will make it resume from standby mode successfully. seems,
> > prom_putchar() have influenced the power.status, and make some devices
> > not enter into the condition statement, and make dpm_power_up return
> > directly. (this is very weird, not sure why?)
> > 
> > so, I removed the prom_putchar() from <<DEBUG>>, and it stopped at
> > resume_device_noirq, here is the following tracing path:
> > 	
> > resume_device_noirq:
> >    --> pm_noirq_op
> >    --> ops->resume_noirq (dev) <--> pci_pm_resume_noirq:
> > 	   --> pci_pm_default_resume_noirq
> > 	   --> pci_restore_standard_config
> > 	   --> pci_set_power_state
> >            --> pci_raw_set_power_state
> >            --> msleep    <-----------------------[ stop here]
> > 
> > msleep:
> > 	--> schedule_timeout_uninterruptible
> > 	--> schedule_timeout
> > 	     --> ... 
> > 	     --> __mod_timer
> >              --> ...
> > 	     --> schedule ---> a new scheduling happen and never return
> > 
> > and then I tried to trace schedule(), and even added a prom_putchar() to
> > the end of the schedule() function, it output something successfully,
> > but never return to schedule_timeout(dead? no keyboard response), seems
> > very weird! this is reproductive, perhaps I have missed something here.
> >  
> > so, to avoid this 'weird' situation, I think it's better not to
> > re-schedule in the resuming procedure from standby. and here, I can not
> > find another condition to judge the resuming procedure from standby, so,
> > I use "current_state == PCI_D3hot"(so, my pre-expression is really wrong
> > for it maybe not resume from standby as you indicated). and is there
> > another condition to judge we are resuming from standby? perhaps this is
> > better:
> > 
> >    ((current_state == PCI_D3hot) && (state == PCI_D0))
> > 
> > but seems this also can not indicate we are resuming from standby.
> 
> 'standby' is a system sleep state, while 'current_state' and 'state' refer to
> device power states.
> 

Yeap, when changing from D3 to D0, it is a procedure of resuming from a
sleep state. resuming from 'standby' is such a procedure, but resuming
from a sleep state maybe include the other situations, so, this
judgement is really wrong here.

> Anyway, the fact that schedule() did not return in your testing setup indicates
> that there were no timer interrupts delivered to the CPU during resume, which
> should not have happened.
> 
> Perhaps it's necessary to annotate your timer interrupts appropriately so that
> they are not disabled during suspend?

You are right:

I'm using an external timer(cs5536 mfgpt timer), and because this works
well in linux-2.6.27, so, I never doubted with it in 2.6.30.1, I just
using the MIPS timer instead of it, works well. so, It must be the
problem of the mfgpt timer, it maybe disabled or not enabled before
device_power_up(PMSG_RESUME) in 2.6.30.1, I will check it later.

Thanks very much!

Regards,
Wu Zhangjin

