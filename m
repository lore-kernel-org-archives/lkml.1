Return-Path: <linux-kernel-owner+w=401wt.eu-S1422993AbXDXS1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422993AbXDXS1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422995AbXDXS1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:27:24 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:38377 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422993AbXDXS1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:27:22 -0400
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="415145514:sNHT75664312"
To: Joachim Fenkes <FENKES@de.ibm.com>
Cc: "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH] ib_core: Add missing device link to class device
X-Message-Flag: Warning: May contain useful information
References: <OF8C8AA8EC.A66DAC49-ONC12572C7.00416B4B-C12572C7.00428AF7@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 24 Apr 2007 11:27:18 -0700
In-Reply-To: <OF8C8AA8EC.A66DAC49-ONC12572C7.00416B4B-C12572C7.00428AF7@de.ibm.com> (Joachim Fenkes's message of "Tue, 24 Apr 2007 14:06:59 +0200")
Message-ID: <adazm4x39x5.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Apr 2007 18:27:18.0866 (UTC) FILETIME=[31042B20:01C7869E]
Authentication-Results: sj-dkim-5; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I had a look at the kernel code -- currently, all device drivers except
 > ehca do this by themselves:

 > So I think it makes a lot of sense to put the class_dev.dev assignment
 > into generic ib_core code instead of repeating it in all the drivers.
 > The respective lines could move out of the drivers in the future but
 > won't hurt anyone until then.

Actually I think we should delete the duplicate code now while merging
this.  So I queued this up for 2.6.22:

commit f19c8d7cbe3153d68f0a559afd02f66655310238
Author: Joachim Fenkes <fenkes@de.ibm.com>
Date:   Mon Apr 23 18:20:27 2007 +0200

IB: Set class_dev->dev in core for nice device symlink

All RDMA drivers except ehca set class_dev->dev to their dma_device
value (ehca leaves this unset).  dma_device is the only value that
makes any sense, so move this assignment to core/sysfs.c.  This reduce
the duplicated code in the rest of the drivers and gives ehca a nice
/sys/class/infiniband/ehcaX/device symlink.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 000c086..08c299e 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -683,6 +683,7 @@ int ib_device_register_sysfs(struct ib_device *device)
 
 	class_dev->class      = &ib_class;
 	class_dev->class_data = device;
+	class_dev->dev	      = device->dma_device;
 	strlcpy(class_dev->class_id, device->name, BUS_ID_SIZE);
 
 	INIT_LIST_HEAD(&device->port_list);
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index fef9727..607c09b 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -796,7 +796,6 @@ int c2_register_device(struct c2_dev *dev)
 	memcpy(&dev->ibdev.node_guid, dev->pseudo_netdev->dev_addr, 6);
 	dev->ibdev.phys_port_cnt = 1;
 	dev->ibdev.dma_device = &dev->pcidev->dev;
-	dev->ibdev.class_dev.dev = &dev->pcidev->dev;
 	dev->ibdev.query_device = c2_query_device;
 	dev->ibdev.query_port = c2_query_port;
 	dev->ibdev.modify_port = c2_modify_port;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 24e0df0..af28a31 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1108,7 +1108,6 @@ int iwch_register_device(struct iwch_dev *dev)
 	memcpy(dev->ibdev.node_desc, IWCH_NODE_DESC, sizeof(IWCH_NODE_DESC));
 	dev->ibdev.phys_port_cnt = dev->rdev.port_info.nports;
 	dev->ibdev.dma_device = &(dev->rdev.rnic_info.pdev->dev);
-	dev->ibdev.class_dev.dev = &(dev->rdev.rnic_info.pdev->dev);
 	dev->ibdev.query_device = iwch_query_device;
 	dev->ibdev.query_port = iwch_query_port;
 	dev->ibdev.modify_port = iwch_modify_port;
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index f5604b8..18c6df2 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1559,7 +1559,6 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	dev->node_type = RDMA_NODE_IB_CA;
 	dev->phys_port_cnt = 1;
 	dev->dma_device = &dd->pcidev->dev;
-	dev->class_dev.dev = dev->dma_device;
 	dev->query_device = ipath_query_device;
 	dev->modify_device = ipath_modify_device;
 	dev->query_port = ipath_query_port;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 0725ad7..47e6fd4 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1293,7 +1293,6 @@ int mthca_register_device(struct mthca_dev *dev)
 	dev->ib_dev.node_type            = RDMA_NODE_IB_CA;
 	dev->ib_dev.phys_port_cnt        = dev->limits.num_ports;
 	dev->ib_dev.dma_device           = &dev->pdev->dev;
-	dev->ib_dev.class_dev.dev        = &dev->pdev->dev;
 	dev->ib_dev.query_device         = mthca_query_device;
 	dev->ib_dev.query_port           = mthca_query_port;
 	dev->ib_dev.modify_device        = mthca_modify_device;
