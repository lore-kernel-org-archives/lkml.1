Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbYAKCz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbYAKCz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 21:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYAKCzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 21:55:51 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:54495 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbYAKCzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 21:55:50 -0500
Message-ID: <4786DAB5.6000809@oracle.com>
Date: Thu, 10 Jan 2008 18:55:49 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hwclock failure in x86.git
References: <4786AA11.5010805@gmail.com>	<4786AB1B.4030004@zytor.com>	<4786AF4C.6050509@gmail.com>	<4786C2CF.4070204@zytor.com> <20080110222744.05f86b18.kjwinchester@gmail.com>
In-Reply-To: <20080110222744.05f86b18.kjwinchester@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm no expert, but I happened to notice this go by.

> The first thing I notice about the path is that ioport_32.c and the unified ioport.c use __clear_bit,
> while ioport_64.c uses clear_bit.

That doesn't seem too critical.

> +#ifdef CONFIG_X86_32
> +asmlinkage long sys_iopl(unsigned long regsp)
> +{
> +	volatile struct pt_regs *regs = (struct pt_regs *)&regsp;
> +	unsigned int level = regs->bx;
> +	unsigned int old = (regs->flags >> 12) & 3;
> +
> +	if (level > 3)
> +		return -EINVAL;
> +	/* Trying to gain more privileges? */
> +	if (level > old) {
> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +	}
> +	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
> +
> +	return 0;
> +}

> -asmlinkage long sys_iopl(unsigned long regsp)
> -{
> -	volatile struct pt_regs *regs = (struct pt_regs *)&regsp;
> -	unsigned int level = regs->bx;
> -	unsigned int old = (regs->flags >> 12) & 3;
> -	struct thread_struct *t = &current->thread;
> -
> -	if (level > 3)
> -		return -EINVAL;
> -	/* Trying to gain more privileges? */
> -	if (level > old) {
> -		if (!capable(CAP_SYS_RAWIO))
> -			return -EPERM;
> -	}
> -
> -	t->iopl = level << 12;
> -	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | t->iopl;
> -	set_iopl_mask(t->iopl);
> -
> -	return 0;
> -}

Is it OK that we lost the different final steps of those two functions?
 It looks like someone might have missed the differing tail sections of
the function when copying and pasting and updating just the start of the
functions?

Sorry if I missed why this is OK and intended, I didn't read very closely.

- z
