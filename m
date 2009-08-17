Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbZHQFlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbZHQFlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 01:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbZHQFlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 01:41:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57978 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756720AbZHQFlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 01:41:13 -0400
Message-ID: <4A88ED25.2040306@cn.fujitsu.com>
Date: Mon, 17 Aug 2009 13:39:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] lock_dep: Fix missing entries in /proc/lock_chains
References: <4A88ED15.20800@cn.fujitsu.com>
In-Reply-To: <4A88ED15.20800@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two entries are missing in the output of /proc/lock_chains.

One is chains[1]. When lc_next() is called the 1st time, chains[0] is
returned. And when it's called the 2nd time, chains[2] is returned.

The other missing ons is, when lc_start() is called the 2nd time, we
should start from chains[@pos-1] but not chains[@pos], because pos == 0
is the header.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/lockdep_proc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 0c39f18..84c6b1e 100644
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
-- 
1.6.3

