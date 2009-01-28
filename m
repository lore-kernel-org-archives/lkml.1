Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZA1Ryt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZA1Ryt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZA1Rxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:53:47 -0500
Received: from ns.suse.de ([195.135.220.2]:53898 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZA1Rxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:53:45 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: greg@kroah.com
Cc: chrisw@sous-sol.org, stable@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH stable-27 1/2] PCI hotplug: fix lock imbalance in pciehp
Date: Wed, 28 Jan 2009 18:53:37 +0100
Message-Id: <1233165221-20106-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

set_lock_status omits mutex_unlock in fail path. Add the omitted
unlock.

As a result a lockup caused by this can be triggered from userspace
by writing 1 to /sys/bus/pci/slots/.../lock often enough.

Commit c2fdd36b550659f5ac2240d1f5a83ffa1a092289.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/hotplug/pciehp_core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 6e18736..6d9b074 100644
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

