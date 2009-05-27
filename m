Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbZE0DDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbZE0DDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbZE0DDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:03:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64718 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755645AbZE0DDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:03:07 -0400
Message-ID: <4A1CADBA.7000707@cn.fujitsu.com>
Date: Wed, 27 May 2009 11:04:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing/stat: change dummpy_cmp() to return -1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

It's caused by "tracing/stat: replace linked list by an rbtree for sorting"
(53059c9b67a62a3dc8c80204d3da42b9267ea5a0).

dummpy_cmp() should return -1, so rb_node will always be inserted as
right-most node in the rbtree, thus we sort the output in ascending
order.

[ Impact: fix the output of trace_stat/workqueues ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.5.4.rc3


