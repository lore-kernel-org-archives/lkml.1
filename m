Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYEWNJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYEWNJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYEWNJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:09:22 -0400
Received: from gw.goop.org ([64.81.55.164]:33885 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbYEWNJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:09:20 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 5] xen: Enable console tty by default in domU if it's not
	a dummy
X-Mercurial-Node: e9931939438dda0e1d235e26fea57f63923ad609
Message-Id: <e9931939438dda0e1d23.1211547981@localhost>
In-Reply-To: <patchbomb.1211547980@localhost>
Date: Fri, 23 May 2008 14:06:21 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Markus Armbruster <armbru@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Armbruster <armbru@redhat.com>

Without console= arguments on the kernel command line, the first
console to register becomes enabled and the preferred console (the one
behind /dev/console).  This is normally tty (assuming
CONFIG_VT_CONSOLE is enabled, which it commonly is).

This is okay as long tty is a useful console.  But unless we have the
PV framebuffer, and it is enabled for this domain, tty0 in domU is
merely a dummy.  In that case, we want the preferred console to be the
Xen console hvc0, and we want it without having to fiddle with the
kernel command line.  Commit b8c2d3dfbc117dff26058fbac316b8acfc2cb5f7
did that for us.

Since we now have the PV framebuffer, we want to enable and prefer tty
again, but only when PVFB is enabled.  But even then we still want to
enable the Xen console as well.

Problem: when tty registers, we can't yet know whether the PVFB is
enabled.  By the time we can know (xenstore is up), the console setup
game is over.

Solution: enable console tty by default, but keep hvc as the preferred
console.  Change the preferred console to tty when PVFB probes
successfully, unless we've been given console kernel parameters.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c    |    4 +++-
 drivers/video/xen-fbfront.c |   25 +++++++++++++++++++++++++
 include/linux/console.h     |    2 ++
 kernel/printk.c             |    4 +++-
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1257,8 +1257,10 @@
 		? __pa(xen_start_info->mod_start) : 0;
 	boot_params.hdr.ramdisk_size = xen_start_info->mod_len;
 
-	if (!is_initial_xendomain())
+	if (!is_initial_xendomain()) {
+		add_preferred_console("tty", 0, NULL);
 		add_preferred_console("hvc", 0, NULL);
+	}
 
 	/* Start the world */
 	start_kernel();
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -18,6 +18,7 @@
  * frame buffer.
  */
 
+#include <linux/console.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/fb.h>
@@ -48,6 +49,7 @@
 
 static u32 xenfb_mem_len = XENFB_WIDTH * XENFB_HEIGHT * XENFB_DEPTH / 8;
 
+static void xenfb_make_preferred_console(void);
 static int xenfb_remove(struct xenbus_device *);
 static void xenfb_init_shared_page(struct xenfb_info *);
 static int xenfb_connect_backend(struct xenbus_device *, struct xenfb_info *);
@@ -348,6 +350,7 @@
 	if (ret < 0)
 		goto error;
 
+	xenfb_make_preferred_console();
 	return 0;
 
  error_nomem:
@@ -356,6 +359,28 @@
  error:
 	xenfb_remove(dev);
 	return ret;
+}
+
+static __devinit void
+xenfb_make_preferred_console(void)
+{
+	struct console *c;
+
+	if (console_set_on_cmdline)
+		return;
+
+	acquire_console_sem();
+	for (c = console_drivers; c; c = c->next) {
+		if (!strcmp(c->name, "tty") && c->index == 0)
+			break;
+	}
+	release_console_sem();
+	if (c) {
+		unregister_console(c);
+		c->flags |= CON_CONSDEV;
+		c->flags &= ~CON_PRINTBUFFER; /* don't print again */
+		register_console(c);
+	}
 }
 
 static int xenfb_resume(struct xenbus_device *dev)
diff --git a/include/linux/console.h b/include/linux/console.h
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -108,6 +108,8 @@
 	struct	 console *next;
 };
 
+extern int console_set_on_cmdline;
+
 extern int add_preferred_console(char *name, int idx, char *options);
 extern int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options);
 extern void register_console(struct console *);
diff --git a/kernel/printk.c b/kernel/printk.c
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -122,6 +122,8 @@
 static struct console_cmdline console_cmdline[MAX_CMDLINECONSOLES];
 static int selected_console = -1;
 static int preferred_console = -1;
+int console_set_on_cmdline;
+EXPORT_SYMBOL(console_set_on_cmdline);
 
 /* Flag: console code may call schedule() */
 static int console_may_schedule;
@@ -895,6 +897,7 @@
 	*s = 0;
 
 	__add_preferred_console(buf, idx, options, brl_options);
+	console_set_on_cmdline = 1;
 	return 1;
 }
 __setup("console=", console_setup);


