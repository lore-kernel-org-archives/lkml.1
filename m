Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbZEFCB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbZEFCB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbZEFCAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:00:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:50561 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758408AbZEFCAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:00:35 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 4/5] usb,early_printk: unregister early usb before rest_init()
Date: Tue,  5 May 2009 21:00:04 -0500
Message-Id: <1241575205-12199-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241575205-12199-4-git-send-email-jason.wessel@windriver.com>
References: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com>
 <1241575205-12199-2-git-send-email-jason.wessel@windriver.com>
 <1241575205-12199-3-git-send-email-jason.wessel@windriver.com>
 <1241575205-12199-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 06 May 2009 02:00:03.0081 (UTC) FILETIME=[5EA8EF90:01C9CDEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The early_printk EHCI debug driver can hang the system or cause
unpredictable results because two separate APIs will attempt to write
to the mapped PCI region.

The safe route is to unregister the early USB console at the end of
the core kernel init, which is before the PCI initialization.  Later,
after the USB initialization completes it is then possible to register
the console against the usb debug device and receive the printk
messages that were missed in the period between early printk
availability and the USB console device.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/early_printk.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index e38c467..ef177d4 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -952,4 +952,26 @@ static int __init setup_early_printk(char *buf)
 	return 0;
 }
 
+#ifdef CONFIG_EARLY_PRINTK_DBGP
+/*
+ * The early console must get unregistered prior to the ECHI
+ * controller getting reset else the debug device cannot be used until
+ * a subsequent EHCI reset, or the kernel hangs.
+ */
+static int __init usb_early_debug_cleanup(void)
+{
+	if (early_dbgp_console.index >= 0 &&
+		early_dbgp_console.flags & CON_PRINTBUFFER) {
+		console_stop(early_console);
+		unregister_console(early_console);
+		early_dbgp_console.index = -1;
+		early_dbgp_console.flags = 0;
+		ehci_debug = NULL;
+		printk(KERN_INFO "Early USB console unregistered\n");
+	}
+	return 0;
+}
+postcore_initcall(usb_early_debug_cleanup);
+#endif /* CONFIG_EARLY_PRINTK_DBGP */
+
 early_param("earlyprintk", setup_early_printk);
-- 
1.6.3.rc0.1.gf800

