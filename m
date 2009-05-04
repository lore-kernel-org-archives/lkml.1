Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbZEDQfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbZEDQfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbZEDQf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:35:26 -0400
Received: from smtp-out.google.com ([216.239.45.13]:57336 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbZEDQfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:35:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=T/KiKW5MEtdZHbHBO/J4lN1n6r7zHyrcShSXkBcrQW+an90uC0gmWt1Ij1B1vGPxN
	X5oS8VwMXKUReTG8MIizA==
Date: Mon, 4 May 2009 09:35:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 1/5] oom: cleanup android low memory killer
Message-ID: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the code in lowmem_shrink() for the Android low memory killer so
that it follows the kernel coding style.

It's unnecessary to check for p->oomkilladj >= min_adj if the selected
task's oomkilladj score is stored since get_mm_rss() will always be
greater than zero.

Cc: San Mehat <san@android.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/staging/android/lowmemorykiller.c |   59 +++++++++++++++++-----------
 1 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -57,46 +57,59 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 	int i;
 	int min_adj = OOM_ADJUST_MAX + 1;
 	int selected_tasksize = 0;
+	int selected_oom_adj;
 	int array_size = ARRAY_SIZE(lowmem_adj);
-	int other_free = global_page_state(NR_FREE_PAGES) + global_page_state(NR_FILE_PAGES);
-	if(lowmem_adj_size < array_size)
+	int other_free = global_page_state(NR_FREE_PAGES) +
+			 global_page_state(NR_FILE_PAGES);
+
+	if (lowmem_adj_size < array_size)
 		array_size = lowmem_adj_size;
-	if(lowmem_minfree_size < array_size)
+	if (lowmem_minfree_size < array_size)
 		array_size = lowmem_minfree_size;
-	for(i = 0; i < array_size; i++) {
-		if(other_free < lowmem_minfree[i]) {
+	for (i = 0; i < array_size; i++) {
+		if (other_free < lowmem_minfree[i]) {
 			min_adj = lowmem_adj[i];
 			break;
 		}
 	}
-	if(nr_to_scan > 0)
-		lowmem_print(3, "lowmem_shrink %d, %x, ofree %d, ma %d\n", nr_to_scan, gfp_mask, other_free, min_adj);
+	if (nr_to_scan > 0)
+		lowmem_print(3, "lowmem_shrink %d, %x, ofree %d, ma %d\n",
+			     nr_to_scan, gfp_mask, other_free, min_adj);
+	selected_oom_adj = min_adj;
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
+		int oom_adj;
+
+		if (!p->mm)
+			continue;
+		oom_adj = p->oomkilladj;
+		if (oom_adj < 0)
+			continue;
+		tasksize = get_mm_rss(p->mm);
+		if (nr_to_scan > 0 && tasksize > 0) {
+			if (!selected || oom_adj > selected_oom_adj ||
+			    (oom_adj == selected_oom_adj &&
+			     tasksize > selected_tasksize)) {
+				selected = p;
+				selected_tasksize = tasksize;
+				selected_oom_adj = oom_adj;
+				lowmem_print(2, "select %d (%s), adj %d, "
+					     "size %d, to kill\n",
+					     p->pid, p->comm, oom_adj,
+					     tasksize);
 			}
-			rem += tasksize;
 		}
+		rem += tasksize;
 	}
-	if(selected != NULL) {
+	if (selected) {
 		lowmem_print(1, "send sigkill to %d (%s), adj %d, size %d\n",
 		             selected->pid, selected->comm,
-		             selected->oomkilladj, selected_tasksize);
+			     selected_oom_adj, selected_tasksize);
 		force_sig(SIGKILL, selected);
 		rem -= selected_tasksize;
 	}
-	lowmem_print(4, "lowmem_shrink %d, %x, return %d\n", nr_to_scan, gfp_mask, rem);
+	lowmem_print(4, "lowmem_shrink %d, %x, return %d\n", nr_to_scan,
+		     gfp_mask, rem);
 	read_unlock(&tasklist_lock);
 	return rem;
 }
