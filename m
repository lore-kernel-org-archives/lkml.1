Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbYE0SeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbYE0SeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbYE0Sd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:33:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:22778 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbYE0Sd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=rlUxSGpOZUWy0gjMYlyA6mwZRTSV0kOVPHtfFk3VkV4BO7s481ZBg6Kay9xqD70sDDZikoIO0d7dPdAYZ9o2AdkbAwFSsmVfDRxGWu7XjixNiX8pIdQQnx7eAVnjDKQGYOBcXZOSgwkHMefC8joz0dQI6js/I7JOBGxCoZOAzdI=
Message-ID: <483C53EE.2060602@gmail.com>
Date: Wed, 28 May 2008 00:03:18 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: distinguish kretprobe'd functions in trace logs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Tracing functions via ftrace which have a kretprobe installed on them, can produce misleading output in their trace logs. E.g, consider the correct trace of the following sequence:

do_IRQ()
{
~
  irq_enter();
~
}


Trace log (sample):
<idle>-0     [00] 4154504455.781616: irq_enter <- do_IRQ


But if irq_enter() has a kretprobe installed on it, the return value stored on the stack at each invocation is modified to divert the return to a kprobe trampoline function called kretprobe_trampoline(). So with this the trace would (currently) look like:

<idle>-0     [00] 4154504455.781616: irq_enter <- kretprobe_trampoline

Now this is quite misleading to the end user, as it suggests something that didn't actually happen. So just to avoid such misinterpretations, the inlined patch aims to output such a log as:

<idle>-0     [00] 4154504455.781616: irq_enter <- [unknown/kretprobe'd]


Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0feae23..12f5e81 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -27,6 +27,7 @@
 #include <linux/poll.h>
 #include <linux/gfp.h>
 #include <linux/fs.h>
+#include <linux/kprobes.h>
 #include <linux/writeback.h>
 
 #include <linux/stacktrace.h>
@@ -1199,6 +1200,20 @@ static void s_stop(struct seq_file *m, void *p)
 	mutex_unlock(&trace_types_lock);
 }
 
+#define KRETPROBE_MSG "[unknown/kretprobe'd]"
+
+#ifdef CONFIG_KRETPROBES
+static inline int kretprobed(unsigned long addr)
+{
+	return addr == (unsigned long)kretprobe_trampoline;
+}
+#else
+static inline int kretprobed(unsigned long addr)
+{
+	return 0;
+}
+#endif /* CONFIG_KRETPROBES */
+
 static int
 seq_print_sym_short(struct trace_seq *s, const char *fmt, unsigned long address)
 {
@@ -1434,7 +1449,10 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 	case TRACE_FN:
 		seq_print_ip_sym(s, entry->fn.ip, sym_flags);
 		trace_seq_puts(s, " (");
-		seq_print_ip_sym(s, entry->fn.parent_ip, sym_flags);
+		if (kretprobed(entry->fn.parent_ip))
+			trace_seq_puts(s, KRETPROBE_MSG);
+		else
+			seq_print_ip_sym(s, entry->fn.parent_ip, sym_flags);
 		trace_seq_puts(s, ")\n");
 		break;
 	case TRACE_CTX:
@@ -1514,8 +1532,11 @@ static int print_trace_fmt(struct trace_iterator *iter)
 			ret = trace_seq_printf(s, " <-");
 			if (!ret)
 				return 0;
-			ret = seq_print_ip_sym(s, entry->fn.parent_ip,
-					       sym_flags);
+			if (kretprobed(entry->fn.parent_ip))
+				ret = trace_seq_puts(s, KRETPROBE_MSG);
+			else
+				ret = seq_print_ip_sym(s, entry->fn.parent_ip,
+						       sym_flags);
 			if (!ret)
 				return 0;
 		}
