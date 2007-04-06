Return-Path: <linux-kernel-owner+w=401wt.eu-S1767470AbXDFAxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767470AbXDFAxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767469AbXDFAxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:53:02 -0400
Received: from gw.goop.org ([64.81.55.164]:48340 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767461AbXDFAxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:53:00 -0400
Message-ID: <461599C1.50002@goop.org>
Date: Thu, 05 Apr 2007 17:52:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
References: <46158674.5090709@vmware.com> <200704060154.41574.ak@suse.de> <46158DE1.4050508@vmware.com> <46158F8E.1050807@goop.org> <46158FBE.3090105@vmware.com> <461590EA.10605@goop.org> <4615924E.8020009@vmware.com> <46159555.4020706@goop.org> <4615982A.1070700@vmware.com>
In-Reply-To: <4615982A.1070700@vmware.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Yes, thought about several solutions, and this seems the best.  But it
> requires a new paravirt-op.

Not with the power of multiplexing.  Something like this, perhaps?

    J

diff -r 5be4a5ff8e6b arch/i386/mm/highmem.c
--- a/arch/i386/mm/highmem.c	Thu Apr 05 17:04:04 2007 -0700
+++ b/arch/i386/mm/highmem.c	Thu Apr 05 17:50:46 2007 -0700
@@ -42,6 +42,8 @@ void *kmap_atomic_prot(struct page *page
 
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
+
+	arch_flush_lazy_mmu_mode();
 
 	return (void*) vaddr;
 }
diff -r 5be4a5ff8e6b include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h	Thu Apr 05 17:04:04 2007 -0700
+++ b/include/asm-generic/pgtable.h	Thu Apr 05 17:50:46 2007 -0700
@@ -180,6 +180,7 @@ static inline void ptep_set_wrprotect(st
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 #define arch_enter_lazy_mmu_mode()	do {} while (0)
 #define arch_leave_lazy_mmu_mode()	do {} while (0)
+#define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
 /*
@@ -193,6 +194,7 @@ static inline void ptep_set_wrprotect(st
 #ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
 #define arch_enter_lazy_cpu_mode()	do {} while (0)
 #define arch_leave_lazy_cpu_mode()	do {} while (0)
+#define arch_flush_lazy_cpu_mode()	do {} while (0)
 #endif
 
 /*
diff -r 5be4a5ff8e6b include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Thu Apr 05 17:04:04 2007 -0700
+++ b/include/asm-i386/paravirt.h	Thu Apr 05 17:50:46 2007 -0700
@@ -27,9 +27,10 @@ struct desc_struct;
 
 /* Lazy mode for batching updates / context switch */
 enum paravirt_lazy_mode {
-	PARAVIRT_LAZY_NONE = 0,
-	PARAVIRT_LAZY_MMU = 1,
-	PARAVIRT_LAZY_CPU = 2,
+	PARAVIRT_LAZY_NONE = 0,		/* exit lazy mode */
+	PARAVIRT_LAZY_MMU = 1,		/* lazy mmu updates */
+	PARAVIRT_LAZY_CPU = 2,		/* lazy cpu state updates */
+	PARAVIRT_LAZY_FLUSH = 3,	/* flush pending changes, if any */
 };
 
 struct paravirt_ops
@@ -1044,6 +1045,10 @@ static inline void arch_leave_lazy_cpu_m
 {
 	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_NONE);
 }
+static inline void arch_flush_lazy_cpu_mode(void)
+{
+	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_FLUSH);
+}
 
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void)
@@ -1053,6 +1058,10 @@ static inline void arch_leave_lazy_mmu_m
 static inline void arch_leave_lazy_mmu_mode(void)
 {
 	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_NONE);
+}
+static inline void arch_flush_lazy_mmu_mode(void)
+{
+	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_FLUSH);
 }
 
 void _paravirt_nop(void);

