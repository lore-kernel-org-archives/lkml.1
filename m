Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbZEDWZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbZEDWZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbZEDWY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:24:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:50388 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbZEDWY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:24:56 -0400
From: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, rientjes@google.com, akpm@linux-foundation.org,
       npiggin@suse.de, san@android.com,
       =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 1/2] lowmemorykiller: Only iterate over process list when needed.
Date: Mon,  4 May 2009 15:24:48 -0700
Message-Id: <1241475889-2281-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090504220905.GA29402@kroah.com>
References: <20090504220905.GA29402@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NR_ACTIVE plus NR_INACTIVE as a size estimate for our fake cache
instead the sum of rss. Neither method is accurate.

Also skip the process scan, if the amount of memory available is above
the largest threshold set.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/lowmemorykiller.c |   35 +++++++++++++++++-----------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 3715d56..b9a2e84 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -71,23 +71,30 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 	}
 	if(nr_to_scan > 0)
 		lowmem_print(3, "lowmem_shrink %d, %x, ofree %d, ma %d\n", nr_to_scan, gfp_mask, other_free, min_adj);
+	rem = global_page_state(NR_ACTIVE) + global_page_state(NR_INACTIVE);
+	if (nr_to_scan <= 0 || min_adj == OOM_ADJUST_MAX + 1) {
+		lowmem_print(5, "lowmem_shrink %d, %x, return %d\n", nr_to_scan, gfp_mask, rem);
+		return rem;
+	}
+
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
-		if(p->oomkilladj >= 0 && p->mm) {
-			tasksize = get_mm_rss(p->mm);
-			if(nr_to_scan > 0 && tasksize > 0 && p->oomkilladj >= min_adj) {
-				if(selected == NULL ||
-				   p->oomkilladj > selected->oomkilladj ||
-				   (p->oomkilladj == selected->oomkilladj &&
-				    tasksize > selected_tasksize)) {
-					selected = p;
-					selected_tasksize = tasksize;
-					lowmem_print(2, "select %d (%s), adj %d, size %d, to kill\n",
-					             p->pid, p->comm, p->oomkilladj, tasksize);
-				}
-			}
-			rem += tasksize;
+		if (p->oomkilladj < min_adj || !p->mm)
+			continue;
+		tasksize = get_mm_rss(p->mm);
+		if (tasksize <= 0)
+			continue;
+		if (selected) {
+			if (p->oomkilladj < selected->oomkilladj)
+				continue;
+			if (p->oomkilladj == selected->oomkilladj &&
+			    tasksize <= selected_tasksize)
+				continue;
 		}
+		selected = p;
+		selected_tasksize = tasksize;
+		lowmem_print(2, "select %d (%s), adj %d, size %d, to kill\n",
+		             p->pid, p->comm, p->oomkilladj, tasksize);
 	}
 	if(selected != NULL) {
 		lowmem_print(1, "send sigkill to %d (%s), adj %d, size %d\n",
-- 
1.6.1

