Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZJKVFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZJKVFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 17:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZJKVFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 17:05:51 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:50295 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZJKVFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 17:05:48 -0400
From: Bernhard Walle <bernhard@bwalle.de>
To: akpm@linuxfoundation.org
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Bernhard Walle <bernhard@bwalle.de>
Subject: [PATCH 1/2] Introduce and use vt_kmsg_redirect() function
Date: Sun, 11 Oct 2009 23:04:30 +0200
Message-Id: <1255295071-13664-2-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255295071-13664-1-git-send-email-bernhard@bwalle.de>
References: <1255295071-13664-1-git-send-email-bernhard@bwalle.de>
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using and exporting a global value kmsg_redirect, introduce a
function vt_kmsg_redirect() that both can set and return the console where
messages are printed.

Change all users of kmsg_redirect (the VT code itself and kernel/power.c)
to the new interface.

The main advantage is that vt_kmsg_redirect() can also be used when
CONFIG_VT_CONSOLE is not set.


Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
---
 drivers/char/vt.c      |   43 +++++++++++++++++++++++++++++++++++++------
 include/linux/tty.h    |    2 --
 include/linux/vt.h     |   15 +++++++++++++++
 kernel/power/console.c |    7 +++----
 4 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 0c80c68..197fec5 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -182,12 +182,10 @@ static DECLARE_WORK(console_work, console_callback);
  * fg_console is the current virtual console,
  * last_console is the last used one,
  * want_console is the console we want to switch to,
- * kmsg_redirect is the console for kernel messages,
  */
 int fg_console;
 int last_console;
 int want_console = -1;
-int kmsg_redirect;
 
 /*
  * For each existing display, we have a pointer to console currently visible
@@ -2426,6 +2424,37 @@ struct tty_driver *console_driver;
 
 #ifdef CONFIG_VT_CONSOLE
 
+/**
+ * vt_kmsg_redirect() - Sets/gets the kernel message console
+ * @new:	The new virtual terminal number or -1 if the console should stay
+ * 		unchanged
+ *
+ * By default, the kernel messages are always printed on the current virtual
+ * console. However, the user may modify that default with the
+ * TIOCL_SETKMSGREDIRECT ioctl call.
+ *
+ * This function sets the kernel message console to be @new. It returns the old
+ * virtual console number. The virtual terminal number 0 (both as parameter and
+ * return value) means no redirection (i.e. always printed on the currently
+ * active console).
+ *
+ * The parameter -1 means that only the current console is returned, but the
+ * value is not modified. You may use the macro vt_get_kmsg_redirect() in that
+ * case to make the code more understandable.
+ *
+ * When the kernel is compiled without CONFIG_VT_CONSOLE, this function ignores
+ * the parameter and always returns 0.
+ */
+int vt_kmsg_redirect(int new)
+{
+	static int kmsg_con;
+
+	if (new != -1)
+		return xchg(&kmsg_con, new);
+	else
+		return kmsg_con;
+}
+
 /*
  *	Console on virtual terminal
  *
@@ -2440,6 +2469,7 @@ static void vt_console_print(struct console *co, const char *b, unsigned count)
 	const ushort *start;
 	ushort cnt = 0;
 	ushort myx;
+	int kmsg_console;
 
 	/* console busy or not yet initialized */
 	if (!printable)
@@ -2447,8 +2477,9 @@ static void vt_console_print(struct console *co, const char *b, unsigned count)
 	if (!spin_trylock(&printing_lock))
 		return;
 
-	if (kmsg_redirect && vc_cons_allocated(kmsg_redirect - 1))
-		vc = vc_cons[kmsg_redirect - 1].d;
+	kmsg_console = vt_get_kmsg_redirect();
+	if (kmsg_console && vc_cons_allocated(kmsg_console - 1))
+		vc = vc_cons[kmsg_console - 1].d;
 
 	/* read `x' only after setting currcons properly (otherwise
 	   the `x' macro will read the x of the foreground console). */
@@ -2605,7 +2636,7 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 			ret = set_vesa_blanking(p);
 			break;
 		case TIOCL_GETKMSGREDIRECT:
-			data = kmsg_redirect;
+			data = vt_get_kmsg_redirect();
 			ret = __put_user(data, p);
 			break;
 		case TIOCL_SETKMSGREDIRECT:
@@ -2615,7 +2646,7 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 				if (get_user(data, p+1))
 					ret = -EFAULT;
 				else
-					kmsg_redirect = data;
+					vt_kmsg_redirect(data);
 			}
 			break;
 		case TIOCL_GETFGCONSOLE:
diff --git a/include/linux/tty.h b/include/linux/tty.h
index f0f43d0..fddafcb 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -340,8 +340,6 @@ extern void tty_write_flush(struct tty_struct *);
 
 extern struct ktermios tty_std_termios;
 
-extern int kmsg_redirect;
-
 extern void console_init(void);
 extern int vcs_init(void);
 
diff --git a/include/linux/vt.h b/include/linux/vt.h
index 7afca0d..1ae127d 100644
--- a/include/linux/vt.h
+++ b/include/linux/vt.h
@@ -84,4 +84,19 @@ struct vt_setactivate {
 
 #define VT_SETACTIVATE	0x560F	/* Activate and set the mode of a console */
 
+#ifdef CONFIG_VT_CONSOLE
+
+extern int vt_kmsg_redirect(int new);
+
+#else
+
+static inline int vt_kmsg_redirect(int new)
+{
+	return 0;
+}
+
+#endif
+
+#define vt_get_kmsg_redirect() vt_kmsg_redirect(-1)
+
 #endif /* _LINUX_VT_H */
diff --git a/kernel/power/console.c b/kernel/power/console.c
index 5187136..218e5af 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -6,7 +6,7 @@
 
 #include <linux/vt_kern.h>
 #include <linux/kbd_kern.h>
-#include <linux/console.h>
+#include <linux/vt.h>
 #include <linux/module.h>
 #include "power.h"
 
@@ -21,8 +21,7 @@ int pm_prepare_console(void)
 	if (orig_fgconsole < 0)
 		return 1;
 
-	orig_kmsg = kmsg_redirect;
-	kmsg_redirect = SUSPEND_CONSOLE;
+	orig_kmsg = vt_kmsg_redirect(SUSPEND_CONSOLE);
 	return 0;
 }
 
@@ -30,7 +29,7 @@ void pm_restore_console(void)
 {
 	if (orig_fgconsole >= 0) {
 		vt_move_to_console(orig_fgconsole, 0);
-		kmsg_redirect = orig_kmsg;
+		vt_kmsg_redirect(orig_kmsg);
 	}
 }
 #endif
-- 
1.6.3.3

