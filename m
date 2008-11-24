Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbYKXQDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbYKXQDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYKXQBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:01:23 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:58641 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbYKXQBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:01:18 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Rodolfo Giometti <giometti@linux.it>
Date: Mon, 24 Nov 2008 17:00:50 +0100
Message-Id: <1227542451-31969-9-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227542451-31969-8-git-send-email-giometti@linux.it>
References: <>
 <1227542451-31969-1-git-send-email-giometti@linux.it>
 <1227542451-31969-2-git-send-email-giometti@linux.it>
 <1227542451-31969-3-git-send-email-giometti@linux.it>
 <1227542451-31969-4-git-send-email-giometti@linux.it>
 <1227542451-31969-5-git-send-email-giometti@linux.it>
 <1227542451-31969-6-git-send-email-giometti@linux.it>
 <1227542451-31969-7-git-send-email-giometti@linux.it>
 <1227542451-31969-8-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 8/9] PPS: parallel port clients support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for the PPS sources connected with the interrupt pin of a
parallel port.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/char/lp.c           |   61 +++++++++++++++++++++++++++++++++++++++++++
 drivers/pps/clients/Kconfig |   10 +++++++
 include/linux/parport.h     |   22 +++++++++++++++
 3 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index e444c2d..dca8a39 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -760,6 +760,27 @@ static struct console lpcons = {
 
 #endif /* console on line printer */
 
+/* Support for PPS signal on the line printer */
+
+#ifdef CONFIG_PPS_CLIENT_LP
+
+static void lp_pps_echo(int source, int event, void *data)
+{
+	struct parport *port = data;
+	unsigned char status = parport_read_status(port);
+
+	/* echo event via SEL bit */
+	parport_write_control(port,
+		parport_read_control(port) | PARPORT_CONTROL_SELECT);
+
+	/* signal no event */
+	if ((status & PARPORT_STATUS_ACK) != 0)
+		parport_write_control(port,
+			parport_read_control(port) & ~PARPORT_CONTROL_SELECT);
+}
+
+#endif
+
 /* --- initialisation code ------------------------------------- */
 
 static int parport_nr[LP_NO] = { [0 ... LP_NO-1] = LP_PARPORT_UNSPEC };
@@ -831,6 +852,38 @@ static int lp_register(int nr, struct parport *port)
 	}
 #endif
 
+#ifdef CONFIG_PPS_CLIENT_LP
+	port->pps_info.owner = THIS_MODULE;
+	port->pps_info.dev = port->dev;
+	snprintf(port->pps_info.path, PPS_MAX_NAME_LEN, "/dev/lp%d", nr);
+
+	/* No PPS support if lp port has no IRQ line */
+	if (port->irq != PARPORT_IRQ_NONE) {
+		strncpy(port->pps_info.name, port->name, PPS_MAX_NAME_LEN);
+
+		port->pps_info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
+				PPS_ECHOASSERT | \
+				PPS_CANWAIT | PPS_TSFMT_TSPEC;
+
+		port->pps_info.echo = lp_pps_echo;
+
+		port->pps_source = pps_register_source(&(port->pps_info),
+				PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
+		if (port->pps_source < 0)
+			dev_err(port->dev,
+					"cannot register PPS source \"%s\"\n",
+					port->pps_info.path);
+		else
+			dev_info(port->dev, "PPS source #%d \"%s\" added\n",
+					port->pps_source, port->pps_info.path);
+	} else {
+		port->pps_source = -1;
+		dev_err(port->dev, "PPS support disabled because port \"%s\" "
+					"is in polling mode\n",
+					port->pps_info.path);
+	}
+#endif
+
 	return 0;
 }
 
@@ -873,6 +926,14 @@ static void lp_detach (struct parport *port)
 		console_registered = NULL;
 	}
 #endif /* CONFIG_LP_CONSOLE */
+
+#ifdef CONFIG_PPS_CLIENT_LP
+	if (port->pps_source >= 0) {
+		pps_unregister_source(port->pps_source);
+		dev_dbg(port->dev, "PPS source #%d \"%s\" removed\n",
+			port->pps_source, port->pps_info.path);
+	}
+#endif
 }
 
 static struct parport_driver lp_driver = {
diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
index 487c1c8..b4054cd 100644
--- a/drivers/pps/clients/Kconfig
+++ b/drivers/pps/clients/Kconfig
@@ -22,4 +22,14 @@ config PPS_CLIENT_LDISC
 	  If you say yes here you get support for a PPS source connected
 	  with the CD (Carrier Detect) pin of your serial port.
 
+comment "Parallel printer support (forced off)"
+	depends on !( PRINTER != n && !(PPS = m && PRINTER = y))
+
+config PPS_CLIENT_LP
+	bool "Parallel printer support"
+	depends on PRINTER != n && !(PPS = m && PRINTER = y)
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the interrupt pin of your parallel port.
+
 endif
diff --git a/include/linux/parport.h b/include/linux/parport.h
index e1f83c5..4276941 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -98,6 +98,7 @@ typedef enum {
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
+#include <linux/pps.h>
 #include <linux/irqreturn.h>
 #include <linux/semaphore.h>
 #include <asm/system.h>
@@ -326,6 +327,11 @@ struct parport {
 
 	struct list_head full_list;
 	struct parport *slaves[3];
+
+#ifdef CONFIG_PPS_CLIENT_LP
+	struct pps_source_info pps_info;
+	int pps_source;		/* PPS source ID */
+#endif
 };
 
 #define DEFAULT_SPIN_TIME 500 /* us */
@@ -514,6 +520,22 @@ extern int parport_daisy_select (struct parport *port, int daisy, int mode);
 /* Lowlevel drivers _can_ call this support function to handle irqs.  */
 static inline void parport_generic_irq(struct parport *port)
 {
+#ifdef CONFIG_PPS_CLIENT_LP
+	struct timespec __ts;
+	struct pps_ktime ts;
+
+	/* First of all we get the time stamp... */
+	getnstimeofday(&__ts);
+
+	/* ... and translate it to PPS time data struct */
+	ts.sec = __ts.tv_sec;
+	ts.nsec = __ts.tv_nsec;
+
+	pps_event(port->pps_source, &ts, PPS_CAPTUREASSERT, port);
+	dev_dbg(port->dev, "PPS assert at %lu on source #%d\n",
+		jiffies, port->pps_source);
+#endif
+
 	parport_ieee1284_interrupt (port);
 	read_lock(&port->cad_lock);
 	if (port->cad && port->cad->irq_func)
-- 
1.5.4.3

