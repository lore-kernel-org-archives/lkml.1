Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbZHQFm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbZHQFm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 01:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbZHQFm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 01:42:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58548 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZHQFm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 01:42:26 -0400
Message-ID: <4A88ED6B.6030602@cn.fujitsu.com>
Date: Mon, 17 Aug 2009 13:40:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] lockdep: Simplify lock_stat seqfile code
References: <4A88ED15.20800@cn.fujitsu.com>
In-Reply-To: <4A88ED15.20800@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- make ls_next() call ls_start()
- remove redundant code in lock_stat_release()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/lockdep_proc.c |   29 +++++++----------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index cd5ed35..37b6ddc 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -383,7 +383,6 @@ struct lock_stat_data {
 };
 
 struct lock_stat_seq {
-	struct lock_stat_data *iter;
 	struct lock_stat_data *iter_end;
 	struct lock_stat_data stats[MAX_LOCKDEP_KEYS];
 };
@@ -571,34 +570,22 @@ static void seq_header(struct seq_file *m)
 static void *ls_start(struct seq_file *m, loff_t *pos)
 {
 	struct lock_stat_seq *data = m->private;
+	struct lock_stat_data *iter;
 
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	data->iter = data->stats + (*pos - 1);
-	if (data->iter >= data->iter_end)
-		data->iter = NULL;
+	iter = data->stats + (*pos - 1);
+	if (iter >= data->iter_end)
+		iter = NULL;
 
-	return data->iter;
+	return iter;
 }
 
 static void *ls_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct lock_stat_seq *data = m->private;
-
 	(*pos)++;
-
-	if (v == SEQ_START_TOKEN)
-		data->iter = data->stats;
-	else {
-		data->iter = v;
-		data->iter++;
-	}
-
-	if (data->iter == data->iter_end)
-		data->iter = NULL;
-
-	return data->iter;
+	return ls_start(m, pos);
 }
 
 static void ls_stop(struct seq_file *m, void *v)
@@ -636,7 +623,6 @@ static int lock_stat_open(struct inode *inode, struct file *file)
 		struct lock_stat_data *iter = data->stats;
 		struct seq_file *m = file->private_data;
 
-		data->iter = iter;
 		list_for_each_entry(class, &all_lock_classes, lock_entry) {
 			iter->class = class;
 			iter->stats = lock_stats(class);
@@ -644,7 +630,7 @@ static int lock_stat_open(struct inode *inode, struct file *file)
 		}
 		data->iter_end = iter;
 
-		sort(data->stats, data->iter_end - data->iter,
+		sort(data->stats, data->iter_end - data->stats,
 				sizeof(struct lock_stat_data),
 				lock_stat_cmp, NULL);
 
@@ -679,7 +665,6 @@ static int lock_stat_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 
 	vfree(seq->private);
-	seq->private = NULL;
 	return seq_release(inode, file);
 }
 
-- 
1.6.3

