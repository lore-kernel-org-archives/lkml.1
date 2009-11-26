Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbZKZHHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbZKZHHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZKZHHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:07:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758671AbZKZHHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:07:18 -0500
Message-ID: <4B0E290F.7030909@cn.fujitsu.com>
Date: Thu, 26 Nov 2009 15:06:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Theodore Ts'o" <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/9] tracing: Convert some jbd2 events to DEFINE_EVENT
References: <4B0E2807.4060102@cn.fujitsu.com>
In-Reply-To: <4B0E2807.4060102@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use TRACE_EVENT_TEMPLATE to remove duplicate code:

   text    data     bss     dec     hex filename
  34903    1693     448   37044    90b4 fs/jbd2/journal.o.old
  31931    1693     416   34040    84f8 fs/jbd2/journal.o

Four events are converted:

  jbd2_commit: jbd2_start_commit,
               jbd2_commit_{locking, flushing, logging}

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/events/jbd2.h |   63 +++++++-----------------------------------
 1 files changed, 11 insertions(+), 52 deletions(-)

diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
index 3c60b75..a1abcf4 100644
--- a/include/trace/events/jbd2.h
+++ b/include/trace/events/jbd2.h
@@ -30,7 +30,7 @@ TRACE_EVENT(jbd2_checkpoint,
 		  jbd2_dev_to_name(__entry->dev), __entry->result)
 );
 
-TRACE_EVENT(jbd2_start_commit,
+TRACE_EVENT_TEMPLATE(jbd2_commit,
 
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
-- 
1.6.3

