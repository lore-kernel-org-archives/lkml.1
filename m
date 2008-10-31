Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbYJaPvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbYJaPvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYJaPvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:51:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37655 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYJaPvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:51:03 -0400
Date: Fri, 31 Oct 2008 11:50:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       ananth@in.ibm.com, jkenisto@us.ibm.com, mhiramat@redhat.com
Subject: Re: [PATCH] ftrace: distinguish kretprobe'd functions in trace
 logs
In-Reply-To: <863e9df20810310832uadf4daay7b5a98b677d86561@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810311142220.22451@gandalf.stny.rr.com>
References: <483C53EE.2060602@gmail.com>  <alpine.DEB.1.10.0810302227360.21031@gandalf.stny.rr.com>  <alpine.DEB.1.10.0810311036130.20157@gandalf.stny.rr.com> <863e9df20810310832uadf4daay7b5a98b677d86561@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 31 Oct 2008, Abhishek Sagar wrote:
> >
> > Hmm, I think I can solve this by not even doing the test here, but simply
> > on the name itself.
> 
> Ok. I wonder if it would be a good idea to export kretprobe_trampoline
> (or kretprobe_trampoline->ip) via asm/kprobes.h for all archs, for the
> kind of checks done here for ftrace (to have them elsewhere too like
> in OOPs generation etc).

Careful, I'm not sure that will work on all archs.

Could you test this patch and see if it still solves the issues. It does 
not require any arch dependent code.

-- Steve


From: Steven Rostedt <srostedt@redhat.com>
Subject: ftrace: use kretprobe trampoline name to test in output

When a function is kprobed, the return address is set to the
kprobe_trampoline, or something similar. This caused the output
of the trace to look confusing when the parent seemed to be this
"kprobe_trampoline" function.

To fix this, Abhishek Sagar added a test of the instruction pointer
of the parent to see if it matched the kprobe_trampoline. If it
did, the output would print a "[unknown/kretprobe'd]" instead.

Unfortunately, not all archs do this the same way, and the trampoline
function may not be exported, which causes failures in builds.

This patch will compare the name instead of the pointer to see
if it matches. This prevents us from depending on a function from
being exported, and should work on all archs. The worst that can
happen is that an arch might use a different name and then we
go back to the confusing output. At least the arch will still build.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-10-31 10:41:29.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-10-31 11:25:21.000000000 -0400
@@ -1104,17 +1104,20 @@ static void s_stop(struct seq_file *m, v
 	mutex_unlock(&trace_types_lock);
 }
 
-#define KRETPROBE_MSG "[unknown/kretprobe'd]"
-
 #ifdef CONFIG_KRETPROBES
-static inline int kretprobed(unsigned long addr)
+static inline const char *kretprobed(const char *name)
 {
-	return addr == (unsigned long)kretprobe_trampoline;
+	static const char tramp_name[] = "kretprobe_trampoline";
+	int size = sizeof(tramp_name);
+
+	if (strncmp(tramp_name, name, size) == 0)
+		return "[unknown/kretprobe'd]";
+	return name;
 }
 #else
-static inline int kretprobed(unsigned long addr)
+static inline const char *kretprobed(const char *name)
 {
-	return 0;
+	return name;
 }
 #endif /* CONFIG_KRETPROBES */
 
@@ -1123,10 +1126,13 @@ seq_print_sym_short(struct trace_seq *s,
 {
 #ifdef CONFIG_KALLSYMS
 	char str[KSYM_SYMBOL_LEN];
+	const char *name;
 
 	kallsyms_lookup(address, NULL, NULL, NULL, str);
 
-	return trace_seq_printf(s, fmt, str);
+	name = kretprobed(str);
+
+	return trace_seq_printf(s, fmt, name);
 #endif
 	return 1;
 }
@@ -1137,9 +1143,12 @@ seq_print_sym_offset(struct trace_seq *s
 {
 #ifdef CONFIG_KALLSYMS
 	char str[KSYM_SYMBOL_LEN];
+	const char *name;
 
 	sprint_symbol(str, address);
-	return trace_seq_printf(s, fmt, str);
+	name = kretprobed(str);
+
+	return trace_seq_printf(s, fmt, name);
 #endif
 	return 1;
 }
@@ -1392,10 +1401,7 @@ print_lat_fmt(struct trace_iterator *ite
 
 		seq_print_ip_sym(s, field->ip, sym_flags);
 		trace_seq_puts(s, " (");
-		if (kretprobed(field->parent_ip))
-			trace_seq_puts(s, KRETPROBE_MSG);
-		else
-			seq_print_ip_sym(s, field->parent_ip, sym_flags);
+		seq_print_ip_sym(s, field->parent_ip, sym_flags);
 		trace_seq_puts(s, ")\n");
 		break;
 	}
@@ -1511,12 +1517,9 @@ static enum print_line_t print_trace_fmt
 			ret = trace_seq_printf(s, " <-");
 			if (!ret)
 				return TRACE_TYPE_PARTIAL_LINE;
-			if (kretprobed(field->parent_ip))
-				ret = trace_seq_puts(s, KRETPROBE_MSG);
-			else
-				ret = seq_print_ip_sym(s,
-						       field->parent_ip,
-						       sym_flags);
+			ret = seq_print_ip_sym(s,
+					       field->parent_ip,
+					       sym_flags);
 			if (!ret)
 				return TRACE_TYPE_PARTIAL_LINE;
 		}
