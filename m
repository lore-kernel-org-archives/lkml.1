Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbZFXJIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbZFXJIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZFXJI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:08:26 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49854 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbZFXJIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:08:25 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, dbrownell@users.sourceforge.net,
       linux-omap@vger.kernel.org
Subject: [PATCH 2/3] TWL4030: power: print warning for out-of-order script loading
Date: Wed, 24 Jun 2009 12:07:59 +0300
Message-Id: <1245834479-7958-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245834390-7904-1-git-send-email-amit.kucheria@verdurent.com>
References: <1245834390-7904-1-git-send-email-amit.kucheria@verdurent.com>
X-OriginalArrivalTime: 24 Jun 2009 09:08:00.0777 (UTC) FILETIME=[46002790:01C9F4AB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the sleep script is loaded before the wakeup script, there is a
chance that the system might go to sleep before the wakeup script
loading is completed. This will lead to a system that does not wakeup
and has been observed to cause non-booting boards.

Various options were considered to solve this problem, including
modification of the core twl4030 power code to be smart enough to
reorder the loading of the scripts. But it felt too over-engineered.

Hence this patch just warns the DPS script developer so that it may be
reordered in the board-code itself.

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
---
 drivers/mfd/twl4030-power.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 75dd814..884c04f 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -320,6 +320,7 @@ static int __init load_triton_script(struct twl4030_script *tscript)
 {
 	u8 address = triton_next_free_address;
 	int err;
+	static u8 mask = 0;
 
 	/* Make sure the script isn't going beyond last valid address */
 	if ((address + tscript->size) > (END_OF_SCRIPT-1)) {
@@ -336,14 +337,20 @@ static int __init load_triton_script(struct twl4030_script *tscript)
 	if (tscript->flags & TRITON_WRST_SCRIPT)
 		err |= config_warmreset_sequence(address);
 
-	if (tscript->flags & TRITON_WAKEUP12_SCRIPT)
+	if (tscript->flags & TRITON_WAKEUP12_SCRIPT) {
 		err |= config_wakeup12_sequence(address);
+		mask |= TRITON_WAKEUP12_SCRIPT;
+	}
 
 	if (tscript->flags & TRITON_WAKEUP3_SCRIPT)
 		err |= config_wakeup3_sequence(address);
 
-	if (tscript->flags & TRITON_SLEEP_SCRIPT)
+	if (tscript->flags & TRITON_SLEEP_SCRIPT) {
+		if (!(mask & TRITON_WAKEUP12_SCRIPT))
+			printk(KERN_WARNING
+			       "TWL4030: Wakeup script not yet loaded. Might lead to boot failure on some boards\n");
 		err |= config_sleep_sequence(address);
+	}
 
 	return err;
 }
-- 
1.6.3.1

