Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYHZUfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYHZUfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbYHZUey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:34:54 -0400
Received: from mout4.freenet.de ([195.4.92.94]:41418 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbYHZUex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:34:53 -0400
Date: Tue, 26 Aug 2008 22:34:49 +0200
From: Gerhard Brauer <gerhard.brauer@web.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080826203449.GD5300@tux1.brauer.lan>
References: <20080822163520.GA9860@Krystal> <20080822142054.403cbdef@doriath.conectiva> <20080822175741.6bc83dc8@doriath.conectiva> <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan> <20080826145338.GA8601@Krystal> <20080826131354.356ae11d@doriath.conectiva> <20080826171822.GB14906@Krystal> <20080826150222.0cf1542c@doriath.conectiva> <20080826181558.GA16887@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080826181558.GA16887@Krystal>
User-Agent: Mutt/1.5.18-muttng (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 02:15:58PM -0400, Mathieu Desnoyers wrote:
> 
> Ok, it might still be caused by paravirt and alternatives instruction
> patching. What if you also do :
> 
> alternative_instructions()
> 
> +        unsigned long flags;
>         /* The patching is not fully atomic, so try to avoid local interruptions
>            that might execute the to be patched code.
>            Other CPUs are not running. */
>         stop_nmi();
> #ifdef CONFIG_X86_MCE
>         stop_mce();
> #endif
> +        local_irq_save(flags);
> 
> 
> ...
> +        local_irq_restore(flags);
>         restart_nmi();
> #ifdef CONFIG_X86_MCE
>         restart_mce();
> #endif
> 
> ?

Hej! This last changes (in addition to the others you mentioned) seems
to be a good shot. I could reboot 8 times the guest, compile several
packages (something which always leeds to the oops) and currently i
build two big packages simultan. So this is heavy IO.

I will try tomorrow more heavy build tests (to gain the good feeling to
the vbox+guest kernel again like it was with 2.6.25), but i think your
changes goes in the right direction.

Here is the diff what i've changed on your hints:

,----[ arch/x86/kernel/alternative.c ]
| --- alternative.c.org	2008-07-13 23:51:29.000000000 +0200
| +++ alternative.c	2008-08-26 21:35:20.000000000 +0200
| @@ -343,6 +343,7 @@
|  void alternatives_smp_switch(int smp)
|  {
|  	struct smp_alt_module *mod;
| +	unsigned long flags;
|  
|  #ifdef CONFIG_LOCKDEP
|  	/*
| @@ -359,7 +360,7 @@
|  		return;
|  	BUG_ON(!smp && (num_online_cpus() > 1));
|  
| -	spin_lock(&smp_alt);
| +	spin_lock_irqsave(&smp_alt, flags);
|  
|  	/*
|  	 * Avoid unnecessary switches because it forces JIT based VMs to
| @@ -383,7 +384,7 @@
|  						mod->text, mod->text_end);
|  	}
|  	smp_mode = smp;
| -	spin_unlock(&smp_alt);
| +	spin_unlock_irqrestore(&smp_alt, flags);
|  }
|  
|  #endif
| @@ -420,6 +421,7 @@
|  
|  void __init alternative_instructions(void)
|  {
| +	unsigned long flags;
|  	/* The patching is not fully atomic, so try to avoid local interruptions
|  	   that might execute the to be patched code.
|  	   Other CPUs are not running. */
| @@ -427,6 +429,7 @@
|  #ifdef CONFIG_X86_MCE
|  	stop_mce();
|  #endif
| +	local_irq_save(flags);
|  
|  	apply_alternatives(__alt_instructions, __alt_instructions_end);
|  
| @@ -465,6 +468,7 @@
|  				(unsigned long)__smp_locks,
|  				(unsigned long)__smp_locks_end);
|  
| +	local_irq_restore(flags);
|  	restart_nmi();
|  #ifdef CONFIG_X86_MCE
|  	restart_mce();
| @@ -508,33 +512,5 @@
|   */
|  void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
|  {
| -	unsigned long flags;
| -	char *vaddr;
| -	int nr_pages = 2;
| -	struct page *pages[2];
| -	int i;
| -
| -	if (!core_kernel_text((unsigned long)addr)) {
| -		pages[0] = vmalloc_to_page(addr);
| -		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
| -	} else {
| -		pages[0] = virt_to_page(addr);
| -		WARN_ON(!PageReserved(pages[0]));
| -		pages[1] = virt_to_page(addr + PAGE_SIZE);
| -	}
| -	BUG_ON(!pages[0]);
| -	if (!pages[1])
| -		nr_pages = 1;
| -	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
| -	BUG_ON(!vaddr);
| -	local_irq_save(flags);
| -	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
| -	local_irq_restore(flags);
| -	vunmap(vaddr);
| -	sync_core();
| -	/* Could also do a CLFLUSH here to speed up CPU recovery; but
| -	   that causes hangs on some VIA CPUs. */
| -	for (i = 0; i < len; i++)
| -		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
| -	return addr;
| +	return text_poke_early(addr, opcode, len);
|  }
`----

So if Luiz and others could also try all 3 mentioned changes, maybe we
have a solution. I also will build tomorrow a new LiveCD/Install ISO
with these patches to see if the error there is also gone.

> Thanks,
> 
> Mathieu

Gerhard


-- 
Was wir wissen, ist ein Tropfen.
Was wir nicht wissen, ein Ozean (Newton)
