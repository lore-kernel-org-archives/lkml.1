Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268Ab0ATNQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0ATNQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187Ab0ATNP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:15:58 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:53030 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab0ATNP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:15:58 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Scott Murray <scott@spiteful.org>, linux-pci@vger.kernel.org
Subject: [PATCH 1/1] PCI: hotplug/cpcihp, fix pci device refcounting
Date: Wed, 20 Jan 2010 14:15:54 +0100
Message-Id: <1263993354-23066-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found an ommitted pci_dev_put on one error path in
cpcihp_generic_init. The path is taken on !dev, but also when
dev->hdr_type != PCI_HEADER_TYPE_BRIDGE. However it omits to
pci_dev_put on the latter.

As it is fine to pass NULL to pci_dev_put, put it in there
uncoditionally.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Scott Murray <scott@spiteful.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/hotplug/cpcihp_generic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/hotplug/cpcihp_generic.c b/drivers/pci/hotplug/cpcihp_generic.c
index 148fb46..fb3f846 100644
--- a/drivers/pci/hotplug/cpcihp_generic.c
+++ b/drivers/pci/hotplug/cpcihp_generic.c
@@ -162,6 +162,7 @@ static int __init cpcihp_generic_init(void)
 	dev = pci_get_slot(bus, PCI_DEVFN(bridge_slot, 0));
 	if(!dev || dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
 		err("Invalid bridge device %s", bridge);
+		pci_dev_put(dev);
 		return -EINVAL;
 	}
 	bus = dev->subordinate;
-- 
1.6.5.7

