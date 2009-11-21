Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZKUNix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZKUNix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZKUNiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:38:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:36428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbZKUNiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:38:52 -0500
Date: Sat, 21 Nov 2009 13:38:00 GMT
From: tip-bot for Paul Mundt <lethal@linux-sh.org>
Cc: acme@redhat.com, mingo@redhat.com, stern@rowland.harvard.edu,
       efault@gmx.de, peterz@infradead.org, jirislaby@gmail.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       paulus@samba.org, arjan@linux.intel.com, lizf@cn.fujitsu.com,
       jan.kiszka@web.de, lethal@linux-sh.org, prasad@linux.vnet.ibm.com,
       mingo@elte.hu, avi@redhat.com
Reply-To: mingo@redhat.com, acme@redhat.com, stern@rowland.harvard.edu,
       peterz@infradead.org, efault@gmx.de, jirislaby@gmail.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       paulus@samba.org, arjan@linux.intel.com, lizf@cn.fujitsu.com,
       jan.kiszka@web.de, lethal@linux-sh.org, avi@redhat.com, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <20091109083733.GA25848@linux-sh.org>
References: <20091109083733.GA25848@linux-sh.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ksym_tracer: Support read accesses independent of read/write.
Message-ID: <tip-676c0dbe6e514fdd8e434a9e623c781aa9b40b15@git.kernel.org>
Git-Commit-ID: 676c0dbe6e514fdd8e434a9e623c781aa9b40b15
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  676c0dbe6e514fdd8e434a9e623c781aa9b40b15
Gitweb:     http://git.kernel.org/tip/676c0dbe6e514fdd8e434a9e623c781aa9b40b15
Author:     Paul Mundt <lethal@linux-sh.org>
AuthorDate: Mon, 9 Nov 2009 17:37:34 +0900
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 10 Nov 2009 11:10:08 +0100

ksym_tracer: Support read accesses independent of read/write.

All of the infrastructure already exists to support read accesses
for platforms that support a read access independently of read/write
(such as in the case of the SuperH UBC). This just trivially hooks
up the read case by itself.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kiszka <jan.kiszka@web.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <20091109083733.GA25848@linux-sh.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_ksym.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

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
