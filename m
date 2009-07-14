Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbZGNL5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbZGNL5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 07:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZGNL5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 07:57:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52833 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbZGNL5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 07:57:06 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] block: sysfs fix mismatched queue_var_{store,show} in 64bit kernel
Date: Tue, 14 Jul 2009 19:56:58 +0800
Message-Id: <1247572618-24073-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In blk-sysfs.c, queue_var_store uses unsigned long to store data,
but queue_var_show uses unsigned int to show data. This causes,

	# echo 70000000000 > /sys/block/<dev>/queue/read_ahead_kb
	# cat /sys/block/<dev>/queue/read_ahead_kb => get wrong value

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 block/blk-sysfs.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b1cd040..e177eb3 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -16,9 +16,9 @@ struct queue_sysfs_entry {
 };
 
 static ssize_t
-queue_var_show(unsigned int var, char *page)
+queue_var_show(unsigned long var, char *page)
 {
-	return sprintf(page, "%d\n", var);
+	return sprintf(page, "lu\n", var);
 }
 
 static ssize_t
@@ -77,7 +77,8 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 
 static ssize_t queue_ra_show(struct request_queue *q, char *page)
 {
-	int ra_kb = q->backing_dev_info.ra_pages << (PAGE_CACHE_SHIFT - 10);
+	unsigned long ra_kb = q->backing_dev_info.ra_pages <<
+					(PAGE_CACHE_SHIFT - 10);
 
 	return queue_var_show(ra_kb, (page));
 }
@@ -95,7 +96,7 @@ queue_ra_store(struct request_queue *q, const char *page, size_t count)
 
 static ssize_t queue_max_sectors_show(struct request_queue *q, char *page)
 {
-	int max_sectors_kb = queue_max_sectors(q) >> 1;
+	unsigned long max_sectors_kb = queue_max_sectors(q) >> 1;
 
 	return queue_var_show(max_sectors_kb, (page));
 }
@@ -140,7 +141,7 @@ queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 
 static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 {
-	int max_hw_sectors_kb = queue_max_hw_sectors(q) >> 1;
+	unsigned long max_hw_sectors_kb = queue_max_hw_sectors(q) >> 1;
 
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
@@ -189,7 +190,7 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_rq_affinity_show(struct request_queue *q, char *page)
 {
-	unsigned int set = test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags);
+	unsigned long set = test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags);
 
 	return queue_var_show(set != 0, page);
 }
-- 
1.6.2.5

