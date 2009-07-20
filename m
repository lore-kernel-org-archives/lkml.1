Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZGTUJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZGTUJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbZGTUJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:09:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:36192 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbZGTUJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:09:46 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       dbrownell@users.sourceforge.net
Subject: [PATCH 08/10] ehci-dbgp: errata for EHCI debug controller initialization
Date: Mon, 20 Jul 2009 15:06:30 -0500
Message-Id: <1248120392-8372-9-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.3.523.g304d0
In-Reply-To: <1248120392-8372-8-git-send-email-jason.wessel@windriver.com>
References: <1248120392-8372-1-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-2-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-3-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-4-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-5-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-6-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-7-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-8-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 20 Jul 2009 20:07:03.0504 (UTC) FILETIME=[A60AF500:01CA0975]
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
index 279d48b..209cf36 100644
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

