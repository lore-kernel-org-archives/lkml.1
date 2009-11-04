Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZKDJSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZKDJSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZKDJSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:18:47 -0500
Received: from www.tglx.de ([62.245.132.106]:47391 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZKDJSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:18:46 -0500
Date: Wed, 4 Nov 2009 10:18:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yong Zhang <yong.zhang0@gmail.com>
cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH]: use spin_lock_irqsave in try_one_irq()
In-Reply-To: <2674af740911030658m76b702cfxb67723984286c4bb@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0911041016070.12138@localhost.localdomain>
References: <20091103134342.24414.82986.sendpatchset@prarit.bos.redhat.com> <2674af740911030658m76b702cfxb67723984286c4bb@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-15680974-1257326304=:12138"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-15680974-1257326304=:12138
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 3 Nov 2009, Yong Zhang wrote:

> > This happens because the &desc->lock is taken with spin_lock_irqsave and
> > just a spin_lock.  In the try_one_irq(), this lock really should be a
> > spin_lock_irqsave().
> >
> 
> Cc'ed Ingo and Thomas.
> 
> The reason is that try_one_irq() is called both from hardirq context and softirq
> context. And by default the timer handler poll_all_shared_irqs() is
> called with irq enabled.
> Then the two usage will cause inconsistent.
> 
> So I think the following patch is also workable to you.

Yes, that's sufficient.
 
> diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
> index 114e704..11affbc 100644
> --- a/kernel/irq/spurious.c
> +++ b/kernel/irq/spurious.c
> @@ -111,6 +111,7 @@ static void poll_all_shared_irqs(void)
> 
>  	for_each_irq_desc(i, desc) {
>  		unsigned int status;
> +		unsigned long flags;
> 
>  		if (!i)
>  			 continue;
> @@ -121,7 +122,9 @@ static void poll_all_shared_irqs(void)
>  		if (!(status & IRQ_SPURIOUS_DISABLED))
>  			continue;
> 
> +		local_irq_save(flags);
>  		try_one_irq(i, desc);
> +		local_irq_restore(flags);

  You can even use local_irq_en/disable() here.

Thanks,

	tglx
--8323328-15680974-1257326304=:12138--
