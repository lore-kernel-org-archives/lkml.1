Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbZKZIpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbZKZIpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbZKZIpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:45:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:58799 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759950AbZKZIpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:45:00 -0500
Date: Thu, 26 Nov 2009 08:44:00 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, tytso@mit.edu, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, tytso@mit.edu, mingo@elte.hu
In-Reply-To: <4B0E290F.7030909@cn.fujitsu.com>
References: <4B0E290F.7030909@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Convert some jbd2 events to DEFINE_EVENT
Message-ID: <tip-071688f36e7eba3e37b2fc48e35bfdab99b80b4d@git.kernel.org>
Git-Commit-ID: 071688f36e7eba3e37b2fc48e35bfdab99b80b4d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  071688f36e7eba3e37b2fc48e35bfdab99b80b4d
Gitweb:     http://git.kernel.org/tip/071688f36e7eba3e37b2fc48e35bfdab99b80b4d
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 26 Nov 2009 15:06:55 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:14:04 +0100

tracing: Convert some jbd2 events to DEFINE_EVENT

Use DECLARE_EVENT_CLASS to remove duplicate code:

   text    data     bss     dec     hex filename
  34903    1693     448   37044    90b4 fs/jbd2/journal.o.old
  31931    1693     416   34040    84f8 fs/jbd2/journal.o

Four events are converted:

  jbd2_commit: jbd2_start_commit,
               jbd2_commit_{locking, flushing, logging}

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0E290F.7030909@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/jbd2.h |   63 +++++++-----------------------------------
 1 files changed, 11 insertions(+), 52 deletions(-)

diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
index 3c60b75..96b370a 100644
--- a/include/trace/events/jbd2.h
+++ b/include/trace/events/jbd2.h
@@ -30,7 +30,7 @@ TRACE_EVENT(jbd2_checkpoint,
 		  jbd2_dev_to_name(__entry->dev), __entry->result)
 );
 
-TRACE_EVENT(jbd2_start_commit,
+DECLARE_EVENT_CLASS(jbd2_commit,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
@@ -53,73 +53,32 @@ TRACE_EVENT(jbd2_start_commit,
 		  __entry->sync_commit)
 );
 
-TRACE_EVENT(jbd2_commit_locking,
+DEFINE_EVENT(jbd2_commit, jbd2_start_commit,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
-	TP_ARGS(journal, commit_transaction),
-
-	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
-		__field(	char,	sync_commit		  )
-		__field(	int,	transaction		  )
-	),
-
-	TP_fast_assign(
-		__entry->dev		= journal->j_fs_dev->bd_dev;
-		__entry->sync_commit = commit_transaction->t_synchronous_commit;
-		__entry->transaction	= commit_transaction->t_tid;
-	),
-
-	TP_printk("dev %s transaction %d sync %d",
-		  jbd2_dev_to_name(__entry->dev), __entry->transaction,
-		  __entry->sync_commit)
+	TP_ARGS(journal, commit_transaction)
 );
 
-TRACE_EVENT(jbd2_commit_flushing,
+DEFINE_EVENT(jbd2_commit, jbd2_commit_locking,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
-	TP_ARGS(journal, commit_transaction),
-
-	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
-		__field(	char,	sync_commit		  )
-		__field(	int,	transaction		  )
-	),
-
-	TP_fast_assign(
-		__entry->dev		= journal->j_fs_dev->bd_dev;
-		__entry->sync_commit = commit_transaction->t_synchronous_commit;
-		__entry->transaction	= commit_transaction->t_tid;
-	),
-
-	TP_printk("dev %s transaction %d sync %d",
-		  jbd2_dev_to_name(__entry->dev), __entry->transaction,
-		  __entry->sync_commit)
+	TP_ARGS(journal, commit_transaction)
 );
 
-TRACE_EVENT(jbd2_commit_logging,
+DEFINE_EVENT(jbd2_commit, jbd2_commit_flushing,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
-	TP_ARGS(journal, commit_transaction),
+	TP_ARGS(journal, commit_transaction)
+);
 
-	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
-		__field(	char,	sync_commit		  )
-		__field(	int,	transaction		  )
-	),
+DEFINE_EVENT(jbd2_commit, jbd2_commit_logging,
 
-	TP_fast_assign(
-		__entry->dev		= journal->j_fs_dev->bd_dev;
-		__entry->sync_commit = commit_transaction->t_synchronous_commit;
-		__entry->transaction	= commit_transaction->t_tid;
-	),
+	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
-	TP_printk("dev %s transaction %d sync %d",
-		  jbd2_dev_to_name(__entry->dev), __entry->transaction,
-		  __entry->sync_commit)
+	TP_ARGS(journal, commit_transaction)
 );
 
 TRACE_EVENT(jbd2_end_commit,
