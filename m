Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbYBNPor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbYBNPor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbYBNPji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:39:38 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:49924 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753211AbYBNPjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:39:13 -0500
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
       =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
Subject: [PATCH 08/14] mm/: Use time_* macros
Date: Thu, 14 Feb 2008 17:36:46 +0200
Message-Id: <1203003412-11594-9-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: y
References: y
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Cc: linux-mm@kvack.org
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 mm/page_alloc.c |    3 ++-
 mm/pdflush.c    |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 75b9793..1a0c9cc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -14,6 +14,7 @@
  *          (lots of bits borrowed from Ingo Molnar & Andrew Morton)
  */
 
+#include <linux/jiffies.h>
 #include <linux/stddef.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
@@ -1276,7 +1277,7 @@ static nodemask_t *zlc_setup(struct zonelist *zonelist, int alloc_flags)
 	if (!zlc)
 		return NULL;
 
-	if (jiffies - zlc->last_full_zap > 1 * HZ) {
+	if (time_after(jiffies, zlc->last_full_zap + HZ)) {
 		bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
 		zlc->last_full_zap = jiffies;
 	}
diff --git a/mm/pdflush.c b/mm/pdflush.c
index 8f6ee07..5d736d5 100644
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -10,6 +10,7 @@
  *		up stack space with nested calls to kernel_thread.
  */
 
+#include <linux/jiffies.h>
 #include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/signal.h>
@@ -130,7 +131,7 @@ static int __pdflush(struct pdflush_work *my_work)
 		 * Thread creation: For how long have there been zero
 		 * available threads?
 		 */
-		if (jiffies - last_empty_jifs > 1 * HZ) {
+		if (time_after(jiffies, last_empty_jifs + HZ)) {
 			/* unlocked list_empty() test is OK here */
 			if (list_empty(&pdflush_list)) {
 				/* unlocked test is OK here */
@@ -151,7 +152,7 @@ static int __pdflush(struct pdflush_work *my_work)
 		if (nr_pdflush_threads <= MIN_PDFLUSH_THREADS)
 			continue;
 		pdf = list_entry(pdflush_list.prev, struct pdflush_work, list);
-		if (jiffies - pdf->when_i_went_to_sleep > 1 * HZ) {
+		if (time_after(jiffies, pdf->when_i_went_to_sleep + HZ)) {
 			/* Limit exit rate */
 			pdf->when_i_went_to_sleep = jiffies;
 			break;					/* exeunt */
-- 
1.5.3.7

