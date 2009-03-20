Return-Path: <linux-kernel-owner+w=401wt.eu-S1760597AbZCTU6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597AbZCTU6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758749AbZCTU4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:56:24 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:6322 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695AbZCTU4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:56:22 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 06/13] PCI: do not enable bridges more than once
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Chiang <achiang@hp.com>
Date: Fri, 20 Mar 2009 14:56:20 -0600
Message-ID: <20090320205620.12275.52427.stgit@bob.kio>
In-Reply-To: <20090320204327.12275.43010.stgit@bob.kio>
References: <20090320204327.12275.43010.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for PCI core hotplug, we need to ensure that we do
not attempt to re-enable bridges that have already been enabled.

Reported-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/bus.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 118c777..68f91a2 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -184,8 +184,10 @@ void pci_enable_bridges(struct pci_bus *bus)
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		if (dev->subordinate) {
-			retval = pci_enable_device(dev);
-			pci_set_master(dev);
+			if (atomic_read(&dev->enable_cnt) == 0) {
+				retval = pci_enable_device(dev);
+				pci_set_master(dev);
+			}
 			pci_enable_bridges(dev->subordinate);
 		}
 	}

