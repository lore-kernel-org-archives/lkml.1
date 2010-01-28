Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925Ab0A1Pqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0A1Pqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 10:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907Ab0A1Pqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 10:46:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:25896 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab0A1Pqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 10:46:31 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] Remove redundant check for zero page
Date: Thu, 28 Jan 2010 21:13:41 +0530
Message-Id: <1264693423-2694-6-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1264693423-2694-1-git-send-email-ngupta@vflare.org>
References: <1264693423-2694-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ramzswap_free_page() already handles the case for zero filled
pages. So, remove redundant logic for the same in ramzswap_write().

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/ramzswap/ramzswap_drv.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
index 3035add..7e0a3fa 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -593,6 +593,10 @@ static void ramzswap_free_page(struct ramzswap *rzs, size_t index)
 	u32 offset = rzs->table[index].offset;
 
 	if (unlikely(!page)) {
+		/*
+		 * No memory is allocated for zero filled pages.
+		 * Simply clear zero page flag.
+		 */
 		if (rzs_test_flag(rzs, index, RZS_ZERO)) {
 			rzs_clear_flag(rzs, index, RZS_ZERO);
 			rzs_stat_dec(&rzs->stats.pages_zero);
@@ -789,18 +793,9 @@ static int ramzswap_write(struct ramzswap *rzs, struct bio *bio)
 	 * is no longer referenced by any process. So, its now safe
 	 * to free the memory that was allocated for this page.
 	 */
-	if (rzs->table[index].page)
+	if (rzs->table[index].page || rzs_test_flag(rzs, index, RZS_ZERO))
 		ramzswap_free_page(rzs, index);
 
-	/*
-	 * No memory is allocated for zero filled pages.
-	 * Simply clear zero page flag.
-	 */
-	if (rzs_test_flag(rzs, index, RZS_ZERO)) {
-		rzs_stat_dec(&rzs->stats.pages_zero);
-		rzs_clear_flag(rzs, index, RZS_ZERO);
-	}
-
 	mutex_lock(&rzs->lock);
 
 	user_mem = kmap_atomic(page, KM_USER0);
-- 
1.6.2.5

