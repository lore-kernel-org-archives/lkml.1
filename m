Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZDMWXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZDMWXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbZDMWXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:23:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:51538 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZDMWXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:23:20 -0400
Date: Mon, 13 Apr 2009 22:22:34 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49D32387.9040106@cn.fujitsu.com>
References: <49D32387.9040106@cn.fujitsu.com>
Subject: [tip:tracing/core] blktrace: fix output of BLK_TC_PC events
Message-ID: <tip-66de7792c02693b49671afe58c771fde3b092fc7@git.kernel.org>
Git-Commit-ID: 66de7792c02693b49671afe58c771fde3b092fc7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Apr 2009 22:22:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66de7792c02693b49671afe58c771fde3b092fc7
Gitweb:     http://git.kernel.org/tip/66de7792c02693b49671afe58c771fde3b092fc7
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 1 Apr 2009 16:19:19 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 15:32:46 +0200

blktrace: fix output of BLK_TC_PC events

BLK_TC_PC events should be treated differently with BLK_TC_FS events.

Before this patch:

 # echo 1 > /sys/block/sda/sda1/trace/enable
 # echo pc > /sys/block/sda/sda1/trace/act_mask
 # echo blk > /debugfs/tracing/current_tracer
 # (generate some BLK_TC_PC events)
 # cat trace
        bash-2184  [000]  1774.275413:   8,7    I   N [bash]
        bash-2184  [000]  1774.275435:   8,7    D   N [bash]
        bash-2184  [000]  1774.275540:   8,7    I   R [bash]
        bash-2184  [000]  1774.275547:   8,7    D   R [bash]
 ksoftirqd/0-4     [000]  1774.275580:   8,7    C   N 0 [0]
        bash-2184  [000]  1774.275648:   8,7    I   R [bash]
        bash-2184  [000]  1774.275653:   8,7    D   R [bash]
 ksoftirqd/0-4     [000]  1774.275682:   8,7    C   N 0 [0]
        bash-2184  [000]  1774.275739:   8,7    I   R [bash]
        bash-2184  [000]  1774.275744:   8,7    D   R [bash]
 ksoftirqd/0-4     [000]  1774.275771:   8,7    C   N 0 [0]
        bash-2184  [000]  1774.275804:   8,7    I   R [bash]
        bash-2184  [000]  1774.275808:   8,7    D   R [bash]
 ksoftirqd/0-4     [000]  1774.275836:   8,7    C   N 0 [0]

After this patch:

 # cat trace
        bash-2263  [000]   366.782149:   8,7    I   N 0 (00 ..) [bash]
        bash-2263  [000]   366.782323:   8,7    D   N 0 (00 ..) [bash]
        bash-2263  [000]   366.782557:   8,7    I   R 8 (25 00 ..) [bash]
        bash-2263  [000]   366.782560:   8,7    D   R 8 (25 00 ..) [bash]
 ksoftirqd/0-4     [000]   366.782582:   8,7    C   N (25 00 ..) [0]
        bash-2263  [000]   366.782648:   8,7    I   R 8 (5a 00 3f 00) [bash]
        bash-2263  [000]   366.782650:   8,7    D   R 8 (5a 00 3f 00) [bash]
 ksoftirqd/0-4     [000]   366.782669:   8,7    C   N (5a 00 3f 00) [0]
        bash-2263  [000]   366.782710:   8,7    I   R 8 (5a 00 08 00) [bash]
        bash-2263  [000]   366.782713:   8,7    D   R 8 (5a 00 08 00) [bash]
 ksoftirqd/0-4     [000]   366.782730:   8,7    C   N (5a 00 08 00) [0]
        bash-2263  [000]   366.783375:   8,7    I   R 36 (5a 00 08 00) [bash]
        bash-2263  [000]   366.783379:   8,7    D   R 36 (5a 00 08 00) [bash]
 ksoftirqd/0-4     [000]   366.783404:   8,7    C   N (5a 00 08 00) [0]

