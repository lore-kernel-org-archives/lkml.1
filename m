Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZIIBQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZIIBQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZIIBQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:16:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52770 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbZIIBQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:16:44 -0400
Message-ID: <4AA701B3.704@cn.fujitsu.com>
Date: Wed, 09 Sep 2009 09:15:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Eric Biederman <ebiederm@xmission.com>
Subject: [PATCH 2/2] tracing/events: Add kexec tracepoints
References: <4AA70198.9070500@cn.fujitsu.com>
In-Reply-To: <4AA70198.9070500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When panic, save in ring buffer the time when crash happened,
the panic message, etc. And the data can be retrieved from
core dump file using flight-recorder, which is going to be a
module of the crash utility.

Also if we implement flight-recorder in perf tool, those trace
outputs can be used by perf tool.

---
 include/trace/events/kexec.h |   51 ++++++++++++++++++++++++++++++++++++++++++
 kernel/kexec.c               |    4 +++
 kernel/panic.c               |    4 +++
 3 files changed, 59 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/kexec.h

diff --git a/include/trace/events/kexec.h b/include/trace/events/kexec.h
new file mode 100644
index 0000000..c1d740a
--- /dev/null
+++ b/include/trace/events/kexec.h
@@ -0,0 +1,51 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kexec
+
+#if !defined(_TRACE_KEXEC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KEXEC_H
+
+#include <linux/kexec.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(panic,
+
+	TP_PROTO(const char *msg),
+
+	TP_ARGS(msg),
+
+	TP_STRUCT__entry(
+		__string(	msg,	msg	)
+	),
+
+	TP_fast_assign(
+		__assign_str(msg, msg);
+	),
+
+	TP_printk("%s", __get_str(msg))
+);
+
+TRACE_EVENT(crash_kexec,
+
+	TP_PROTO(struct kimage *image, struct pt_regs *regs),
+
+	TP_ARGS(image, regs),
+
+	TP_STRUCT__entry(
+		__field(	void *,	image	)
+		__field(	void *, ip	)
+	),
+
+	TP_fast_assign(
+		__entry->image	= image;
+		__entry->ip	= regs ?
+			(void *)instruction_pointer(regs) : NULL;
+	),
+
+	TP_printk("image=%p, ip=%p", __entry->image, __entry->ip)
+);
+
+#endif /* _TRACE_KEXEC_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
diff --git a/kernel/kexec.c b/kernel/kexec.c
index f336e21..3d7eda7 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -38,6 +38,8 @@
 #include <asm/system.h>
 #include <asm/sections.h>
 
+#include <trace/events/kexec.h>
+
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t* crash_notes;
 
@@ -1073,6 +1075,8 @@ void crash_kexec(struct pt_regs *regs)
 	if (mutex_trylock(&kexec_mutex)) {
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
+
+			trace_crash_kexec(kexec_crash_image, regs);
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
diff --git a/kernel/panic.c b/kernel/panic.c
index 22ec502..c3baa23 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,9 @@
 #include <linux/nmi.h>
 #include <linux/dmi.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/kexec.h>
+
 int panic_on_oops;
 static unsigned long tainted_mask;
 static int pause_on_oops;
@@ -69,6 +72,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
+	trace_panic(buf);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	dump_stack();
-- 
1.6.3

