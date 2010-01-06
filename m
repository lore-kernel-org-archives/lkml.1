Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986Ab0AFQsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab0AFQsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965Ab0AFQr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:47:59 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:51374 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab0AFQr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:47:59 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       linux-pci@vger.kernel.org
Subject: [PATCH 2/2] PCI: hotplug, fix memory leaks
Date: Wed,  6 Jan 2010 17:47:56 +0100
Message-Id: <1262796476-17737-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <1262796476-17737-1-git-send-email-jslaby@suse.cz>
References: <1262796476-17737-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a cut&pasted memory leak in pciehp_queue_pushbutton_work
and shpchp_queue_pushbutton_work. info is not freed/assigned on all
paths. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/hotplug/pciehp_ctrl.c |    1 +
 drivers/pci/hotplug/shpchp_ctrl.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index d6ac1b2..9a7f247 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -341,6 +341,7 @@ void pciehp_queue_pushbutton_work(struct work_struct *work)
 		p_slot->state = POWERON_STATE;
 		break;
 	default:
+		kfree(info);
 		goto out;
 	}
 	queue_work(pciehp_wq, &info->work);
diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
index b8ab279..86f6276 100644
--- a/drivers/pci/hotplug/shpchp_ctrl.c
+++ b/drivers/pci/hotplug/shpchp_ctrl.c
@@ -462,6 +462,7 @@ void shpchp_queue_pushbutton_work(struct work_struct *work)
 		p_slot->state = POWERON_STATE;
 		break;
 	default:
+		kfree(info);
 		goto out;
 	}
 	queue_work(shpchp_wq, &info->work);
-- 
1.6.5.7

