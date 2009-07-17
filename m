Return-Path: <linux-kernel-owner+w=401wt.eu-S933768AbZGQAGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768AbZGQAGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933738AbZGQAGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:06:06 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39141 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933736AbZGQAGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:06:03 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 19/21] Blackfin: add CPLB entries for Core B on-chip L1 SRAM regions
Date: Thu, 16 Jul 2009 20:05:44 -0400
Message-Id: <1247789146-18786-20-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

The Blackfin SMP port was missing CPLB entries for Core B on-chip L1 SRAM
regions.  Any code that attempted to use these would wrongly crash due to
a CPLB miss.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/cplb-nompu/cplbinit.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/kernel/cplb-nompu/cplbinit.c b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
index d6c0677..685f160 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
@@ -72,13 +72,24 @@ void __init generate_cplb_tables_cpu(unsigned int cpu)
 	}
 
 	/* Cover L1 memory.  One 4M area for code and data each is enough.  */
-	if (L1_DATA_A_LENGTH || L1_DATA_B_LENGTH) {
-		d_tbl[i_d].addr = L1_DATA_A_START;
-		d_tbl[i_d++].data = L1_DMEMORY | PAGE_SIZE_4MB;
+	if (cpu == 0) {
+		if (L1_DATA_A_LENGTH || L1_DATA_B_LENGTH) {
+			d_tbl[i_d].addr = L1_DATA_A_START;
+			d_tbl[i_d++].data = L1_DMEMORY | PAGE_SIZE_4MB;
+		}
+		i_tbl[i_i].addr = L1_CODE_START;
+		i_tbl[i_i++].data = L1_IMEMORY | PAGE_SIZE_4MB;
 	}
-	i_tbl[i_i].addr = L1_CODE_START;
-	i_tbl[i_i++].data = L1_IMEMORY | PAGE_SIZE_4MB;
-
+#ifdef CONFIG_SMP
+	else {
+		if (L1_DATA_A_LENGTH || L1_DATA_B_LENGTH) {
+			d_tbl[i_d].addr = COREB_L1_DATA_A_START;
+			d_tbl[i_d++].data = L1_DMEMORY | PAGE_SIZE_4MB;
+		}
+		i_tbl[i_i].addr = COREB_L1_CODE_START;
+		i_tbl[i_i++].data = L1_IMEMORY | PAGE_SIZE_4MB;
+	}
+#endif
 	first_switched_dcplb = i_d;
 	first_switched_icplb = i_i;
 
-- 
1.6.3.3

