Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbXI1GKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbXI1GKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 02:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbXI1GJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 02:09:54 -0400
Received: from owa.c2.net ([207.235.78.2]:28438 "EHLO email.c2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014AbXI1GJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 02:09:53 -0400
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 02:09:53 EDT
Subject: [PATCH] Inconsistent mmap()/mremap() flags
From: Thayne Harbaugh <thayne@c2.net>
Reply-To: thayne@c2.net
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, linux-mm@kvack.org, discuss@x86-64.org
Content-Type: text/plain
Organization: C2
Date: Thu, 27 Sep 2007 23:46:33 -0600
Message-Id: <1190958393.5128.85.camel@phantasm.home.enterpriseandprosperity.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Sep 2007 05:53:38.0715 (UTC) FILETIME=[EA8F76B0:01C80193]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The x86_64 mmap() accepts the MAP_32BIT flag to request 32-bit clean
addresses.  It seems to me that for consistency x86_64 mremap() should
also accept this (or an equivalent) flag.

Here is a trivial and untested patch for basis of discussion:

--- linux-source-2.6.22/mm/mremap.c.orig	2007-09-27 23:02:13.000000000 -0600
+++ linux-source-2.6.22/mm/mremap.c	2007-09-27 23:07:29.000000000 -0600
@@ -23,6 +23,11 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>

+/* MAP_32BIT possibly defined in asm/mman.h */
+#ifndef MAP_32BIT
+#define MAP_32BIT 0
+#endif
+
 static pmd_t *get_old_pmd(struct mm_struct *mm, unsigned long addr)
 {
 	pgd_t *pgd;
@@ -255,7 +259,7 @@
 	unsigned long ret = -EINVAL;
 	unsigned long charged = 0;
 
-	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))
+	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE | MAP_32BIT))
 		goto out;
 
 	if (addr & ~PAGE_MASK)
@@ -388,6 +392,9 @@
 			if (vma->vm_flags & VM_MAYSHARE)
 				map_flags |= MAP_SHARED;
 
+			if (flags & MAP_32BIT)
+				map_flags |= MAP_32BIT;
+
 			new_addr = get_unmapped_area(vma->vm_file, 0, new_len,
 						vma->vm_pgoff, map_flags);
 			ret = new_addr;


