Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446AbZGaPJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbZGaPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 11:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZGaPJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 11:09:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:43576 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbZGaPJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 11:09:24 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       dbrownell@users.sourceforge.net
Subject: [PATCH 08/10] ehci-dbgp: errata for EHCI debug controller initialization
Date: Fri, 31 Jul 2009 10:07:11 -0500
Message-Id: <1249052833-9655-9-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.3.523.g304d0
In-Reply-To: <1249052833-9655-8-git-send-email-jason.wessel@windriver.com>
References: <1249052833-9655-1-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-2-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-3-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-4-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-5-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-6-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-7-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-8-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 31 Jul 2009 15:07:32.0159 (UTC) FILETIME=[A0D494F0:01CA11F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some EHCI usb debug controllers, the EHCI debug device will fail to
be seen after a port reset, after a warm reset.  Two options exist to
get the device to initialize correctly.

Option 1 is to unplug and plug in the device.

Option 2 is to use the EHCI port test to get the usb debug device to
start talking again.  At that point the debug controller port reset
will succeed.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
CC: dbrownell@users.sourceforge.net
---
 drivers/usb/early/ehci-dbgp.c |   23 ++++++++++++++++++++++-
 include/linux/usb/ehci_def.h  |    1 +
 2 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/early/ehci-dbgp.c b/drivers/usb/early/ehci-dbgp.c
index b88cb65..f0a41c6 100644
--- a/drivers/usb/early/ehci-dbgp.c
+++ b/drivers/usb/early/ehci-dbgp.c
@@ -478,10 +478,13 @@ int dbgp_external_startup(void)
 	int devnum;
 	struct usb_debug_descriptor dbgp_desc;
 	int ret;
-	u32 ctrl, portsc;
+	u32 ctrl, portsc, cmd;
 	int dbg_port = dbgp_phys_port;
 	int tries = 3;
+	int reset_port_tries = 1;
+	int try_hard_once = 1;
 
+try_port_reset_again:
 	ret = dbgp_ehci_startup();
 	if (ret)
 		return ret;
@@ -490,6 +493,24 @@ int dbgp_external_startup(void)
 	ret = ehci_wait_for_port(dbg_port);
 	if (ret < 0) {
 		portsc = readl(&ehci_regs->port_status[dbg_port - 1]);
+		if (!(portsc & PORT_CONNECT) && try_hard_once) {
+			/* Last ditch effort to try to force enable
+			 * the debug device by using the packet test
+			 * ehci command to try and wake it up. */
+			try_hard_once = 0;
+			cmd = readl(&ehci_regs->command);
+			cmd &= ~CMD_RUN;
+			writel(cmd, &ehci_regs->command);
+			portsc = readl(&ehci_regs->port_status[dbg_port - 1]);
+			portsc |= PORT_TEST_PKT;
+			writel(portsc, &ehci_regs->port_status[dbg_port - 1]);
+			dbgp_ehci_status("Trying to force debug port online");
+			mdelay(50);
+			dbgp_ehci_controller_reset();
+			goto try_port_reset_again;
+		} else if (reset_port_tries--) {
+			goto try_port_reset_again;
+		}
 		dbgp_printk("No device found in debug port\n");
 		return -EIO;
 	}
diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
index 7290daf..f62576c 100644
--- a/include/linux/usb/ehci_def.h
+++ b/include/linux/usb/ehci_def.h
@@ -105,6 +105,7 @@ struct ehci_regs {
 #define PORT_WKDISC_E	(1<<21)		/* wake on disconnect (enable) */
 #define PORT_WKCONN_E	(1<<20)		/* wake on connect (enable) */
 /* 19:16 for port testing */
+#define PORT_TEST_PKT	(0x4<<16)	/* Port Test Control - packet test */
 #define PORT_LED_OFF	(0<<14)
 #define PORT_LED_AMBER	(1<<14)
 #define PORT_LED_GREEN	(2<<14)
-- 
1.6.0.3.523.g304d0

