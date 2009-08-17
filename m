Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbZHQFlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbZHQFlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 01:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbZHQFll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 01:41:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58451 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZHQFll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 01:41:41 -0400
Message-ID: <4A88ED41.5000000@cn.fujitsu.com>
Date: Mon, 17 Aug 2009 13:40:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] lockdep: Simplify lockdep seqfile code
References: <4A88ED15.20800@cn.fujitsu.com>
In-Reply-To: <4A88ED15.20800@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use seq_list_start_head() and seq_list_next().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/lockdep_proc.c |   46 +++++-----------------------------------------
 1 files changed, 5 insertions(+), 41 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 84c6b1e..d0f53b0 100644
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
-- 
1.6.3

