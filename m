Return-Path: <linux-kernel-owner+w=401wt.eu-S936100AbXHMOxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936100AbXHMOxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968800AbXHMMOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:14:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:44967 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968593AbXHMMOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:14:36 -0400
Date: Mon, 13 Aug 2007 15:08:45 +0200
From: Andi Kleen <ak@suse.de>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: [PATCH] x86: optionally show last exception from/to register contents
Message-ID: <20070813130845.GA3406@bingen.suse.de>
References: <46C05D91.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C05D91.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 12:33:05PM +0100, Jan Beulich wrote:


>  
>  	if (cpu_has_ds) {
>  		unsigned int l1;
> --- linux-2.6.23-rc3/arch/i386/kernel/traps.c	2007-08-13 08:59:45.000000000 +0200
> +++ 2.6.23-rc3-x86-ler/arch/i386/kernel/traps.c	2007-08-07 10:42:55.000000000 +0200
> @@ -321,6 +321,13 @@ void show_registers(struct pt_regs *regs
>  		unsigned int code_len = code_bytes;
>  		unsigned char c;
>  
> +		if (__get_cpu_var(ler_msr)) {
> +			u32 from, to, hi;
> +
> +			rdmsr(__get_cpu_var(ler_msr), from, hi);
> +			rdmsr(__get_cpu_var(ler_msr) + 1, to, hi);
> +			printk("LER: %08x -> %08x\n", from, to);
> +		}

This seems racy -- AFAIK the MSR will record the last branch
before an interrupt too, and the trap handlers enable interrupts
before coming here. 

Can't think of a good way to avoid that for page fault at least
without impacting interrupt latency or reading the MSR always.

The other thing is that this should use print_symbol()

>  		printk("\n" KERN_EMERG "Stack: ");
>  		show_stack_log_lvl(NULL, regs, (unsigned long *)esp, KERN_EMERG);
>  
> @@ -360,6 +367,18 @@ int is_valid_bugaddr(unsigned long eip)
>  	return ud2 == 0x0b0f;
>  }
>  
> +DEFINE_PER_CPU(u32, ler_msr);
> +int ler_enabled = 0;
> +
> +void ler_enable(void) {
> +	if (__get_cpu_var(ler_msr)) {
> +		u64 debugctl;
> +
> +		rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
> +		wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl | 1);

Better use checking_rd/wrmsrl and disable on fail -- often emulators 
fake specific CPUs, but don't implement all debugging features.

> +static int __init ler_setup(char *s)
> +{
> +	ler_enabled = 1;
> +	return 1;
> +}
> +__setup("ler", ler_setup);

I don't think the option is very useful.

BTW I have a patch somewhere to save/report last branch on exception
too, but it never seemed suitable for mainline because of its
high overhead. If someone submitted a full BTS driver I would
be tempted though :)

-Andi

