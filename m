Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbZKLSsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbZKLSsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZKLSr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:47:57 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33277 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbZKLSrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:47:52 -0500
Subject: [PATCH 02/11] cciss: Fix problem with remove_from_scan_list on driver
	unload
To: axboe@kernel.dk, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, achiang@hp.com,
       brace@beardog.cce.hp.com
Date: Thu, 12 Nov 2009 12:49:19 -0600
Message-ID: <20091112184919.23389.52861.stgit@beardog.cce.hp.com>
In-Reply-To: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
References: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: Fix problem with remove_from_scan_list that on driver unload
it doesn't remove the controller from the scan list correctly if
the controller is currently being scanned for new devices.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 92b1263..81c2187 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3513,28 +3513,33 @@ static int add_to_scan_list(struct ctlr_info *h)
  * @h:			   Pointer to the controller.
  *
  * Removes the controller from the rescan queue if present. Blocks if
- * the controller is currently conducting a rescan.
+ * the controller is currently conducting a rescan.  The controller
+ * can be in one of three states:
+ * 1. Doesn't need a scan
+ * 2. On the scan list, but not scanning yet (we remove it)
+ * 3. Busy scanning (and not on the list). In this case we want to wait for
+ *    the scan to complete to make sure the scanning thread for this
+ *    controller is completely idle.
  **/
 static void remove_from_scan_list(struct ctlr_info *h)
 {
 	struct ctlr_info *test_h, *tmp_h;
-	int scanning = 0;
 
 	mutex_lock(&scan_mutex);
 	list_for_each_entry_safe(test_h, tmp_h, &scan_q, scan_list) {
-		if (test_h == h) {
+		if (test_h == h) { /* state 2. */
 			list_del(&h->scan_list);
 			complete_all(&h->scan_wait);
 			mutex_unlock(&scan_mutex);
 			return;
 		}
 	}
-	if (&h->busy_scanning)
-		scanning = 0;
-	mutex_unlock(&scan_mutex);
-
-	if (scanning)
+	if (h->busy_scanning) { /* state 3. */
+		mutex_unlock(&scan_mutex);
 		wait_for_completion(&h->scan_wait);
+	} else { /* state 1, nothing to do. */
+		mutex_unlock(&scan_mutex);
+	}
 }
 
 /**

