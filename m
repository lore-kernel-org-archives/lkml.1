Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYJ3MO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYJ3MO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 08:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYJ3MOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 08:14:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:29029 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbYJ3MOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 08:14:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=POndTgB7Z03/ulHvLQ55f5m8ii+USWFl3ye3TmfRMzkYL5WrJa2KOrHXY2+0OzgDmq
         IbtwVKid4b3IYI0fGg/UKYpuAKJqlZnTCxwd5VEn6jwBd25/uBqnPu8Pds4wjPWWHN37
         lowNwDywbAdV8qPUJQOKM4hAfSIt8MefvCuls=
Date: Thu, 30 Oct 2008 15:18:07 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: [PATCH v2] Really remove unwinder
Message-ID: <20081030121807.GA27845@x200.localdomain>
References: <20081030112023.GA27476@x200.localdomain> <20081030114708.GC12152@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030114708.GC12152@boogie.lpds.sztaki.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 12:47:08PM +0100, Gabor Gombas wrote:
> On Thu, Oct 30, 2008 at 02:20:23PM +0300, Alexey Dobriyan wrote:
> 
> > -static inline void unwind_init(void) {}
> 
> [...]
> 
> > -	/*
> > -	 * Need to run as early as possible, to initialize the
> > -	 * lockdep hash:
> > -	 */
> > -	unwind_init();
> >  	lockdep_init();
> >  	debug_objects_early_init();
> 
> IMHO the comment does not refer to unwind_init() so it should not be
> removed...

You're right, 

[PATCH v2] Really remove unwinder 

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/include/asm/unwind.h |   13 --------
 arch/x86/kernel/traps.c       |    2 -
 include/linux/module.h        |    3 -
 include/linux/unwind.h        |   68 ------------------------------------------
 init/main.c                   |    3 -
 kernel/module.c               |   15 ---------
 lib/fault-inject.c            |    1 
 7 files changed, 105 deletions(-)

deleted file mode 100644
--- a/arch/x86/include/asm/unwind.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef _ASM_X86_UNWIND_H
-#define _ASM_X86_UNWIND_H
-
-#define UNW_PC(frame) ((void)(frame), 0UL)
-#define UNW_SP(frame) ((void)(frame), 0UL)
-#define UNW_FP(frame) ((void)(frame), 0UL)
-
-static inline int arch_unw_user_mode(const void *info)
-{
-	return 0;
-}
-
-#endif /* _ASM_X86_UNWIND_H */
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/string.h>
-#include <linux/unwind.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/kexec.h>
@@ -52,7 +51,6 @@
 #include <asm/debugreg.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
-#include <asm/unwind.h>
 #include <asm/traps.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -294,9 +294,6 @@ struct module
 	/* The size of the executable code in each section.  */
 	unsigned int init_text_size, core_text_size;
 
-	/* The handle returned from unwind_add_table. */
-	void *unwind_info;
-
 	/* Arch-specific module values */
 	struct mod_arch_specific arch;
 
deleted file mode 100644
--- a/include/linux/unwind.h
+++ /dev/null
@@ -1,68 +0,0 @@
-#ifndef _LINUX_UNWIND_H
-#define _LINUX_UNWIND_H
-
-/*
- * Copyright (C) 2002-2006 Novell, Inc.
- *	Jan Beulich <jbeulich@novell.com>
- * This code is released under version 2 of the GNU GPL.
- *
- * A simple API for unwinding kernel stacks.  This is used for
- * debugging and error reporting purposes.  The kernel doesn't need
- * full-blown stack unwinding with all the bells and whistles, so there
- * is not much point in implementing the full Dwarf2 unwind API.
- */
-
-struct module;
-
-struct unwind_frame_info {};
-
-static inline void unwind_init(void) {}
-static inline void unwind_setup(void) {}
-
-#ifdef CONFIG_MODULES
-
-static inline void *unwind_add_table(struct module *mod,
-                                     const void *table_start,
-                                     unsigned long table_size)
-{
-	return NULL;
-}
-
-static inline void unwind_remove_table(void *handle, int init_only)
-{
-}
-
-#endif
-
-static inline int unwind_init_frame_info(struct unwind_frame_info *info,
-                                         struct task_struct *tsk,
-                                         const struct pt_regs *regs)
-{
-	return -ENOSYS;
-}
-
-static inline int unwind_init_blocked(struct unwind_frame_info *info,
-                                      struct task_struct *tsk)
-{
-	return -ENOSYS;
-}
-
-static inline int unwind_init_running(struct unwind_frame_info *info,
-                                      asmlinkage int (*cb)(struct unwind_frame_info *,
-                                                           void *arg),
-                                      void *arg)
-{
-	return -ENOSYS;
-}
-
-static inline int unwind(struct unwind_frame_info *info)
-{
-	return -ENOSYS;
-}
-
-static inline int unwind_to_user(struct unwind_frame_info *info)
-{
-	return -ENOSYS;
-}
-
-#endif /* _LINUX_UNWIND_H */
--- a/init/main.c
+++ b/init/main.c
@@ -51,7 +51,6 @@
 #include <linux/rmap.h>
 #include <linux/mempolicy.h>
 #include <linux/key.h>
