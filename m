Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbZCYLz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbZCYLz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760237AbZCYLzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:55:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:36742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759663AbZCYLzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:55:14 -0400
Date: Wed, 25 Mar 2009 11:54:35 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49C9F725.9080409@cn.fujitsu.com>
References: <49C9F725.9080409@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: fix a race when creating blk_tree_root in debugfs
Message-ID: <tip-a216c4acfafb28d697fe07b4137ab780131e4d60@git.kernel.org>
Git-Commit-ID: a216c4acfafb28d697fe07b4137ab780131e4d60
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 11:54:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a216c4acfafb28d697fe07b4137ab780131e4d60
Gitweb:     http://git.kernel.org/tip/a216c4acfafb28d697fe07b4137ab780131e4d60
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 25 Mar 2009 17:19:33 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 12:05:39 +0100

blktrace: fix a race when creating blk_tree_root in debugfs

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
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49C9F725.9080409@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
