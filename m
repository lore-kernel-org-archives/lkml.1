Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbYFLMGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbYFLMGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYFLMGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:06:40 -0400
Received: from www.tglx.de ([62.245.132.106]:54883 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbYFLMGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:06:39 -0400
Date: Thu, 12 Jun 2008 14:06:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: junjie cai <junjiec@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [rt] __reacquire_lock_kernel bug?
In-Reply-To: <ca992f110806112331v3d4d73abhaa46167f494e8d9b@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0806121255480.3193@apollo.tec.linutronix.de>
References: <a5530a0e-7f34-4ddf-862e-83771a9c78e3@a32g2000prf.googlegroups.com> <ca992f110806112331v3d4d73abhaa46167f494e8d9b@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, junjie cai wrote:
> Hi, List
> 
> We get a BUG_ON during some tests on a 2.6.22.19-rt9,
> the message is pasted at the end of this mail.

There is no BUG_ON in the code path where your stack trace comes from.
Unfortunately you omitted the interesting part of the message, which
is printed _before_ the stack trace:

"BUG: scheduling while atomic: .....
 
> It seems that preemption happened in __reacquire_kernel_lock()
> that kernel_lock in released twice.

Sorry, I do not understand what you mean.
 
>  int __lockfunc __reacquire_kernel_lock(void)
>  {
>        local_irq_enable();
> >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> preempted here

When you use rt you won't be in that code path. -rt uses the
preemptible BKL implementation.

>        _raw_spin_lock(&kernel_flag);
>        local_irq_disable();
>        preempt_disable();
> }
> 
> After checking the 2.6.25.4-rt6, I think that same problem exist.
> Isn't that lock_depth should be set to -1 before local_irq_enable() ?
> 
>  int __lockfunc __reacquire_kernel_lock(void)
>  {
>        struct task_struct *task = current;
>        int saved_lock_depth = task->lock_depth;
> 
>        local_irq_enable();
>        BUG_ON(saved_lock_depth < 0);
>  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>preempted here

That's ok, when we the task is preempted here. lock_depth needs to be
set to -1 before we call down() and it is restored
afterwards. preempt_schedule_irq() handles the BKL in the right way.

Thanks,

	tglx
