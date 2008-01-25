Return-Path: <linux-kernel-owner+w=401wt.eu-S1763851AbYAYH7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763851AbYAYH7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759045AbYAYHhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:37:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:50155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761007AbYAYHhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:37:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <mshefty@ichips.intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 110/196] Kobject: change drivers/infiniband to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:19 -0800
Message-Id: <1201246425-5058-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <mshefty@ichips.intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/infiniband/core/sysfs.c |   35 +++++++++--------------------------
 include/rdma/ib_verbs.h         |    2 +-
 2 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 3d40506..aa81129 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -508,19 +508,10 @@ static int add_port(struct ib_device *device, int port_num)
 
 	p->ibdev      = device;
 	p->port_num   = port_num;
-	p->kobj.ktype = &port_type;
 
-	p->kobj.parent = kobject_get(&device->ports_parent);
-	if (!p->kobj.parent) {
-		ret = -EBUSY;
-		goto err;
-	}
-
-	ret = kobject_set_name(&p->kobj, "%d", port_num);
-	if (ret)
-		goto err_put;
-
-	ret = kobject_register(&p->kobj);
+	ret = kobject_init_and_add(&p->kobj, &port_type,
+				   kobject_get(device->ports_parent),
+				   "%d", port_num);
 	if (ret)
 		goto err_put;
 
@@ -549,6 +540,7 @@ static int add_port(struct ib_device *device, int port_num)
 
 	list_add_tail(&p->kobj.entry, &device->port_list);
 
+	kobject_uevent(&p->kobj, KOBJ_ADD);
 	return 0;
 
 err_free_pkey:
@@ -570,9 +562,7 @@ err_remove_pma:
 	sysfs_remove_group(&p->kobj, &pma_group);
 
 err_put:
-	kobject_put(&device->ports_parent);
-
-err:
+	kobject_put(device->ports_parent);
 	kfree(p);
 	return ret;
 }
@@ -694,16 +684,9 @@ int ib_device_register_sysfs(struct ib_device *device)
 			goto err_unregister;
 	}
 
-	device->ports_parent.parent = kobject_get(&class_dev->kobj);
-	if (!device->ports_parent.parent) {
-		ret = -EBUSY;
-		goto err_unregister;
-	}
-	ret = kobject_set_name(&device->ports_parent, "ports");
-	if (ret)
-		goto err_put;
-	ret = kobject_register(&device->ports_parent);
-	if (ret)
+	device->ports_parent = kobject_create_and_add("ports",
+					kobject_get(&class_dev->kobj));
+	if (!device->ports_parent)
 		goto err_put;
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH) {
@@ -758,7 +741,7 @@ void ib_device_unregister_sysfs(struct ib_device *device)
 		kobject_unregister(p);
 	}
 
-	kobject_unregister(&device->ports_parent);
+	kobject_unregister(device->ports_parent);
 	class_device_unregister(&device->class_dev);
 }
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 11f3960..cfbd38f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1026,7 +1026,7 @@ struct ib_device {
 
 	struct module               *owner;
 	struct class_device          class_dev;
-	struct kobject               ports_parent;
+	struct kobject               *ports_parent;
 	struct list_head             port_list;
 
 	enum {
-- 
1.5.3.8

