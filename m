Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbZJPK6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbZJPK6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 06:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbZJPK6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 06:58:46 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:59318 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbZJPK6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 06:58:45 -0400
Subject: Re: Leaks in trace reported by kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <c4e36d110910160045y52d80450g1d803dd2090a2bd8@mail.gmail.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <4AD6EF65.6080602@cn.fujitsu.com>
	 <1255605778.10164.49.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160045y52d80450g1d803dd2090a2bd8@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 16 Oct 2009 11:57:54 +0100
Message-Id: <1255690674.3008.24.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2009 10:57:55.0619 (UTC) FILETIME=[83ECAF30:01CA4E4F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 09:45 +0200, Zdenek Kabelac wrote:
> 2009/10/15 Catalin Marinas <catalin.marinas@arm.com>:
> >> Zdenek Kabelac wrote:
> >> > I've noticed your latest patch for memory leak in filter setting
> >> > (8ad807318fcd...) - but even with this patch - kmemleak seems to still
> >> > report  lots  (~900) of following leaks - note - they come only from
> >> > i915 and kvm module - so I'm not sure if these two modules are doing
> >> > something wrong or the problem is in trace code.
> > 
> > It is probably caused by the fact that kmemleak doesn't scan the
> > mod->trace_events data in a module (the _ftrace_events section). It only
> > scans those sections beginning with .data and .bss in a module. Maybe we
> > should add "_ftrace_events" as well or just prefix it with ".data".
> >
> > Something like below may fix this (untested):
> >
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 8b7d880..1449691 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -2383,6 +2383,9 @@ static noinline struct module *load_module(void __user *umod,
> >                                         "_ftrace_events",
> >                                         sizeof(*mod->trace_events),
> >                                         &mod->num_trace_events);
> > +       kmemleak_scan_area(mod->module_core, mod->trace_events,
> > +                          sizeof(*mod->trace_events) * mod->num_trace_events,
> > +                          GFP_KERNEL);
> >  #endif
> >  #ifdef CONFIG_FTRACE_MCOUNT_RECORD
> >        /* sechdrs[0].sh_size is always zero */
> 
> Yep - I've assume it could be also a problem of missing memory segment
> in kmemleak scanning routine - but it was weird that just these two
> modules (i915 & kvm) are doing such strange thing.
> 
> I've tested patch above with added cast  ( (unsigned
> long)mod->trace_events) to pacify warning - but it did not helped -
> leaks are still printed.

Same trace-related leaks?

Do any of the leaks disappear with subsequent memory scans (echo scan >
debug/kmemleak)?

Could you try the patch below? It ensures that all the module memory is
scanned:

diff --git a/kernel/module.c b/kernel/module.c
index 8b7d880..fc6ef3a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2036,36 +2036,6 @@ static void *module_alloc_update_bounds(unsigned long size)
 	return ret;
 }
 
-#ifdef CONFIG_DEBUG_KMEMLEAK
-static void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
-				 Elf_Shdr *sechdrs, char *secstrings)
-{
-	unsigned int i;
-
-	/* only scan the sections containing data */
-	kmemleak_scan_area(mod->module_core, (unsigned long)mod -
-			   (unsigned long)mod->module_core,
-			   sizeof(struct module), GFP_KERNEL);
-
-	for (i = 1; i < hdr->e_shnum; i++) {
-		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
-			continue;
-		if (strncmp(secstrings + sechdrs[i].sh_name, ".data", 5) != 0
-		    && strncmp(secstrings + sechdrs[i].sh_name, ".bss", 4) != 0)
-			continue;
-
-		kmemleak_scan_area(mod->module_core, sechdrs[i].sh_addr -
-				   (unsigned long)mod->module_core,
-				   sechdrs[i].sh_size, GFP_KERNEL);
-	}
-}
-#else
-static inline void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
-					Elf_Shdr *sechdrs, char *secstrings)
-{
-}
-#endif
-
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static noinline struct module *load_module(void __user *umod,
@@ -2293,7 +2263,6 @@ static noinline struct module *load_module(void __user *umod,
 	}
 	/* Module has been moved. */
 	mod = (void *)sechdrs[modindex].sh_addr;
-	kmemleak_load_module(mod, hdr, sechdrs, secstrings);
 
 #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
 	mod->refptr = percpu_modalloc(sizeof(local_t), __alignof__(local_t),

> And I add another leak - which might be from the same range of problem :
> (it's also present many times - and it even looks like hex dump is
> changing so it's probably even frequently used memory region - at
> least in few such objects)
> 
> unreferenced object 0xffff88013aa4ad80 (size 192):
>   comm "swapper", pid 1, jiffies 4294877809
>   hex dump (first 32 bytes):
>     c0 dc a4 3a 01 88 ff ff 00 0c 79 39 01 88 ff ff  ...:......y9....
>     90 00 cf 3a 01 88 ff ff 02 00 00 00 00 00 00 00  ...:............
>   backtrace:
>     [<ffffffff8140e9a6>] kmemleak_alloc+0x26/0x60
>     [<ffffffff81126a01>] kmem_cache_alloc_notrace+0xc1/0x140
>     [<ffffffff8127256a>] dma_debug_init+0x23a/0x3a0
>     [<ffffffff81864a37>] pci_iommu_init+0xe/0x28
>     [<ffffffff8100904c>] do_one_initcall+0x3c/0x1d0
>     [<ffffffff8185f4e6>] kernel_init+0x150/0x1a6
>     [<ffffffff8100d21a>] child_rip+0xa/0x20
>     [<ffffffffffffffff>] 0xffffffffffffffff

Same as above, does it disappear with subsequent scans? This doesn't
look immediately like a false positive, it needs a bit more
investigation.

Thanks.

-- 
Catalin

