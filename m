Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbZCMQcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbZCMQcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759087AbZCMQal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:30:41 -0400
Received: from gw.goop.org ([64.81.55.164]:56775 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758821AbZCMQak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:30:40 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Juan Quintela <quintela@redhat.com>
Subject: [PATCH 01/15] xen dom0: Make hvc_xen console work for dom0.
Date: Fri, 13 Mar 2009 09:29:42 -0700
Message-Id: <1236961796-13407-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236961796-13407-1-git-send-email-jeremy@goop.org>
References: <1236961796-13407-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the console hypercalls for dom0 console.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 drivers/char/hvc_xen.c |  101 ++++++++++++++++++++++++++++++++----------------
 drivers/xen/events.c   |    2 +-
 include/xen/events.h   |    2 +
 3 files changed, 70 insertions(+), 35 deletions(-)

diff --git a/drivers/char/hvc_xen.c b/drivers/char/hvc_xen.c
index eba999f..81d9186 100644
--- a/drivers/char/hvc_xen.c
+++ b/drivers/char/hvc_xen.c
@@ -55,7 +55,7 @@ static inline void notify_daemon(void)
 	notify_remote_via_evtchn(xen_start_info->console.domU.evtchn);
 }
 
-static int write_console(uint32_t vtermno, const char *data, int len)
+static int domU_write_console(uint32_t vtermno, const char *data, int len)
 {
 	struct xencons_interface *intf = xencons_interface();
 	XENCONS_RING_IDX cons, prod;
@@ -76,7 +76,7 @@ static int write_console(uint32_t vtermno, const char *data, int len)
 	return sent;
 }
 
-static int read_console(uint32_t vtermno, char *buf, int len)
+static int domU_read_console(uint32_t vtermno, char *buf, int len)
 {
 	struct xencons_interface *intf = xencons_interface();
 	XENCONS_RING_IDX cons, prod;
@@ -97,28 +97,63 @@ static int read_console(uint32_t vtermno, char *buf, int len)
 	return recv;
 }
 
