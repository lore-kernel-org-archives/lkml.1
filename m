Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbZFMN2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbZFMN2p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764573AbZFMN07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:26:59 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:37936 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbZFMN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:26:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=b7O6LSMUkKIJMv9w3K5HujA0aDlPpqb7cYLqV0RyPEw61z5UOOTyw/21bHOoiZqAWA
         Tg2ZgH2R75mLawIZoPrN8RBUgYZnSXpbxXJWxaUuHU8JIgNs1ru3LRCGut/CDuy2f6hl
         2URBUc7PoFwj0qF/GKIbjpOdEiAATqAiLrykU=
Message-ID: <4A33A835.901@gmail.com>
Date: Sat, 13 Jun 2009 15:23:01 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: [PATCH 13/14] Pramfs: Write protection
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Write protection.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -uprN linux-2.6.30-orig/fs/pramfs/wprotect.c linux-2.6.30/fs/pramfs/wprotect.c
--- linux-2.6.30-orig/fs/pramfs/wprotect.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30/fs/pramfs/wprotect.c	2009-06-13 12:54:16.000000000 +0200
@@ -0,0 +1,84 @@
+/*
+ * FILE NAME fs/pramfs/wprotect.c
+ *
+ * BRIEF DESCRIPTION
+ *
+ * Write protection for the filesystem pages.
+ *
+ * Copyright 2009 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/tlbflush.h>
+#include "pram_fs.h"
+
+/* init_mm.page_table_lock must be held before calling! */
+static void pram_page_writeable(unsigned long addr, int rw)
+{
+	pgd_t *pgdp;
+	pud_t *pudp;
+	pmd_t *pmdp;
+	pte_t *ptep;
+
+	pgdp = pgd_offset_k(addr);
+	if (!pgd_none(*pgdp)) {
+		pudp = pud_offset(pgdp, addr);
+		if (!pud_none(*pudp)) {
+			pmdp = pmd_offset(pudp, addr);
+			if (!pmd_none(*pmdp)) {
+				pte_t pte;
+				ptep = pte_offset_kernel(pmdp, addr);
+				pte = *ptep;
+				if (pte_present(pte)) {
+					pte = rw ? pte_mkwrite(pte) :
+						pte_wrprotect(pte);
+					set_pte(ptep, pte);
+				}
+			}
+		}
+	}
+}
+
+/* init_mm.page_table_lock must be held before calling! */
+void pram_writeable(void *vaddr, unsigned long size, int rw)
+{
+	unsigned long addr = (unsigned long)vaddr & PAGE_MASK;
+	unsigned long end = (unsigned long)vaddr + size;
+	unsigned long start = addr;
+
+	do {
+		pram_page_writeable(addr, rw);
+		addr += PAGE_SIZE;
+	} while (addr && (addr < end));
+
+
+	/*
+	 * NOTE: we will always flush just one page (one TLB
+	 * entry) except possibly in one case: when a new
+	 * filesystem is initialized at mount time, when pram_read_super
+	 * calls pram_lock_range to make the super block, inode
+	 * table, and bitmap writeable.
+	 */
+#if defined(CONFIG_ARM) || defined(CONFIG_M68K) || defined(CONFIG_H8300) || \
+	defined(CONFIG_BLACKFIN)
+	/*
+	 * FIXME: so far only these archs have flush_tlb_kernel_page(),
+	 * for the rest just use flush_tlb_kernel_range(). Not ideal
+	 * to use _range() because many archs just flush the whole TLB.
+	 */
+	if (end <= start + PAGE_SIZE)
+		flush_tlb_kernel_page(start);
+	else
+#endif
+		flush_tlb_kernel_range(start, end);
+}


