Return-Path: <linux-kernel-owner+w=401wt.eu-S933721AbZINUJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721AbZINUJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933653AbZINUJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:20 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54186 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933661AbZINUJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:05 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 63/72] Blackfin: fix typo in isram_write()
Date: Mon, 14 Sep 2009 16:08:07 -0400
Message-Id: <1252958896-25150-64-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

The DTEST write bit is 2, not 1.  Improve comments in the related macro
while we're here.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mm/isram-driver.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/mm/isram-driver.c b/arch/blackfin/mm/isram-driver.c
index 02eaaa6..beb1a60 100644
--- a/arch/blackfin/mm/isram-driver.c
+++ b/arch/blackfin/mm/isram-driver.c
@@ -53,10 +53,12 @@ static DEFINE_SPINLOCK(dtest_lock);
 #define IADDR2DTEST(x) \
 	({ unsigned long __addr = (unsigned long)(x); \
 		(__addr & 0x47F8)        | /* address bits 14 & 10:3 */ \
+		(__addr & 0x8000) << 23  | /* Bank A/B               */ \
 		(__addr & 0x0800) << 15  | /* address bit  11        */ \
-		(__addr  & 0x3000) << 4  | /* address bits 13:12     */ \
-		(__addr  & 0x8000) << 8  | /* address bit  15        */ \
-		(0x1000004);               /* isram access           */ \
+		(__addr & 0x3000) <<  4  | /* address bits 13:12     */ \
+		(__addr & 0x8000) <<  8  | /* address bit  15        */ \
+		(0x1000000)              | /* instruction access = 1 */ \
+		(0x4);                     /* data array = 1         */ \
 	})
 
 /* Takes a pointer, and returns the offset (in bits) which things should be shifted */
@@ -73,7 +75,7 @@ static void isram_write(const void *addr, uint64_t data)
 	if (addr >= (void *)(L1_CODE_START + L1_CODE_LENGTH))
 		return;
 
-	cmd = IADDR2DTEST(addr) | 1;             /* write */
+	cmd = IADDR2DTEST(addr) | 2;             /* write */
 
 	/*
 	 * Writes to DTEST_DATA[0:1] need to be atomic with write to DTEST_COMMAND
-- 
1.6.4.2

