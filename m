Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbZAHN4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbZAHN4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 08:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbZAHN4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 08:56:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42799 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbZAHN4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 08:56:08 -0500
Date: Thu, 8 Jan 2009 21:56:00 +0800
From: Eugene Teo <eugeneteo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Subject: [PATCH] IB: check for memory allocation failure
Message-ID: <20090108135549.GA9756@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix error-path NULL deref in c2_register_device().

Signed-off-by: Eugene Teo <eugeneteo@kernel.org>
---
 drivers/infiniband/hw/amso1100/c2_provider.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index 5119d65..8cede6c 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -780,11 +780,11 @@ int c2_register_device(struct c2_dev *dev)
 	/* Register pseudo network device */
 	dev->pseudo_netdev = c2_pseudo_netdev_init(dev);
 	if (!dev->pseudo_netdev)
-		goto out3;
+		goto out4;
 
 	ret = register_netdev(dev->pseudo_netdev);
 	if (ret)
-		goto out2;
+		goto out3;
 
 	pr_debug("%s:%u\n", __func__, __LINE__);
 	strlcpy(dev->ibdev.name, "amso%d", IB_DEVICE_NAME_MAX);
@@ -851,6 +851,8 @@ int c2_register_device(struct c2_dev *dev)
 	dev->ibdev.post_recv = c2_post_receive;
 
 	dev->ibdev.iwcm = kmalloc(sizeof(*dev->ibdev.iwcm), GFP_KERNEL);
+	if (!dev->ibdev.iwcm)
+		goto out2;
 	dev->ibdev.iwcm->add_ref = c2_add_ref;
 	dev->ibdev.iwcm->rem_ref = c2_rem_ref;
 	dev->ibdev.iwcm->get_qp = c2_get_qp;
@@ -870,15 +872,17 @@ int c2_register_device(struct c2_dev *dev)
 		if (ret)
 			goto out0;
 	}
-	goto out3;
+	goto out4;
 
 out0:
 	ib_unregister_device(&dev->ibdev);
 out1:
-	unregister_netdev(dev->pseudo_netdev);
+	kfree(dev->ibdev.iwcm);
 out2:
-	free_netdev(dev->pseudo_netdev);
+	unregister_netdev(dev->pseudo_netdev);
 out3:
+	free_netdev(dev->pseudo_netdev);
+out4:
 	pr_debug("%s:%u ret=%d\n", __func__, __LINE__, ret);
 	return ret;
 }

