Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZGHKt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZGHKt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbZGHKtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:49:42 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:64691 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbZGHKtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:49:40 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: sameo@linux.intel.com
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: [PATCH 2/3] MFD: TWL4030: print warning for out-of-order script loading
Date: Wed,  8 Jul 2009 13:49:35 +0300
Message-Id: <1247050175-31163-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247050046-31104-1-git-send-email-./0000-cover-letter.patch>
References: <1247050046-31104-1-git-send-email-./0000-cover-letter.patch>
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

Hence this patch just warns the DPS script developer so that they may be
reordered in the board-code itself.

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
---
 drivers/mfd/twl4030-power.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index bb9e45f..ef4cc4e 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -315,6 +315,7 @@ static int __init load_triton_script(struct twl4030_script *tscript)
 {
 	u8 address = triton_next_free_address;
 	int err;
+	static u8 mask = 0;
 
 	/* Make sure the script isn't going beyond last valid address */
 	if ((address + tscript->size) > (END_OF_SCRIPT-1)) {
@@ -331,14 +332,20 @@ static int __init load_triton_script(struct twl4030_script *tscript)
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
1.6.3.3

