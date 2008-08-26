Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbYHZUsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbYHZUsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYHZUsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:48:17 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:57060 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292AbYHZUsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:48:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhwFANsFtEhMRKxB/2dsb2JhbACBZbkbgWs
Date: Tue, 26 Aug 2008 16:48:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Gerhard Brauer <gerhard.brauer@web.de>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080826204814.GB23544@Krystal>
References: <20080822142054.403cbdef@doriath.conectiva> <20080822175741.6bc83dc8@doriath.conectiva> <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan> <20080826145338.GA8601@Krystal> <20080826131354.356ae11d@doriath.conectiva> <20080826171822.GB14906@Krystal> <20080826150222.0cf1542c@doriath.conectiva> <20080826181558.GA16887@Krystal> <20080826203449.GD5300@tux1.brauer.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080826203449.GD5300@tux1.brauer.lan>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:40:33 up 83 days,  1:20,  6 users,  load average: 0.28, 1.14,
	1.00
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gerhard Brauer (gerhard.brauer@web.de) wrote:
> On Tue, Aug 26, 2008 at 02:15:58PM -0400, Mathieu Desnoyers wrote:
> > 
> > Ok, it might still be caused by paravirt and alternatives instruction
> > patching. What if you also do :
> > 
> > alternative_instructions()
> > 
> > +        unsigned long flags;
> >         /* The patching is not fully atomic, so try to avoid local interruptions
> >            that might execute the to be patched code.
> >            Other CPUs are not running. */
> >         stop_nmi();
> > #ifdef CONFIG_X86_MCE
> >         stop_mce();
> > #endif
> > +        local_irq_save(flags);
> > 
> > 
> > ...
> > +        local_irq_restore(flags);
> >         restart_nmi();
> > #ifdef CONFIG_X86_MCE
> >         restart_mce();
> > #endif
> > 
> > ?
> 
> Hej! This last changes (in addition to the others you mentioned) seems
> to be a good shot. I could reboot 8 times the guest, compile several
> packages (something which always leeds to the oops) and currently i
> build two big packages simultan. So this is heavy IO.
> 
> I will try tomorrow more heavy build tests (to gain the good feeling to
> the vbox+guest kernel again like it was with 2.6.25), but i think your
> changes goes in the right direction.
> 

OK, so we have a problem with interrupts coming while we are doing the
alternatives patching.

First thing, I wonder if Virtualbox expects the OS to patch all its
paravirt instructions in one go ?

Also, could you then try to :
- to revert all those changes
- Do this to text_poke_early and text_poke :

- put the sync_core() within the irq off critical section
(test)
- add a wbinvd();  just after the sync_core() in both functions
(test).

Thanks,

Mathieu


> Here is the diff what i've changed on your hints:
> 
> ,----[ arch/x86/kernel/alternative.c ]
> | --- alternative.c.org	2008-07-13 23:51:29.000000000 +0200
> | +++ alternative.c	2008-08-26 21:35:20.000000000 +0200
> | @@ -343,6 +343,7 @@
> |  void alternatives_smp_switch(int smp)
> |  {
> |  	struct smp_alt_module *mod;
> | +	unsigned long flags;
> |  
> |  #ifdef CONFIG_LOCKDEP
> |  	/*
> | @@ -359,7 +360,7 @@
> |  		return;
> |  	BUG_ON(!smp && (num_online_cpus() > 1));
> |  
> | -	spin_lock(&smp_alt);
> | +	spin_lock_irqsave(&smp_alt, flags);
> |  
> |  	/*
> |  	 * Avoid unnecessary switches because it forces JIT based VMs to
> | @@ -383,7 +384,7 @@
> |  						mod->text, mod->text_end);
> |  	}
> |  	smp_mode = smp;
> | -	spin_unlock(&smp_alt);
> | +	spin_unlock_irqrestore(&smp_alt, flags);
> |  }
> |  
> |  #endif
> | @@ -420,6 +421,7 @@
> |  
> |  void __init alternative_instructions(void)
> |  {
> | +	unsigned long flags;
> |  	/* The patching is not fully atomic, so try to avoid local interruptions
> |  	   that might execute the to be patched code.
> |  	   Other CPUs are not running. */
> | @@ -427,6 +429,7 @@
> |  #ifdef CONFIG_X86_MCE
> |  	stop_mce();
> |  #endif
> | +	local_irq_save(flags);
> |  
> |  	apply_alternatives(__alt_instructions, __alt_instructions_end);
> |  
> | @@ -465,6 +468,7 @@
> |  				(unsigned long)__smp_locks,
> |  				(unsigned long)__smp_locks_end);
> |  
> | +	local_irq_restore(flags);
> |  	restart_nmi();
> |  #ifdef CONFIG_X86_MCE
> |  	restart_mce();
> | @@ -508,33 +512,5 @@
> |   */
> |  void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
> |  {
> | -	unsigned long flags;
> | -	char *vaddr;
> | -	int nr_pages = 2;
> | -	struct page *pages[2];
> | -	int i;
> | -
> | -	if (!core_kernel_text((unsigned long)addr)) {
> | -		pages[0] = vmalloc_to_page(addr);
> | -		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
> | -	} else {
> | -		pages[0] = virt_to_page(addr);
> | -		WARN_ON(!PageReserved(pages[0]));
> | -		pages[1] = virt_to_page(addr + PAGE_SIZE);
> | -	}
> | -	BUG_ON(!pages[0]);
> | -	if (!pages[1])
> | -		nr_pages = 1;
> | -	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> | -	BUG_ON(!vaddr);
> | -	local_irq_save(flags);
> | -	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
> | -	local_irq_restore(flags);
> | -	vunmap(vaddr);
> | -	sync_core();
> | -	/* Could also do a CLFLUSH here to speed up CPU recovery; but
> | -	   that causes hangs on some VIA CPUs. */
> | -	for (i = 0; i < len; i++)
> | -		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
> | -	return addr;
> | +	return text_poke_early(addr, opcode, len);
> |  }
> `----
> 
> So if Luiz and others could also try all 3 mentioned changes, maybe we
> have a solution. I also will build tomorrow a new LiveCD/Install ISO
> with these patches to see if the error there is also gone.
> 
> > Thanks,
> > 
> > Mathieu
> 
> Gerhard
> 
> 
> -- 
> Was wir wissen, ist ein Tropfen.
> Was wir nicht wissen, ein Ozean (Newton)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
