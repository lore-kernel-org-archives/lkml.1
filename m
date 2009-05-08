Return-Path: <linux-kernel-owner+w=401wt.eu-S1762901AbZEHVXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762901AbZEHVXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbZEHVXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:23:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:44749 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbZEHVXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:23:33 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 04/13] RFC ONLY - kgdb: gdb "monitor" -> kdb passthrough
Date: Fri,  8 May 2009 16:23:11 -0500
Message-Id: <1241817800-9320-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241817800-9320-4-git-send-email-jason.wessel@windriver.com>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-2-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-3-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 08 May 2009 21:23:27.0184 (UTC) FILETIME=[39F94500:01C9D023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a RFC patch.  The work to possibly merge kdb and kgdb is being
evaluated and this patch is considered only a proof of concept or
prototype.

One of the driving forces behind integrating another front end to kgdb
is to allow front end commands to be accessible via gdb's monitor
command.  It is true that you could write gdb macros to get certain
data, but you may want to just use gdb to access the commands that are
available in the kdb front end.

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
 include/linux/kgdb.h |    3 ++-
 kdb/kdb_io.c         |   13 +++++++++----
 kernel/kgdb.c        |   28 +++++++++++++++++++++++++---
 3 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 967803d..0299b79 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -279,7 +279,8 @@ extern int
 kgdb_handle_exception(int ex_vector, int signo, int err_code,
 		      struct pt_regs *regs);
 extern int kgdb_nmicallback(int cpu, void *regs);
-
+extern int kgdb_use_passthrough;
+extern void kgdb_msg_write(const char *s, int len);
 extern int			kgdb_single_step;
 extern atomic_t			kgdb_active;
 
diff --git a/kdb/kdb_io.c b/kdb/kdb_io.c
index e7c3b40..d00f05c 100644
--- a/kdb/kdb_io.c
+++ b/kdb/kdb_io.c
@@ -24,6 +24,7 @@
 #include <linux/kdb.h>
 #include <linux/kdbprivate.h>
 #include <linux/kallsyms.h>
+#include <linux/kgdb.h>
 
 static struct console *kdbcons;
 
@@ -698,10 +699,14 @@ kdb_printit:
 	else
 #endif
 
-	while (c) {
-		c->write(c, kdb_buffer, strlen(kdb_buffer));
-		touch_nmi_watchdog();
-		c = c->next;
+	if (!kgdb_use_passthrough && kgdb_connected) {
+		kgdb_msg_write(kdb_buffer, strlen(kdb_buffer));
+	} else {
+		while (c) {
+			c->write(c, kdb_buffer, strlen(kdb_buffer));
+			touch_nmi_watchdog();
+			c = c->next;
+		}
 	}
 	if (logging) {
 		saved_loglevel = console_loglevel;
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 2f093bc..484f106 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -100,9 +100,9 @@ static int kgdb_use_con;
 
 /* Controls for using the kgdb passthrough */
 #ifdef CONFIG_KGDB_KDB_PRIMARY
-static int kgdb_use_passthrough = 1;
+int kgdb_use_passthrough = 1;
 #else /* ! CONFIG_KGDB_KDB_PRIMARY */
-static int kgdb_use_passthrough;
+int kgdb_use_passthrough;
 #endif /* CONFIG_KGDB_KDB_PRIMARY */
 #define KGDB_PASS_EVENT -12345
 
@@ -963,12 +963,15 @@ static inline int shadow_pid(int realpid)
 
 static char gdbmsgbuf[BUFMAX + 1];
 
-static void kgdb_msg_write(const char *s, int len)
+void kgdb_msg_write(const char *s, int len)
 {
 	char *bufptr;
 	int wcount;
 	int i;
 
+	if (len == 0)
+		len = strlen(s);
+
 	/* 'O'utput */
 	gdbmsgbuf[0] = 'O';
 
@@ -1270,6 +1273,25 @@ static void gdb_cmd_query(struct kgdb_state *ks)
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
 
-- 
1.6.3.rc0.1.gf800

