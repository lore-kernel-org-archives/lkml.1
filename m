Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbYAQSAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbYAQSAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbYAQR7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:59:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:38885 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbYAQR7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:59:52 -0500
Message-ID: <478F9785.5030006@windriver.com>
Date: Thu, 17 Jan 2008 11:59:33 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [RFC][PATCH] kgdb: late kgdb console registration
References: <478F5CEB.8030400@siemens.com>
In-Reply-To: <478F5CEB.8030400@siemens.com>
Content-Type: multipart/mixed;
 boundary="------------040906000705050006000001"
X-OriginalArrivalTime: 17 Jan 2008 17:59:33.0574 (UTC) FILETIME=[B721C660:01C85932]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040906000705050006000001
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Jan Kiszka wrote:
> KGDB allows to direct the console output also to the gdb frontend. But
> if you switch on CONFIG_KGDB_CONSOLE blindly, you end up without a
> suitable initial console for init, causing a boot panic (like I faced:
> http://lkml.org/lkml/2008/1/14/284). One workaround is to explicitly
> provide the first console in the kernel command line.
>
> This patch implements a less error-prone approach by registering the
> console in kgdb_internal_init(). Before that point, it is unusable
> anyway due to the debugger not being attached.
>
> Note that this patch also fully initializes the non-static kgdbcons
> struct - not needed if we were able to kill its only external
> reference by PXA_CONSOLE (see related posting). If non-static remains
> necessary, I can also split up this patch into two.
>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>   

We can move beyond the RFC and into an official patch.

I would agree that the PXA_CONSOLE variable should be changed based on
the way the console registration works today.  I will drop the pxa.c
patches from the arm-lite.patch.

If I don't hear any complaints, from the kgdb mailing list I'll commit
the patch to the development head branch and the 2.6.24 branch.

Thanks,
Jason.

--------------040906000705050006000001
Content-Type: text/x-patch;
 name="kgdb_console_fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kgdb_console_fixes.patch"

KGDB allows to direct the console output also to the gdb frontend. But
if you switch on CONFIG_KGDB_CONSOLE blindly, you end up without a
suitable initial console for init, causing a boot panic (like I faced:
http://lkml.org/lkml/2008/1/14/284). One workaround is to explicitly
provide the first console in the kernel command line.

This patch implements a less error-prone approach by registering the
console in kgdb_internal_init(). Before that point, it is unusable
anyway due to the debugger not being attached.

The external references to the kgdbcons were removed, because it
should not be used outside the kgdb core.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 include/linux/kgdb.h |    4 ---
 kernel/kgdb.c        |   56 ++++++++++++++++++++++++---------------------------
 2 files changed, 27 insertions(+), 33 deletions(-)

--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1628,6 +1628,29 @@ static struct notifier_block kgdb_panic_
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
+static struct console kgdbcons = {
+	.name = "kgdb",
+	.write = kgdb_console_write,
+	.flags = CON_PRINTBUFFER | CON_ENABLED,
+	.index = -1,
+};
+#endif
+
 /*
  * Initialization that needs to be done in either of our entry points.
  */
@@ -1648,6 +1671,10 @@ static void __init kgdb_internal_init(vo
 	/* We can't do much if this fails */
 	register_module_notifier(&kgdb_module_load_nb);
 
+#ifdef CONFIG_KGDB_CONSOLE
+	register_console(&kgdbcons);
+#endif
+
 	kgdb_initialized = 1;
 }
 
@@ -1957,35 +1984,6 @@ static int kgdb_notify_reboot(struct not
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
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -33,10 +33,6 @@ struct pt_regs;
 struct task_struct;
 struct uart_port;
 
-#ifdef CONFIG_KGDB_CONSOLE
-extern struct console kgdbcons;
-#endif
-
 /* To enter the debugger explicitly. */
 extern void breakpoint(void);
 extern int kgdb_connected;

--------------040906000705050006000001--
