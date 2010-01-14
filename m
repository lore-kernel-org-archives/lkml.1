Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075Ab0ANPJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab0ANPJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723Ab0ANPJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:09:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:47614 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab0ANPAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:00:52 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 15/40] kgdb: gdb "monitor" -> kdb passthrough
Date: Thu, 14 Jan 2010 08:59:11 -0600
Message-Id: <1263481176-1897-16-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:00:33.0694 (UTC) FILETIME=[526423E0:01CA952A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the driving forces behind integrating another front end (kdb)
to the debug core is to allow front end commands to be accessible via
gdb's monitor command.  It is true that you could write gdb macros to
get certain data, but you may want to just use gdb to access the
commands that are available in the kdb front end.

This patch implements the Rcmd gdb stub packet.  In gdb you access
this with the "monitor" command.  For instance you could type "monitor
help", "monitor lsmod" or "monitor ps A" etc...

There is no error checking or command restrictions on what you can and
cannot access at this point.  Doing something like trying to set
breakpoints with the monitor command is going to cause nothing but
problems.  Perhaps in the future only the commands that are actually
known to work with the gdb monitor command will be available.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c      |    2 +-
 kernel/debug/debug_core.h      |    2 ++
 kernel/debug/gdbstub.c         |   22 ++++++++++++++++++++++
 kernel/debug/kdb/kdb_io.c      |   13 +++++++++----
 kernel/debug/kdb/kdb_private.h |    1 -
 5 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 4a90148..1281d1d 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -81,7 +81,7 @@ static int kgdb_use_con;
 int dbg_switch_cpu;
 
 /* Use kdb or gdbserver mode */
-static int dbg_kdb_mode = 1;
+int dbg_kdb_mode = 1;
 
 static int __init opt_kgdb_con(char *str)
 {
diff --git a/kernel/debug/debug_core.h b/kernel/debug/debug_core.h
index cf14dae..7d374c0 100644
--- a/kernel/debug/debug_core.h
+++ b/kernel/debug/debug_core.h
@@ -67,9 +67,11 @@ extern void gdbstub_msg_write(const char *s, int len);
 
 /* gdbstub functions used for kdb <-> gdbstub transition */
 extern int gdbstub_state(struct kgdb_state *ks, char *cmd);
+extern int dbg_kdb_mode;
 
 #ifdef CONFIG_KGDB_KDB
 extern int kdb_stub(struct kgdb_state *ks);
+extern int kdb_parse(const char *cmdstr);
 #else /* ! CONFIG_KGDB_KDB */
 static inline int kdb_stub(struct kgdb_state *ks)
 {
diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 6965b5c..cee2c0e 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -201,6 +201,9 @@ void gdbstub_msg_write(const char *s, int len)
 	int wcount;
 	int i;
 
+	if (len == 0)
+		len = strlen(s);
+
 	/* 'O'utput */
 	gdbmsgbuf[0] = 'O';
 
@@ -690,6 +693,25 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 			kgdb_mem2hex(tmpstr, remcom_out_buffer, strlen(tmpstr));
 		}
 		break;
+#ifdef CONFIG_KGDB_KDB
+	case 'R':
+		if (strncmp(remcom_in_buffer, "qRcmd,", 6) == 0) {
+			int len = strlen(remcom_in_buffer + 6);
+
+			if ((len % 2) != 0) {
+				strcpy(remcom_out_buffer, "E01");
+				break;
+			}
+			kgdb_hex2mem(remcom_in_buffer + 6,
+				     remcom_out_buffer, len);
+			len = len / 2;
+			remcom_out_buffer[len++] = 0;
+
+			kdb_parse(remcom_out_buffer);
+			strcpy(remcom_out_buffer, "OK");
+		}
+		break;
+#endif
 	}
 }
 
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 01fc16d..8fcd22c 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -21,6 +21,7 @@
 #include <linux/smp.h>
 #include <linux/nmi.h>
 #include <linux/delay.h>
+#include <linux/kgdb.h>
 #include <linux/kdb.h>
 #include <linux/kallsyms.h>
 #include "kdb_private.h"
@@ -668,10 +669,14 @@ kdb_printit:
 	 * Write to all consoles.
 	 */
 	retlen = strlen(kdb_buffer);
-	while (c) {
-		c->write(c, kdb_buffer, retlen);
-		touch_nmi_watchdog();
-		c = c->next;
+	if (!dbg_kdb_mode && kgdb_connected) {
+		gdbstub_msg_write(kdb_buffer, retlen);
+	} else {
+		while (c) {
+			c->write(c, kdb_buffer, retlen);
+			touch_nmi_watchdog();
+			c = c->next;
+		}
 	}
 	if (logging) {
 		saved_loglevel = console_loglevel;
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 768655e..2db38ff 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -317,7 +317,6 @@ extern unsigned long kdb_task_state(const struct task_struct *p,
 				    unsigned long mask);
 extern void kdb_ps_suppressed(void);
 extern void kdb_ps1(const struct task_struct *p);
-extern int kdb_parse(const char *cmdstr);
 extern void kdb_print_nameval(const char *name, unsigned long val);
 extern void kdb_send_sig_info(struct task_struct *p,
 			      struct siginfo *info, int seqno);
-- 
1.6.3.1.9.g95405b

