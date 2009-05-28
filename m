Return-Path: <linux-kernel-owner+w=401wt.eu-S1763449AbZE1Qmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763449AbZE1Qmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763309AbZE1QmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:42:16 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:64406 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407AbZE1QmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:42:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VpXW1jJa4YoGDn/riYt40I7a3ttwg/k2oylU9sxnBR/LR4DZaam1e0vitrmq1NwDuQ
         6Bszc7tZYHP+vWKv2eSVcrzHQh+ZTfdVqSKxncDa6CGftXQWUlXRnq14Q2tNANQgQoFp
         RPjgwAQ0G/wh6ltsS0l/3a9Dpi/4adKWSud60=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] tracing/stat: change dummpy_cmp() to return -1
Date: Thu, 28 May 2009 18:42:08 +0200
Message-Id: <1243528930-5318-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243528930-5318-1-git-send-email-fweisbec@gmail.com>
References: <1243528930-5318-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Currently the output of trace_stat/workqueues is totally reversed:

 # cat /debug/tracing/trace_stat/workqueues
    ...
    1       17       17      210       37   `-blk_unplug_work+0x0/0x57
    1     3779     3779      181       11   |-cfq_kick_queue+0x0/0x2f
    1     3796     3796                     kblockd/1:120
    ...

The correct output should be:

    1     3796     3796                     kblockd/1:120
    1     3779     3779      181       11   |-cfq_kick_queue+0x0/0x2f
    1       17       17      210       37   `-blk_unplug_work+0x0/0x57

It's caused by "tracing/stat: replace linked list by an rbtree for
sorting"
(53059c9b67a62a3dc8c80204d3da42b9267ea5a0).

dummpy_cmp() should return -1, so rb_node will always be inserted as
right-most node in the rbtree, thus we sort the output in ascending
order.

[ Impact: fix the output of trace_stat/workqueues ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 2e849b5..8b7420a 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -127,7 +127,7 @@ insert_stat(struct rb_root *root, struct stat_node *data, cmp_stat_t cmp)
  */
 static int dummy_cmp(void *p1, void *p2)
 {
-	return 1;
+	return -1;
 }
 
 /*
-- 
1.6.2.3