This is what we do with PC events in user-space blktrace.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49D32387.9040106@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |   88 ++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index e45e1af..2b98195 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -971,6 +971,16 @@ static inline const void *pdu_start(const struct trace_entry *ent)
 	return te_blk_io_trace(ent) + 1;
 }
 
+static inline u32 t_action(const struct trace_entry *ent)
+{
+	return te_blk_io_trace(ent)->action;
+}
+
+static inline u32 t_bytes(const struct trace_entry *ent)
+{
+	return te_blk_io_trace(ent)->bytes;
+}
+
 static inline u32 t_sec(const struct trace_entry *ent)
 {
 	return te_blk_io_trace(ent)->bytes >> 9;
@@ -1031,25 +1041,87 @@ static int blk_log_action(struct trace_iterator *iter, const char *act)
 				MAJOR(t->device), MINOR(t->device), act, rwbs);
 }
 
+static int blk_log_dump_pdu(struct trace_seq *s, const struct trace_entry *ent)
+{
+	const char *pdu_buf;
+	int pdu_len;
+	int i, end, ret;
+
+	pdu_buf = pdu_start(ent);
+	pdu_len = te_blk_io_trace(ent)->pdu_len;
+
+	if (!pdu_len)
+		return 1;
+
+	/* find the last zero that needs to be printed */
+	for (end = pdu_len - 1; end >= 0; end--)
+		if (pdu_buf[end])
+			break;
+	end++;
+
+	if (!trace_seq_putc(s, '('))
+		return 0;
+
+	for (i = 0; i < pdu_len; i++) {
+
+		ret = trace_seq_printf(s, "%s%02x",
+				       i == 0 ? "" : " ", pdu_buf[i]);
+		if (!ret)
+			return ret;
+
+		/*
+		 * stop when the rest is just zeroes and indicate so
+		 * with a ".." appended
+		 */
+		if (i == end && end != pdu_len - 1)
+			return trace_seq_puts(s, " ..) ");
+	}
+
+	return trace_seq_puts(s, ") ");
+}
+
 static int blk_log_generic(struct trace_seq *s, const struct trace_entry *ent)
 {
 	char cmd[TASK_COMM_LEN];
 
 	trace_find_cmdline(ent->pid, cmd);
 
-	if (t_sec(ent))
-		return trace_seq_printf(s, "%llu + %u [%s]\n",
-					t_sector(ent), t_sec(ent), cmd);
-	return trace_seq_printf(s, "[%s]\n", cmd);
+	if (t_action(ent) & BLK_TC_ACT(BLK_TC_PC)) {
+		int ret;
+
+		ret = trace_seq_printf(s, "%u ", t_bytes(ent));
+		if (!ret)
+			return 0;
+		ret = blk_log_dump_pdu(s, ent);
+		if (!ret)
+			return 0;
+		return trace_seq_printf(s, "[%s]\n", cmd);
+	} else {
+		if (t_sec(ent))
+			return trace_seq_printf(s, "%llu + %u [%s]\n",
+						t_sector(ent), t_sec(ent), cmd);
+		return trace_seq_printf(s, "[%s]\n", cmd);
+	}
 }
 
 static int blk_log_with_error(struct trace_seq *s,
 			      const struct trace_entry *ent)
 {
-	if (t_sec(ent))
-		return trace_seq_printf(s, "%llu + %u [%d]\n", t_sector(ent),
-					t_sec(ent), t_error(ent));
-	return trace_seq_printf(s, "%llu [%d]\n", t_sector(ent), t_error(ent));
+	if (t_action(ent) & BLK_TC_ACT(BLK_TC_PC)) {
+		int ret;
+
+		ret = blk_log_dump_pdu(s, ent);
+		if (ret)
+			return trace_seq_printf(s, "[%d]\n", t_error(ent));
+		return 0;
+	} else {
+		if (t_sec(ent))
+			return trace_seq_printf(s, "%llu + %u [%d]\n",
+						t_sector(ent),
+						t_sec(ent), t_error(ent));
+		return trace_seq_printf(s, "%llu [%d]\n",
+					t_sector(ent), t_error(ent));
+	}
 }
 
 static int blk_log_remap(struct trace_seq *s, const struct trace_entry *ent)
