Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab0BXM3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 07:29:20 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:38603 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765Ab0BXM3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 07:29:14 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: linuxpps@ml.enneenne.com, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
       stas@lvk.cs.msu.su, Rodolfo Giometti <giometti@enneenne.com>,
       john stultz <johnstul@us.ibm.com>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCHv2 6/6] pps: add parallel port PPS client
Date: Wed, 24 Feb 2010 15:28:17 +0300
Message-Id: <b52773fa6c8b6b387cd1acfb50de125d036c5320.1267008049.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add parallel port PPS client. It uses a standard method for capturing
timestamps for assert edge transitions: getting a timestamp soon after
an interrupt has happened. This is not a very precise source of time
information due to interrupt handling delays. However, timestamps for
clear edge transitions are much more precise because the interrupt
handler continuously polls hardware port until the transition is done.
Hardware port operations require only about 1us so the maximum error
should not exceed this value. This was my primary goal when developing
this client.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/Kconfig               |    2 +
 drivers/pps/Makefile              |    2 +-
 drivers/pps/clients/Kconfig       |   16 +++
 drivers/pps/clients/Makefile      |    9 ++
 drivers/pps/clients/pps_parport.c |  211 +++++++++++++++++++++++++++++++++++++
 5 files changed, 239 insertions(+), 1 deletions(-)
 create mode 100644 drivers/pps/clients/Kconfig
 create mode 100644 drivers/pps/clients/Makefile
 create mode 100644 drivers/pps/clients/pps_parport.c

diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index f3b14cd..3b70d9e 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -31,6 +31,8 @@ config PPS_DEBUG
 	  messages to the system log.  Select this if you are having a
 	  problem with PPS support and want to see more of what is going on.
 
+source drivers/pps/clients/Kconfig
+
 source drivers/pps/generators/Kconfig
 
 endmenu
diff --git a/drivers/pps/Makefile b/drivers/pps/Makefile
index b299814..1906eb7 100644
--- a/drivers/pps/Makefile
+++ b/drivers/pps/Makefile
@@ -4,6 +4,6 @@
 
 pps_core-y			:= pps.o kapi.o sysfs.o
 obj-$(CONFIG_PPS)		:= pps_core.o
-obj-y				+= generators/
+obj-y				+= clients/ generators/
 
 ccflags-$(CONFIG_PPS_DEBUG) := -DDEBUG
diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
new file mode 100644
index 0000000..969a486
--- /dev/null
+++ b/drivers/pps/clients/Kconfig
@@ -0,0 +1,16 @@
+#
+# PPS clients configuration
+#
+
+if PPS
+
+comment "PPS clients support"
+
+config PPS_CLIENT_PARPORT
+	tristate "Parallel port PPS client"
+	depends on PPS && PARPORT
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the interrupt pin of your parallel port.
+
+endif
diff --git a/drivers/pps/clients/Makefile b/drivers/pps/clients/Makefile
new file mode 100644
index 0000000..95f6fc3
--- /dev/null
+++ b/drivers/pps/clients/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for PPS clients.
+#
+
+obj-$(CONFIG_PPS_CLIENT_PARPORT) += pps_parport.o
+
+ifeq ($(CONFIG_PPS_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
diff --git a/drivers/pps/clients/pps_parport.c b/drivers/pps/clients/pps_parport.c
new file mode 100644
index 0000000..390f8e4
--- /dev/null
+++ b/drivers/pps/clients/pps_parport.c
@@ -0,0 +1,211 @@
+/*
+ * pps_parport.c -- kernel parallel port PPS client
+ *
+ *
+ * Copyright (C) 2009   Alexander Gordeev <lasaine@lvk.cs.msu.su>
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
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+/*
+ * TODO:
+ * 1. try using SA_NODELAY for parport irq handler
+ * 2. test under heavy load
+ * 3. implement echo over SEL pin
+ * 4. module parameters
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/irqnr.h>
+#include <linux/time.h>
+#include <linux/parport.h>
+#include <linux/pps_kernel.h>
+
+#define DRVNAME "pps_parport"
+#define DRVDESC "parallel port PPS client"
+
+/* maximum number of port reads when polling for signal clear */
+#define RECEIVE_TIMEOUT	100
+
+/* internal per port structure */
+struct pps_client_pp {
+	struct pardevice *pardev;	/* parport device */
+	int source;			/* PPS source number */
+};
+
+#define SIGNAL_IS_SET(port) \
+	((port->ops->read_status(port) & PARPORT_STATUS_ACK) != 0)
+
+/* parport interrupt handler */
+static void parport_irq(void *handle)
+{
+	struct pps_event_time ts_assert, ts_clear;
+	struct pps_client_pp *dev = handle;
+	struct parport *port = dev->pardev->port;
+	int i;
+	unsigned long flags;
+
+	/* first of all we get the time stamp... */
+	pps_get_ts(&ts_assert);
+
+	/* check the signal (no signal means the pulse is lost this time) */
+	if (!SIGNAL_IS_SET(port)) {
+		pr_err(DRVNAME ": lost the signal\n");
+		return;
+	}
+
+	/* FIXME: this is here until we have a fast interrupt */
+	local_irq_save(flags);
+	/* poll the port until the signal is unset */
+	for (i = RECEIVE_TIMEOUT; i; i--)
+		if (!SIGNAL_IS_SET(port)) {
+			pps_get_ts(&ts_clear);
+			local_irq_restore(flags);
+
+			/* FIXME: move these two calls to workqueue? */
+			/* fire assert event */
+			pps_event(dev->source, &ts_assert,
+					PPS_CAPTUREASSERT, NULL);
+			/* fire clear event */
+			pps_event(dev->source, &ts_clear,
+					PPS_CAPTURECLEAR, NULL);
+
+			return;
+		}
+	local_irq_restore(flags);
+
+	/* timeout */
+	pr_err(DRVNAME ": timeout in interrupt handler while waiting"
+			" for signal clear\n");
+}
+
+/* the PPS echo function */
+static void pps_echo(int source, int event, void *data)
+{
+	pr_info("echo %s %s for source %d\n",
+		event & PPS_CAPTUREASSERT ? "assert" : "",
+		event & PPS_CAPTURECLEAR ? "clear" : "",
+		source);
+}
+
+static void parport_attach(struct parport *port)
+{
+	struct pps_client_pp *device;
+	struct pps_source_info info = {
+		.name		= DRVNAME,
+		.path		= "",
+		.mode		= PPS_CAPTUREBOTH | \
+				  PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
+				  PPS_ECHOASSERT | PPS_ECHOCLEAR | \
+				  PPS_CANWAIT | PPS_TSFMT_TSPEC,
+		.echo 		= pps_echo,
+		.owner		= THIS_MODULE,
+	};
+
+	device = kzalloc(sizeof(struct pps_client_pp), GFP_KERNEL);
+	if (!device) {
+		pr_err(DRVNAME ": memory allocation failed, not attaching\n");
+		return;
+	}
+
+	device->pardev = parport_register_device(port, DRVNAME,
+			NULL, NULL, parport_irq, 0, device);
+	if (!device->pardev) {
+		pr_err(DRVNAME ": couldn't register with %s\n", port->name);
+		goto err_free;
+	}
+
+	if (parport_claim_or_block(device->pardev) < 0) {
+		pr_err(DRVNAME ": couldn't claim %s\n", port->name);
+		goto err_unregister_dev;
+	}
+
+	device->source = pps_register_source(&info,
+			PPS_CAPTUREBOTH | PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
+	if (device->source < 0) {
+		pr_err(DRVNAME ": couldn't register PPS source\n");
+		goto err_release_dev;
+	}
+
+	port->ops->enable_irq(port);
+
+	pr_info(DRVNAME ": attached to %s\n", port->name);
+
+	return;
+
+err_release_dev:
+	parport_release(device->pardev);
+err_unregister_dev:
+	parport_unregister_device(device->pardev);
+err_free:
+	kfree(device);
+}
+
+static void parport_detach(struct parport *port)
+{
+	struct pardevice *pardev = port->cad;
+	struct pps_client_pp *device;
+
+	/* oooh, this is ugly! */
+	if (strcmp(pardev->name, DRVNAME))
+		/* not our port */
+		return;
+
+	device = pardev->private;
+
+	port->ops->disable_irq(port);
+	pps_unregister_source(device->source);
+	parport_release(pardev);
+	parport_unregister_device(pardev);
+	kfree(device);
+}
+
+static struct parport_driver pps_parport_driver = {
+	.name = DRVNAME,
+	.attach = parport_attach,
+	.detach = parport_detach,
+};
+
+/* module staff */
+
+static int __init pps_parport_init(void)
+{
+	int ret;
+
+	pr_info(DRVNAME ": " DRVDESC "\n");
+
+	ret = parport_register_driver(&pps_parport_driver);
+	if (ret) {
+		pr_err(DRVNAME ": unable to register with parport\n");
+		return ret;
+	}
+
+	return  0;
+}
+
+static void __exit pps_parport_exit(void)
+{
+	parport_unregister_driver(&pps_parport_driver);
+}
+
+module_init(pps_parport_init);
+module_exit(pps_parport_exit);
+
+MODULE_AUTHOR("Alexander Gordeev <lasaine@lvk.cs.msu.su>");
+MODULE_DESCRIPTION(DRVDESC);
+MODULE_LICENSE("GPL");
-- 
1.6.6.1

