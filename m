Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbZEKWqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbZEKWqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbZEKWpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:45:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10784 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbZEKWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:45:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:content-id:x-system-of-record;
	b=wyCUBWom5mmi3g5LZs7ryy3s8JbLormooTs8GTszQRcrrSjEhAsaKJWVODr/B0H8B
	R3UILJ4N+mZhLyKXj8KOQ==
Date: Mon, 11 May 2009 15:45:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       San Mehat <san@android.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/4] lowmemorykiller: Only iterate over process list when
 needed.
In-Reply-To: <alpine.DEB.2.00.0905111539500.5533@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0905111543000.5533@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905111539500.5533@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="497827084-1180920695-1242081811=:5533"
Content-ID: <alpine.DEB.2.00.0905111545080.5533@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--497827084-1180920695-1242081811=:5533
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.0905111545081.5533@chino.kir.corp.google.com>

From: Arve Hjønnevåg <arve@android.com>

Use NR_ACTIVE plus NR_INACTIVE as a size estimate for our fake cache
instead the sum of rss. Neither method is accurate.

Also skip the process scan, if the amount of memory available is above
the largest threshold set.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/lowmemorykiller.c |   35 +++++++++++++++++-----------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
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
--497827084-1180920695-1242081811=:5533--
