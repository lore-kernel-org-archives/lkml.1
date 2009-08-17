Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbZHQIEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbZHQIEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757292AbZHQIEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:04:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:34335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757251AbZHQIEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:04:40 -0400
Date: Mon, 17 Aug 2009 08:01:52 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A88ED25.2040306@cn.fujitsu.com>
References: <4A88ED25.2040306@cn.fujitsu.com>
Subject: [tip:core/locking] lockdep: Fix missing entries in /proc/lock_chains
Message-ID: <tip-e9d65725bdf5954283625ca4d770bfc34f2ae56a@git.kernel.org>
Git-Commit-ID: e9d65725bdf5954283625ca4d770bfc34f2ae56a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 08:01:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9d65725bdf5954283625ca4d770bfc34f2ae56a
Gitweb:     http://git.kernel.org/tip/e9d65725bdf5954283625ca4d770bfc34f2ae56a
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 17 Aug 2009 13:39:49 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 09:54:40 +0200

lockdep: Fix missing entries in /proc/lock_chains

Two entries are missing in the output of /proc/lock_chains.

One is chains[1]. When lc_next() is called the 1st time,
chains[0] is returned. And when it's called the 2nd time,
chains[2] is returned.

The other missing ons is, when lc_start() is called the 2nd
time, we should start from chains[@pos-1] but not chains[@pos],
because pos == 0 is the header.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4A88ED25.2040306@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep_proc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 5dbe30b..9a7996e 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -160,8 +160,8 @@ static void *lc_next(struct seq_file *m, void *v, loff_t *pos)
 	else {
 		chain = v;
 
-		if (*pos < nr_lock_chains)
-			chain = lock_chains + *pos;
+		if (*pos - 1 < nr_lock_chains)
+			chain = lock_chains + (*pos - 1);
 		else
 			chain = NULL;
 	}
@@ -174,8 +174,8 @@ static void *lc_start(struct seq_file *m, loff_t *pos)
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	if (*pos < nr_lock_chains)
-		return lock_chains + *pos;
+	if (*pos - 1 < nr_lock_chains)
+		return lock_chains + (*pos - 1);
 
 	return NULL;
 }
