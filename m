Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbYGRMhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbYGRMhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYGRMhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:37:32 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:30517 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582AbYGRMhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:37:31 -0400
Message-Id: <4880AAC1.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 13:37:53 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix two modpost warnings
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though it's only the difference of the two __initdata symbols
that's being calculated, modpost still doesn't like this. So rather
calculate the size once in an __init function and store it for later
use.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/vdso/vma.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- linux-2.6.26/arch/x86/vdso/vma.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.26-x86-modpost-warnings/arch/x86/vdso/vma.c	2008-07-15 14:51:28.000000000 +0200
@@ -21,7 +21,8 @@ int vdso_enabled = 1;
 extern char vdso_start[], vdso_end[];
 extern unsigned short vdso_sync_cpuid;
 
-struct page **vdso_pages;
+static struct page **vdso_pages;
+static unsigned vdso_size;
 
 static inline void *var_ref(void *p, char *name)
 {
@@ -38,6 +39,7 @@ static int __init init_vdso_vars(void)
 	int i;
 	char *vbase;
 
+	vdso_size = npages << PAGE_SHIFT;
 	vdso_pages = kmalloc(sizeof(struct page *) * npages, GFP_KERNEL);
 	if (!vdso_pages)
 		goto oom;
@@ -101,20 +103,19 @@ int arch_setup_additional_pages(struct l
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
 	int ret;
-	unsigned len = round_up(vdso_end - vdso_start, PAGE_SIZE);
 
 	if (!vdso_enabled)
 		return 0;
 
 	down_write(&mm->mmap_sem);
-	addr = vdso_addr(mm->start_stack, len);
-	addr = get_unmapped_area(NULL, addr, len, 0, 0);
+	addr = vdso_addr(mm->start_stack, vdso_size);
+	addr = get_unmapped_area(NULL, addr, vdso_size, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
 		goto up_fail;
 	}
 
-	ret = install_special_mapping(mm, addr, len,
+	ret = install_special_mapping(mm, addr, vdso_size,
 				      VM_READ|VM_EXEC|
 				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
 				      VM_ALWAYSDUMP,



