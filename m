Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbZEEA1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbZEEA1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbZEEA1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:27:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37088 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509AbZEEA1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:27:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=RWYzW/9v9Z/g7bZKoHoxekStzyjaUGj/qEgI3nON/doPmAPMwZiNdoJnLatScMfMo
	zmy9iNEQciWGDwaLsBEPA==
Date: Mon, 4 May 2009 17:26:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
cc: Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 3/7] oom: cleanup android low memory killer
In-Reply-To: <alpine.DEB.2.00.0905041722040.11756@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0905041724470.11756@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905041722040.11756@chino.kir.corp.google.com>
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
 drivers/staging/android/lowmemorykiller.c |   39 +++++++++++++++++++---------
 1 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -57,58 +57,71 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 	int i;
 	int min_adj = OOM_ADJUST_MAX + 1;
 	int selected_tasksize = 0;
+	int selected_oom_adj;
 	int array_size = ARRAY_SIZE(lowmem_adj);
 	int other_free = global_page_state(NR_FREE_PAGES);
 	int other_file = global_page_state(NR_FILE_PAGES);
-	if(lowmem_adj_size < array_size)
+
+	if (lowmem_adj_size < array_size)
 		array_size = lowmem_adj_size;
-	if(lowmem_minfree_size < array_size)
+	if (lowmem_minfree_size < array_size)
 		array_size = lowmem_minfree_size;
-	for(i = 0; i < array_size; i++) {
+	for (i = 0; i < array_size; i++) {
 		if (other_free < lowmem_minfree[i] &&
 		    other_file < lowmem_minfree[i]) {
 			min_adj = lowmem_adj[i];
 			break;
 		}
 	}
-	if(nr_to_scan > 0)
-		lowmem_print(3, "lowmem_shrink %d, %x, ofree %d %d, ma %d\n", nr_to_scan, gfp_mask, other_free, other_file, min_adj);
+	if (nr_to_scan > 0)
+		lowmem_print(3, "lowmem_shrink %d, %x, ofree %d %d, ma %d\n",
+			     nr_to_scan, gfp_mask, other_free, other_file,
+			     min_adj);
 	rem = global_page_state(NR_ACTIVE_ANON) +
 		global_page_state(NR_ACTIVE_FILE) +
 		global_page_state(NR_INACTIVE_ANON) +
 		global_page_state(NR_INACTIVE_FILE);
 	if (nr_to_scan <= 0 || min_adj == OOM_ADJUST_MAX + 1) {
-		lowmem_print(5, "lowmem_shrink %d, %x, return %d\n", nr_to_scan, gfp_mask, rem);
+		lowmem_print(5, "lowmem_shrink %d, %x, return %d\n",
+			     nr_to_scan, gfp_mask, rem);
 		return rem;
 	}
+	selected_oom_adj = min_adj;
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
-		if (p->oomkilladj < min_adj || !p->mm)
+		int oom_adj;
+
+		if (!p->mm)
+			continue;
+		oom_adj = p->oomkilladj;
+		if (oom_adj < min_adj)
 			continue;
 		tasksize = get_mm_rss(p->mm);
 		if (tasksize <= 0)
 			continue;
 		if (selected) {
-			if (p->oomkilladj < selected->oomkilladj)
+			if (oom_adj < selected_oom_adj)
 				continue;
-			if (p->oomkilladj == selected->oomkilladj &&
+			if (oom_adj == selected_oom_adj &&
 			    tasksize <= selected_tasksize)
 				continue;
 		}
 		selected = p;
 		selected_tasksize = tasksize;
+		selected_oom_adj = oom_adj;
 		lowmem_print(2, "select %d (%s), adj %d, size %d, to kill\n",
-		             p->pid, p->comm, p->oomkilladj, tasksize);
+		             p->pid, p->comm, oom_adj, tasksize);
 	}
-	if(selected != NULL) {
+	if (selected) {
 		lowmem_print(1, "send sigkill to %d (%s), adj %d, size %d\n",
 		             selected->pid, selected->comm,
-		             selected->oomkilladj, selected_tasksize);
+		             selected_oom_adj, selected_tasksize);
 		force_sig(SIGKILL, selected);
 		rem -= selected_tasksize;
 	}
-	lowmem_print(4, "lowmem_shrink %d, %x, return %d\n", nr_to_scan, gfp_mask, rem);
+	lowmem_print(4, "lowmem_shrink %d, %x, return %d\n",
+		     nr_to_scan, gfp_mask, rem);
 	read_unlock(&tasklist_lock);
 	return rem;
 }
