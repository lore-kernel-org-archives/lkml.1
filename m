Return-Path: <linux-kernel-owner+w=401wt.eu-S935833AbYBVOE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935833AbYBVOE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935624AbYBVOBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:01:16 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:36456 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935586AbYBVOBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:01:13 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Rodolfo Giometti <giometti@linux.it>
Date: Fri, 22 Feb 2008 15:03:33 +0100
Message-Id: <12036890141304-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12036890142501-git-send-email-giometti@linux.it>
References: <12036890132090-git-send-email-giometti@linux.it>
 <1203689013811-git-send-email-giometti@linux.it>
 <12036890131940-git-send-email-giometti@linux.it>
 <12036890133944-git-send-email-giometti@linux.it>
 <12036890141964-git-send-email-giometti@linux.it>
 <12036890142414-git-send-email-giometti@linux.it>
 <12036890142501-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] PPS: parallel port clients support.
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
 include/linux/parport.h     |   12 ++++++++
 3 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index 60ac642..b201fed 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -746,6 +746,27 @@ static struct console lpcons = {
 
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
@@ -816,6 +837,38 @@ static int lp_register(int nr, struct parport *port)
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
 
@@ -858,6 +911,14 @@ static void lp_detach (struct parport *port)
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
index 517c338..09ba5c3 100644
--- a/drivers/pps/clients/Kconfig
+++ b/drivers/pps/clients/Kconfig
@@ -25,4 +25,14 @@ config PPS_CLIENT_UART
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
index d1ad546..501a9dc 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -100,6 +100,7 @@ typedef enum {
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
+#include <linux/pps.h>
 #include <linux/irqreturn.h>
 #include <asm/system.h>
 #include <asm/ptrace.h>
@@ -328,6 +329,11 @@ struct parport {
 
 	struct list_head full_list;
 	struct parport *slaves[3];
+
+#ifdef CONFIG_PPS_CLIENT_LP
+	struct pps_source_info pps_info;
+	int pps_source;		/* PPS source ID */
+#endif
 };
 
 #define DEFAULT_SPIN_TIME 500 /* us */
@@ -516,6 +522,12 @@ extern int parport_daisy_select (struct parport *port, int daisy, int mode);
 /* Lowlevel drivers _can_ call this support function to handle irqs.  */
 static inline void parport_generic_irq(struct parport *port)
 {
+#ifdef CONFIG_PPS_CLIENT_LP
+	pps_event(port->pps_source, PPS_CAPTUREASSERT, port);
+	dev_dbg(port->dev, "PPS assert at %lu on source #%d\n",
+		jiffies, port->pps_source);
+#endif
+
 	parport_ieee1284_interrupt (port);
 	read_lock(&port->cad_lock);
 	if (port->cad && port->cad->irq_func)
-- 
1.5.2.5

