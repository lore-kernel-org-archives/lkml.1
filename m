Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbYKDWT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbYKDWT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYKDWTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:19:20 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44114 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbYKDWTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:19:19 -0500
Message-ID: <4910CA5A.2000209@linux.vnet.ibm.com>
Date: Tue, 04 Nov 2008 15:19:06 -0700
From: Chris J Arges <arges@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 2.6.28-rc3] pmac_zilog: console polling support
Content-Type: multipart/mixed;
 boundary="------------060201080701010006090103"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060201080701010006090103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds console polling support for the pmac_zilog serial driver.



--------------060201080701010006090103
Content-Type: text/x-patch;
 name="0001-pmac_zilog-console-polling-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-pmac_zilog-console-polling-support.patch"

>From e768d25cfa8e1f4a1eebb8fb69930c2ef64da2cb Mon Sep 17 00:00:00 2001
From: Chris J Arges <arges@linux.vnet.ibm.com>
Date: Tue, 4 Nov 2008 15:10:37 -0600
Subject: [PATCH] pmac_zilog console polling support

Implemented poll_get_char and poll_put_char for console polling which then
enables kgdb to work on machines (for example the Apple PowerMac G5) that use
the pmac_zilog serial driver.
---
 drivers/serial/pmac_zilog.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/pmac_zilog.c b/drivers/serial/pmac_zilog.c
index 317b061..ad34885 100644
--- a/drivers/serial/pmac_zilog.c
+++ b/drivers/serial/pmac_zilog.c
@@ -1383,6 +1383,29 @@ static int pmz_verify_port(struct uart_port *port, struct serial_struct *ser)
 	return -EINVAL;
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+
+static int pmz_poll_get_char(struct uart_port *port)
+{
+	struct uart_pmac_port *uap = (struct uart_pmac_port *)port;
+
+	while ((read_zsreg(uap, R0) & Rx_CH_AV) == 0)
+		udelay(5);
+	return read_zsdata(uap);
+}
+
+static void pmz_poll_put_char(struct uart_port *port, unsigned char c)
+{
+	struct uart_pmac_port *uap = (struct uart_pmac_port *)port;
+
+	/* Wait for the transmit buffer to empty. */
+	while ((read_zsreg(uap, R0) & Tx_BUF_EMP) == 0)
+		udelay(5);
+	write_zsdata(uap, c);
+}
+
+#endif
+
 static struct uart_ops pmz_pops = {
 	.tx_empty	=	pmz_tx_empty,
 	.set_mctrl	=	pmz_set_mctrl,
@@ -1400,6 +1423,10 @@ static struct uart_ops pmz_pops = {
 	.request_port	=	pmz_request_port,
 	.config_port	=	pmz_config_port,
 	.verify_port	=	pmz_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char	=	pmz_poll_get_char,
+	.poll_put_char	=	pmz_poll_put_char,
+#endif
 };
 
 /*
-- 
1.5.4.5

Signed-off-by: Chris J Arges <arges@linux.vnet.ibm.com>


--------------060201080701010006090103--
