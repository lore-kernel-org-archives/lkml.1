Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbXLEH4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbXLEH4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbXLEHzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:19 -0500
Received: from ns2.suse.de ([195.135.220.15]:42662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbXLEHzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:10 -0500
Message-Id: <20071205071626.816160000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:15:48 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 01/18] ia64: ia32 nopage
Content-Disposition: inline; filename=ia64-ia32-nopage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert ia64's ia32 support from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/ia64/ia32/binfmt_elf32.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/ia64/ia32/binfmt_elf32.c
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/binfmt_elf32.c
+++ linux-2.6/arch/ia64/ia32/binfmt_elf32.c
@@ -52,33 +52,29 @@ extern struct page *ia32_shared_page[];
 extern unsigned long *ia32_gdt;
 extern struct page *ia32_gate_page;
 
-struct page *
-ia32_install_shared_page (struct vm_area_struct *vma, unsigned long address, int *type)
+int
+ia32_install_shared_page (struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	struct page *pg = ia32_shared_page[smp_processor_id()];
-	get_page(pg);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return pg;
-}
-
-struct page *
-ia32_install_gate_page (struct vm_area_struct *vma, unsigned long address, int *type)
-{
-	struct page *pg = ia32_gate_page;
-	get_page(pg);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return pg;
+	vmf->page = ia32_shared_page[smp_processor_id()];
+	get_page(vmf->page);
+	return 0;
+}
+
+int
+ia32_install_gate_page (struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	vmf->page = ia32_gate_page;
+	get_page(vmf->page);
+	return 0;
 }
 
 
 static struct vm_operations_struct ia32_shared_page_vm_ops = {
-	.nopage = ia32_install_shared_page
+	.fault = ia32_install_shared_page
 };
 
 static struct vm_operations_struct ia32_gate_page_vm_ops = {
-	.nopage = ia32_install_gate_page
+	.fault = ia32_install_gate_page
 };
 
 void

-- 

