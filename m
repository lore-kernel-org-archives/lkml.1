Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbYJaCaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbYJaCaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 22:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYJaCaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 22:30:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47170 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbYJaCaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 22:30:20 -0400
Date: Thu, 30 Oct 2008 22:30:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ftrace: distinguish kretprobe'd functions in trace
 logs
In-Reply-To: <483C53EE.2060602@gmail.com>
Message-ID: <alpine.DEB.1.10.0810302227360.21031@gandalf.stny.rr.com>
References: <483C53EE.2060602@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 28 May 2008, Abhishek Sagar wrote:
> Hi Steven,
> 
> Tracing functions via ftrace which have a kretprobe installed on them, can produce misleading output in their trace logs. E.g, consider the correct trace of the following sequence:
> 
> do_IRQ()
> {
> ~
>   irq_enter();
> ~
> }
> 
> 
> Trace log (sample):
> <idle>-0     [00] 4154504455.781616: irq_enter <- do_IRQ
> 
> 
> But if irq_enter() has a kretprobe installed on it, the return value stored on the stack at each invocation is modified to divert the return to a kprobe trampoline function called kretprobe_trampoline(). So with this the trace would (currently) look like:
> 
> <idle>-0     [00] 4154504455.781616: irq_enter <- kretprobe_trampoline
> 
> Now this is quite misleading to the end user, as it suggests something that didn't actually happen. So just to avoid such misinterpretations, the inlined patch aims to output such a log as:
> 
> <idle>-0     [00] 4154504455.781616: irq_enter <- [unknown/kretprobe'd]
> 
> 

[...]

> +
> +#ifdef CONFIG_KRETPROBES
> +static inline int kretprobed(unsigned long addr)
> +{
> +	return addr == (unsigned long)kretprobe_trampoline;

Hi Abhishek,

Now that this code is in mainline, it has become apparent that 
kretprobe_trampoline is not defined on all archs as a global like it is in 
x86. This needs to be fixed (it breaks ia64 build).

Thanks,

-- Steve


> +}
> +#else
> +static inline int kretprobed(unsigned long addr)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_KRETPROBES */
