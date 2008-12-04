Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYLDMqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYLDMqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYLDMqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:46:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57213 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbYLDMqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:46:09 -0500
Subject: [PATCH] virtio: make PCI devices take a virtio_pci module ref
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>, Michael Tokarev <mjt@tls.msk.ru>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 12:44:31 +0000
Message-Id: <1228394671.3732.77.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing takes a ref on virtio_pci, so even if you have
devices in use, rmmod will attempt to unload the module.

Fix by simply making each device take a ref on the module.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Reported-by: Michael Tokarev <mjt@tls.msk.ru>
---
 drivers/virtio/virtio_pci.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index c7dc37c..147a17f 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -322,6 +322,9 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 		return -ENODEV;
 	}
 
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
 	/* allocate our structure and fill it out */
 	vp_dev = kzalloc(sizeof(struct virtio_pci_device), GFP_KERNEL);
 	if (vp_dev == NULL)
@@ -393,6 +396,7 @@ static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
 	pci_release_regions(pci_dev);
 	pci_disable_device(pci_dev);
 	kfree(vp_dev);
+	module_put(THIS_MODULE);
 }
 
 #ifdef CONFIG_PM
-- 
1.6.0.3

