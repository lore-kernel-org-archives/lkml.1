Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab0BYMli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 07:41:38 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:59959 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab0BYMlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 07:41:35 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>,
       Rodolfo Giometti <giometti@linux.it>
Date: Thu, 25 Feb 2010 13:41:09 +0100
Message-Id: <1267101671-23575-5-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267101671-23575-4-git-send-email-giometti@linux.it>
References: <1267101671-23575-1-git-send-email-giometti@linux.it>
 <1267101671-23575-2-git-send-email-giometti@linux.it>
 <1267101671-23575-3-git-send-email-giometti@linux.it>
 <1267101671-23575-4-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 4/6] pps: serial clients support.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support, by using the PPS line discipline, for the PPS sources
connected with the CD (Carrier Detect) pin of a serial port.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/pps/clients/Kconfig     |    7 ++
 drivers/pps/clients/Makefile    |    1 +
 drivers/pps/clients/pps-ldisc.c |  154 +++++++++++++++++++++++++++++++++++++++
 include/linux/serial_core.h     |   11 +++-
 4 files changed, 172 insertions(+), 1 deletions(-)
 create mode 100644 drivers/pps/clients/pps-ldisc.c

diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
index 43ccd3b..4e801bd 100644
--- a/drivers/pps/clients/Kconfig
+++ b/drivers/pps/clients/Kconfig
@@ -15,4 +15,11 @@ config PPS_CLIENT_KTIMER
 	  This driver can also be built as a module.  If so, the module
 	  will be called pps-ktimer.
 
+config PPS_CLIENT_LDISC
+	tristate "PPS line discipline"
+	depends on PPS
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the CD (Carrier Detect) pin of your serial port.
+
 endif
diff --git a/drivers/pps/clients/Makefile b/drivers/pps/clients/Makefile
index 115572a..812c9b1 100644
--- a/drivers/pps/clients/Makefile
+++ b/drivers/pps/clients/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= pps-ktimer.o
+obj-$(CONFIG_PPS_CLIENT_LDISC)	+= pps-ldisc.o
 
 ifeq ($(CONFIG_PPS_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
new file mode 100644
index 0000000..2607d0b
--- /dev/null
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -0,0 +1,154 @@
+/*
+ * pps-ldisc.c -- PPS line discipline
+ *
+ *
+ * Copyright (C) 2008	Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/serial_core.h>
+#include <linux/tty.h>
+#include <linux/pps_kernel.h>
+
+#define PPS_TTY_MAGIC		0x0001
+
+static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
+				struct timespec *ts)
+{
+	int id = (int) tty->disc_data;
+	struct timespec __ts;
+	struct pps_ktime pps_ts;
+
+	/* First of all we get the time stamp... */
+	getnstimeofday(&__ts);
+
+	/* Does caller give us a timestamp? */
+	if (ts) {	/* Yes. Let's use it! */
+		pps_ts.sec = ts->tv_sec;
+		pps_ts.nsec = ts->tv_nsec;
+	} else {	/* No. Do it ourself! */
+		pps_ts.sec = __ts.tv_sec;
+		pps_ts.nsec = __ts.tv_nsec;
+	}
+
+	/* Now do the PPS event report */
+	pps_event(id, &pps_ts, status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR,
+			NULL);
+
+	pr_debug("PPS %s at %lu on source #%d\n",
+			status ? "assert" : "clear", jiffies, id);
+}
+
+static int (*alias_n_tty_open)(struct tty_struct *tty);
+
+static int pps_tty_open(struct tty_struct *tty)
+{
+	struct pps_source_info info;
+	struct tty_driver *drv = tty->driver;
+	int index = tty->index + drv->name_base;
+	int ret;
+
+	info.owner = THIS_MODULE;
+	info.dev = NULL;
+	snprintf(info.name, PPS_MAX_NAME_LEN, "%s%d", drv->driver_name, index);
+	snprintf(info.path, PPS_MAX_NAME_LEN, "/dev/%s%d", drv->name, index);
+	info.mode = PPS_CAPTUREBOTH | \
+			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
+			PPS_CANWAIT | PPS_TSFMT_TSPEC;
+
+	ret = pps_register_source(&info, PPS_CAPTUREBOTH | \
+				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
+	if (ret < 0) {
+		pr_err("cannot register PPS source \"%s\"\n", info.path);
+		return ret;
+	}
+	tty->disc_data = (void *) ret;
+
+	/* Should open N_TTY ldisc too */
+	ret = alias_n_tty_open(tty);
+	if (ret < 0)
+		pps_unregister_source((int) tty->disc_data);
+
+	pr_info("PPS source #%d \"%s\" added\n", ret, info.path);
+
+	return 0;
+}
+
+static void (*alias_n_tty_close)(struct tty_struct *tty);
+
+static void pps_tty_close(struct tty_struct *tty)
+{
+	int id = (int) tty->disc_data;
+
+	pps_unregister_source(id);
+	alias_n_tty_close(tty);
+
+	pr_info("PPS source #%d removed\n", id);
+}
+
+static struct tty_ldisc_ops pps_ldisc_ops;
+
+/*
+ * Module stuff
+ */
+
+static int __init pps_tty_init(void)
+{
+	int err;
+
+	/* Inherit the N_TTY's ops */
+	n_tty_inherit_ops(&pps_ldisc_ops);
+
+	/* Save N_TTY's open()/close() methods */
+	alias_n_tty_open = pps_ldisc_ops.open;
+	alias_n_tty_close = pps_ldisc_ops.close;
+
+	/* Init PPS_TTY data */
+	pps_ldisc_ops.owner = THIS_MODULE;
+	pps_ldisc_ops.magic = PPS_TTY_MAGIC;
+	pps_ldisc_ops.name = "pps_tty";
+	pps_ldisc_ops.dcd_change = pps_tty_dcd_change;
+	pps_ldisc_ops.open = pps_tty_open;
+	pps_ldisc_ops.close = pps_tty_close;
+
+	err = tty_register_ldisc(N_PPS, &pps_ldisc_ops);
+	if (err)
+		pr_err("can't register PPS line discipline\n");
+	else
+		pr_info("PPS line discipline registered\n");
+
+	return err;
+}
+
+static void __exit pps_tty_cleanup(void)
+{
+	int err;
+
+	err = tty_unregister_ldisc(N_PPS);
+	if (err)
+		pr_err("can't unregister PPS line discipline\n");
+	else
+		pr_info("PPS line discipline removed\n");
+}
+
+module_init(pps_tty_init);
+module_exit(pps_tty_cleanup);
+
+MODULE_ALIAS_LDISC(N_PPS);
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("PPS TTY device driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 8c3dd36..78dd1e7 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -491,9 +491,13 @@ uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 {
 	struct uart_state *state = uport->state;
 	struct tty_port *port = &state->port;
+	struct tty_ldisc *ld = tty_ldisc_ref(port->tty);
+	struct timespec ts;
 
-	uport->icount.dcd++;
+	if (ld && ld->ops->dcd_change)
+		getnstimeofday(&ts);
 
+	uport->icount.dcd++;
 #ifdef CONFIG_HARD_PPS
 	if ((uport->flags & UPF_HARDPPS_CD) && status)
 		hardpps();
@@ -505,6 +509,11 @@ uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 		else if (port->tty)
 			tty_hangup(port->tty);
 	}
+
+	if (ld && ld->ops->dcd_change)
+		ld->ops->dcd_change(port->tty, status, &ts);
+	if (ld)
+		tty_ldisc_deref(ld);
 }
 
 /**
-- 
1.6.3.3

