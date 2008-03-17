Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbYCQCEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbYCQCEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbYCQB6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:58:35 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:23348 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbYCQB6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:58:34 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
In-Reply-To: <20080317258.659191058@firstfloor.org>
To: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: [PATCH] [18/18] Implement hugepagesz= option for x86-64
Message-Id: <20080317015832.2E3DF1B41E0@basil.firstfloor.org>
Date: Mon, 17 Mar 2008 02:58:32 +0100 (CET)
X-OriginalArrivalTime: 17 Mar 2008 01:51:57.0908 (UTC) FILETIME=[7C0B2940:01C887D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add an hugepagesz=... option similar to IA64, PPC etc. to x86-64.

This finally allows to select GB pages for hugetlbfs in x86 now
that all the infrastructure is in place.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/kernel-parameters.txt |   11 +++++++++--
 arch/x86/mm/hugetlbpage.c           |   17 +++++++++++++++++
 include/asm-x86/page.h              |    2 ++
 3 files changed, 28 insertions(+), 2 deletions(-)

Index: linux/arch/x86/mm/hugetlbpage.c
===================================================================
--- linux.orig/arch/x86/mm/hugetlbpage.c
+++ linux/arch/x86/mm/hugetlbpage.c
@@ -421,3 +421,20 @@ hugetlb_get_unmapped_area(struct file *f
 
 #endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
 
+#ifdef CONFIG_X86_64
+static __init int setup_hugepagesz(char *opt)
+{
+	unsigned long ps = memparse(opt, &opt);
+	if (ps == PMD_SIZE) {
+		huge_add_hstate(PMD_SHIFT - PAGE_SHIFT);
+	} else if (ps == PUD_SIZE && cpu_has_gbpages) {
+		huge_add_hstate(PUD_SHIFT - PAGE_SHIFT);
+	} else {
+		printk(KERN_ERR "hugepagesz: Unsupported page size %lu M\n",
+			ps >> 20);
+		return 0;
+	}
+	return 1;
+}
+__setup("hugepagesz=", setup_hugepagesz);
+#endif
Index: linux/include/asm-x86/page.h
===================================================================
--- linux.orig/include/asm-x86/page.h
+++ linux/include/asm-x86/page.h
@@ -21,6 +21,8 @@
 #define HPAGE_MASK		(~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
 
+#define HUGE_MAX_HSTATE 2
+
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
 
Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -726,8 +726,15 @@ and is between 256 and 4096 characters. 
 	hisax=		[HW,ISDN]
 			See Documentation/isdn/README.HiSax.
 
-	hugepages=	[HW,X86-32,IA-64] Maximal number of HugeTLB pages.
-	hugepagesz=	[HW,IA-64,PPC] The size of the HugeTLB pages.
+	hugepages=	[HW,X86-32,IA-64] HugeTLB pages to allocate at boot.
+	hugepagesz=	[HW,IA-64,PPC,X86-64] The size of the HugeTLB pages.
+			On x86 this option can be specified multiple times
+			interleaved with hugepages= to reserve huge pages
+			of different sizes. Valid pages sizes on x86-64
+			are 2M (when the CPU supports "pse") and 1G (when the
+			CPU supports the "pdpe1gb" cpuinfo flag)
+			Note that 1GB pages can only be allocated at boot time
+			using hugepages= and not freed afterwards.
 
 	i8042.direct	[HW] Put keyboard port into non-translated mode
 	i8042.dumbkbd	[HW] Pretend that controller can only read data from
