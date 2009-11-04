Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbZKDPmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbZKDPmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbZKDPmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:42:15 -0500
Received: from www84.your-server.de ([213.133.104.84]:48991 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbZKDPmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:42:14 -0500
Subject: Re: [PATCH] update fix X86_64 procfs provide stack information for
 threads
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <20091104120019.GK31511@one.firstfloor.org>
References: <1257233486.22553.6.camel@wall-e>
	 <874opaa68v.fsf@basil.nowhere.org> <1257335404.2123.29.camel@wall-e>
	 <20091104120019.GK31511@one.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 04 Nov 2009 16:42:11 +0100
Message-ID: <1257349331.12786.5.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 04.11.2009, 13:00 +0100 schrieb Andi Kleen:
> > This is true, but i think it is better to get an outdated value than a
> > complete wrong value like -1.
> 
> -1 means "I don't know".  I don't think "completely wrong" 
> is the correct term to describe that.
> 
> > The truth is that KSTK_ESP always return an outdated value on a multi
> > core system if the process never do a system call.
> 
> I think not supporting updates on interrupts at least is very poor.
> Unfortunately there's no good way fast path way to detect this I know of
> (that is why I originally added -1 here)

This is a first draft for supporting interrupts:

unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
{
	struct pt_regs *old_regs = set_irq_regs(regs);

	/* high bit used in ret_from_ code  */
	unsigned vector = ~regs->orig_ax;
	unsigned irq;

	exit_idle();
	irq_enter();

/* >>>>>>>> update usersp */  
	current->thread.usersp = regs->sp;

	irq = __get_cpu_var(vector_irq)[vector];

	if (!handle_irq(irq, regs)) {
		ack_APIC_irq();

		if (printk_ratelimit())
			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
				__func__, smp_processor_id(), vector, irq);
	}

	irq_exit();

	set_irq_regs(old_regs);
	return 1;
}

This works in my environment, but i have not the oversight if it work
under all circumstances. And we need a similar line in the timer
interrupt.

Greetings,
Stefani


