Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbXHVINc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbXHVINc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbXHVIMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:12:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48180 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXHVIML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:12:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: [RFC][PATCH -mm 3/4] Hibernation: Pass CR3 in the image header on x86_64
Date: Wed, 22 Aug 2007 10:20:34 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708221015.16493.rjw@sisk.pl>
In-Reply-To: <200708221015.16493.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708221020.34988.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since we already pass the address of restore_registers() in the image header,
we can also pass the value of the CR3 register from before the hibernation in
the same way.  This will allow us to avoid using init_level4_pgt page tables
during the restore.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86_64/kernel/suspend.c     |   26 +++++++++++++++++++++-----
 arch/x86_64/kernel/suspend_asm.S |    8 +++++---
 2 files changed, 26 insertions(+), 8 deletions(-)

Index: linux-2.6.23-rc3/arch/x86_64/kernel/suspend.c
===================================================================
--- linux-2.6.23-rc3.orig/arch/x86_64/kernel/suspend.c
+++ linux-2.6.23-rc3/arch/x86_64/kernel/suspend.c
@@ -9,6 +9,7 @@
 
 #include <linux/smp.h>
 #include <linux/suspend.h>
+#include <linux/crc32.h>
 #include <asm/proto.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -150,6 +151,12 @@ extern int restore_image(void);
  */
 unsigned long restore_jump_address;
 
+/*
+ * Value of the cr3 register from before the hibernation (this value is passed
+ * in the image header).
+ */
+unsigned long restore_cr3;
+
 pgd_t *temp_level4_pgt;
 
 static int res_phys_pud_init(pud_t *pud, unsigned long address, unsigned long end)
@@ -239,7 +246,9 @@ int pfn_is_nosave(unsigned long pfn)
 
 struct restore_data_record {
 	unsigned long jump_address;
-	unsigned long control;
+	unsigned long cr3;
+	unsigned long magic;
+	u32 crc;
 };
 
 #define RESTORE_MAGIC	0x0123456789ABCDEFUL
@@ -253,10 +262,13 @@ int arch_hibernation_header_save(void *a
 {
 	struct restore_data_record *rdr = addr;
 
-	if (max_size < sizeof(struct restore_data_record))
+	if (max_size < sizeof(*rdr))
 		return -EOVERFLOW;
 	rdr->jump_address = restore_jump_address;
-	rdr->control = (restore_jump_address ^ RESTORE_MAGIC);
+	rdr->cr3 = restore_cr3;
+	rdr->magic = RESTORE_MAGIC;
+	rdr->crc = 0;
+	rdr->crc = crc32_le(0, addr, sizeof(*rdr));
 	return 0;
 }
 
@@ -268,9 +280,13 @@ int arch_hibernation_header_save(void *a
 int arch_hibernation_header_restore(void *addr)
 {
 	struct restore_data_record *rdr = addr;
+	u32 crc;
 
 	restore_jump_address = rdr->jump_address;
-	return (rdr->control == (restore_jump_address ^ RESTORE_MAGIC)) ?
-			0 : -EINVAL;
+	restore_cr3 = rdr->cr3;
+	crc = rdr->crc;
+	rdr->crc = 0;
+	return (crc == crc32_le(0, addr, sizeof(*rdr))
+		&& rdr->magic == RESTORE_MAGIC) ? 0 : -EINVAL;
 }
 #endif /* CONFIG_HIBERNATION */
Index: linux-2.6.23-rc3/arch/x86_64/kernel/suspend_asm.S
===================================================================
--- linux-2.6.23-rc3.orig/arch/x86_64/kernel/suspend_asm.S
+++ linux-2.6.23-rc3/arch/x86_64/kernel/suspend_asm.S
@@ -39,6 +39,9 @@ ENTRY(swsusp_arch_suspend)
 	/* save the address of restore_registers */
 	movq	$restore_registers, %rax
 	movq	%rax, restore_jump_address(%rip)
+	/* save cr3 */
+	movq	%cr3, %rax
+	movq	%rax, restore_cr3(%rip)
 
 	call swsusp_save
 	ret
@@ -66,6 +69,7 @@ ENTRY(restore_image)
 
 	/* prepare to jump to the image kernel */
 	movq	restore_jump_address(%rip), %rax
+	movq	restore_cr3(%rip), %rbx
 
 	/* copy image data to their original locations */
 	xorq	%r10, %r10
@@ -116,9 +120,7 @@ ENTRY(restore_registers)
 	movsq
 
 	/* go back to the original page tables */
-1:	movq    $(init_level4_pgt - __START_KERNEL_map), %rax
-	addq    phys_base(%rip), %rax
-	movq    %rax, %cr3
+1:	movq    %rbx, %cr3
 
 	/* Flush TLB, including "global" things (vmalloc) */
 	movq	mmu_cr4_features(%rip), %rax

