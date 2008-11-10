Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbYKJG3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbYKJG3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 01:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYKJG3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 01:29:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:60890 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbYKJG3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 01:29:08 -0500
Message-ID: <4917D4AB.4080401@kernel.org>
Date: Mon, 10 Nov 2008 15:28:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] block: fix add_partition() error path
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Nov 2008 06:29:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Partition stats structure was not freed on devt allocation failure
path.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/partitions/check.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: work/fs/partitions/check.c
===================================================================
--- work.orig/fs/partitions/check.c
+++ work/fs/partitions/check.c
@@ -395,7 +395,7 @@ int add_partition(struct gendisk *disk,
 
 	err = blk_alloc_devt(p, &devt);
 	if (err)
-		goto out_free;
+		goto out_free_stats;
 	pdev->devt = devt;
 
 	/* delay uevent until 'holders' subdir is created */
@@ -426,6 +426,8 @@ int add_partition(struct gendisk *disk,
 
 	return 0;
 
+out_free_stats:
+	free_part_stats(p);
 out_free:
 	kfree(p);
 	return err;
