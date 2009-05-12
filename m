Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZELWdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZELWdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZELWch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:32:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:57580 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbZELWcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:32:35 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, oliver@neukum.org, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/2] usb_serial: Run the sysrq handler in a tasklet
Date: Tue, 12 May 2009 17:32:20 -0500
Message-Id: <1242167540-23585-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.9.g6345d
In-Reply-To: <1242167540-23585-2-git-send-email-jason.wessel@windriver.com>
References: <1242167540-23585-1-git-send-email-jason.wessel@windriver.com>
 <1242167540-23585-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 May 2009 22:32:25.0346 (UTC) FILETIME=[8629AE20:01C9D351]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a sysrq is processed on the while holding the usb hcd lock, it is
impossible to drain the queue of urbs via the polling interface and
all the printk output is lost.

Using a tasklet to schedule the sysrq allows the hcd device lock to
free up.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/generic.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index df56ed3..7554d71 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -527,11 +527,42 @@ void usb_serial_generic_unthrottle(struct tty_struct *tty)
 	}
 }
 
+#ifdef CONFIG_MAGIC_SYSRQ
+/* The sysrq tasklet is used to make the sysrq request not occur with
+ * the hcd device lock held.
+ */
+static struct usb_sysrq_data {
+	struct tty_struct *tty;
+	unsigned int ch;
+	int pending;
+} priv_usb_sysrq;
+
+static void usb_sysrq_task(unsigned long args)
+{
+	handle_sysrq(priv_usb_sysrq.ch, priv_usb_sysrq.tty);
+	priv_usb_sysrq.pending = 0;
+}
+static DECLARE_TASKLET(usb_sysrq_tasklet, usb_sysrq_task, 0);
+
+void usb_serial_generic_sysrq_invoke(struct usb_serial_port *port,
+				     unsigned int ch)
+{
+	if (priv_usb_sysrq.pending)
+		return;
+	priv_usb_sysrq.pending = 1;
+	priv_usb_sysrq.ch = ch;
+	priv_usb_sysrq.tty = tty_port_tty_get(&port->port);
+	tasklet_schedule(&usb_sysrq_tasklet);
+}
+#else
+static void usb_serial_generic_sysrq_invoke() {}
+#endif /* CONFIG_SYSRQ */
+
 int usb_serial_handle_sysrq_char(struct usb_serial_port *port, unsigned int ch)
 {
 	if (port->sysrq) {
 		if (ch && time_before(jiffies, port->sysrq)) {
-			handle_sysrq(ch, tty_port_tty_get(&port->port));
+			usb_serial_generic_sysrq_invoke(port, ch);
 			port->sysrq = 0;
 			return 1;
 		}
-- 
1.6.3.9.g6345d

