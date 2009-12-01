Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbZLAUFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbZLAUFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 15:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZLAUFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 15:05:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:21255 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbZLAUFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 15:05:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,322,1257148800"; 
   d="scan'208";a="471975822"
From: =?UTF-8?q?Kristian=20H=C3=B8gsberg?= <krh@bitplanet.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Don't free perf_mmap_data until work has been done.
Date: Tue,  1 Dec 2009 15:05:01 -0500
Message-Id: <1259697901-1747-1-git-send-email-krh@bitplanet.net>
X-Mailer: git-send-email 1.6.5.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the CONFIG_PERF_USE_VMALLOC case, perf_mmap_data_free() only
schedules the cleanup of the perf_mmap_data struct.  In that case
we have to wait until the work has been done before we free data.

Signed-off-by: Kristian Høgsberg <krh@bitplanet.net>
---
 kernel/perf_event.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 7f29643..f1854b9 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2174,6 +2174,7 @@ static void perf_mmap_data_free(struct perf_mmap_data *data)
 	perf_mmap_free_page((unsigned long)data->user_page);
 	for (i = 0; i < data->nr_pages; i++)
 		perf_mmap_free_page((unsigned long)data->data_pages[i]);
+	kfree(data);
 }
 
 #else
@@ -2214,6 +2215,7 @@ static void perf_mmap_data_free_work(struct work_struct *work)
 		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
 
 	vfree(base);
+	kfree(data);
 }
 
 static void perf_mmap_data_free(struct perf_mmap_data *data)
@@ -2319,7 +2321,6 @@ static void perf_mmap_data_free_rcu(struct rcu_head *rcu_head)
 
 	data = container_of(rcu_head, struct perf_mmap_data, rcu_head);
 	perf_mmap_data_free(data);
-	kfree(data);
 }
 
 static void perf_mmap_data_release(struct perf_event *event)
-- 
1.6.5.rc2

