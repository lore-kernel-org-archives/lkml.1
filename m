Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbZCYJTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbZCYJTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758614AbZCYJTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:19:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58105 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758565AbZCYJTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:19:05 -0400
Message-ID: <49C9F725.9080409@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 17:19:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] blktrace: fix a race when creating blk_tree_root in debugfs
References: <49C9F700.9070609@cn.fujitsu.com>
In-Reply-To: <49C9F700.9070609@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

t1                                t2
------                            ------
do_blk_trace_setup()              do_blk_trace_setup()
  if (!blk_tree_root) {
                                    if (!blk_tree_root)
    blk_tree_root = create_dir()
                                      blk_tree_root = create_dir();
                                      (now blk_tree_root == NULL)
  ...
  dir = create_dir(name, blk_tree_root);

Due to this race, t1 will create 'dir' in /debugfs but not /debugfs/block.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index ee7a8bb..95f89fa 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -426,11 +426,15 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 
 	ret = -ENOENT;
 
+	mutex_lock(&blk_tree_mutex);
 	if (!blk_tree_root) {
 		blk_tree_root = debugfs_create_dir("block", NULL);
-		if (!blk_tree_root)
+		if (!blk_tree_root) {
+			mutex_unlock(&blk_tree_mutex);
 			goto err;
+		}
 	}
+	mutex_unlock(&blk_tree_mutex);
 
 	dir = debugfs_create_dir(buts->name, blk_tree_root);
 
-- 
1.5.4.rc3


