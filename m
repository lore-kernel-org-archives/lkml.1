Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbZGGFw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbZGGFw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZGGFws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:52:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63564 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbZGGFwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:52:47 -0400
Message-ID: <4A52E2B4.6030706@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 13:52:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/8] ksym_tracer: Rewrite ksym_trace_filter_read()
References: <4A52E291.1020408@cn.fujitsu.com>
In-Reply-To: <4A52E291.1020408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading ksym_trace_filter gave me some arbitrary characters,
when it should show nothing. It's because buf is not initialized
when there's no filter.

Also reduce stack usage by about 512 bytes.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.5.4.rc3
