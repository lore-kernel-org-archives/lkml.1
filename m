Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbZFQQXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbZFQQXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbZFQQWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:22:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34027 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097AbZFQQWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:22:37 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, rgetz@blackfin.uclinux.org, akpm@linux-foundation.org
Subject: [PATCH 4/4] Blackfin: override text/data checking functions
Date: Wed, 17 Jun 2009 12:22:24 -0400
Message-Id: <1245255744-21039-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245255744-21039-1-git-send-email-vapier@gentoo.org>
References: <1245255744-21039-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/sections.h |   38 +++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/include/asm/sections.h b/arch/blackfin/include/asm/sections.h
index e7fd0ec..ae4dae1 100644
--- a/arch/blackfin/include/asm/sections.h
+++ b/arch/blackfin/include/asm/sections.h
@@ -1,9 +1,6 @@
 #ifndef _BLACKFIN_SECTIONS_H
 #define _BLACKFIN_SECTIONS_H
 
-/* nothing to see, move along */
-#include <asm-generic/sections.h>
-
 /* only used when MTD_UCLINUX */
 extern unsigned long memory_mtd_start, memory_mtd_end, mtd_size;
 
@@ -15,4 +12,39 @@ extern char _stext_l1[], _etext_l1[], _sdata_l1[], _edata_l1[], _sbss_l1[],
 	_stext_l2[], _etext_l2[], _sdata_l2[], _edata_l2[], _sbss_l2[],
 	_ebss_l2[], _l2_lma_start[];
 
+#include <asm/mem_map.h>
+
+/* Blackfin systems have discontinuous memory map and no virtualized memory */
+static inline int arch_is_kernel_text(unsigned long addr)
+{
+	return
+		(L1_CODE_LENGTH &&
+		 addr >= (unsigned long)_stext_l1 &&
+		 addr <  (unsigned long)_etext_l1)
+		||
+		(L2_LENGTH &&
+		 addr >= (unsigned long)_stext_l2 &&
+		 addr <  (unsigned long)_etext_l2);
+}
+#define arch_is_kernel_text(addr) arch_is_kernel_text(addr)
+
+static inline int arch_is_kernel_data(unsigned long addr)
+{
+	return
+		(L1_DATA_A_LENGTH &&
+		 addr >= (unsigned long)_sdata_l1 &&
+		 addr <  (unsigned long)_ebss_l1)
+		||
+		(L1_DATA_B_LENGTH &&
+		 addr >= (unsigned long)_sdata_b_l1 &&
+		 addr <  (unsigned long)_ebss_b_l1)
+		||
+		(L2_LENGTH &&
+		 addr >= (unsigned long)_sdata_l2 &&
+		 addr <  (unsigned long)_ebss_l2);
+}
+#define arch_is_kernel_data(addr) arch_is_kernel_data(addr)
+
+#include <asm-generic/sections.h>
+
 #endif
-- 
1.6.3.1

