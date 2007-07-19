Return-Path: <linux-kernel-owner+w=401wt.eu-S933129AbXGSK0C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129AbXGSK0C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:26:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXGSJ4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:56:13 -0400
Received: from mail.suse.de ([195.135.220.2]:35451 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbXGSJzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:48 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: nigel@nigel.suspend2.net, rdunlap@xenotime.net, ak@suse.de, rjw@sisk.pl,
       pavel@ucw.cz, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [53/58] x86: PM_TRACE support
Message-Id: <20070719095540.4B0F214DFC@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Nigel Cunningham <nigel@nigel.suspend2.net>

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andi Kleen <ak@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/vmlinux.lds.S  |    7 +++++++
 drivers/base/power/trace.c        |    5 ++++-
 include/asm-i386/resume-trace.h   |   13 +++++++++++++
 include/asm-x86_64/resume-trace.h |   13 +++++++++++++
 include/linux/resume-trace.h      |   19 +++++--------------
 kernel/power/Kconfig              |    2 +-
 6 files changed, 43 insertions(+), 16 deletions(-)

Index: linux/arch/x86_64/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/x86_64/kernel/vmlinux.lds.S
+++ linux/arch/x86_64/kernel/vmlinux.lds.S
@@ -52,6 +52,13 @@ SECTIONS
 
   RODATA
 
+  . = ALIGN(4);
+  .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
+  	__tracedata_start = .;
+	*(.tracedata)
+  	__tracedata_end = .;
+  }
+
   . = ALIGN(PAGE_SIZE);        /* Align data segment to page size boundary */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
Index: linux/drivers/base/power/trace.c
===================================================================
--- linux.orig/drivers/base/power/trace.c
+++ linux/drivers/base/power/trace.c
@@ -142,6 +142,7 @@ void set_trace_device(struct device *dev
 {
 	dev_hash_value = hash_string(DEVSEED, dev->bus_id, DEVHASH);
 }
+EXPORT_SYMBOL(set_trace_device);
 
 /*
  * We could just take the "tracedata" index into the .tracedata
@@ -162,6 +163,7 @@ void generate_resume_trace(void *traceda
 	file_hash_value = hash_string(lineno, file, FILEHASH);
 	set_magic_time(user_hash_value, file_hash_value, dev_hash_value);
 }
+EXPORT_SYMBOL(generate_resume_trace);
 
 extern char __tracedata_start, __tracedata_end;
 static int show_file_hash(unsigned int value)
@@ -170,7 +172,8 @@ static int show_file_hash(unsigned int v
 	char *tracedata;
 
 	match = 0;
-	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ; tracedata += 6) {
+	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ;
+			tracedata += 2 + sizeof(unsigned long)) {
 		unsigned short lineno = *(unsigned short *)tracedata;
 		const char *file = *(const char **)(tracedata + 2);
 		unsigned int hash = hash_string(lineno, file, FILEHASH);
Index: linux/include/asm-i386/resume-trace.h
===================================================================
--- /dev/null
+++ linux/include/asm-i386/resume-trace.h
@@ -0,0 +1,13 @@
+#define TRACE_RESUME(user) do {					\
+	if (pm_trace_enabled) {					\
+		void *tracedata;				\
+		asm volatile("movl $1f,%0\n"			\
+			".section .tracedata,\"a\"\n"		\
+			"1:\t.word %c1\n"			\
+			"\t.long %c2\n"				\
+			".previous"				\
+			:"=r" (tracedata)			\
+			: "i" (__LINE__), "i" (__FILE__));	\
+		generate_resume_trace(tracedata, user);		\
+	}							\
+} while (0)
Index: linux/include/asm-x86_64/resume-trace.h
===================================================================
--- /dev/null
+++ linux/include/asm-x86_64/resume-trace.h
@@ -0,0 +1,13 @@
+#define TRACE_RESUME(user) do {					\
+	if (pm_trace_enabled) {					\
+		void *tracedata;				\
+		asm volatile("movq $1f,%0\n"			\
+			".section .tracedata,\"a\"\n"		\
+			"1:\t.word %c1\n"			\
+			"\t.quad %c2\n"				\
+			".previous"				\
+			:"=r" (tracedata)			\
+			: "i" (__LINE__), "i" (__FILE__));	\
+		generate_resume_trace(tracedata, user);		\
+	}							\
+} while (0)
Index: linux/include/linux/resume-trace.h
===================================================================
--- linux.orig/include/linux/resume-trace.h
+++ linux/include/linux/resume-trace.h
@@ -2,6 +2,7 @@
 #define RESUME_TRACE_H
 
 #ifdef CONFIG_PM_TRACE
+#include <asm/resume-trace.h>
 
 extern int pm_trace_enabled;
 
@@ -9,20 +10,10 @@ struct device;
 extern void set_trace_device(struct device *);
 extern void generate_resume_trace(void *tracedata, unsigned int user);
 
-#define TRACE_DEVICE(dev) set_trace_device(dev)
-#define TRACE_RESUME(user) do {					\
-	if (pm_trace_enabled) {					\
-		void *tracedata;				\
-		asm volatile("movl $1f,%0\n"			\
-			".section .tracedata,\"a\"\n"		\
-			"1:\t.word %c1\n"			\
-			"\t.long %c2\n"				\
-			".previous"				\
-			:"=r" (tracedata)			\
-			: "i" (__LINE__), "i" (__FILE__));	\
-		generate_resume_trace(tracedata, user);		\
-	}							\
-} while (0)
+#define TRACE_DEVICE(dev) do { \
+	if (pm_trace_enabled) \
+		set_trace_device(dev); \
+	} while(0)
 
 #else
 
Index: linux/kernel/power/Kconfig
===================================================================
--- linux.orig/kernel/power/Kconfig
+++ linux/kernel/power/Kconfig
@@ -50,7 +50,7 @@ config DISABLE_CONSOLE_SUSPEND
 
 config PM_TRACE
 	bool "Suspend/resume event tracing"
-	depends on PM && PM_DEBUG && X86_32 && EXPERIMENTAL
+	depends on PM && PM_DEBUG && X86 && EXPERIMENTAL
 	default n
 	---help---
 	This enables some cheesy code to save the last PM event point in the
