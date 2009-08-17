Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZHQIEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZHQIEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbZHQIEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:04:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:34341 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757340AbZHQIEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:04:48 -0400
Date: Mon, 17 Aug 2009 08:02:05 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A88ED41.5000000@cn.fujitsu.com>
References: <4A88ED41.5000000@cn.fujitsu.com>
Subject: [tip:core/locking] lockdep: Simplify lockdep seqfile code
Message-ID: <tip-8109e1de8502421f9efff1359f2779b1adcc0724@git.kernel.org>
Git-Commit-ID: 8109e1de8502421f9efff1359f2779b1adcc0724
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 08:02:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8109e1de8502421f9efff1359f2779b1adcc0724
Gitweb:     http://git.kernel.org/tip/8109e1de8502421f9efff1359f2779b1adcc0724
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 17 Aug 2009 13:40:17 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 09:54:40 +0200

lockdep: Simplify lockdep seqfile code

Use seq_list_start_head() and seq_list_next().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4A88ED41.5000000@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep_proc.c |   46 +++++-----------------------------------------
 1 files changed, 5 insertions(+), 41 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 9a7996e..05fb5fd 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -25,38 +25,12 @@
 
 static void *l_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct lock_class *class;
-
-	(*pos)++;
-
-	if (v == SEQ_START_TOKEN)
-		class = m->private;
-	else {
-		class = v;
-
-		if (class->lock_entry.next != &all_lock_classes)
-			class = list_entry(class->lock_entry.next,
-					   struct lock_class, lock_entry);
-		else
-			class = NULL;
-	}
-
-	return class;
+	return seq_list_next(v, &all_lock_classes, pos);
 }
 
 static void *l_start(struct seq_file *m, loff_t *pos)
 {
-	struct lock_class *class;
-	loff_t i = 0;
-
-	if (*pos == 0)
-		return SEQ_START_TOKEN;
-
-	list_for_each_entry(class, &all_lock_classes, lock_entry) {
-		if (++i == *pos)
-		return class;
-	}
-	return NULL;
+	return seq_list_start_head(&all_lock_classes, *pos);
 }
 
 static void l_stop(struct seq_file *m, void *v)
@@ -82,11 +56,11 @@ static void print_name(struct seq_file *m, struct lock_class *class)
 
 static int l_show(struct seq_file *m, void *v)
 {
-	struct lock_class *class = v;
+	struct lock_class *class = list_entry(v, struct lock_class, lock_entry);
 	struct lock_list *entry;
 	char usage[LOCK_USAGE_CHARS];
 
-	if (v == SEQ_START_TOKEN) {
+	if (v == &all_lock_classes) {
 		seq_printf(m, "all lock classes:\n");
 		return 0;
 	}
@@ -128,17 +102,7 @@ static const struct seq_operations lockdep_ops = {
 
 static int lockdep_open(struct inode *inode, struct file *file)
 {
-	int res = seq_open(file, &lockdep_ops);
-	if (!res) {
-		struct seq_file *m = file->private_data;
-
-		if (!list_empty(&all_lock_classes))
-			m->private = list_entry(all_lock_classes.next,
-					struct lock_class, lock_entry);
-		else
-			m->private = NULL;
-	}
-	return res;
+	return seq_open(file, &lockdep_ops);
 }
 
 static const struct file_operations proc_lockdep_operations = {
