Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbYDDQ3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbYDDQ3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 12:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYDDQ2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 12:28:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbYDDQ2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 12:28:49 -0400
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, mingo@redhat.com
From: Markus Armbruster <armbru@redhat.com>
Date: Fri, 4 Apr 2008 16:59:35 +0200
Subject: [PATCH] xen: Enable Xen console by default in domU
Message-ID: <87hcehshyc.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without console= arguments on the kernel command line, the first
console to register becomes enabled and the preferred console (the one
behind /dev/console).  This is tty (assuming CONFIG_VT_CONSOLE is
enabled, which it commonly is).

This is okay as long tty is a useful console.  But unless we have the
PV framebuffer, and it is enabled for this domain, tty0 in domU is
merely a dummy.  In that case, we want the preferred console to be the
Xen console hvc0, and we want it without having to fiddle with the
kernel command line.

Even with PV framebuffer enabled, we still want to enable the Xen
console as well.

Problem: when tty registers, we can't yet know whether the PVFB is
enabled.  By the time we can know (xenstore is up), the console setup
game is over.

Enable the Xen console hvc by default, and make it the preferred
console.  Change the preferred to tty when PVFB probes successfully.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
This patch supersedes the "xen: Make hvc0 the preferred console in
domU" patch.  It does not depend on the PVFB patch; it works with and
without it.

Aside: xenfb_make_preferred_console() may not be the best way to solve
the problem.  I simply followed the precedence in
arch/parisc/kernel/pdc_cons.c's pdc_console_restart().  Maybe a
function console_force_prefer() in printk.c to move make a console the
preferred console would make more sense.

 arch/x86/xen/enlighten.c    |    6 ++++++
 drivers/video/xen-fbfront.c |   22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index de4e6f0..4a5106e 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -25,6 +25,7 @@
 #include <linux/mm.h>
 #include <linux/page-flags.h>
 #include <linux/highmem.h>
+#include <linux/console.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/physdev.h>
@@ -1215,6 +1216,11 @@ asmlinkage void __init xen_start_kernel(void)
 		? __pa(xen_start_info->mod_start) : 0;
 	boot_params.hdr.ramdisk_size = xen_start_info->mod_len;
 
+	if (!is_initial_xendomain()) {
+		add_preferred_console("tty", 0, NULL);
+		add_preferred_console("hvc", 0, NULL);
+	}
+
 	/* Start the world */
 	start_kernel();
 }
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 619a6f8..9b428b5 100644
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
@@ -358,6 +361,25 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	return ret;
 }
 
+static __devinit void
+xenfb_make_preferred_console(void)
+{
+	struct console *c;
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
-- 
1.5.3.3

