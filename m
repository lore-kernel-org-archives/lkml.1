Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbYG1Cpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbYG1Cpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 22:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYG1Cpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 22:45:31 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:50898 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbYG1Cpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 22:45:30 -0400
Date: Mon, 28 Jul 2008 12:45:28 +1000
From: Simon Horman <horms@verge.net.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Chandru <chandru@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Terry Loftin <terry.loftin@hp.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch] crashdump: fix undefined reference to `elfcorehdr_addr'
Message-ID: <20080728024526.GB3334@verge.net.au>
References: <20080727234529.GM6175@verge.net.au> <20080728015117.GA12055@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728015117.GA12055@verge.net.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rfc patch I made to rename is_kdump_kernel to kernel_has_vmcore,
which I appended to my previous post should have looked more like the
following. Although, as I noted in my previous post, its more a starting
point for discussion than a solution to the problem at hand.

Index: linux-2.6/arch/x86/kernel/pci-calgary_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-calgary_64.c	2008-07-28 10:10:31.000000000 +1000
+++ linux-2.6/arch/x86/kernel/pci-calgary_64.c	2008-07-28 10:14:24.000000000 +1000
@@ -801,7 +801,7 @@ static int __init calgary_setup_tar(stru
 	tbl = pci_iommu(dev->bus);
 	tbl->it_base = (unsigned long)bus_info[dev->bus->number].tce_space;
 
-	if (is_kdump_kernel())
+	if (kernel_has_vmcore())
 		calgary_init_bitmap_from_tce_table(tbl);
 	else
 		tce_free(tbl, 0, tbl->it_size);
@@ -1184,7 +1184,7 @@ static int __init calgary_init(void)
 		return ret;
 
 	/* Purely for kdump kernel case */
-	if (is_kdump_kernel())
+	if (kernel_has_vmcore())
 		get_tce_space_from_tar();
 
 	do {
@@ -1438,7 +1438,7 @@ void __init detect_calgary(void)
 		return;
 	}
 
-	specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
+	specified_table_size = determine_tce_table_size((kernel_has_vmcore() ?
 					saved_max_pfn : max_pfn) * PAGE_SIZE);
 
 	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
@@ -1461,7 +1461,7 @@ void __init detect_calgary(void)
 			 * If it is kdump kernel, find and use tce tables
 			 * from first kernel, else allocate tce tables here
 			 */
-			if (!is_kdump_kernel()) {
+			if (!kernel_has_vmcore()) {
 				tbl = alloc_tce_table();
 				if (!tbl)
 					goto cleanup;
Index: linux-2.6/fs/proc/vmcore.c
===================================================================
--- linux-2.6.orig/fs/proc/vmcore.c	2008-07-28 09:51:30.000000000 +1000
+++ linux-2.6/fs/proc/vmcore.c	2008-07-28 09:51:53.000000000 +1000
@@ -32,8 +32,7 @@ static size_t elfcorebuf_sz;
 /* Total size of vmcore file. */
 static u64 vmcore_size;
 
-/* Stores the physical address of elf header of crash image. */
-unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+unsigned long long elfcorehdr_addr;
 
 struct proc_dir_entry *proc_vmcore = NULL;
 
Index: linux-2.6/include/linux/crash_dump.h
===================================================================
--- linux-2.6.orig/include/linux/crash_dump.h	2008-07-28 09:46:29.000000000 +1000
+++ linux-2.6/include/linux/crash_dump.h	2008-07-28 10:43:03.000000000 +1000
@@ -11,8 +11,13 @@
 
 #ifdef CONFIG_PROC_VMCORE
 extern unsigned long long elfcorehdr_addr;
+
+static inline int kernel_has_vmcore(void)
+{
+	return (elfcorehdr_addr != ELFCORE_ADDR_MAX) ? 1 : 0;
+}
 #else
-static const unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+static inline int kernel_has_vmcore(void) { return 0; }
 #endif
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
@@ -28,12 +33,6 @@ extern struct proc_dir_entry *proc_vmcor
 
 #define vmcore_elf_check_arch(x) (elf_check_arch(x) || vmcore_elf_check_arch_cross(x))
 
-static inline int is_kdump_kernel(void)
-{
-	return (elfcorehdr_addr != ELFCORE_ADDR_MAX) ? 1 : 0;
-}
-#else /* !CONFIG_CRASH_DUMP */
-static inline int is_kdump_kernel(void) { return 0; }
 #endif /* CONFIG_CRASH_DUMP */
 
 extern unsigned long saved_max_pfn;
