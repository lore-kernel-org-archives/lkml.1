Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZDMRoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZDMRoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 13:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZDMRoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 13:44:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:9573 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbZDMRoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 13:44:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,180,1239001200"; 
   d="scan'208";a="402740177"
Subject: Re: [PATCH 2/3] [BUGFIX] x86/x86_64: fix CPU offlining triggered
 inactive device IRQ interrruption
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       Gary Hade <garyhade@us.ibm.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lcm@us.ibm.com" <lcm@us.ibm.com>
In-Reply-To: <m1myanbgiv.fsf@fess.ebiederm.org>
References: <20090408210735.GD11159@us.ibm.com>
	 <m1r601fg9l.fsf@fess.ebiederm.org> <20090410200919.GA7242@us.ibm.com>
	 <m1tz4wcgm8.fsf@fess.ebiederm.org>
	 <86802c440904110051p3e071f8etd0792702c08d9ec5@mail.gmail.com>
	 <m1myanbgiv.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 10:41:35 -0700
Message-Id: <1239644495.4529.8580.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-11 at 04:01 -0700, Eric W. Biederman wrote:
> Yinghai Lu <yhlu.kernel@gmail.com> writes:
> 
> > commit 932775a4ab622e3c99bd59f14cc7d96722f79501
> > Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
> > Date:   Fri Sep 5 18:02:15 2008 -0700
> >
> >     x86: HPET_MSI change IRQ affinity in process context when it is disabled
> >
> >     Change the IRQ affinity in the process context when the IRQ is disabled.
> >
> >     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> >     Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >
> > diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> > index ddc9568..ad2ce72 100644
> > --- a/kernel/irq/manage.c
> > +++ b/kernel/irq/manage.c
> > @@ -87,10 +87,11 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
> >                 return -EINVAL;
> >
> >  #ifdef CONFIG_GENERIC_PENDING_IRQ
> > -       if (desc->status & IRQ_MOVE_PCNTXT) {
> > +       if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
> >                 unsigned long flags;
> >
> >                 spin_lock_irqsave(&desc->lock, flags);
> > +               desc->affinity = cpumask;
> >                 desc->chip->set_affinity(irq, cpumask);
> >                 spin_unlock_irqrestore(&desc->lock, flags);
> >         } else
> 
> If the goal is moving MSIs, we should modify the msi code to be safe
> in process context and to set IRQ_MOVE_PCNTXT.
> 
> The only reason we migrate MSIs in interrupt context today is that there
> wasn't infrastructure for support migration both in interrupt context
> and outside of it.
> 

Yes. The idea here was to force the MSI migration to happen in process
context. One of the patches in the series did

	disable_irq(dev->irq);
	irq_set_affinity(dev->irq, cpumask_of(dev->cpu));
	enable_irq(dev->irq);

with the above patch adding irq/manage code check for interrupt disabled
and moving the interrupt in process context.

IIRC, there was no IRQ_MOVE_PCNTXT when we were developing this HPET
code and we ended up having this ugly hack. IRQ_MOVE_PCNTXT was there
when we eventually submitted the patch upstream. But, looks like I did a
blind rebasing instead of using IRQ_MOVE_PCNTXT in hpet MSI code. That
was my fault. Will send a patch to fix this ugliness.

Thanks,
Venki

