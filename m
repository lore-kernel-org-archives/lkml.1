Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZHGChp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZHGChp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 22:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbZHGCho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 22:37:44 -0400
Received: from [222.73.24.84] ([222.73.24.84]:53436 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZHGCho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 22:37:44 -0400
Message-ID: <4A7B930D.6060206@cn.fujitsu.com>
Date: Fri, 07 Aug 2009 10:35:57 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: jens.axboe@oracle.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] CFQ: mark must_alloc flag when a cfqq doesn't allocate any
 request
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

CFQ judges whether must_alloc flag is set, but never marks this flag.
This patch set must_alloc flag when there is no request allocated by
a cfqq. This change ensures cfqq will get at least one request even
if the queue is full.
Hope it helps.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fd7080e..531a404 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2279,6 +2279,9 @@ static void cfq_put_request(struct request *rq)
 		BUG_ON(!cfqq->allocated[rw]);
 		cfqq->allocated[rw]--;
 
+		if (!(cfqq->allocated[0] + cfqq->allocated[1]))
+			cfq_mark_cfqq_must_alloc(cfqq);
+
 		put_io_context(RQ_CIC(rq)->ioc);
 
 		rq->elevator_private = NULL;
-- 
1.5.4.rc3


