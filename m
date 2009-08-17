Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbZHQOCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbZHQOCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 10:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbZHQOCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 10:02:04 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:49433 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbZHQOCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 10:02:01 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, dbrownell@users.sourceforge.net,
       linux-omap@vger.kernel.org
Subject: [PATCH 2/3] MFD: TWL4030: print warning for out-of-order script loading
Date: Mon, 17 Aug 2009 17:01:56 +0300
Message-Id: <1250517716-16079-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1250517469-15899-1-git-send-email-amit.kucheria@verdurent.com>
References: <1250517469-15899-1-git-send-email-amit.kucheria@verdurent.com>
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
Cc: sameo@linux.intel.com
Cc: dbrownell@users.sourceforge.net
Cc: linux-omap@vger.kernel.org
---
 drivers/mfd/twl4030-power.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index e7688b0..5284c7c 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -379,6 +379,7 @@ static int __init load_twl4030_script(struct twl4030_script *tscript,
 	       u8 address)
 {
 	int err;
+	static int order;
 
 	/* Make sure the script isn't going beyond last valid address (0x3f) */
 	if ((address + tscript->size) > END_OF_SCRIPT) {
@@ -399,6 +400,7 @@ static int __init load_twl4030_script(struct twl4030_script *tscript,
 		err = twl4030_config_wakeup12_sequence(address);
 		if (err)
 			goto out;
+		order = 1;
 	}
 	if (tscript->flags & TWL4030_WAKEUP3_SCRIPT) {
 		err = twl4030_config_wakeup3_sequence(address);
@@ -406,6 +408,10 @@ static int __init load_twl4030_script(struct twl4030_script *tscript,
 			goto out;
 	}
 	if (tscript->flags & TWL4030_SLEEP_SCRIPT)
+		if (order)
+			pr_warning("TWL4030: Bad order of scripts (sleep "\
+					"script before wakeup) Leads to boot"\
+					"failure on some boards\n");
 		err = twl4030_config_sleep_sequence(address);
 out:
 	return err;
-- 
1.6.3.3

