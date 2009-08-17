Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbZHQFmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbZHQFmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 01:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZHQFmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 01:42:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52658 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZHQFmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 01:42:11 -0400
Message-ID: <4A88ED57.5060609@cn.fujitsu.com>
Date: Mon, 17 Aug 2009 13:40:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] lockdep: Simplify lockdep_chains seqfile code
References: <4A88ED15.20800@cn.fujitsu.com>
In-Reply-To: <4A88ED15.20800@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- make lc_next() call lc_start()
- use lock_chains directly instead of storing it in m->private

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/lockdep_proc.c |   37 +++++++------------------------------
 1 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index d0f53b0..cd5ed35 100644
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
-- 
1.6.3

