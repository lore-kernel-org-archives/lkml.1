Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbZKUNe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZKUNe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZKUNez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:34:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:41588 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbZKUNew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:34:52 -0500
Date: Sat, 21 Nov 2009 13:34:07 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <4A52E2B4.6030706@cn.fujitsu.com>
References: <4A52E2B4.6030706@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ksym_tracer: Rewrite ksym_trace_filter_read()
Message-ID: <tip-be9742e6cb107fe1d77db7a081ea4eb25e79e1ad@git.kernel.org>
Git-Commit-ID: be9742e6cb107fe1d77db7a081ea4eb25e79e1ad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be9742e6cb107fe1d77db7a081ea4eb25e79e1ad
Gitweb:     http://git.kernel.org/tip/be9742e6cb107fe1d77db7a081ea4eb25e79e1ad
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 7 Jul 2009 13:52:52 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 11:59:40 +0200

ksym_tracer: Rewrite ksym_trace_filter_read()

Reading ksym_trace_filter gave me some arbitrary characters,
when it should show nothing. It's because buf is not initialized
when there's no filter.

Also reduce stack usage by about 512 bytes.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A52E2B4.6030706@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_ksym.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 085ff05..b6710d3 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -35,7 +35,6 @@
 #define KSYM_TRACER_MAX HBP_NUM
 
 #define KSYM_TRACER_OP_LEN 3 /* rw- */
-#define KSYM_FILTER_ENTRY_LEN (KSYM_NAME_LEN + KSYM_TRACER_OP_LEN + 1)
 
 struct trace_ksym {
 	struct hw_breakpoint	*ksym_hbp;
@@ -230,25 +229,33 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 {
 	struct trace_ksym *entry;
 	struct hlist_node *node;
-	char buf[KSYM_FILTER_ENTRY_LEN * KSYM_TRACER_MAX];
-	ssize_t ret, cnt = 0;
+	struct trace_seq *s;
+	ssize_t cnt = 0;
+	int ret;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+	trace_seq_init(s);
 
 	mutex_lock(&ksym_tracer_mutex);
 
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
-		cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt, "%s:",
-				entry->ksym_hbp->info.name);
+		ret = trace_seq_printf(s, "%s:", entry->ksym_hbp->info.name);
 		if (entry->ksym_hbp->info.type == HW_BREAKPOINT_WRITE)
-			cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt,
-								"-w-\n");
+			ret = trace_seq_puts(s, "-w-\n");
 		else if (entry->ksym_hbp->info.type == HW_BREAKPOINT_RW)
-			cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt,
-								"rw-\n");
+			ret = trace_seq_puts(s, "rw-\n");
+		WARN_ON_ONCE(!ret);
 	}
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, strlen(buf));
+
+	cnt = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
+
 	mutex_unlock(&ksym_tracer_mutex);
 
-	return ret;
+	kfree(s);
+
+	return cnt;
 }
 
 static ssize_t ksym_trace_filter_write(struct file *file,
