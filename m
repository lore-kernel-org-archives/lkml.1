Return-Path: <linux-kernel-owner+w=401wt.eu-S1762053AbYEUIjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762053AbYEUIjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYEUIjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:39:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbYEUIjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:39:11 -0400
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       mingo@redhat.com, akpm@linux-foundation.org,
       Pat Campbell <plc@novell.com>
Subject: [PATCH 1/5] xen: Enable console tty by default in domU if it's not a dummy
References: <87d4ngm4s4.fsf@pike.pond.sub.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Wed, 21 May 2008 10:38:50 +0200
Message-ID: <878wy4m4px.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/xen/enlighten.c    |    4 +++-
 drivers/video/xen-fbfront.c |   25 +++++++++++++++++++++++++
 include/linux/console.h     |    2 ++
 kernel/printk.c             |    3 +++
 4 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c8a56e4..a9f8d6a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1242,8 +1242,10 @@ asmlinkage void __init xen_start_kernel(void)
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
index 619a6f8..4e10876 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -18,6 +18,7 @@
  * frame buffer.
  */
 
+#include <linux/console.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/fb.h>
@@ -48,6 +49,7 @@ struct xenfb_info {
 
 static u32 xenfb_mem_len = XENFB_WIDTH * XENFB_HEIGHT * XENFB_DEPTH / 8;
 
+static void xenfb_make_preferred_console(void);
 static int xenfb_remove(struct xenbus_device *);
 static void xenfb_init_shared_page(struct xenfb_info *);
 static int xenfb_connect_backend(struct xenbus_device *, struct xenfb_info *);
@@ -348,6 +350,7 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	if (ret < 0)
 		goto error;
 
+	xenfb_make_preferred_console();
 	return 0;
 
  error_nomem:
@@ -358,6 +361,28 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	return ret;
 }
 
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
+}
+
 static int xenfb_resume(struct xenbus_device *dev)
 {
 	struct xenfb_info *info = dev->dev.driver_data;
diff --git a/include/linux/console.h b/include/linux/console.h
index a4f27fb..248e6e3 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -108,6 +108,8 @@ struct console {
 	struct	 console *next;
 };
 
+extern int console_set_on_cmdline;
+
 extern int add_preferred_console(char *name, int idx, char *options);
 extern int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options);
 extern void register_console(struct console *);
diff --git a/kernel/printk.c b/kernel/printk.c
index 8fb01c3..028ed75 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -121,6 +121,8 @@ struct console_cmdline
 static struct console_cmdline console_cmdline[MAX_CMDLINECONSOLES];
 static int selected_console = -1;
 static int preferred_console = -1;
+int console_set_on_cmdline;
+EXPORT_SYMBOL(console_set_on_cmdline);
 
 /* Flag: console code may call schedule() */
 static int console_may_schedule;
@@ -890,6 +892,7 @@ static int __init console_setup(char *str)
 	*s = 0;
 
 	__add_preferred_console(buf, idx, options, brl_options);
+	console_set_on_cmdline = 1;
 	return 1;
 }
 __setup("console=", console_setup);
-- 
1.5.3.3

