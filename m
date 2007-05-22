Return-Path: <linux-kernel-owner+w=401wt.eu-S936014AbXEVP3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936014AbXEVP3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934882AbXEVPTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:47 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:5011
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965760AbXEVPTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:16 -0400
Message-Id: <20070522141253.642486495@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:10:12 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [patch 31/33] xen: xen: handle external requests for shutdown, reboot and sysrq
Content-Disposition: inline; filename=xen-management.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The guest domain can be asked to shutdown or reboot itself, or have a
sysrq key injected, via xenbus.  This patch adds a watcher for those
events, and does the appropriate action.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>

---
 arch/i386/xen/Makefile |    2 
 arch/i386/xen/manage.c |  143 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/i386/xen/Makefile
+++ b/arch/i386/xen/Makefile
@@ -1,4 +1,4 @@ obj-y		:= enlighten.o setup.o features.o
 obj-y		:= enlighten.o setup.o features.o multicalls.o mmu.o \
-			events.o time.o
+			events.o time.o manage.o
 
 obj-$(CONFIG_SMP)	+= smp.o
===================================================================
--- /dev/null
+++ b/arch/i386/xen/manage.c
@@ -0,0 +1,143 @@
+/*
+ * Handle extern requests for shutdown, reboot and sysrq
+ */
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/reboot.h>
+#include <linux/sysrq.h>
+
+#include <xen/xenbus.h>
+
+#define SHUTDOWN_INVALID  -1
+#define SHUTDOWN_POWEROFF  0
+#define SHUTDOWN_SUSPEND   2
+/* Code 3 is SHUTDOWN_CRASH, which we don't use because the domain can only
+ * report a crash, not be instructed to crash!
+ * HALT is the same as POWEROFF, as far as we're concerned.  The tools use
+ * the distinction when we return the reason code to them.
+ */
+#define SHUTDOWN_HALT      4
+
+/* Ignore multiple shutdown requests. */
+static int shutting_down = SHUTDOWN_INVALID;
+
+static void shutdown_handler(struct xenbus_watch *watch,
+			     const char **vec, unsigned int len)
+{
+	char *str;
+	struct xenbus_transaction xbt;
+	int err;
+
+	if (shutting_down != SHUTDOWN_INVALID)
+		return;
+
+ again:
+	err = xenbus_transaction_start(&xbt);
+	if (err)
+		return;
+
+	str = (char *)xenbus_read(xbt, "control", "shutdown", NULL);
+	/* Ignore read errors and empty reads. */
+	if (XENBUS_IS_ERR_READ(str)) {
+		xenbus_transaction_end(xbt, 1);
+		return;
+	}
+
+	xenbus_write(xbt, "control", "shutdown", "");
+
+	err = xenbus_transaction_end(xbt, 0);
+	if (err == -EAGAIN) {
+		kfree(str);
+		goto again;
+	}
+
+	if (strcmp(str, "poweroff") == 0 ||
+	    strcmp(str, "halt") == 0)
+		orderly_poweroff(false);
+	else if (strcmp(str, "reboot") == 0)
+		ctrl_alt_del();
+	else {
+		printk("Ignoring shutdown request: %s\n", str);
+		shutting_down = SHUTDOWN_INVALID;
+	}
+
+	kfree(str);
+}
+
+static void sysrq_handler(struct xenbus_watch *watch, const char **vec,
+			  unsigned int len)
+{
+	char sysrq_key = '\0';
+	struct xenbus_transaction xbt;
+	int err;
+
+ again:
+	err = xenbus_transaction_start(&xbt);
+	if (err)
+		return;
+	if (!xenbus_scanf(xbt, "control", "sysrq", "%c", &sysrq_key)) {
+		printk(KERN_ERR "Unable to read sysrq code in "
+		       "control/sysrq\n");
+		xenbus_transaction_end(xbt, 1);
+		return;
+	}
+
+	if (sysrq_key != '\0')
+		xenbus_printf(xbt, "control", "sysrq", "%c", '\0');
+
+	err = xenbus_transaction_end(xbt, 0);
+	if (err == -EAGAIN)
+		goto again;
+
+	if (sysrq_key != '\0')
+		handle_sysrq(sysrq_key, NULL);
+}
+
+static struct xenbus_watch shutdown_watch = {
+	.node = "control/shutdown",
+	.callback = shutdown_handler
+};
+
+static struct xenbus_watch sysrq_watch = {
+	.node = "control/sysrq",
+	.callback = sysrq_handler
+};
+
+static int setup_shutdown_watcher(void)
+{
+	int err;
+
+	err = register_xenbus_watch(&shutdown_watch);
+	if (err) {
+		printk(KERN_ERR "Failed to set shutdown watcher\n");
+		return err;
+	}
+
+	err = register_xenbus_watch(&sysrq_watch);
+	if (err) {
+		printk(KERN_ERR "Failed to set sysrq watcher\n");
+		return err;
+	}
+
+	return 0;
+}
+
+static int shutdown_event(struct notifier_block *notifier,
+			  unsigned long event,
+			  void *data)
+{
+	setup_shutdown_watcher();
+	return NOTIFY_DONE;
+}
+
+static int __init setup_shutdown_event(void)
+{
+	static struct notifier_block xenstore_notifier = {
+		.notifier_call = shutdown_event
+	};
+	register_xenstore_notifier(&xenstore_notifier);
+
+	return 0;
+}
+
+subsys_initcall(setup_shutdown_event);

-- 

