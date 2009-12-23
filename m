Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbZLWVVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbZLWVVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbZLWVUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:20:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:45127 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248AbZLWVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:46 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 24/37] kgdboc,kdb: Allow kdb to work on a non open console port
Date: Wed, 23 Dec 2009 15:19:37 -0600
Message-Id: <1261603190-5036-25-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-24-git-send-email-jason.wessel@windriver.com>
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
 <1261603190-5036-17-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-18-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-19-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-20-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-21-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-22-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-23-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-24-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:24.0348 (UTC) FILETIME=[BD9775C0:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kdb is open on a serial port that is not actually a console make
sure to call the poll routines to emit and receive characters.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/kgdboc.c   |   14 ++++++++++++++
 include/linux/kgdb.h      |    3 +++
 kernel/debug/kdb/kdb_io.c |   16 ++++++++++++++++
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index f4066b3..02fbd86 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -16,6 +16,7 @@
 #include <linux/kgdb.h>
 #include <linux/kdb.h>
 #include <linux/tty.h>
+#include <linux/console.h>
 
 #define MAX_CONFIG_LEN		40
 
@@ -72,12 +73,14 @@ static int configure_kgdboc(void)
 	int tty_line = 0;
 	int err;
 	char *cptr = config;
+	struct console *cons;
 
 	err = kgdboc_option_setup(config);
 	if (err || !strlen(config) || isspace(config[0]))
 		goto noconfig;
 
 	err = -ENODEV;
+	kgdboc_io_ops.is_console = 0;
 
 #ifdef CONFIG_KDB_KEYBOARD
 	kgdb_tty_driver = NULL;
@@ -98,6 +101,17 @@ static int configure_kgdboc(void)
 	if (!p)
 		goto noconfig;
 
+	cons = console_drivers;
+	while (cons) {
+		int idx;
+		if (cons->device && cons->device(cons, &idx) == p &&
+		    idx == tty_line) {
+			kgdboc_io_ops.is_console = 1;
+			break;
+		}
+		cons = cons->next;
+	}
+
 	kgdb_tty_driver = p;
 	kgdb_tty_line = tty_line;
 
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index b5de457..619019a 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -234,6 +234,8 @@ struct kgdb_arch {
  * the I/O driver.
  * @post_exception: Pointer to a function that will do any cleanup work
  * for the I/O driver.
+ * @is_console: 1 if the end device is a console 0 if the I/O device is
+ * not a console
  */
 struct kgdb_io {
 	const char		*name;
@@ -243,6 +245,7 @@ struct kgdb_io {
 	int			(*init) (void);
 	void			(*pre_exception) (void);
 	void			(*post_exception) (void);
+	int			is_console;
 };
 
 extern struct kgdb_arch		arch_kgdb_ops;
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index b7b4c4a..17aa1f2 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -671,6 +671,14 @@ kdb_printit:
 	if (!dbg_kdb_mode && kgdb_connected) {
 		gdbstub_msg_write(kdb_buffer, strlen(kdb_buffer));
 	} else {
+		if (!dbg_io_ops->is_console) {
+			len = strlen(kdb_buffer);
+			cp = kdb_buffer;
+			while (len--) {
+				dbg_io_ops->write_char(*cp);
+				cp++;
+			}
+		}
 		while (c) {
 			c->write(c, kdb_buffer, strlen(kdb_buffer));
 			touch_nmi_watchdog();
@@ -717,6 +725,14 @@ kdb_printit:
 		kdb_input_flush();
 		c = console_drivers;
 
+		if (!dbg_io_ops->is_console) {
+			len = strlen(moreprompt);
+			cp = moreprompt;
+			while (len--) {
+				dbg_io_ops->write_char(*cp);
+				cp++;
+			}
+		}
 		while (c) {
 			c->write(c, moreprompt, strlen(moreprompt));
 			touch_nmi_watchdog();
-- 
1.6.4.rc1

