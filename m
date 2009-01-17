Return-Path: <linux-kernel-owner+w=401wt.eu-S1762876AbZAQPYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762876AbZAQPYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 10:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758992AbZAQPYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 10:24:08 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:47976 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758922AbZAQPYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 10:24:06 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [PATCH] PCI: pciehp_core, fix lock imbalance
Date: Sat, 17 Jan 2009 16:23:55 +0100
Message-Id: <1232205835-21854-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_lock_status omits mutex_unlock in fail path. Add the omitted
unlock.

As a result a lockup caused by this can be triggered from userspace
by writing 1 to /sys/bus/pci/slots/.../lock often enough.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/hotplug/pciehp_core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 5482d4e..c248554 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -126,8 +126,10 @@ static int set_lock_status(struct hotplug_slot *hotplug_slot, u8 status)
 	mutex_lock(&slot->ctrl->crit_sect);
 
 	/* has it been >1 sec since our last toggle? */
-	if ((get_seconds() - slot->last_emi_toggle) < 1)
+	if ((get_seconds() - slot->last_emi_toggle) < 1) {
+		mutex_unlock(&slot->ctrl->crit_sect);
 		return -EINVAL;
+	}
 
 	/* see what our current state is */
 	retval = get_lock_status(hotplug_slot, &value);
-- 
1.6.1
caught by stanse
