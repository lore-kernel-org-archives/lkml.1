Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZJ2P10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZJ2P10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbZJ2P1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:27:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbZJ2P1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:27:24 -0400
Date: Thu, 29 Oct 2009 17:24:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Alex Chiang <achiang@hp.com>,
       Yu Zhao <yu.zhao@intel.com>, Matthew Wilcox <willy@linux.intel.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       gleb@redhat.com
Subject: [PATCH] pci: fix nit in ROM BAR size probing
Message-ID: <20091029152459.GA5480@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When probing for ROM BAR size, we should not
change bits 1:10 in this BAR, because these
bits are marked as "reserved for future use" in PCI spec,
so changing them might have side effects.

No such issue for I/O or memory, as there is
an implementation note in PCI spec which explicitly allows
writing 0xfffffffff there.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/pci/probe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8105e32..d65aae4 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -163,12 +163,12 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 {
 	u32 l, sz, mask;
 
-	mask = type ? ~PCI_ROM_ADDRESS_ENABLE : ~0;
+	mask = type ? PCI_ROM_ADDRESS_MASK : ~0;
 
 	res->name = pci_name(dev);
 
 	pci_read_config_dword(dev, pos, &l);
-	pci_write_config_dword(dev, pos, mask);
+	pci_write_config_dword(dev, pos, l | mask);
 	pci_read_config_dword(dev, pos, &sz);
 	pci_write_config_dword(dev, pos, l);
 
-- 
1.6.5.rc2
