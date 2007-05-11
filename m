Return-Path: <linux-kernel-owner+w=401wt.eu-S1031123AbXEKTYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031123AbXEKTYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966267AbXEKTTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:19:54 -0400
Received: from 161.sub-75-209-96.myvzw.com ([75.209.96.161]:36796 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966249AbXEKTTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:19:52 -0400
Message-Id: <20070511001204.173739000@goop.org>
References: <20070511000643.025196000@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 17:07:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Olof Johansson <olof@lixom.net>
Subject: [patch 18/28]xen: Use the hvc console infrastructure for Xen console
Content-Disposition: inline; filename=xen-hvc-console.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a Xen back-end for hvc console.

From: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Olof Johansson <olof@lixom.net>
---
 arch/i386/xen/events.c |    3 -
 drivers/Makefile       |    3 +
 drivers/char/Kconfig   |    8 ++
 drivers/char/Makefile  |    1 
 drivers/char/hvc_xen.c |  134 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/xen/events.h   |    1 
 6 files changed, 149 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/i386/xen/events.c
+++ b/arch/i386/xen/events.c
@@ -244,7 +244,7 @@ static int find_unbound_irq(void)
 	return irq;
 }
 
-static int bind_evtchn_to_irq(unsigned int evtchn)
+int bind_evtchn_to_irq(unsigned int evtchn)
 {
 	int irq;
 
@@ -269,6 +269,7 @@ static int bind_evtchn_to_irq(unsigned i
 
 	return irq;
 }
+EXPORT_SYMBOL_GPL(bind_evtchn_to_irq);
 
 static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 {
===================================================================
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -14,6 +14,9 @@ obj-$(CONFIG_ACPI)		+= acpi/
 # was used and do nothing if so
 obj-$(CONFIG_PNP)		+= pnp/
 obj-$(CONFIG_ARM_AMBA)		+= amba/
+
+# Xen is the default console when running as a guest
+obj-$(CONFIG_XEN)		+= xen/
 
 # char/ comes before serial/ etc so that the VT console is the boot-time
 # default.
===================================================================
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -650,6 +650,14 @@ config HVC_BEAT
 	help
 	  Toshiba's Cell Reference Set Beat Console device driver
 
+config HVC_XEN
+	bool "Xen Hypervisor Console support"
+	depends on XEN
+	select HVC_DRIVER
+	default y
+	help
+	  Xen virtual console device driver
+
 config HVCS
 	tristate "IBM Hypervisor Virtual Console Server support"
 	depends on PPC_PSERIES
===================================================================
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_SX)		+= sx.o generic_serial
 obj-$(CONFIG_SX)		+= sx.o generic_serial.o
 obj-$(CONFIG_RIO)		+= rio/ generic_serial.o
 obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o hvsi.o
+obj-$(CONFIG_HVC_XEN)		+= hvc_xen.o
 obj-$(CONFIG_HVC_ISERIES)	+= hvc_iseries.o
 obj-$(CONFIG_HVC_RTAS)		+= hvc_rtas.o
 obj-$(CONFIG_HVC_BEAT)		+= hvc_beat.o
===================================================================
--- /dev/null
+++ b/drivers/char/hvc_xen.c
@@ -0,0 +1,134 @@
+/*
+ * xen console driver interface to hvc_console.c
+ *
+ * (c) 2007 Gerd Hoffmann <kraxel@suse.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/console.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/types.h>
+
+#include <asm/xen/hypervisor.h>
+#include <xen/page.h>
+#include <xen/events.h>
+#include <xen/interface/io/console.h>
+
+#include "hvc_console.h"
+
+#define HVC_COOKIE   0x58656e /* "Xen" in hex */
+
+static struct hvc_struct *hvc;
+static int xencons_irq;
+
+/* ------------------------------------------------------------------ */
+
+static inline struct xencons_interface *xencons_interface(void)
+{
+	return mfn_to_virt(xen_start_info->console.domU.mfn);
+}
+
+static inline void notify_daemon(void)
+{
+	/* Use evtchn: this is called early, before irq is set up. */
+	notify_remote_via_evtchn(xen_start_info->console.domU.evtchn);
+}
+
+static int write_console(uint32_t vtermno, const char *data, int len)
+{
+	struct xencons_interface *intf = xencons_interface();
+	XENCONS_RING_IDX cons, prod;
+	int sent = 0;
+
+	cons = intf->out_cons;
+	prod = intf->out_prod;
+	mb();
+	BUG_ON((prod - cons) > sizeof(intf->out));
+
+	while ((sent < len) && ((prod - cons) < sizeof(intf->out)))
+		intf->out[MASK_XENCONS_IDX(prod++, intf->out)] = data[sent++];
+
+	wmb();
+	intf->out_prod = prod;
+
+	notify_daemon();
+	return sent;
+}
+
+static int read_console(uint32_t vtermno, char *buf, int len)
+{
+	struct xencons_interface *intf = xencons_interface();
+	XENCONS_RING_IDX cons, prod;
+	int recv = 0;
+
+	cons = intf->in_cons;
+	prod = intf->in_prod;
+	mb();
+	BUG_ON((prod - cons) > sizeof(intf->in));
+
+	while (cons != prod && recv < len)
+		buf[recv++] = intf->in[MASK_XENCONS_IDX(cons++,intf->in)];
+
+	mb();
+	intf->in_cons = cons;
+
+	notify_daemon();
+	return recv;
+}
+
+static struct hv_ops hvc_ops = {
+	.get_chars = read_console,
+	.put_chars = write_console,
+};
+
+static int __init xen_init(void)
+{
+	struct hvc_struct *hp;
+
+	if (!is_running_on_xen())
+		return 0;
+
+	xencons_irq = bind_evtchn_to_irq(xen_start_info->console.domU.evtchn);
+	if (xencons_irq < 0)
+		xencons_irq = 0 /* NO_IRQ */;
+	hp = hvc_alloc(HVC_COOKIE, xencons_irq, &hvc_ops, 256);
+	if (IS_ERR(hp))
+		return PTR_ERR(hp);
+
+	hvc = hp;
+	return 0;
+}
+
+static void __exit xen_fini(void)
+{
+	if (hvc)
+		hvc_remove(hvc);
+}
+
+static int xen_cons_init(void)
+{
+	if (!is_running_on_xen())
+		return 0;
+
+	hvc_instantiate(HVC_COOKIE, 0, &hvc_ops);
+	return 0;
+}
+
+module_init(xen_init);
+module_exit(xen_fini);
+console_initcall(xen_cons_init);
===================================================================
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -13,6 +13,7 @@ enum ipi_vector {
 	XEN_NR_IPIS,
 };
 
+int bind_evtchn_to_irq(unsigned int evtchn);
 int bind_evtchn_to_irqhandler(unsigned int evtchn,
 			      irq_handler_t handler,
 			      unsigned long irqflags, const char *devname,

-- 

