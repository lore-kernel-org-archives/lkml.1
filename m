Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbXGGMyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbXGGMyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 08:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXGGMx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 08:53:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:24172 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbXGGMx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 08:53:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=YFaT//cECMUs5V/XXK49OznJ8Ih111xGNg4cxNL7Lxy5/Sb1YsF4nYSSwz/GRC77OC/HtBENWG8smnSCEgbCDYbC99dSzYNf57D7sZ6D3hBCvItty7jRFiZWPNj+WoFxeVtuQn6UTcbHytJf5c0+u0//ACpL4i/gxWOtvcEMneo=
Date: Sat, 7 Jul 2007 16:53:53 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fs/proc/mmu.c: headers butchery
Message-ID: <20070707125353.GA5910@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fs/proc/mmu.c consists of only one function which uses only:
1) struct vmalloc_info *
2) struct vm_struct *
3) struct vmalloc_info
4) vmlist
5) VMALLOC_TOTAL, VMALLOC_START, VMALLOC_END
6) read_lock, read_unlock
7) vmlist_lock
8) struct vm_struct

This gives us linux/spinlock.h, asm/pgtable.h, "internal.h", linux/vmalloc.h.
asm/pgtable.h uses PKMAP_BASE on i386, for which asm/highmem.h is needed.
But, linux/highmem.h is actually used to make it compile everywhere.
I'll deal later with this particular i386 surprise.

Cross-compile tested on many archs and configs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/mmu.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

--- a/fs/proc/mmu.c
+++ b/fs/proc/mmu.c
@@ -8,27 +8,10 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
-
-#include <linux/types.h>
-#include <linux/errno.h>
-#include <linux/time.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/mman.h>
-#include <linux/proc_fs.h>
-#include <linux/mm.h>
-#include <linux/mmzone.h>
-#include <linux/pagemap.h>
-#include <linux/swap.h>
-#include <linux/slab.h>
-#include <linux/smp.h>
-#include <linux/seq_file.h>
-#include <linux/hugetlb.h>
+#include <linux/spinlock.h>
 #include <linux/vmalloc.h>
-#include <asm/uaccess.h>
+#include <linux/highmem.h>
 #include <asm/pgtable.h>
-#include <asm/tlb.h>
-#include <asm/div64.h>
 #include "internal.h"
 
 void get_vmalloc_info(struct vmalloc_info *vmi)

