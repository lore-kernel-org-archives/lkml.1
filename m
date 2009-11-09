Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbZKIIh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbZKIIh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZKIIh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:37:58 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41237 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbZKIIh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:37:57 -0500
Date: Mon, 9 Nov 2009 17:37:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip] ksym_tracer: Support read accesses independent of read/write.
Message-ID: <20091109083733.GA25848@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the infrastructure already exists to support read accesses
for platforms that support a read access independently of read/write
(such as in the case of the SuperH UBC). This just trivially hooks
up the read case by itself.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

Applies on top of v6 of the hw-breakpoints perf event rewrite (and
tracing/hw-breakpoints in -tip as of this moment).

 kernel/trace/trace_ksym.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index fea83ee..11935b5 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -136,6 +136,7 @@ static int ksym_trace_get_access_type(char *str)
 		access |= HW_BREAKPOINT_X;
 
 	switch (access) {
+	case HW_BREAKPOINT_R:
 	case HW_BREAKPOINT_W:
 	case HW_BREAKPOINT_W | HW_BREAKPOINT_R:
 		return access;
@@ -239,7 +240,9 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
 		ret = trace_seq_printf(s, "%pS:", (void *)entry->ksym_addr);
-		if (entry->type == HW_BREAKPOINT_W)
+		if (entry->type == HW_BREAKPOINT_R)
+			ret = trace_seq_puts(s, "r--\n");
+		else if (entry->type == HW_BREAKPOINT_W)
 			ret = trace_seq_puts(s, "-w-\n");
 		else if (entry->type == (HW_BREAKPOINT_W | HW_BREAKPOINT_R))
 			ret = trace_seq_puts(s, "rw-\n");
@@ -414,6 +417,9 @@ static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	switch (field->type) {
+	case HW_BREAKPOINT_R:
+		ret = trace_seq_printf(s, " R  ");
+		break;
 	case HW_BREAKPOINT_W:
 		ret = trace_seq_printf(s, " W  ");
 		break;
@@ -488,6 +494,9 @@ static int ksym_tracer_stat_show(struct seq_file *m, void *v)
 	access_type = entry->type;
 
 	switch (access_type) {
+	case HW_BREAKPOINT_R:
+		seq_puts(m, "  R           ");
+		break;
 	case HW_BREAKPOINT_W:
 		seq_puts(m, "  W           ");
 		break;
