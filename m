Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZHQIDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZHQIDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbZHQIDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:03:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:34307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208AbZHQIDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:03:31 -0400
Date: Mon, 17 Aug 2009 08:02:18 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A88ED57.5060609@cn.fujitsu.com>
References: <4A88ED57.5060609@cn.fujitsu.com>
Subject: [tip:core/locking] lockdep: Simplify lockdep_chains seqfile code
Message-ID: <tip-12aac19d4ba41019a1748f49d3c5d259b1bfb26d@git.kernel.org>
Git-Commit-ID: 12aac19d4ba41019a1748f49d3c5d259b1bfb26d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 08:02:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12aac19d4ba41019a1748f49d3c5d259b1bfb26d
Gitweb:     http://git.kernel.org/tip/12aac19d4ba41019a1748f49d3c5d259b1bfb26d
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 17 Aug 2009 13:40:39 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 09:54:41 +0200

lockdep: Simplify lockdep_chains seqfile code

- make lc_next() call lc_start()
- use lock_chains directly instead of storing it in m->private

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4A88ED57.5060609@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep_proc.c |   37 +++++++------------------------------
 1 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 05fb5fd..2bbe25f 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -113,26 +113,6 @@ static const struct file_operations proc_lockdep_operations = {
 };
 
 #ifdef CONFIG_PROVE_LOCKING
-static void *lc_next(struct seq_file *m, void *v, loff_t *pos)
-{
-	struct lock_chain *chain;
-
-	(*pos)++;
-
-	if (v == SEQ_START_TOKEN)
-		chain = m->private;
-	else {
-		chain = v;
-
-		if (*pos - 1 < nr_lock_chains)
-			chain = lock_chains + (*pos - 1);
-		else
-			chain = NULL;
-	}
-
-	return chain;
-}
-
 static void *lc_start(struct seq_file *m, loff_t *pos)
 {
 	if (*pos == 0)
@@ -144,6 +124,12 @@ static void *lc_start(struct seq_file *m, loff_t *pos)
 	return NULL;
 }
 
+static void *lc_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return lc_start(m, pos);
+}
+
 static void lc_stop(struct seq_file *m, void *v)
 {
 }
@@ -184,16 +170,7 @@ static const struct seq_operations lockdep_chains_ops = {
 
 static int lockdep_chains_open(struct inode *inode, struct file *file)
 {
-	int res = seq_open(file, &lockdep_chains_ops);
-	if (!res) {
-		struct seq_file *m = file->private_data;
-
-		if (nr_lock_chains)
-			m->private = lock_chains;
-		else
-			m->private = NULL;
-	}
-	return res;
+	return seq_open(file, &lockdep_chains_ops);
 }
 
 static const struct file_operations proc_lockdep_chains_operations = {
