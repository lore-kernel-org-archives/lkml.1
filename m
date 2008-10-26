Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYJZO7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYJZO7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 10:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbYJZO7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 10:59:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:35746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbYJZO7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 10:59:39 -0400
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Bernhard Walle <bwalle@suse.de>,
       Wim Van Sebroeck <wim@iguana.be>,
       Thomas Mingarelli <thomas.mingarelli@hp.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] [WATCHDOG] Fix kdump when using hpwdt
Date: Sun, 26 Oct 2008 15:59:37 +0100
Message-Id: <1225033177-5311-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the "hpwdt" module is loaded (even if the /dev/watchdog device is not
opened), then kdump does not work. The panic kernel either does not start at
all or crash in various places.

The problem is that hpwdt_pretimeout is registered with register_die_notifier()
with the highest possible priority. Because it returns NOTIFY_STOP, the
crash_nmi_callback which is also registered with register_die_notifier()
is never executed. This causes the shutdown of other CPUs to fail.

Reverting the order is no option: The crash_nmi_callback executes HLT
and so never returns normally. Because of that, it must be executed as
last notifier, which currently is done.

So, that patch returns NOTIFY_OK in case allow_kdump is set as module parameter
in the hpwdt module. Also, it changes the default of allow_kdump to 1. Kdump is
quite common and should be working as default.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/watchdog/hpwdt.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a3765e0..65e7102 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -116,7 +116,7 @@ static unsigned int reload;			/* the computed soft_margin */
 static int nowayout = WATCHDOG_NOWAYOUT;
 static char expect_release;
 static unsigned long hpwdt_is_open;
-static unsigned int allow_kdump;
+static unsigned int allow_kdump = 1;
 
 static void __iomem *pci_mem_addr;		/* the PCI-memory address */
 static unsigned long __iomem *hpwdt_timer_reg;
@@ -482,7 +482,11 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 			"Management Log for details.\n");
 	}
 
-	return NOTIFY_STOP;
+	/*
+	 * for kdump, we must return NOTIFY_OK here to execute the
+	 * crash_nmi_callback afterwards, see arch/x86/kernel/crash.c
+	 */
+	return allow_kdump ? NOTIFY_OK : NOTIFY_STOP;
 }
 
 /*
@@ -759,7 +763,7 @@ MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 module_param(soft_margin, int, 0);
 MODULE_PARM_DESC(soft_margin, "Watchdog timeout in seconds");
 
-module_param(allow_kdump, int, 0);
+module_param(allow_kdump, int, 1);
 MODULE_PARM_DESC(allow_kdump, "Start a kernel dump after NMI occurs");
 
 module_param(nowayout, int, 0);
-- 
1.6.0.2

