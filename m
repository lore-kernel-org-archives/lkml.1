Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZHQIEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZHQIEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbZHQIEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:04:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:34339 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbZHQIEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:04:45 -0400
Date: Mon, 17 Aug 2009 08:02:30 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A88ED6B.6030602@cn.fujitsu.com>
References: <4A88ED6B.6030602@cn.fujitsu.com>
Subject: [tip:core/locking] lockdep: Simplify lock_stat seqfile code
Message-ID: <tip-96004bb2a1e4ccad2b1eeb92e51031d1e8e609e3@git.kernel.org>
Git-Commit-ID: 96004bb2a1e4ccad2b1eeb92e51031d1e8e609e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 08:02:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96004bb2a1e4ccad2b1eeb92e51031d1e8e609e3
Gitweb:     http://git.kernel.org/tip/96004bb2a1e4ccad2b1eeb92e51031d1e8e609e3
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 17 Aug 2009 13:40:59 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 09:54:41 +0200

lockdep: Simplify lock_stat seqfile code

- make ls_next() call ls_start()
- remove redundant code in lock_stat_release()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4A88ED6B.6030602@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep_proc.c |   29 +++++++----------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 2bbe25f..8dac840 100644
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
 
