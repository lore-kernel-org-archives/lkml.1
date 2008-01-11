Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbYAKJWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbYAKJWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbYAKJWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:22:21 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:32708
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313AbYAKJWT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:22:19 -0500
Message-Id: <4787436E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 11 Jan 2008 09:22:38 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@xensource.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] adjust/fix LDT handling for Xen
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't rely on kmalloc(PAGE_SIZE) returning PAGE_SIZE aligned memory
(Xen requires GDT *and* LDT to be page-aligned). Using the page
allocator interface also removes the (albeit small) slab allocator
overhead. The same change being done for 64-bits for consistency.

Further, the Xen hypercall interface expects the LDT address to be
virtual, not machine.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/kernel/ldt_32.c |    7 +++----
 arch/x86/kernel/ldt_64.c |    7 +++----
 arch/x86/xen/enlighten.c |    9 +--------
 3 files changed, 7 insertions(+), 16 deletions(-)

--- linux-2.6.24-rc7/arch/x86/kernel/ldt_32.c	2008-01-10 16:53:54.000000000 +0100
+++ 2.6.24-rc7-x86-xen-ldt/arch/x86/kernel/ldt_32.c	2008-01-09 13:59:50.000000000 +0100
@@ -9,7 +9,6 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/vmalloc.h>
-#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -38,7 +37,7 @@ static int alloc_ldt(mm_context_t *pc, i
 	if (mincount*LDT_ENTRY_SIZE > PAGE_SIZE)
 		newldt = vmalloc(mincount*LDT_ENTRY_SIZE);
 	else
-		newldt = kmalloc(mincount*LDT_ENTRY_SIZE, GFP_KERNEL);
+		newldt = (void *)__get_free_page(GFP_KERNEL);
 
 	if (!newldt)
 		return -ENOMEM;
@@ -69,7 +68,7 @@ static int alloc_ldt(mm_context_t *pc, i
 		if (oldsize*LDT_ENTRY_SIZE > PAGE_SIZE)
 			vfree(oldldt);
 		else
-			kfree(oldldt);
+			put_page(virt_to_page(oldldt));
 	}
 	return 0;
 }
@@ -114,7 +113,7 @@ void destroy_context(struct mm_struct *m
 		if (mm->context.size*LDT_ENTRY_SIZE > PAGE_SIZE)
 			vfree(mm->context.ldt);
 		else
-			kfree(mm->context.ldt);
+			put_page(virt_to_page(mm->context.ldt));
 		mm->context.size = 0;
 	}
 }
--- linux-2.6.24-rc7/arch/x86/kernel/ldt_64.c	2008-01-10 16:53:54.000000000 +0100
+++ 2.6.24-rc7-x86-xen-ldt/arch/x86/kernel/ldt_64.c	2008-01-09 13:59:50.000000000 +0100
@@ -12,7 +12,6 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/vmalloc.h>
-#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -41,7 +40,7 @@ static int alloc_ldt(mm_context_t *pc, u
 	if (mincount*LDT_ENTRY_SIZE > PAGE_SIZE)
 		newldt = vmalloc(mincount*LDT_ENTRY_SIZE);
 	else
-		newldt = kmalloc(mincount*LDT_ENTRY_SIZE, GFP_KERNEL);
+		newldt = (void *)__get_free_page(GFP_KERNEL);
 
 	if (!newldt)
 		return -ENOMEM;
@@ -73,7 +72,7 @@ static int alloc_ldt(mm_context_t *pc, u
 		if (oldsize*LDT_ENTRY_SIZE > PAGE_SIZE)
 			vfree(oldldt);
 		else
-			kfree(oldldt);
+			put_page(virt_to_page(oldldt));
 	}
 	return 0;
 }
@@ -117,7 +116,7 @@ void destroy_context(struct mm_struct *m
 		if ((unsigned)mm->context.size*LDT_ENTRY_SIZE > PAGE_SIZE)
 			vfree(mm->context.ldt);
 		else
-			kfree(mm->context.ldt);
+			put_page(virt_to_page(mm->context.ldt));
 		mm->context.size = 0;
 	}
 }
--- linux-2.6.24-rc7/arch/x86/xen/enlighten.c	2008-01-10 16:53:55.000000000 +0100
+++ 2.6.24-rc7-x86-xen-ldt/arch/x86/xen/enlighten.c	2008-01-09 14:00:51.000000000 +0100
@@ -275,19 +275,12 @@ static unsigned long xen_store_tr(void)
 
 static void xen_set_ldt(const void *addr, unsigned entries)
 {
-	unsigned long linear_addr = (unsigned long)addr;
 	struct mmuext_op *op;
 	struct multicall_space mcs = xen_mc_entry(sizeof(*op));
 
 	op = mcs.args;
 	op->cmd = MMUEXT_SET_LDT;
-	if (linear_addr) {
-		/* ldt my be vmalloced, use arbitrary_virt_to_machine */
-		xmaddr_t maddr;
-		maddr = arbitrary_virt_to_machine((unsigned long)addr);
-		linear_addr = (unsigned long)maddr.maddr;
-	}
-	op->arg1.linear_addr = linear_addr;
+	op->arg1.linear_addr = (unsigned long)addr;
 	op->arg2.nr_ents = entries;
 
 	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);



