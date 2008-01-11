Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbYAKJRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbYAKJRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757002AbYAKJRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:17:21 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:32425
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756982AbYAKJRU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:17:20 -0500
Message-Id: <47874243.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 11 Jan 2008 09:17:39 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [PATCH] make .tracedata a normal part of RODATA()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. allowing it to be write-protected just as other read-only data
under CONFIG_DEBUG_RODATA.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/kernel/vmlinux_32.lds.S  |    7 -------
 arch/x86/kernel/vmlinux_64.lds.S  |    7 -------
 drivers/base/power/trace.c        |    2 +-
 include/asm-generic/vmlinux.lds.h |   14 ++++++++++++++
 include/asm-x86/resume-trace_32.h |    2 +-
 include/asm-x86/resume-trace_64.h |    4 ++--
 include/linux/resume-trace.h      |    2 +-
 7 files changed, 19 insertions(+), 19 deletions(-)

--- linux-2.6.24-rc7/arch/x86/kernel/vmlinux_32.lds.S	2008-01-10 16:53:55.000000000 +0100
+++ 2.6.24-rc7-resume-trace-rodata/arch/x86/kernel/vmlinux_32.lds.S	2007-12-18 16:36:00.000000000 +0100
@@ -64,13 +64,6 @@ SECTIONS
 
   BUG_TABLE :text
 
-  . = ALIGN(4);
-  .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
-  	__tracedata_start = .;
-	*(.tracedata)
-  	__tracedata_end = .;
-  }
-
   RODATA
 
   /* writeable */
--- linux-2.6.24-rc7/arch/x86/kernel/vmlinux_64.lds.S	2008-01-10 16:53:55.000000000 +0100
+++ 2.6.24-rc7-resume-trace-rodata/arch/x86/kernel/vmlinux_64.lds.S	2007-12-20 16:08:56.000000000 +0100
@@ -54,13 +54,6 @@ SECTIONS
 
   RODATA
 
-  . = ALIGN(4);
-  .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
-  	__tracedata_start = .;
-	*(.tracedata)
-  	__tracedata_end = .;
-  }
-
   . = ALIGN(PAGE_SIZE);        /* Align data segment to page size boundary */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
--- linux-2.6.24-rc7/drivers/base/power/trace.c	2008-01-10 16:54:00.000000000 +0100
+++ 2.6.24-rc7-resume-trace-rodata/drivers/base/power/trace.c	2007-12-18 16:30:48.000000000 +0100
@@ -153,7 +153,7 @@ EXPORT_SYMBOL(set_trace_device);
  * it's not any guarantee, but it's a high _likelihood_ that
  * the match is valid).
  */
-void generate_resume_trace(void *tracedata, unsigned int user)
+void generate_resume_trace(const void *tracedata, unsigned int user)
 {
 	unsigned short lineno = *(unsigned short *)tracedata;
 	const char *file = *(const char **)(tracedata + 2);
--- linux-2.6.24-rc7/include/asm-generic/vmlinux.lds.h	2008-01-10 16:55:01.000000000 +0100
+++ 2.6.24-rc7-resume-trace-rodata/include/asm-generic/vmlinux.lds.h	2007-12-19 12:31:00.000000000 +0100
@@ -57,6 +57,8 @@
 		VMLINUX_SYMBOL(__end_rio_route_ops) = .;		\
 	}								\
 									\
+	TRACEDATA							\
+									\
 	/* Kernel symbol table: Normal symbols */			\
 	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
@@ -229,6 +231,18 @@
 		__stop___bug_table = .;					\
 	}
 
+#ifdef CONFIG_PM_TRACE
+#define TRACEDATA							\
+	. = ALIGN(4);							\
+	.tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {		\
+	  	__tracedata_start = .;					\
+		*(.tracedata)						\
+	  	__tracedata_end = .;					\
+	}
+#else
+#define TRACEDATA
+#endif
+
 #define NOTES								\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__start_notes) = .;			\
--- linux-2.6.24-rc7/include/asm-x86/resume-trace_32.h	2008-01-10 16:55:10.000000000 +0100
+++ 2.6.24-rc7-resume-trace-rodata/include/asm-x86/resume-trace_32.h	2007-12-18 16:31:48.000000000 +0100
@@ -1,6 +1,6 @@
 #define TRACE_RESUME(user) do {					\
 	if (pm_trace_enabled) {					\
-		void *tracedata;				\
+		const void *tracedata;				\
 		asm volatile("movl $1f,%0\n"			\
 			".section .tracedata,\"a\"\n"		\
 			"1:\t.word %c1\n"			\
--- linux-2.6.24-rc7/include/asm-x86/resume-trace_64.h	2008-01-10 16:55:10.000000000 +0100
+++ 2.6.24-rc7-resume-trace-rodata/include/asm-x86/resume-trace_64.h	2007-12-19 12:00:47.000000000 +0100
@@ -1,7 +1,7 @@
 #define TRACE_RESUME(user) do {					\
 	if (pm_trace_enabled) {					\
-		void *tracedata;				\
-		asm volatile("movq $1f,%0\n"			\
+		const void *tracedata;				\
+		asm volatile("leaq 1f(%rip),%0\n"		\
 			".section .tracedata,\"a\"\n"		\
 			"1:\t.word %c1\n"			\
 			"\t.quad %c2\n"				\
--- linux-2.6.24-rc7/include/linux/resume-trace.h	2007-10-09 22:31:38.000000000 +0200
+++ 2.6.24-rc7-resume-trace-rodata/include/linux/resume-trace.h	2007-12-18 16:31:30.000000000 +0100
@@ -8,7 +8,7 @@ extern int pm_trace_enabled;
 
 struct device;
 extern void set_trace_device(struct device *);
-extern void generate_resume_trace(void *tracedata, unsigned int user);
+extern void generate_resume_trace(const void *tracedata, unsigned int user);
 
 #define TRACE_DEVICE(dev) do { \
 	if (pm_trace_enabled) \


