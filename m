Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbZLOB6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbZLOB6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbZLOB6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:58:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55850 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757543AbZLOB6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:58:06 -0500
Message-ID: <4B26EC23.6020701@cn.fujitsu.com>
Date: Tue, 15 Dec 2009 09:53:39 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Corrado Zoccolo <czoccolo@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] cfq: set workload as expired if it doesn't have any slice
 left.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a group is resumed, if it doesn't have workload slice left,
we should set workload_expires as expired. Otherwise, we might
start from where we left in previous group by error. 
Thanks the idea from Corrado.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f3f6239..e2f8046 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2113,7 +2113,9 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 		cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
 		cfqd->serving_type = cfqg->saved_workload;
 		cfqd->serving_prio = cfqg->saved_serving_prio;
-	}
+	} else
+		cfqd->workload_expires = jiffies - 1;
+
 	choose_service_tree(cfqd, cfqg);
 }
 
-- 
1.5.4.rc3

