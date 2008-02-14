Return-Path: <linux-kernel-owner+w=401wt.eu-S1762216AbYBNPob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762216AbYBNPob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbYBNPjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:39:36 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:49923 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753250AbYBNPjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:39:13 -0500
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org,
       =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
Subject: [PATCH 07/14] drivers/net/ax88796.c: Use time_* macros
Date: Thu, 14 Feb 2008 17:36:45 +0200
Message-Id: <1203003412-11594-8-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: y
References: y
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Cc: netdev@vger.kernel.org
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 drivers/net/ax88796.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ax88796.c b/drivers/net/ax88796.c
index 194949a..0f823d7 100644
--- a/drivers/net/ax88796.c
+++ b/drivers/net/ax88796.c
@@ -11,6 +11,7 @@
  * published by the Free Software Foundation.
 */
 
+#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -151,7 +152,7 @@ static void ax_reset_8390(struct net_device *dev)
 
 	/* This check _should_not_ be necessary, omit eventually. */
 	while ((ei_inb(addr + EN0_ISR) & ENISR_RESET) == 0) {
-		if (jiffies - reset_start_time > 2*HZ/100) {
+		if (time_after(jiffies, reset_start_time + 2 * HZ/100)) {
 			dev_warn(&ax->dev->dev, "%s: %s did not complete.\n",
 			       __FUNCTION__, dev->name);
 			break;
@@ -287,7 +288,7 @@ static void ax_block_output(struct net_device *dev, int count,
 	dma_start = jiffies;
 
 	while ((ei_inb(nic_base + EN0_ISR) & ENISR_RDC) == 0) {
-		if (jiffies - dma_start > 2*HZ/100) {		/* 20ms */
+		if (time_after(jiffies, dma_start + 2 * HZ/100)) {		/* 20ms */
 			dev_warn(&ax->dev->dev,
 				 "%s: timeout waiting for Tx RDC.\n", dev->name);
 			ax_reset_8390(dev);
-- 
1.5.3.7

