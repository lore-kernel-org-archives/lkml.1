Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbZFEIVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbZFEIVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbZFEIGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:53 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37483 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657AbZFEIGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:08 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 44/62] Blackfin: merge sram init functions
Date: Fri,  5 Jun 2009 04:04:53 -0400
Message-Id: <1244189111-19639-45-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Now that the sram_init() function exists only to call the bfin_sram_init()
after the punting of the reserve_pda() function, simply merge the two to
avoid pointless overhead.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mm/blackfin_sram.h |    1 -
 arch/blackfin/mm/init.c          |    9 ---------
 arch/blackfin/mm/sram-alloc.c    |    5 ++++-
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/blackfin/mm/blackfin_sram.h b/arch/blackfin/mm/blackfin_sram.h
index 8cb0945..bc00628 100644
--- a/arch/blackfin/mm/blackfin_sram.h
+++ b/arch/blackfin/mm/blackfin_sram.h
@@ -30,7 +30,6 @@
 #ifndef __BLACKFIN_SRAM_H__
 #define __BLACKFIN_SRAM_H__
 
-extern void bfin_sram_init(void);
 extern void *l1sram_alloc(size_t);
 
 #endif
diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
index 9a62b30..014a55a 100644
--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -175,15 +175,6 @@ void __init mem_init(void)
 		initk, codek, datak, DMA_UNCACHED_REGION >> 10, (reservedpages << (PAGE_SHIFT-10)));
 }
 
-static int __init sram_init(void)
-{
-	/* Initialize the blackfin L1 Memory. */
-	bfin_sram_init();
-
-	return 0;
-}
-pure_initcall(sram_init);
-
 static void __init free_init_pages(const char *what, unsigned long begin, unsigned long end)
 {
 	unsigned long addr;
diff --git a/arch/blackfin/mm/sram-alloc.c b/arch/blackfin/mm/sram-alloc.c
index 530d139..36376d8 100644
--- a/arch/blackfin/mm/sram-alloc.c
+++ b/arch/blackfin/mm/sram-alloc.c
@@ -223,7 +223,7 @@ static void __init l2_sram_init(void)
 	spin_lock_init(&l2_sram_lock);
 }
 
-void __init bfin_sram_init(void)
+static int __init bfin_sram_init(void)
 {
 	sram_piece_cache = kmem_cache_create("sram_piece_cache",
 				sizeof(struct sram_piece),
@@ -233,7 +233,10 @@ void __init bfin_sram_init(void)
 	l1_data_sram_init();
 	l1_inst_sram_init();
 	l2_sram_init();
+
+	return 0;
 }
+pure_initcall(bfin_sram_init);
 
 /* SRAM allocate function */
 static void *_sram_alloc(size_t size, struct sram_piece *pfree_head,
-- 
1.6.3.1

