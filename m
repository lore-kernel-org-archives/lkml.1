Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbYEBJpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbYEBJpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757927AbYEBJpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:45:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:51732 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbYEBJpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=xIGw44gZY0xbQ1P6Htw4i79NxYYpZ4Y/jtJBfFOPQgmomqW9v8mMHPAJMgA2FQfN6u/LQvAJyOObT2cmLEUZWAfXIp8JnRWy9kHAmK5TABq/Jfgzr9zpTIXPbJLmZiQUdIpJ84Qmds+8KW6Oeco1lXg70ZowdKsuhBlZPbahk4U=
Message-ID: <481AE2A1.7000201@gmail.com>
Date: Fri, 02 May 2008 11:45:05 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       sandeen@sandeen.net
Subject: Re: [PATCH] i386: Execute stack overflow warning on interrupt stack
References: <20080502091806.GA26062@basil.nowhere.org>
In-Reply-To: <20080502091806.GA26062@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2008 11:18 AM, Andi Kleen wrote:
> i386: Execute stack overflow warning on interrupt stack
[...]
> --- linux.orig/arch/x86/kernel/irq_32.c
> +++ linux/arch/x86/kernel/irq_32.c
> @@ -61,6 +61,26 @@ static union irq_ctx *hardirq_ctx[NR_CPU
>  static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
>  #endif
>  
> +static void stack_overflow(void)
> +{
> +	printk("low stack detected by irq handler\n");
> +	dump_stack();
> +}
> +
> +static inline void call_on_stack2(void *func, unsigned long stack,
> +			   unsigned long arg1, unsigned long arg2)
> +{
> +	unsigned long bx;
> +	asm volatile(
> +			"       xchgl  %%ebx,%%esp    \n"
> +			"       call   *%%edi         \n"
> +			"       movl   %%ebx,%%esp    \n"
> +			: "=a" (arg1), "=d" (arg2), "=b" (bx)
> +			:  "0" (arg1),   "1" (arg2),  "2" (stack),
> +			   "D" (func)
> +			: "memory", "cc", "ecx');

Am I seeing wrong, or is it a ' after the ecx?