-static struct hv_ops hvc_ops = {
-	.get_chars = read_console,
-	.put_chars = write_console,
+static struct hv_ops domU_hvc_ops = {
+	.get_chars = domU_read_console,
+	.put_chars = domU_write_console,
 	.notifier_add = notifier_add_irq,
 	.notifier_del = notifier_del_irq,
 	.notifier_hangup = notifier_hangup_irq,
 };
 
-static int __init xen_init(void)
+static int dom0_read_console(uint32_t vtermno, char *buf, int len)
+{
+	return HYPERVISOR_console_io(CONSOLEIO_read, len, buf);
+}
+
+/*
+ * Either for a dom0 to write to the system console, or a domU with a
+ * debug version of Xen
+ */
+static int dom0_write_console(uint32_t vtermno, const char *str, int len)
+{
+	int rc = HYPERVISOR_console_io(CONSOLEIO_write, len, (char *)str);
+	if (rc < 0)
+		return 0;
+
+	return len;
+}
+
+static struct hv_ops dom0_hvc_ops = {
+	.get_chars = dom0_read_console,
+	.put_chars = dom0_write_console,
+	.notifier_add = notifier_add_irq,
+	.notifier_del = notifier_del_irq,
+	.notifier_hangup = notifier_hangup_irq,
+};
+
+static int __init xen_hvc_init(void)
 {
 	struct hvc_struct *hp;
+	struct hv_ops *ops;
 
-	if (!xen_pv_domain() ||
-	    xen_initial_domain() ||
-	    !xen_start_info->console.domU.evtchn)
-		return -ENODEV;
+	if (!xen_pv_domain())
+ 		return -ENODEV;
+
+	if (xen_initial_domain()) {
+		ops = &dom0_hvc_ops;
+		xencons_irq = bind_virq_to_irq(VIRQ_CONSOLE, 0);
+	} else {
+		if (!xen_start_info->console.domU.evtchn)
+			return -ENODEV;
+
+		ops = &domU_hvc_ops;
+		xencons_irq = bind_evtchn_to_irq(xen_start_info->console.domU.evtchn);
+	}
 
-	xencons_irq = bind_evtchn_to_irq(xen_start_info->console.domU.evtchn);
 	if (xencons_irq < 0)
 		xencons_irq = 0; /* NO_IRQ */
 
-	hp = hvc_alloc(HVC_COOKIE, xencons_irq, &hvc_ops, 256);
+	hp = hvc_alloc(HVC_COOKIE, xencons_irq, ops, 256);
 	if (IS_ERR(hp))
 		return PTR_ERR(hp);
 
@@ -135,7 +170,7 @@ void xen_console_resume(void)
 		rebind_evtchn_irq(xen_start_info->console.domU.evtchn, xencons_irq);
 }
 
-static void __exit xen_fini(void)
+static void __exit xen_hvc_fini(void)
 {
 	if (hvc)
 		hvc_remove(hvc);
@@ -143,29 +178,24 @@ static void __exit xen_fini(void)
 
 static int xen_cons_init(void)
 {
+	struct hv_ops *ops;
+
 	if (!xen_pv_domain())
 		return 0;
 
-	hvc_instantiate(HVC_COOKIE, 0, &hvc_ops);
+	ops = &domU_hvc_ops;
+	if (xen_initial_domain())
+		ops = &dom0_hvc_ops;
+
+	hvc_instantiate(HVC_COOKIE, 0, ops);
+
 	return 0;
 }
 
-module_init(xen_init);
-module_exit(xen_fini);
+module_init(xen_hvc_init);
+module_exit(xen_hvc_fini);
 console_initcall(xen_cons_init);
 
-static void raw_console_write(const char *str, int len)
-{
-	while(len > 0) {
-		int rc = HYPERVISOR_console_io(CONSOLEIO_write, len, (char *)str);
-		if (rc <= 0)
-			break;
-
-		str += rc;
-		len -= rc;
-	}
-}
-
 #ifdef CONFIG_EARLY_PRINTK
 static void xenboot_write_console(struct console *console, const char *string,
 				  unsigned len)
@@ -173,19 +203,22 @@ static void xenboot_write_console(struct console *console, const char *string,
 	unsigned int linelen, off = 0;
 	const char *pos;
 
-	raw_console_write(string, len);
+	dom0_write_console(0, string, len);
+
+	if (xen_initial_domain())
+		return;
 
-	write_console(0, "(early) ", 8);
+	domU_write_console(0, "(early) ", 8);
 	while (off < len && NULL != (pos = strchr(string+off, '\n'))) {
 		linelen = pos-string+off;
 		if (off + linelen > len)
 			break;
-		write_console(0, string+off, linelen);
-		write_console(0, "\r\n", 2);
+		domU_write_console(0, string+off, linelen);
+		domU_write_console(0, "\r\n", 2);
 		off += linelen + 1;
 	}
 	if (off < len)
-		write_console(0, string+off, len-off);
+		domU_write_console(0, string+off, len-off);
 }
 
 struct console xenboot_console = {
@@ -197,7 +230,7 @@ struct console xenboot_console = {
 
 void xen_raw_console_write(const char *str)
 {
-	raw_console_write(str, strlen(str));
+	dom0_write_console(0, str, strlen(str));
 }
 
 void xen_raw_printk(const char *fmt, ...)
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 30963af..f46e880 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -404,7 +404,7 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 }
 
 
-static int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
+int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 {
 	struct evtchn_bind_virq bind_virq;
 	int evtchn, irq;
diff --git a/include/xen/events.h b/include/xen/events.h
index 0d5f1ad..0397ba1 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -12,6 +12,8 @@ int bind_evtchn_to_irqhandler(unsigned int evtchn,
 			      irq_handler_t handler,
 			      unsigned long irqflags, const char *devname,
 			      void *dev_id);
+int bind_virq_to_irq(unsigned int virq, unsigned int cpu);
+
 int bind_virq_to_irqhandler(unsigned int virq, unsigned int cpu,
 			    irq_handler_t handler,
 			    unsigned long irqflags, const char *devname,
-- 
1.6.0.6

