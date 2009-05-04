Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbZEDWZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbZEDWZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZEDWY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:24:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:43981 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZEDWY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:24:56 -0400
From: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, rientjes@google.com, akpm@linux-foundation.org,
       npiggin@suse.de, san@android.com,
       =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 2/2] lowmemorykiller: Don't count free space unless it meets the specified limit by itself
Date: Mon,  4 May 2009 15:24:49 -0700
Message-Id: <1241475889-2281-2-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1241475889-2281-1-git-send-email-arve@android.com>
References: <20090504220905.GA29402@kroah.com>
 <1241475889-2281-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows processes to be killed when the kernel evict cache pages in
an attempt to get more contiguous free memory.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/lowmemorykiller.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index b9a2e84..b2ab7fa 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -58,20 +58,25 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 	int min_adj = OOM_ADJUST_MAX + 1;
 	int selected_tasksize = 0;
 	int array_size = ARRAY_SIZE(lowmem_adj);
-	int other_free = global_page_state(NR_FREE_PAGES) + global_page_state(NR_FILE_PAGES);
+	int other_free = global_page_state(NR_FREE_PAGES);
+	int other_file = global_page_state(NR_FILE_PAGES);
 	if(lowmem_adj_size < array_size)
 		array_size = lowmem_adj_size;
 	if(lowmem_minfree_size < array_size)
 		array_size = lowmem_minfree_size;
 	for(i = 0; i < array_size; i++) {
-		if(other_free < lowmem_minfree[i]) {
+		if (other_free < lowmem_minfree[i] &&
+		    other_file < lowmem_minfree[i]) {
 			min_adj = lowmem_adj[i];
 			break;
 		}
 	}
 	if(nr_to_scan > 0)
-		lowmem_print(3, "lowmem_shrink %d, %x, ofree %d, ma %d\n", nr_to_scan, gfp_mask, other_free, min_adj);
-	rem = global_page_state(NR_ACTIVE) + global_page_state(NR_INACTIVE);
+		lowmem_print(3, "lowmem_shrink %d, %x, ofree %d %d, ma %d\n", nr_to_scan, gfp_mask, other_free, other_file, min_adj);
+	rem = global_page_state(NR_ACTIVE_ANON) +
+		global_page_state(NR_ACTIVE_FILE) +
+		global_page_state(NR_INACTIVE_ANON) +
+		global_page_state(NR_INACTIVE_FILE);
 	if (nr_to_scan <= 0 || min_adj == OOM_ADJUST_MAX + 1) {
 		lowmem_print(5, "lowmem_shrink %d, %x, return %d\n", nr_to_scan, gfp_mask, rem);
 		return rem;
-- 
1.6.1

