Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZG1KH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZG1KH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZG1KH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:07:58 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:49858 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbZG1KH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:07:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CRD4rEqgTc5URDsIxp9vU62a6eiF711LBHTlEFxHZXamgw0hFKCgwLsKWuxuORcAlU
         O+IEMWGW3tY5AP+BoZo/GHVGXd75UxqzKIB/8tWTrRHYDlnnirvQVHNZ//mKzJwdEUBZ
         NYsxkst1rimLM8hkTZs5NfOs2qULSx5Ki3BwU=
Date: Tue, 28 Jul 2009 18:10:09 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xiyou.wangcong@gmail.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       ralf@linux-mips.org, benh@kernel.crashing.org, lethal@linux-sh.org
Subject: Re: [RFC][PATCH 4/6] kcore: kcore unify text range entry
Message-ID: <20090728101009.GF6036@cr0.nay.redhat.com>
References: <20090724170819.2625ba07.kamezawa.hiroyu@jp.fujitsu.com> <20090724171522.701497e3.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724171522.701497e3.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 05:15:22PM +0900, KAMEZAWA Hiroyuki wrote:
>From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
>Some 64bit arch has a special segment for mapping kernel text. It should be
>entried to /proc/kcore in addtion to direct-linear-map, vmalloc area.
>This patch unifies KCORE_TEXT entry scattered under x86 and ia64.
>
>I'm not familiar with other archs (mips has its own even after this patch)
>If range of [_stext ..._end) is a valid area of text/data and it's not
>in direct-map/vmalloc area, defining CONFIG_ARCH_PROC_KCORE_TEXT is only
>a necessary thing to do for archs.
>
>Note: I left mips-64 as it is now.
>
>Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Excellent.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

>---
>Index: mmotm-2.6.31-Jul16/arch/x86/Kconfig
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/x86/Kconfig
>+++ mmotm-2.6.31-Jul16/arch/x86/Kconfig
>@@ -1244,6 +1244,10 @@ config ARCH_MEMORY_PROBE
> 	def_bool X86_64
> 	depends on MEMORY_HOTPLUG
> 
>+config ARCH_PROC_KCORE_TEXT
>+	def_bool y
>+	depends on X86_64 && PROC_KCORE
>+
> config ILLEGAL_POINTER_VALUE
>        hex
>        default 0 if X86_32
>Index: mmotm-2.6.31-Jul16/arch/ia64/Kconfig
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/ia64/Kconfig
>+++ mmotm-2.6.31-Jul16/arch/ia64/Kconfig
>@@ -496,6 +496,10 @@ config HAVE_ARCH_NODEDATA_EXTENSION
> 	def_bool y
> 	depends on NUMA
> 
>+config ARCH_PROC_KCORE_TEXT
>+	def_bool y
>+	depends on PROC_KCORE
>+
> config IA32_SUPPORT
> 	bool "Support for Linux/x86 binaries"
> 	help
>Index: mmotm-2.6.31-Jul16/arch/ia64/mm/init.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/ia64/mm/init.c
>+++ mmotm-2.6.31-Jul16/arch/ia64/mm/init.c
>@@ -617,7 +617,6 @@ mem_init (void)
> 	long reserved_pages, codesize, datasize, initsize;
> 	pg_data_t *pgdat;
> 	int i;
>-	static struct kcore_list kcore_kernel;
> 
> 	BUG_ON(PTRS_PER_PGD * sizeof(pgd_t) != PAGE_SIZE);
> 	BUG_ON(PTRS_PER_PMD * sizeof(pmd_t) != PAGE_SIZE);
>@@ -637,7 +636,6 @@ mem_init (void)
> 	max_mapnr = max_low_pfn;
> #endif
> 	high_memory = __va(max_low_pfn * PAGE_SIZE);
>-	kclist_add(&kcore_kernel, _stext, _end - _stext, KCORE_TEXT);
> 
> 	for_each_online_pgdat(pgdat)
> 		if (pgdat->bdata->node_bootmem_map)
>Index: mmotm-2.6.31-Jul16/arch/x86/mm/init_64.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/x86/mm/init_64.c
>+++ mmotm-2.6.31-Jul16/arch/x86/mm/init_64.c
>@@ -647,8 +647,7 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
> 
> #endif /* CONFIG_MEMORY_HOTPLUG */
> 
>-static struct kcore_list kcore_mem, kcore_kernel,
>-			 kcore_modules, kcore_vsyscall;
>+static struct kcore_list kcore_mem, kcore_modules, kcore_vsyscall;
> 
> void __init mem_init(void)
> {
>@@ -678,7 +677,6 @@ void __init mem_init(void)
> 
> 	/* Register memory areas for /proc/kcore */
> 	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
>-	kclist_add(&kcore_kernel, &_stext, _end - _stext, KCORE_TEXT);
> 	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN,
> 			KCORE_OTHER);
> 	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START,
>Index: mmotm-2.6.31-Jul16/fs/proc/kcore.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/fs/proc/kcore.c
>+++ mmotm-2.6.31-Jul16/fs/proc/kcore.c
>@@ -21,6 +21,7 @@
> #include <asm/uaccess.h>
> #include <asm/io.h>
> #include <linux/list.h>
>+#include <asm/sections.h>
> 
> #define CORE_STR "CORE"
> 
>@@ -408,10 +409,26 @@ read_kcore(struct file *file, char __use
> 
> static struct kcore_list kcore_vmalloc;
> 
>+#ifdef CONFIG_ARCH_PROC_KCORE_TEXT
>+static struct kcore_list kcore_text;
>+/*
>+ * If defined, special segment is used for mapping kernel text instead of
>+ * direct-map area. We need to create special TEXT section.
>+ */
>+static void __init proc_kcore_text_init(void)
>+{
>+	kclist_add(&kcore_text, _stext, _end - _stext, KCORE_TEXT);
>+}
>+#else
>+static void __init proc_kcore_text_init(void)
>+{
>+}
>+#endif
>+
> static int __init proc_kcore_init(void)
> {
> 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
>-
>+	proc_kcore_text_init();
> 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
> 		VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
> 	return 0;
>
