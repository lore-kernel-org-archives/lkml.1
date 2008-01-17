Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYAQNtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYAQNtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYAQNtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:49:36 -0500
Received: from gecko.sbs.de ([194.138.37.40]:22694 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbYAQNtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:49:35 -0500
Message-ID: <478F5CEB.8030400@siemens.com>
Date: Thu, 17 Jan 2008 14:49:31 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] kgdb: late kgdb console registration
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KGDB allows to direct the console output also to the gdb frontend. But
if you switch on CONFIG_KGDB_CONSOLE blindly, you end up without a
suitable initial console for init, causing a boot panic (like I faced:
http://lkml.org/lkml/2008/1/14/284). One workaround is to explicitly
provide the first console in the kernel command line.

This patch implements a less error-prone approach by registering the
console in kgdb_internal_init(). Before that point, it is unusable
anyway due to the debugger not being attached.

Note that this patch also fully initializes the non-static kgdbcons
struct - not needed if we were able to kill its only external
reference by PXA_CONSOLE (see related posting). If non-static remains
necessary, I can also split up this patch into two.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

---
 kernel/kgdb.c |   61 ++++++++++++++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

Index: b/kernel/kgdb.c
===================================================================
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1614,6 +1614,34 @@ static struct notifier_block kgdb_panic_
 	.notifier_call = kgdb_panic_notify,
 };
 
+#ifdef CONFIG_KGDB_CONSOLE
+void kgdb_console_write(struct console *co, const char *s, unsigned count)
+{
+	unsigned long flags;
+
+	/* If we're debugging, or KGDB has not connected, don't try
+	 * and print. */
+	if (!kgdb_connected || atomic_read(&debugger_active) != 0)
+		return;
+
+	local_irq_save(flags);
+	kgdb_msg_write(s, count);
+	local_irq_restore(flags);
+}
+
+struct console kgdbcons = {
+	.name = "kgdb",
+	.write = kgdb_console_write,
+	.flags = CON_PRINTBUFFER | CON_ENABLED,
+	.index = -1,
+	.read = NULL,
+	.device = NULL,
+	.unblank = NULL,
+	.early_setup = NULL,
+	.setup = NULL,
+};
+#endif
+
 /*
  * Initialization that needs to be done in either of our entry points.
  */
@@ -1634,6 +1662,10 @@ static void __init kgdb_internal_init(vo
 	/* We can't do much if this fails */
 	register_module_notifier(&kgdb_module_load_nb);
 
+#ifdef CONFIG_KGDB_CONSOLE
+	register_console(&kgdbcons);
+#endif
+
 	kgdb_initialized = 1;
 }
 
@@ -1943,35 +1975,6 @@ static int kgdb_notify_reboot(struct not
 	return NOTIFY_DONE;
 }
 
-#ifdef CONFIG_KGDB_CONSOLE
-void kgdb_console_write(struct console *co, const char *s, unsigned count)
-{
-	unsigned long flags;
-
-	/* If we're debugging, or KGDB has not connected, don't try
-	 * and print. */
-	if (!kgdb_connected || atomic_read(&debugger_active) != 0)
-		return;
-
-	local_irq_save(flags);
-	kgdb_msg_write(s, count);
-	local_irq_restore(flags);
-}
-
-struct console kgdbcons = {
-	.name = "kgdb",
-	.write = kgdb_console_write,
-	.flags = CON_PRINTBUFFER | CON_ENABLED,
-};
-static int __init kgdb_console_init(void)
-{
-	register_console(&kgdbcons);
-	return 0;
-}
-
-console_initcall(kgdb_console_init);
-#endif
-
 static int __init opt_kgdb_attachwait(char *str)
 {
 	attachwait = 1;
