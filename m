Return-Path: <linux-kernel-owner+w=401wt.eu-S1422887AbXBHCIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422887AbXBHCIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 21:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422873AbXBHCIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 21:08:13 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:48478 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422887AbXBHCIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 21:08:12 -0500
Subject: Re: [PATCH] Add PM_TRACE x86_64 support.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Otavio Salvador <otavio@debian.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87lkj9bg67.fsf@neumann.lab.ossystems.com.br>
References: <1170895857.4451.55.camel@nigel.suspend2.net>
	 <87lkj9bg67.fsf@neumann.lab.ossystems.com.br>
Content-Type: text/plain
Date: Thu, 08 Feb 2007 13:08:06 +1100
Message-Id: <1170900487.4451.62.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 23:18 -0200, Otavio Salvador wrote:
> Nigel Cunningham <nigel@nigel.suspend2.net> writes:
> 
> > -	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ; tracedata += 6) {
> > +	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ; tracedata += 2 + sizeof(unsigned long)) {
> 
> Could you split this line?

Sure.

-- New version -- (What's the right way to do this?)

This patch add x86_64 support for PM_TRACE, and shifts per-arch code to
the appropriate subdirectories.

Symbol exports are added so tracing can be used from drivers built as
modules too.

Please apply.

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>

 arch/x86_64/kernel/vmlinux.lds.S  |    7 +++++++
 drivers/base/power/trace.c        |    5 ++++-
 include/asm-i386/resume-trace.h   |   21 +++++++++++++++++++++
 include/asm-x86_64/resume-trace.h |   21 +++++++++++++++++++++
 include/linux/resume-trace.h      |   24 ++++++------------------
 kernel/power/Kconfig              |    2 +-
 6 files changed, 60 insertions(+), 20 deletions(-)
diff -ruNp 160-PM_TRACE.patch-old/arch/x86_64/kernel/vmlinux.lds.S 160-PM_TRACE.patch-new/arch/x86_64/kernel/vmlinux.lds.S
--- 160-PM_TRACE.patch-old/arch/x86_64/kernel/vmlinux.lds.S	2007-02-08 13:05:09.000000000 +1100
+++ 160-PM_TRACE.patch-new/arch/x86_64/kernel/vmlinux.lds.S	2007-02-07 23:32:23.000000000 +1100
@@ -54,6 +54,13 @@ SECTIONS
 
   BUG_TABLE
 
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
diff -ruNp 160-PM_TRACE.patch-old/drivers/base/power/trace.c 160-PM_TRACE.patch-new/drivers/base/power/trace.c
--- 160-PM_TRACE.patch-old/drivers/base/power/trace.c	2007-02-06 14:48:31.000000000 +1100
+++ 160-PM_TRACE.patch-new/drivers/base/power/trace.c	2007-02-08 13:04:51.000000000 +1100
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
diff -ruNp 160-PM_TRACE.patch-old/include/asm-i386/resume-trace.h 160-PM_TRACE.patch-new/include/asm-i386/resume-trace.h
--- 160-PM_TRACE.patch-old/include/asm-i386/resume-trace.h	1970-01-01 10:00:00.000000000 +1000
+++ 160-PM_TRACE.patch-new/include/asm-i386/resume-trace.h	2007-02-07 23:32:23.000000000 +1100
@@ -0,0 +1,21 @@
+#ifndef ARCH_RESUME_TRACE_H
+#define ARCH_RESUME_TRACE_H
+
+#ifdef CONFIG_PM_TRACE
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
+#else
+#define TRACE_RESUME(user) do { } while (0)
+#endif
+#endif
diff -ruNp 160-PM_TRACE.patch-old/include/asm-x86_64/resume-trace.h 160-PM_TRACE.patch-new/include/asm-x86_64/resume-trace.h
--- 160-PM_TRACE.patch-old/include/asm-x86_64/resume-trace.h	1970-01-01 10:00:00.000000000 +1000
+++ 160-PM_TRACE.patch-new/include/asm-x86_64/resume-trace.h	2007-02-07 23:32:23.000000000 +1100
@@ -0,0 +1,21 @@
+#ifndef ARCH_RESUME_TRACE_H
+#define ARCH_RESUME_TRACE_H
+
+#ifdef CONFIG_PM_TRACE
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
+#else
+#define TRACE_RESUME(user) do { } while (0)
+#endif
+#endif
diff -ruNp 160-PM_TRACE.patch-old/include/linux/resume-trace.h 160-PM_TRACE.patch-new/include/linux/resume-trace.h
--- 160-PM_TRACE.patch-old/include/linux/resume-trace.h	2007-02-06 14:48:57.000000000 +1100
+++ 160-PM_TRACE.patch-new/include/linux/resume-trace.h	2007-02-07 23:32:23.000000000 +1100
@@ -1,6 +1,8 @@
 #ifndef RESUME_TRACE_H
 #define RESUME_TRACE_H
 
+#include <asm/resume-trace.h>
+
 #ifdef CONFIG_PM_TRACE
 
 extern int pm_trace_enabled;
@@ -9,26 +11,12 @@ struct device;
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
-
+#define TRACE_DEVICE(dev) do { \
+	if (pm_trace_enabled) \
+		set_trace_device(dev); \
+	} while(0)
 #else
-
 #define TRACE_DEVICE(dev) do { } while (0)
-#define TRACE_RESUME(dev) do { } while (0)
-
 #endif
 
 #endif
diff -ruNp 160-PM_TRACE.patch-old/kernel/power/Kconfig 160-PM_TRACE.patch-new/kernel/power/Kconfig
--- 160-PM_TRACE.patch-old/kernel/power/Kconfig	2007-02-06 14:48:57.000000000 +1100
+++ 160-PM_TRACE.patch-new/kernel/power/Kconfig	2007-02-08 13:05:42.000000000 +1100
@@ -50,7 +50,7 @@ config DISABLE_CONSOLE_SUSPEND
 
 config PM_TRACE
 	bool "Suspend/resume event tracing"
-	depends on PM && PM_DEBUG && X86_32 && EXPERIMENTAL
+	depends on PM && PM_DEBUG && X86 && EXPERIMENTAL
 	default n
 	---help---
 	This enables some cheesy code to save the last PM event point in the


