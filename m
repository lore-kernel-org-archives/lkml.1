Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYFBSLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYFBSLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYFBSLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:11:33 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40043 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYFBSKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:10:54 -0400
X-Greylist: delayed 1891 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jun 2008 14:10:54 EDT
Subject: [PATCH] FIx crash in mmc_block on 64-bit
From: Ben Collins <ben.collins@canonical.com>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: drzeus-mmc@drzeus.cx, kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain
Organization: Canonical
Date: Mon, 02 Jun 2008 13:39:19 -0400
Message-Id: <1212428359.7239.4.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fairly simple. "dev_use" was being allocated as a zero length array
because of bad math on 64-bit systems causing a crash in
find_first_zero_bit(). One-liner follows:

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 91ded3e..f9ad960 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -46,7 +46,7 @@
 #define MMC_SHIFT	3
 #define MMC_NUM_MINORS	(256 >> MMC_SHIFT)
 
-static unsigned long dev_use[MMC_NUM_MINORS/(8*sizeof(unsigned long))];
+static DECLARE_BITMAP(dev_use, MMC_NUM_MINORS);
 
 /*
  * There is one mmc_blk_data per slot.