-#include <linux/unwind.h>
 #include <linux/buffer_head.h>
 #include <linux/page_cgroup.h>
 #include <linux/debug_locks.h>
@@ -572,7 +571,6 @@ asmlinkage void __init start_kernel(void)
 	 * Need to run as early as possible, to initialize the
 	 * lockdep hash:
 	 */
-	unwind_init();
 	lockdep_init();
 	debug_objects_early_init();
 
@@ -600,7 +598,6 @@ asmlinkage void __init start_kernel(void)
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
-	unwind_setup();
 	cpu_alloc_init();
 	setup_per_cpu_areas();
 	setup_nr_cpu_ids();
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -43,7 +43,6 @@
 #include <linux/device.h>
 #include <linux/string.h>
 #include <linux/mutex.h>
-#include <linux/unwind.h>
 #include <linux/rculist.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1283,8 +1282,6 @@ static void free_module(struct module *mod)
 	remove_sect_attrs(mod);
 	mod_kobject_remove(mod);
 
-	unwind_remove_table(mod->unwind_info, 0);
-
 	/* Arch-specific cleanup. */
 	module_arch_cleanup(mod);
 
@@ -1691,7 +1688,6 @@ static noinline struct module *load_module(void __user *umod,
 	unsigned int symindex = 0;
 	unsigned int strindex = 0;
 	unsigned int modindex, versindex, infoindex, pcpuindex;
-	unsigned int unwindex = 0;
 	unsigned int num_kp, num_mcount;
 	struct kernel_param *kp;
 	struct module *mod;
@@ -1775,9 +1771,6 @@ static noinline struct module *load_module(void __user *umod,
 	versindex = find_sec(hdr, sechdrs, secstrings, "__versions");
 	infoindex = find_sec(hdr, sechdrs, secstrings, ".modinfo");
 	pcpuindex = find_pcpusec(hdr, sechdrs, secstrings);
-#ifdef ARCH_UNWIND_SECTION_NAME
-	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
-#endif
 
 	/* Don't keep modinfo and version sections. */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1787,8 +1780,6 @@ static noinline struct module *load_module(void __user *umod,
 	sechdrs[symindex].sh_flags |= SHF_ALLOC;
 	sechdrs[strindex].sh_flags |= SHF_ALLOC;
 #endif
-	if (unwindex)
-		sechdrs[unwindex].sh_flags |= SHF_ALLOC;
 
 	/* Check module struct version now, before we try to use module. */
 	if (!check_modstruct_version(sechdrs, versindex, mod)) {
@@ -2099,11 +2090,6 @@ static noinline struct module *load_module(void __user *umod,
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 
-	/* Size of section 0 is 0, so this works well if no unwind info. */
-	mod->unwind_info = unwind_add_table(mod,
-					    (void *)sechdrs[unwindex].sh_addr,
-					    sechdrs[unwindex].sh_size);
-
 	/* Get rid of temporary copy */
 	vfree(hdr);
 
@@ -2200,7 +2186,6 @@ sys_init_module(void __user *umod,
 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
 	module_put(mod);
-	unwind_remove_table(mod->unwind_info, 1);
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -6,7 +6,6 @@
 #include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/unwind.h>
 #include <linux/stacktrace.h>
 #include <linux/kallsyms.h>
 #include <linux/fault-inject.h>
