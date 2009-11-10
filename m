Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbZKJK0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbZKJK0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:26:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbZKJK0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:26:01 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62696 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbZKJKZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:25:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jsi2x8GSjqwik86lRPcgLarL3YyParyPsGbSR+NaBfFMNzCpHvy+zo8Q5PbHEelEFK
         0woItS4ln7MDRIMWkndFMi450A9DSVedp0/2oOrkabscc2s8qWY81l+uC2LIK04b8mmW
         EyJS5NORgaY8EdId0Mc8nfwesO+UE7l+27UpQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
       Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/4] ksym_tracer: Support read accesses independent of read/write.
Date: Tue, 10 Nov 2009 11:25:57 +0100
Message-Id: <1257848760-9407-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257848760-9407-1-git-send-email-fweisbec@gmail.com>
References: <1257848760-9407-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>

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
-- 
1.6.2.3

