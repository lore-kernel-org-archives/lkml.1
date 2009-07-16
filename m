Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbZGPPnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbZGPPnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932466AbZGPPnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:43:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:27865 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457AbZGPPnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YQGirvCfevV+Y0gqQWfpfgIVlaMShByA3Jqy+Eo2B2IQ5a/jlPKZnA5SayGuLeCZLI
         4zAHsSuvVkPq4kYcdw/id2+ik5QX3RNuszsyA9YHSD9kM4KqiqcFzIHtg5DaopLpVhlI
         iuVmG9yKtLxN07v3S8cmq8B1wXkXOAlQI6bPw=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, pavel@ucw.cz,
       zhangfx@lemote.com, wuzj@lemote.com, yanh@lemote.com,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH] [suspend] pci_raw_set_power_state: replace msleep by udelay in resuming procedure
Date: Thu, 16 Jul 2009 23:43:27 +0800
Message-Id: <1247759007-27411-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we can not call msleep() when resuming from STR/Standby: if the
current_state of the pci device is PCI_D3hot, means we are in the
procedure of resuming, in this procedure, we can not re-schedule,
otherwise, there will be a deadlock.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 drivers/pci/pci.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 440f4fb..3d9a4e2 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -497,8 +497,18 @@ static int pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state)
 
 	/* Mandatory power management transition delays */
 	/* see PCI PM 1.1 5.6.1 table 18 */
-	if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
+
+	/* we can not call msleep() when resume:
+	 *
+	 *   if the current_state is PCI_D3hot, means we are in the procedure
+	 *   of resuming, in this procedure, we can not re-schedule, otherwise,
+	 *   there will be a deadlock.
+	 */
+
+	if (state == PCI_D3hot)
 		msleep(pci_pm_d3_delay);
+	else if (dev->current_state == PCI_D3hot)
+		udelay(pci_pm_d3_delay);
 	else if (state == PCI_D2 || dev->current_state == PCI_D2)
 		udelay(PCI_PM_D2_DELAY);
 
-- 
1.6.2.1

