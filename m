Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab0BYPjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:39:22 -0500
Received: from mail-px0-f204.google.com ([209.85.216.204]:59967 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759385Ab0BYPjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:39:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UBJaqXiynUM8gmZMEZ8MD/0ap+ha32O0Hy/Nhq0fcoPcaTfFtEIKtQp0HWuFdGn+qN
         DjNSxX3kE8wFHLfyy9eV+SaLRhjXXfMDCxXynTorIx1RKsny1PD9KyKX14Ca2hGR8FVU
         SIc/CRVs1OZQ7cEpMOqAcd7TvAEh450zb3GQk=
Date: Thu, 25 Feb 2010 23:39:11 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/07] kernel.h panic cleanup
Message-ID: <20100225153911.GA2661@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup kernel.h panic related stuff, move to linux/panic.h 

Due to lots of files need it, include them in kernel.h just for convinience
It can be thought as the first step of further cleanup. 

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/kernel.h |   29 +----------------------------
 include/linux/panic.h  |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 28 deletions(-)

--- linux-2.6.orig/include/linux/kernel.h	2010-02-25 20:43:08.000000000 +0800
+++ linux-2.6/include/linux/kernel.h	2010-02-25 20:45:26.000000000 +0800
@@ -14,6 +14,7 @@
 #include <linux/log2.h>
 #include <linux/typecheck.h>
 #include <linux/printk.h>
+#include <linux/panic.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -131,13 +132,6 @@ static inline void might_fault(void)
 }
 #endif
 
-extern struct atomic_notifier_head panic_notifier_list;
-extern long (*panic_blink)(long time);
-NORET_TYPE void panic(const char * fmt, ...)
-	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
-extern void oops_enter(void);
-extern void oops_exit(void);
-extern int oops_may_print(void);
 NORET_TYPE void do_exit(long error_code)
 	ATTRIB_NORET;
 NORET_TYPE void complete_and_exit(struct completion *, long)
@@ -186,15 +180,6 @@ extern struct pid *session_of_pgrp(struc
 unsigned long int_sqrt(unsigned long);
 
 extern void bust_spinlocks(int yes);
-extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
-extern int panic_timeout;
-extern int panic_on_oops;
-extern int panic_on_unrecovered_nmi;
-extern int panic_on_io_nmi;
-extern const char *print_tainted(void);
-extern void add_taint(unsigned flag);
-extern int test_taint(unsigned flag);
-extern unsigned long get_taint(void);
 extern int root_mountflags;
 
 /* Values used for system_state */
@@ -207,18 +192,6 @@ extern enum system_states {
 	SYSTEM_SUSPEND_DISK,
 } system_state;
 
-#define TAINT_PROPRIETARY_MODULE	0
-#define TAINT_FORCED_MODULE		1
-#define TAINT_UNSAFE_SMP		2
-#define TAINT_FORCED_RMMOD		3
-#define TAINT_MACHINE_CHECK		4
-#define TAINT_BAD_PAGE			5
-#define TAINT_USER			6
-#define TAINT_DIE			7
-#define TAINT_OVERRIDDEN_ACPI_TABLE	8
-#define TAINT_WARN			9
-#define TAINT_CRAP			10
-
 extern void dump_stack(void) __cold;
 
 enum {
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/linux/panic.h	2010-02-25 20:45:55.000000000 +0800
@@ -0,0 +1,34 @@
+#ifndef _PANIC_H
+#define _PANIC_H
+
+#include <linux/linkage.h>
+#define TAINT_PROPRIETARY_MODULE	0
+#define TAINT_FORCED_MODULE		1
+#define TAINT_UNSAFE_SMP		2
+#define TAINT_FORCED_RMMOD		3
+#define TAINT_MACHINE_CHECK		4
+#define TAINT_BAD_PAGE			5
+#define TAINT_USER			6
+#define TAINT_DIE			7
+#define TAINT_OVERRIDDEN_ACPI_TABLE	8
+#define TAINT_WARN			9
+#define TAINT_CRAP			10
+
+extern struct atomic_notifier_head panic_notifier_list;
+extern long (*panic_blink)(long time);
+NORET_TYPE void panic(const char *fmt, ...)
+	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+extern void oops_enter(void);
+extern void oops_exit(void);
+extern int oops_may_print(void);
+/* If set, an oops, panic(), BUG() or die() is in progress */
+extern int oops_in_progress;
+extern int panic_timeout;
+extern int panic_on_oops;
+extern int panic_on_unrecovered_nmi;
+extern int panic_on_io_nmi;
+extern const char *print_tainted(void);
+extern void add_taint(unsigned flag);
+extern int test_taint(unsigned flag);
+extern unsigned long get_taint(void);
+#endif
