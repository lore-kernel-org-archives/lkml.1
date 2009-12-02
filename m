Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZLBRTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZLBRTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbZLBRTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:19:20 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:42291 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbZLBRTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:19:12 -0500
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
       Rodolfo Giometti <giometti@linux.it>
Date: Wed,  2 Dec 2009 18:18:44 +0100
Message-Id: <1259774329-29663-7-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259774329-29663-6-git-send-email-giometti@linux.it>
References: <1259774329-29663-1-git-send-email-giometti@linux.it>
 <1259774329-29663-2-git-send-email-giometti@linux.it>
 <1259774329-29663-3-git-send-email-giometti@linux.it>
 <1259774329-29663-4-git-send-email-giometti@linux.it>
 <1259774329-29663-5-git-send-email-giometti@linux.it>
 <1259774329-29663-6-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 06/11] pps: serial clients support.
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
 drivers/pps/clients/pps-ldisc.c |  155 +++++++++++++++++++++++++++++++++++++++
 include/linux/serial_core.h     |   11 +++-
 4 files changed, 173 insertions(+), 1 deletions(-)
 create mode 100644 drivers/pps/clients/pps-ldisc.c

diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
index 60b83be..487c1c8 100644
--- a/drivers/pps/clients/Kconfig
+++ b/drivers/pps/clients/Kconfig
@@ -15,4 +15,11 @@ config PPS_CLIENT_KTIMER
 	  This driver can also be built as a module.  If so, the module
 	  will be called ktimer.ko.
 
+config PPS_CLIENT_LDISC
+	tristate "PPS line discipline"
+	depends on PPS
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the CD (Carrier Detect) pin of your serial port.
+
 endif
diff --git a/drivers/pps/clients/Makefile b/drivers/pps/clients/Makefile
index f3c1e39..9f5b988 100644
--- a/drivers/pps/clients/Makefile
+++ b/drivers/pps/clients/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= ktimer.o
+obj-$(CONFIG_PPS_CLIENT_LDISC)	+= pps-ldisc.o
 
 ifeq ($(CONFIG_PPS_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
new file mode 100644
index 0000000..c2a7be6
--- /dev/null
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -0,0 +1,155 @@
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
+	ret = n_tty_open(tty);
+	if (ret < 0)
+		pps_unregister_source((int) tty->disc_data);
+
+	pr_info("PPS source #%d \"%s\" added\n", ret, info.path);
+
+	return 0;
+}
+
+static void pps_tty_close(struct tty_struct *tty)
+{
+	int id = (int) tty->disc_data;
+
+	pps_unregister_source(id);
+	n_tty_close(tty);
+
+	pr_info("PPS source #%d removed\n", id);
+}
+
+struct tty_ldisc_ops pps_ldisc_ops = {
+	.owner		= THIS_MODULE,
+	.magic		= PPS_TTY_MAGIC,
+	.name		= "pps_tty",
+	.dcd_change	= pps_tty_dcd_change,
+	.open		= pps_tty_open,
+	.close		= pps_tty_close,
+
+	/* Now we should use N_TTY ldisc methods in order to have
+	 * normal tty behaviour
+	 */
+	.flush_buffer	= n_tty_flush_buffer,
+	.chars_in_buffer = n_tty_chars_in_buffer,
+	.read		= n_tty_read,
+	.write		= n_tty_write,
+	.ioctl		= n_tty_ioctl_helper,
+	.set_termios	= n_tty_set_termios,
+	.poll		= n_tty_poll,
+	.receive_buf	= n_tty_receive_buf,
+	.write_wakeup	= n_tty_write_wakeup
+};
+
+/*
+ * Module stuff
+ */
+
+static int __init pps_tty_init(void)
+{
+	int err;
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
index db532ce..4bfb046 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -488,9 +488,13 @@ uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
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
@@ -502,6 +506,11 @@ uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
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

