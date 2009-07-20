Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZGTUJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZGTUJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZGTUJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:09:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:36140 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbZGTUJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:09:33 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       dbrownell@users.sourceforge.net, Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 03/10] ehci-dbgp: Execute early BIOS hand off
Date: Mon, 20 Jul 2009 15:06:25 -0500
Message-Id: <1248120392-8372-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.3.523.g304d0
In-Reply-To: <1248120392-8372-3-git-send-email-jason.wessel@windriver.com>
References: <1248120392-8372-1-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-2-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 20 Jul 2009 20:06:39.0785 (UTC) FILETIME=[97E7B990:01CA0975]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI quirk code executes a BIOS hand off to obtain full control of
the EHCI host controller, the self contained ehci-dbgp driver must do
the same thing using the early PCI API, else the BIOS can cause a
fatal fault.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: dbrownell@users.sourceforge.net
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/usb/early/ehci-dbgp.c |   49 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/early/ehci-dbgp.c b/drivers/usb/early/ehci-dbgp.c
index 51ec414..f4bfe31 100644
--- a/drivers/usb/early/ehci-dbgp.c
+++ b/drivers/usb/early/ehci-dbgp.c
@@ -435,6 +435,53 @@ static void __init detect_set_debug_port(void)
 	}
 }
 
+/* The code in early_ehci_bios_handoff() is derived from the usb pci
+ * quirk initialization, but altered so as to use the early PCI
+ * routines. */
+#define EHCI_USBLEGSUP_BIOS	(1 << 16)	/* BIOS semaphore */
+#define EHCI_USBLEGCTLSTS	4		/* legacy control/status */
+static void __init early_ehci_bios_handoff(void)
+{
+	u32 hcc_params = readl(&ehci_caps->hcc_params);
+	int offset = (hcc_params >> 8) & 0xff;
+	u32 cap;
+	int msec;
+
+	if (!offset)
+		return;
+
+	cap = read_pci_config(ehci_dev.bus, ehci_dev.slot,
+			      ehci_dev.func, offset);
+	dbgp_printk("dbgp: ehci BIOS state %08x\n", cap);
+
+	if ((cap & 0xff) == 1 && (cap & EHCI_USBLEGSUP_BIOS)) {
+		dbgp_printk("dbgp: BIOS handoff\n");
+		write_pci_config_byte(ehci_dev.bus, ehci_dev.slot,
+				      ehci_dev.func, offset + 3, 1);
+	}
+
+	/* if boot firmware now owns EHCI, spin till it hands it over. */
+	msec = 1000;
+	while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
+		mdelay(10);
+		msec -= 10;
+		cap = read_pci_config(ehci_dev.bus, ehci_dev.slot,
+				      ehci_dev.func, offset);
+	}
+
+	if (cap & EHCI_USBLEGSUP_BIOS) {
+		/* well, possibly buggy BIOS... try to shut it down,
+		 * and hope nothing goes too wrong */
+		dbgp_printk("dbgp: BIOS handoff failed: %08x\n", cap);
+		write_pci_config_byte(ehci_dev.bus, ehci_dev.slot,
+				      ehci_dev.func, offset + 2, 0);
+	}
+
+	/* just in case, always disable EHCI SMIs */
+	write_pci_config_byte(ehci_dev.bus, ehci_dev.slot, ehci_dev.func,
+			      offset + EHCI_USBLEGCTLSTS, 0);
+}
+
 static int __init ehci_setup(void)
 {
 	struct usb_debug_descriptor dbgp_desc;
@@ -446,6 +493,8 @@ static int __init ehci_setup(void)
 	int port_map_tried;
 	int playtimes = 3;
 
+	early_ehci_bios_handoff();
+
 try_next_time:
 	port_map_tried = 0;
 
-- 
1.6.0.3.523.g304d0

