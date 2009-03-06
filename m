Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZCFSg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZCFSg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZCFSgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:36:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49944 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbZCFSgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:36:47 -0500
Date: Fri, 6 Mar 2009 19:36:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] x86 fixes
Message-ID: <20090306183634.GA10546@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Brian Maly (1):
      x86: fix DMI on EFI

Daniel Glöckner (1):
      x86, math-emu: fix init_fpu for task != current

Huang Ying (1):
      x86: EFI: Back efi_ioremap with init_memory_mapping instead of FIX_MAP

Leann Ogasawara (1):
      x86: add Dell XPS710 reboot quirk

Markus Metzger (2):
      x86, bts: remove bad warning
      x86, pebs: correct qualifier passed to ds_write_config() from ds_request_pebs()


 arch/x86/include/asm/efi.h       |    2 --
 arch/x86/include/asm/fixmap_64.h |    4 ----
 arch/x86/include/asm/i387.h      |    8 +++++++-
 arch/x86/kernel/ds.c             |    3 +--
 arch/x86/kernel/efi.c            |    7 +++++--
 arch/x86/kernel/efi_64.c         |   21 ++++-----------------
 arch/x86/kernel/i387.c           |    2 +-
 arch/x86/kernel/reboot.c         |    8 ++++++++
 arch/x86/kernel/setup.c          |    5 +++--
 arch/x86/math-emu/fpu_aux.c      |   31 ++++++++++++++++++++-----------
 10 files changed, 49 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index ca5ffb2..edc90f2 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -37,8 +37,6 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #else /* !CONFIG_X86_32 */
 
-#define MAX_EFI_IO_PAGES	100
-
 extern u64 efi_call0(void *fp);
 extern u64 efi_call1(void *fp, u64 arg1);
 extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
diff --git a/arch/x86/include/asm/fixmap_64.h b/arch/x86/include/asm/fixmap_64.h
index 00a30ab..8be7409 100644
--- a/arch/x86/include/asm/fixmap_64.h
+++ b/arch/x86/include/asm/fixmap_64.h
@@ -16,7 +16,6 @@
 #include <asm/apicdef.h>
 #include <asm/page.h>
 #include <asm/vsyscall.h>
-#include <asm/efi.h>
 
 /*
  * Here we define all the compile-time 'special' virtual
@@ -43,9 +42,6 @@ enum fixed_addresses {
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 	FIX_IO_APIC_BASE_0,
 	FIX_IO_APIC_BASE_END = FIX_IO_APIC_BASE_0 + MAX_IO_APICS - 1,
-	FIX_EFI_IO_MAP_LAST_PAGE,
-	FIX_EFI_IO_MAP_FIRST_PAGE = FIX_EFI_IO_MAP_LAST_PAGE
-				  + MAX_EFI_IO_PAGES - 1,
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 48f0004..71c9e51 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -172,7 +172,13 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 
 #else  /* CONFIG_X86_32 */
 
-extern void finit(void);
+#ifdef CONFIG_MATH_EMULATION
+extern void finit_task(struct task_struct *tsk);
+#else
+static inline void finit_task(struct task_struct *tsk)
+{
+}
+#endif
 
 static inline void tolerant_fwait(void)
 {
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 169a120..87b67e3 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -729,7 +729,7 @@ struct pebs_tracer *ds_request_pebs(struct task_struct *task,
 
 	spin_unlock_irqrestore(&ds_lock, irq);
 
-	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_bts);
+	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_pebs);
 	ds_resume_pebs(tracer);
 
 	return tracer;
@@ -1029,5 +1029,4 @@ void ds_copy_thread(struct task_struct *tsk, struct task_struct *father)
 
 void ds_exit_thread(struct task_struct *tsk)
 {
-	WARN_ON(tsk->thread.ds_ctx);
 }
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 1119d24..eb1ef3b 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -467,7 +467,7 @@ void __init efi_enter_virtual_mode(void)
 	efi_memory_desc_t *md;
 	efi_status_t status;
 	unsigned long size;
-	u64 end, systab, addr, npages;
+	u64 end, systab, addr, npages, end_pfn;
 	void *p, *va;
 
 	efi.systab = NULL;
@@ -479,7 +479,10 @@ void __init efi_enter_virtual_mode(void)
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
 
