Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZGTUJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZGTUJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbZGTUJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:09:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:36138 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbZGTUJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:09:32 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 04/10] usb,early_printk: EHCI debug controller initialization delays
Date: Mon, 20 Jul 2009 15:06:26 -0500
Message-Id: <1248120392-8372-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.3.523.g304d0
In-Reply-To: <1248120392-8372-4-git-send-email-jason.wessel@windriver.com>
References: <1248120392-8372-1-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-2-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-3-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 20 Jul 2009 20:06:40.0926 (UTC) FILETIME=[9895D3E0:01CA0975]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the EHCI host controller as a polled device, a bit more
tolerance is required in terms of delays.  On some 3+ghz systems the
cpu loops were faster than the EHCI device mmio and resulted in the
controller failing to initialize.

On at least one first generation EHCI controller when it was not
operating in interrupt mode, it would fail to report a port change
status, but executing the port reset allowed the debug controller to
work correctly anyway.  This errata causes a one time 300ms delay in
the boot time, where as the typical delay is 1-5ms for an EHCI
controller that does not have this errata.

The debug printk's were fixed to have the correct state messages, and
there was a conversion from using early_printk to printk to avoid
calling the dbgp driver while debugging the initialization.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/usb/early/ehci-dbgp.c |   45 +++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/early/ehci-dbgp.c b/drivers/usb/early/ehci-dbgp.c
index f4bfe31..6198ebd 100644
--- a/drivers/usb/early/ehci-dbgp.c
+++ b/drivers/usb/early/ehci-dbgp.c
@@ -9,6 +9,12 @@
 #include <asm/pci-direct.h>
 #include <asm/fixmap.h>
 
+#ifdef DBGP_DEBUG
+# define dbgp_printk printk
+#else
+static inline void dbgp_printk(const char *fmt, ...) { }
+#endif
+
 static struct ehci_caps __iomem *ehci_caps;
 static struct ehci_regs __iomem *ehci_regs;
 static struct ehci_dbg_port __iomem *ehci_debug;
@@ -342,6 +348,7 @@ static int __init ehci_reset_port(int port)
 	u32 delay_time, delay;
 	int loop;
 
+	dbgp_printk("ehci_reset_port %i\n", port);
 	/* Reset the usb debug port */
 	portsc = readl(&ehci_regs->port_status[port - 1]);
 	portsc &= ~PORT_PE;
@@ -352,14 +359,17 @@ static int __init ehci_reset_port(int port)
 	for (delay_time = 0; delay_time < HUB_RESET_TIMEOUT;
 	     delay_time += delay) {
 		dbgp_mdelay(delay);
-
 		portsc = readl(&ehci_regs->port_status[port - 1]);
+		if (!(portsc & PORT_RESET))
+			break;
+	}
 		if (portsc & PORT_RESET) {
 			/* force reset to complete */
-			loop = 2;
+			loop = 100 * 1000;
 			writel(portsc & ~(PORT_RWC_BITS | PORT_RESET),
 				&ehci_regs->port_status[port - 1]);
 			do {
+				udelay(1);
 				portsc = readl(&ehci_regs->port_status[port-1]);
 			} while ((portsc & PORT_RESET) && (--loop > 0));
 		}
@@ -375,7 +385,6 @@ static int __init ehci_reset_port(int port)
 		/* If we've finished resetting, then break out of the loop */
 		if (!(portsc & PORT_RESET) && (portsc & PORT_PE))
 			return 0;
-	}
 	return -EBUSY;
 }
 
@@ -384,24 +393,18 @@ static int __init ehci_wait_for_port(int port)
 	u32 status;
 	int ret, reps;
 
-	for (reps = 0; reps < 3; reps++) {
-		dbgp_mdelay(100);
+	for (reps = 0; reps < 300; reps++) {
 		status = readl(&ehci_regs->status);
-		if (status & STS_PCD) {
-			ret = ehci_reset_port(port);
-			if (ret == 0)
-				return 0;
-		}
+		if (status & STS_PCD)
+			break;
+		dbgp_mdelay(1);
 	}
+	ret = ehci_reset_port(port);
+	if (ret == 0)
+		return 0;
 	return -ENOTCONN;
 }
 
-#ifdef DBGP_DEBUG
-# define dbgp_printk early_printk
-#else
-static inline void dbgp_printk(const char *fmt, ...) { }
-#endif
-
 typedef void (*set_debug_port_t)(int port);
 
 static void __init default_set_debug_port(int port)
@@ -520,7 +523,7 @@ try_next_port:
 		return -1;
 	}
 
-	loop = 10;
+	loop = 250 * 1000;
 	/* Reset the EHCI controller */
 	cmd = readl(&ehci_regs->command);
 	cmd |= CMD_RESET;
@@ -540,6 +543,7 @@ try_next_port:
 	ctrl |= DBGP_OWNER;
 	ctrl &= ~(DBGP_ENABLED | DBGP_INUSE);
 	writel(ctrl, &ehci_debug->control);
+	udelay(1);
 
 	/* Start the ehci running */
 	cmd = readl(&ehci_regs->command);
@@ -554,10 +558,13 @@ try_next_port:
 	loop = 10;
 	do {
 		status = readl(&ehci_regs->status);
-	} while ((status & STS_HALT) && (--loop > 0));
+		if (!(status & STS_HALT))
+			break;
+		udelay(1);
+	} while (--loop > 0);
 
 	if (!loop) {
-		dbgp_printk("ehci can be started\n");
+		dbgp_printk("ehci can not be started\n");
 		return -1;
 	}
 	dbgp_printk("ehci started\n");
-- 
1.6.0.3.523.g304d0

