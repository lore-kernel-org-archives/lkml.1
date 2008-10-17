Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbYJQR2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbYJQR2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYJQR16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:27:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59822 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbYJQR15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:27:57 -0400
Date: Fri, 17 Oct 2008 19:27:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20081017172747.GA21992@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
mm/vmalloc.c                       # 73bdf0a: Introduce is_vmalloc_or_module_ad

 Thanks,

	Ingo

------------------>
Linus Torvalds (1):
      Introduce is_vmalloc_or_module_addr() and use with DEBUG_VIRTUAL

Rafael J. Wysocki (1):
      x86 ACPI: fix breakage of resume on 64-bit UP systems with SMP kernel


 arch/x86/kernel/acpi/sleep.c |    3 +++
 mm/vmalloc.c                 |   18 ++++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 426e5d9..c44cd6d 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -10,6 +10,7 @@
 #include <linux/dmi.h>
 #include <linux/cpumask.h>
 #include <asm/segment.h>
+#include <asm/desc.h>
 
 #include "realmode/wakeup.h"
 #include "sleep.h"
@@ -98,6 +99,8 @@ int acpi_save_state_mem(void)
 	header->trampoline_segment = setup_trampoline() >> 4;
 #ifdef CONFIG_SMP
 	stack_start.sp = temp_stack + 4096;
+	early_gdt_descr.address =
+			(unsigned long)get_cpu_gdt_table(smp_processor_id());
 #endif
 	initial_code = (unsigned long)wakeup_long64;
 	saved_magic = 0x123456789abcdef0;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bba06c4..f018d7e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -168,6 +168,21 @@ int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
 }
 EXPORT_SYMBOL_GPL(map_vm_area);
 
+static inline int is_vmalloc_or_module_addr(const void *x)
+{
+	/*
+	 * x86-64 and sparc64 put modules in a special place,
+	 * and fall back on vmalloc() if that fails. Others
+	 * just put it in the vmalloc space.
+	 */
+#if defined(CONFIG_MODULES) && defined(MODULES_VADDR)
+	unsigned long addr = (unsigned long)x;
+	if (addr >= MODULES_VADDR && addr < MODULES_END)
+		return 1;
+#endif
+	return is_vmalloc_addr(x);
+}
+
 /*
  * Map a vmalloc()-space virtual address to the physical page.
  */
@@ -184,8 +199,7 @@ struct page *vmalloc_to_page(const void *vmalloc_addr)
 	 * XXX we might need to change this if we add VIRTUAL_BUG_ON for
 	 * architectures that do not vmalloc module space
 	 */
-	VIRTUAL_BUG_ON(!is_vmalloc_addr(vmalloc_addr) &&
-			!is_module_address(addr));
+	VIRTUAL_BUG_ON(!is_vmalloc_or_module_addr(vmalloc_addr));
 
 	if (!pgd_none(*pgd)) {
 		pud = pud_offset(pgd, addr);
