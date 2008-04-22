Return-Path: <linux-kernel-owner+w=401wt.eu-S933951AbYDVPZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951AbYDVPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbYDVPZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:25:06 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16082 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbYDVPZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:25:04 -0400
Message-Id: <480E1F7C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:25:16 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: move tracedata to RODATA
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

---
 arch/x86/kernel/vmlinux_32.lds.S  |    7 -------
 arch/x86/kernel/vmlinux_64.lds.S  |    7 -------
 drivers/base/power/trace.c        |    2 +-
 include/asm-generic/vmlinux.lds.h |   14 ++++++++++++++
 include/asm-x86/resume-trace.h    |    2 +-
 include/linux/resume-trace.h      |    2 +-
 6 files changed, 17 insertions(+), 17 deletions(-)

--- linux-2.6.25/arch/x86/kernel/vmlinux_32.lds.S	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-resume-trace-rodata/arch/x86/kernel/vmlinux_32.lds.S	2008-03-04 11:12:20.000000000 +0100
@@ -60,13 +60,6 @@ SECTIONS
 
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
--- linux-2.6.25/arch/x86/kernel/vmlinux_64.lds.S	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-resume-trace-rodata/arch/x86/kernel/vmlinux_64.lds.S	2008-03-04 11:13:30.000000000 +0100
@@ -53,13 +53,6 @@ SECTIONS
 
   RODATA
 
-  . = ALIGN(4);
-  .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
-  	__tracedata_start = .;
-	*(.tracedata)
-  	__tracedata_end = .;
-  }
-
   . = ALIGN(PAGE_SIZE);		/* Align data segment to page size boundary */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
--- linux-2.6.25/drivers/base/power/trace.c	2008-01-24 23:58:37.000000000 +0100
+++ 2.6.25-resume-trace-rodata/drivers/base/power/trace.c	2008-03-04 11:12:20.000000000 +0100
@@ -153,7 +153,7 @@ EXPORT_SYMBOL(set_trace_device);
  * it's not any guarantee, but it's a high _likelihood_ that
  * the match is valid).
  */
-void generate_resume_trace(void *tracedata, unsigned int user)
+void generate_resume_trace(const void *tracedata, unsigned int user)
 {
 	unsigned short lineno = *(unsigned short *)tracedata;
 	const char *file = *(const char **)(tracedata + 2);
--- linux-2.6.25/include/asm-generic/vmlinux.lds.h	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-resume-trace-rodata/include/asm-generic/vmlinux.lds.h	2008-03-04 11:12:20.000000000 +0100
@@ -93,6 +93,8 @@
 		VMLINUX_SYMBOL(__end_rio_route_ops) = .;		\
 	}								\
 									\
+	TRACEDATA							\
+									\
 	/* Kernel symbol table: Normal symbols */			\
 	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
@@ -318,6 +320,18 @@
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
--- linux-2.6.25/include/asm-x86/resume-trace.h	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-resume-trace-rodata/include/asm-x86/resume-trace.h	2008-03-04 11:14:02.000000000 +0100
@@ -5,7 +5,7 @@
 
 #define TRACE_RESUME(user) do {					\
 	if (pm_trace_enabled) {					\
-		void *tracedata;				\
+		const void *tracedata;				\
 		asm volatile(_ASM_MOV_UL " $1f,%0\n"		\
 			".section .tracedata,\"a\"\n"		\
 			"1:\t.word %c1\n\t"			\
--- linux-2.6.25/include/linux/resume-trace.h	2007-10-09 22:31:38.000000000 +0200
+++ 2.6.25-resume-trace-rodata/include/linux/resume-trace.h	2008-03-04 11:12:20.000000000 +0100
@@ -8,7 +8,7 @@ extern int pm_trace_enabled;
 
 struct device;
 extern void set_trace_device(struct device *);
-extern void generate_resume_trace(void *tracedata, unsigned int user);
+extern void generate_resume_trace(const void *tracedata, unsigned int user);
 
 #define TRACE_DEVICE(dev) do { \
 	if (pm_trace_enabled) \



