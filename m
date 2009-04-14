Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZDNUYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZDNUYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 16:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZDNUV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 16:21:56 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48643 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbZDNUVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 16:21:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=J1//23tvJVC859P9imYr83NFiL29XUVh61qP+ejxYJWr0EvvDpgBm+PZQ4B+jnqAJZ
         iBpjPkAySHzE5mIPCgFmFJouJDiMPcfibfAc0eM34jRrlmLmRM3k6ODm+BCKufQWi/x+
         rTVh5yes5RY1337sZ3ITlgQ4yZ6xF3U4Hx7/c=
From: Andrea Righi <righi.andrea@gmail.com>
To: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Date: Tue, 14 Apr 2009 22:21:20 +0200
Message-Id: <1239740480-28125-10-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delaying journal IO can unnecessarily delay other independent IO
operations from different cgroups.

Add BIO_RW_META flag to the ext3 journal IO that informs the io-throttle
subsystem to account but not delay journal IO and avoid potential
priority inversion problems.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 fs/jbd/commit.c  |    4 ++--
 fs/jbd2/commit.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index a8e8513..2e444af 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -318,7 +318,7 @@ void journal_commit_transaction(journal_t *journal)
 	int first_tag = 0;
 	int tag_flag;
 	int i;
-	int write_op = WRITE;
+	int write_op = WRITE | (1 << BIO_RW_META);
 
 	/*
 	 * First job: lock down the current transaction and wait for
@@ -357,7 +357,7 @@ void journal_commit_transaction(journal_t *journal)
 	 * instead we rely on sync_buffer() doing the unplug for us.
 	 */
 	if (commit_transaction->t_synchronous_commit)
-		write_op = WRITE_SYNC_PLUG;
+		write_op = WRITE_SYNC_PLUG | (1 << BIO_RW_META);
 	spin_lock(&commit_transaction->t_handle_lock);
 	while (commit_transaction->t_updates) {
 		DEFINE_WAIT(wait);
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 073c8c3..61484d0 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -367,7 +367,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	int tag_bytes = journal_tag_bytes(journal);
 	struct buffer_head *cbh = NULL; /* For transactional checksums */
 	__u32 crc32_sum = ~0;
-	int write_op = WRITE;
+	int write_op = WRITE | (1 << BIO_RW_META);
 
 	/*
 	 * First job: lock down the current transaction and wait for
@@ -408,7 +408,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 * instead we rely on sync_buffer() doing the unplug for us.
 	 */
 	if (commit_transaction->t_synchronous_commit)
-		write_op = WRITE_SYNC_PLUG;
+		write_op = WRITE_SYNC_PLUG | (1 << BIO_RW_META);
 	stats.u.run.rs_wait = commit_transaction->t_max_wait;
 	stats.u.run.rs_locked = jiffies;
 	stats.u.run.rs_running = jbd2_time_diff(commit_transaction->t_start,
-- 
1.5.6.3