-		if (PFN_UP(end) <= max_low_pfn_mapped)
+		end_pfn = PFN_UP(end);
+		if (end_pfn <= max_low_pfn_mapped
+		    || (end_pfn > (1UL << (32 - PAGE_SHIFT))
+			&& end_pfn <= max_pfn_mapped))
 			va = __va(md->phys_addr);
 		else
 			va = efi_ioremap(md->phys_addr, size);
diff --git a/arch/x86/kernel/efi_64.c b/arch/x86/kernel/efi_64.c
index 652c528..cb783b9 100644
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -99,24 +99,11 @@ void __init efi_call_phys_epilog(void)
 
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size)
 {
-	static unsigned pages_mapped __initdata;
-	unsigned i, pages;
-	unsigned long offset;
+	unsigned long last_map_pfn;
 
-	pages = PFN_UP(phys_addr + size) - PFN_DOWN(phys_addr);
-	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
-
-	if (pages_mapped + pages > MAX_EFI_IO_PAGES)
+	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
+	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size)
 		return NULL;
 
-	for (i = 0; i < pages; i++) {
-		__set_fixmap(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
-			     phys_addr, PAGE_KERNEL);
-		phys_addr += PAGE_SIZE;
-		pages_mapped++;
-	}
-
-	return (void __iomem *)__fix_to_virt(FIX_EFI_IO_MAP_FIRST_PAGE - \
-					     (pages_mapped - pages)) + offset;
+	return (void __iomem *)__va(phys_addr);
 }
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index b0f61f0..f2f8540 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -136,7 +136,7 @@ int init_fpu(struct task_struct *tsk)
 #ifdef CONFIG_X86_32
 	if (!HAVE_HWFP) {
 		memset(tsk->thread.xstate, 0, xstate_size);
-		finit();
+		finit_task(tsk);
 		set_stopped_child_used_math(tsk);
 		return 0;
 	}
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 2b46eb4..4526b3a 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -217,6 +217,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell XPS710 */
+		.callback = set_bios_reboot,
+		.ident = "Dell XPS710",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell XPS710"),
+		},
+	},
 	{ }
 };
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c461f6d..6a8811a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -770,6 +770,9 @@ void __init setup_arch(char **cmdline_p)
 
 	finish_e820_parsing();
 
+	if (efi_enabled)
+		efi_init();
+
 	dmi_scan_machine();
 
 	dmi_check_system(bad_bios_dmi_table);
@@ -789,8 +792,6 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
-	if (efi_enabled)
-		efi_init();
 
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
diff --git a/arch/x86/math-emu/fpu_aux.c b/arch/x86/math-emu/fpu_aux.c
index 491e737..aa09870 100644
--- a/arch/x86/math-emu/fpu_aux.c
+++ b/arch/x86/math-emu/fpu_aux.c
@@ -30,20 +30,29 @@ static void fclex(void)
 }
 
 /* Needs to be externally visible */
-void finit(void)
+void finit_task(struct task_struct *tsk)
 {
-	control_word = 0x037f;
-	partial_status = 0;
-	top = 0;		/* We don't keep top in the status word internally. */
-	fpu_tag_word = 0xffff;
+	struct i387_soft_struct *soft = &tsk->thread.xstate->soft;
+	struct address *oaddr, *iaddr;
+	soft->cwd = 0x037f;
+	soft->swd = 0;
+	soft->ftop = 0;	/* We don't keep top in the status word internally. */
+	soft->twd = 0xffff;
 	/* The behaviour is different from that detailed in
 	   Section 15.1.6 of the Intel manual */
-	operand_address.offset = 0;
-	operand_address.selector = 0;
-	instruction_address.offset = 0;
-	instruction_address.selector = 0;
-	instruction_address.opcode = 0;
-	no_ip_update = 1;
+	oaddr = (struct address *)&soft->foo;
+	oaddr->offset = 0;
+	oaddr->selector = 0;
+	iaddr = (struct address *)&soft->fip;
+	iaddr->offset = 0;
+	iaddr->selector = 0;
+	iaddr->opcode = 0;
+	soft->no_update = 1;
+}
+
+void finit(void)
+{
+	finit_task(current);
 }
 
 /*
