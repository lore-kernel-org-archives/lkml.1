Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbZLWV1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbZLWV1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZLWV1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:27:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:45080 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbZLWVUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:34 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 16/37] kgdb: gdb "monitor" -> kdb passthrough
Date: Wed, 23 Dec 2009 15:19:29 -0600
Message-Id: <1261603190-5036-17-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-13-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:15.0692 (UTC) FILETIME=[B86EA8C0:01CA8415]
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
index f146ac8..502e488 100644
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
index d8f7158..cbd41ec 100644
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
index aef5351..b7b4c4a 100644
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
@@ -667,10 +668,14 @@ kdb_printit:
 	/*
 	 * Write to all consoles.
 	 */
-	while (c) {
-		c->write(c, kdb_buffer, strlen(kdb_buffer));
-		touch_nmi_watchdog();
-		c = c->next;
+	if (!dbg_kdb_mode && kgdb_connected) {
+		gdbstub_msg_write(kdb_buffer, strlen(kdb_buffer));
+	} else {
+		while (c) {
+			c->write(c, kdb_buffer, strlen(kdb_buffer));
+			touch_nmi_watchdog();
+			c = c->next;
+		}
 	}
 	if (logging) {
 		saved_loglevel = console_loglevel;
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index f578a40..85bc8e4 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -349,7 +349,6 @@ extern unsigned long kdb_task_state(const struct task_struct *p,
 				    unsigned long mask);
 extern void kdb_ps_suppressed(void);
 extern void kdb_ps1(const struct task_struct *p);
-extern int kdb_parse(const char *cmdstr);
 extern void kdb_print_nameval(const char *name, unsigned long val);
 extern void kdb_send_sig_info(struct task_struct *p,
 			      struct siginfo *info, int seqno);
-- 
1.6.4.rc1

