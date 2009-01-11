Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbZAKTPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbZAKTPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZAKTPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:15:11 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:54740 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZAKTPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:15:09 -0500
Subject: [PATCH] jbd2: fix wrong use of do_div
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 11 Jan 2009 20:16:33 +0100
Message-Id: <1231701393.17759.30.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the following warning:

fs/jbd2/journal.c: In function ‘jbd2_seq_info_show’:
fs/jbd2/journal.c:850: warning: format ‘%lu’ expects type ‘long
unsigned int’, but argument 3 has type ‘uint32_t’

is caused by wrong usage of do_div that modifies the dividend in-place
and returns the quotient. So not only would an incorrect value be
displayed, but s->journal->j_average_commit_time would also be changed
to a wrong value! This patch fixes it.

Signed-off-by: Simon Holm Thøgersen <odie@cs.aau.dk>
---
 fs/jbd2/journal.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5667530..f9620e3 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -828,6 +828,7 @@ static void *jbd2_seq_info_next(struct seq_file *seq, void *v, loff_t *pos)
 static int jbd2_seq_info_show(struct seq_file *seq, void *v)
 {
 	struct jbd2_stats_proc_session *s = seq->private;
+	u64 n;
 
 	if (v != SEQ_START_TOKEN)
 		return 0;
@@ -846,8 +847,11 @@ static int jbd2_seq_info_show(struct seq_file *seq, void *v)
 	    jiffies_to_msecs(s->stats->u.run.rs_flushing / s->stats->ts_tid));
 	seq_printf(seq, "  %ums logging transaction\n",
 	    jiffies_to_msecs(s->stats->u.run.rs_logging / s->stats->ts_tid));
-	seq_printf(seq, "  %luus average transaction commit time\n",
-		   do_div(s->journal->j_average_commit_time, 1000));
+
+	n = s->journal->j_average_commit_time;
+	do_div(n, 1000);
+	seq_printf(seq, "  %llus average transaction commit time\n", n);
+
 	seq_printf(seq, "  %lu handles per transaction\n",
 	    s->stats->u.run.rs_handle_count / s->stats->ts_tid);
 	seq_printf(seq, "  %lu blocks per transaction\n",
-- 
1.6.0.2.526.g5c283

