Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbXEXBEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbXEXBEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbXEXBD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:03:59 -0400
Received: from critter.phunnypharm.org ([67.97.251.11]:2376 "EHLO critter"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755212AbXEXBD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:03:59 -0400
To: linux-kernel@vger.kernel.org
Message-Id: <b31c080.git.bcollins@ubuntu.com>
In-Reply-To: <98cd38b5.git.bcollins@ubuntu.com>
From: Ben Collins <bcollins@ubuntu.com>
Date: Wed, 23 May 2007 17:59:10 -0400
Subject: [PATCH 1/6] i386/x86_64: Allow disabling the putstr's from compressed boot wrapper
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
---
 arch/i386/Kconfig.debug            |    6 ++++++
 arch/i386/boot/compressed/misc.c   |    8 +++++---
 arch/x86_64/Kconfig.debug          |    6 ++++++
 arch/x86_64/boot/compressed/misc.c |    8 +++++---
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/i386/Kconfig.debug b/arch/i386/Kconfig.debug
index b31c080..eb26441 100644
--- a/arch/i386/Kconfig.debug
+++ b/arch/i386/Kconfig.debug
@@ -19,6 +19,12 @@ config EARLY_PRINTK
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash.
 
+config WRAPPER_PRINT
+	bool "Boot wrapper print" if EMBEDDED
+	default y
+	help
+	  Enable informational output from the bootwrapper (bzImage and zImage).
+
 config DEBUG_STACKOVERFLOW
 	bool "Check for stack overflows"
 	depends on DEBUG_KERNEL
diff --git a/arch/i386/boot/compressed/misc.c b/arch/i386/boot/compressed/misc.c
index b28505c..cc630d5 100644
--- a/arch/i386/boot/compressed/misc.c
+++ b/arch/i386/boot/compressed/misc.c
@@ -184,8 +184,6 @@ static void free(void *where);
 static void *memset(void *s, int c, unsigned n);
 static void *memcpy(void *dest, const void *src, unsigned n);
 
-static void putstr(const char *);
-
 static unsigned long free_mem_ptr;
 static unsigned long free_mem_end_ptr;
 
@@ -232,7 +230,8 @@ static void gzip_release(void **ptr)
 {
 	free_mem_ptr = (unsigned long) *ptr;
 }
- 
+
+#ifdef CONFIG_WRAPPER_PRINT 
 static void scroll(void)
 {
 	int i;
@@ -278,6 +277,9 @@ static void putstr(const char *s)
 	outb_p(15, vidport);
 	outb_p(0xff & (pos >> 1), vidport+1);
 }
+#else
+#define putstr(__x) do{}while(0)
+#endif /* CONFIG_WRAPPER_PRINT */
 
 static void* memset(void* s, int c, unsigned n)
 {
diff --git a/arch/x86_64/Kconfig.debug b/arch/x86_64/Kconfig.debug
index 775d211..a1b87b8 100644
--- a/arch/x86_64/Kconfig.debug
+++ b/arch/x86_64/Kconfig.debug
@@ -6,6 +6,12 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
+config WRAPPER_PRINT
+	bool "Boot wrapper print" if EMBEDDED
+	default y
+	help
+	  Enable informational output from the bootwrapper (bzImage and zImage).
+
 config DEBUG_RODATA
        bool "Write protect kernel read-only data structures"
        depends on DEBUG_KERNEL
diff --git a/arch/x86_64/boot/compressed/misc.c b/arch/x86_64/boot/compressed/misc.c
index f932b0e..43bb44c 100644
--- a/arch/x86_64/boot/compressed/misc.c
+++ b/arch/x86_64/boot/compressed/misc.c
@@ -184,8 +184,6 @@ static void free(void *where);
 static void *memset(void *s, int c, unsigned n);
 static void *memcpy(void *dest, const void *src, unsigned n);
 
-static void putstr(const char *);
-
 static long free_mem_ptr;
 static long free_mem_end_ptr;
 
@@ -228,7 +226,8 @@ static void gzip_release(void **ptr)
 {
 	free_mem_ptr = (long) *ptr;
 }
- 
+
+#ifdef CONFIG_WRAPPER_PRINT 
 static void scroll(void)
 {
 	int i;
@@ -274,6 +273,9 @@ static void putstr(const char *s)
 	outb_p(15, vidport);
 	outb_p(0xff & (pos >> 1), vidport+1);
 }
+#else
+#define putstr(__x) do{}while(0)
+#endif /* CONFIG_WRAPPER_PRINT */
 
 static void* memset(void* s, int c, unsigned n)
 {
-- 
1.5.1.4

