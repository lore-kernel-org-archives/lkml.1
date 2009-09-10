Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbZIJGbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbZIJGbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 02:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZIJGbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 02:31:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54196 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbZIJGbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 02:31:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2][resend][for 2.6.31 stable tree] Revert "Staging: android: lowmemorykiller.c: fix it for "oom: move oom_adj value from task_struct to mm_struct""
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       <stable@kernel.org>
In-Reply-To: <20090910152551.DB3C.A69D9226@jp.fujitsu.com>
References: <20090910152551.DB3C.A69D9226@jp.fujitsu.com>
Message-Id: <20090910153007.DB3F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Sep 2009 15:31:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0753ba01 (mm: revert "oom: move oom_adj value") reverted some
regression patch. but it didn't revert one oom retrieved driver patch.

Then, it made build error to the driver. This reverts commit
a6a9f81ccc9f5c86ccc22bbed1960a57d0316e8b too and fixes the build error.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/staging/android/lowmemorykiller.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 935d281..f91ed1c 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -99,21 +99,19 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
-		struct mm_struct *mm;
 		int oom_adj;
 
 		task_lock(p);
-		mm = p->mm;
-		if (!mm) {
+		if (!p->mm) {
 			task_unlock(p);
 			continue;
 		}
-		oom_adj = mm->oom_adj;
+		oom_adj = p->oomkilladj;
 		if (oom_adj < min_adj) {
 			task_unlock(p);
 			continue;
 		}
-		tasksize = get_mm_rss(mm);
+		tasksize = get_mm_rss(p->mm);
 		task_unlock(p);
 		if (tasksize <= 0)
 			continue;
-- 
1.6.2.5



