Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbXIYMNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbXIYMNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbXIYMNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:13:06 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:5059 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbXIYMNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:13:02 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Paul Mackerras <paulus@samba.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] ibmebus: Move to of_device and of_platform_driver, match eHCA and eHEA drivers
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
       Paul Mackerras <pmac@au1.ibm.com>
References: <200709251410.29780.fenkes@de.ibm.com>
In-Reply-To: <200709251410.29780.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 8152
Date: Tue, 25 Sep 2007 14:12:59 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709251412.59904.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    2 +-
 drivers/net/ehea/ehea.h                   |    2 +-
 include/asm-powerpc/ibmebus.h             |   38 +++------------
 arch/powerpc/kernel/ibmebus.c             |   28 ++++++-----
 drivers/infiniband/hw/ehca/ehca_eq.c      |    6 +-
 drivers/infiniband/hw/ehca/ehca_main.c    |   32 ++++++------
 drivers/net/ehea/ehea_main.c              |   72 ++++++++++++++--------------
 7 files changed, 79 insertions(+), 101 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index c2edd4c..8ca4dd4 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -106,7 +106,7 @@ struct ehca_sport {
 
 struct ehca_shca {
 	struct ib_device ib_device;
-	struct ibmebus_dev *ibmebus_dev;
+	struct of_device *ofdev;
 	u8 num_ports;
 	int hw_level;
 	struct list_head shca_list;
diff --git a/drivers/net/ehea/ehea.h b/drivers/net/ehea/ehea.h
index 8d58be5..830a66a 100644
--- a/drivers/net/ehea/ehea.h
+++ b/drivers/net/ehea/ehea.h
@@ -382,7 +382,7 @@ struct ehea_port_res {
 #define EHEA_MAX_PORTS 16
 struct ehea_adapter {
 	u64 handle;
-	struct ibmebus_dev *ebus_dev;
+	struct of_device *ofdev;
 	struct ehea_port *port[EHEA_MAX_PORTS];
 	struct ehea_eq *neq;       /* notification event queue */
 	struct workqueue_struct *ehea_wq;
diff --git a/include/asm-powerpc/ibmebus.h b/include/asm-powerpc/ibmebus.h
index 87d396e..1a9d9ae 100644
--- a/include/asm-powerpc/ibmebus.h
+++ b/include/asm-powerpc/ibmebus.h
@@ -43,42 +43,18 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/mod_devicetable.h>
-#include <asm/of_device.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
 
 extern struct bus_type ibmebus_bus_type;
 
-struct ibmebus_dev {
-	struct of_device ofdev;
-};
+int ibmebus_register_driver(struct of_platform_driver *drv);
+void ibmebus_unregister_driver(struct of_platform_driver *drv);
 
-struct ibmebus_driver {
-	char *name;
-	struct of_device_id *id_table;
-	int (*probe) (struct ibmebus_dev *dev, const struct of_device_id *id);
-	int (*remove) (struct ibmebus_dev *dev);
-	struct device_driver driver;
-};
-
-int ibmebus_register_driver(struct ibmebus_driver *drv);
-void ibmebus_unregister_driver(struct ibmebus_driver *drv);
-
-int ibmebus_request_irq(struct ibmebus_dev *dev,
-			u32 ist,
-			irq_handler_t handler,
-			unsigned long irq_flags, const char * devname,
+int ibmebus_request_irq(u32 ist, irq_handler_t handler,
+			unsigned long irq_flags, const char *devname,
 			void *dev_id);
-void ibmebus_free_irq(struct ibmebus_dev *dev, u32 ist, void *dev_id);
-
-static inline struct ibmebus_driver *to_ibmebus_driver(struct device_driver *drv)
-{
-	return container_of(drv, struct ibmebus_driver, driver);
-}
-
-static inline struct ibmebus_dev *to_ibmebus_dev(struct device *dev)
-{
-	return container_of(dev, struct ibmebus_dev, ofdev.dev);
-}
-
+void ibmebus_free_irq(u32 ist, void *dev_id);
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_IBMEBUS_H */
diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index c506e0d..379472f 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -194,21 +194,26 @@ static int ibmebus_create_devices(const struct of_device_id *matches)
 	return ret;
 }
 
-int ibmebus_register_driver(struct ibmebus_driver *drv)
+int ibmebus_register_driver(struct of_platform_driver *drv)
 {
-	return 0;
+	/* If the driver uses devices that ibmebus doesn't know, add them */
+	ibmebus_create_devices(drv->match_table);
+
+	drv->driver.name   = drv->name;
+	drv->driver.bus    = &ibmebus_bus_type;
+
+	return driver_register(&drv->driver);
 }
 EXPORT_SYMBOL(ibmebus_register_driver);
 
-void ibmebus_unregister_driver(struct ibmebus_driver *drv)
+void ibmebus_unregister_driver(struct of_platform_driver *drv)
 {
+	driver_unregister(&drv->driver);
 }
 EXPORT_SYMBOL(ibmebus_unregister_driver);
 
-int ibmebus_request_irq(struct ibmebus_dev *dev,
-			u32 ist,
-			irq_handler_t handler,
-			unsigned long irq_flags, const char * devname,
+int ibmebus_request_irq(u32 ist, irq_handler_t handler,
+			unsigned long irq_flags, const char *devname,
 			void *dev_id)
 {
 	unsigned int irq = irq_create_mapping(NULL, ist);
@@ -216,12 +221,11 @@ int ibmebus_request_irq(struct ibmebus_dev *dev,
 	if (irq == NO_IRQ)
 		return -EINVAL;
 
-	return request_irq(irq, handler,
-			   irq_flags, devname, dev_id);
+	return request_irq(irq, handler, irq_flags, devname, dev_id);
 }
 EXPORT_SYMBOL(ibmebus_request_irq);
 
-void ibmebus_free_irq(struct ibmebus_dev *dev, u32 ist, void *dev_id)
+void ibmebus_free_irq(u32 ist, void *dev_id)
 {
 	unsigned int irq = irq_find_mapping(NULL, ist);
 
@@ -232,9 +236,7 @@ EXPORT_SYMBOL(ibmebus_free_irq);
 static ssize_t name_show(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
-	struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
-	const char *name = of_get_property(ebus_dev->ofdev.node, "name", NULL);
-	return sprintf(buf, "%s\n", name);
+	return sprintf(buf, "%s\n", to_of_device(dev)->node->name);
 }
 
 static struct device_attribute ibmebus_dev_attrs[] = {
diff --git a/drivers/infiniband/hw/ehca/ehca_eq.c b/drivers/infiniband/hw/ehca/ehca_eq.c
index 1d41faa..b4ac617 100644
--- a/drivers/infiniband/hw/ehca/ehca_eq.c
+++ b/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -123,7 +123,7 @@ int ehca_create_eq(struct ehca_shca *shca,
 
 	/* register interrupt handlers and initialize work queues */
 	if (type == EHCA_EQ) {
-		ret = ibmebus_request_irq(NULL, eq->ist, ehca_interrupt_eq,
+		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
 					  IRQF_DISABLED, "ehca_eq",
 					  (void *)shca);
 		if (ret < 0)
@@ -131,7 +131,7 @@ int ehca_create_eq(struct ehca_shca *shca,
 
 		tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
 	} else if (type == EHCA_NEQ) {
-		ret = ibmebus_request_irq(NULL, eq->ist, ehca_interrupt_neq,
+		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
 					  IRQF_DISABLED, "ehca_neq",
 					  (void *)shca);
 		if (ret < 0)
@@ -171,7 +171,7 @@ int ehca_destroy_eq(struct ehca_shca *shca, struct ehca_eq *eq)
 	u64 h_ret;
 
 	spin_lock_irqsave(&eq->spinlock, flags);
-	ibmebus_free_irq(NULL, eq->ist, (void *)shca);
+	ibmebus_free_irq(eq->ist, (void *)shca);
 
 	h_ret = hipz_h_destroy_eq(shca->ipz_hca_handle, eq);
 
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index c84e310..8a038b1 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -404,7 +404,7 @@ int ehca_init_device(struct ehca_shca *shca)
 	shca->ib_device.node_type           = RDMA_NODE_IB_CA;
 	shca->ib_device.phys_port_cnt       = shca->num_ports;
 	shca->ib_device.num_comp_vectors    = 1;
-	shca->ib_device.dma_device          = &shca->ibmebus_dev->ofdev.dev;
+	shca->ib_device.dma_device          = &shca->ofdev->dev;
 	shca->ib_device.query_device        = ehca_query_device;
 	shca->ib_device.query_port          = ehca_query_port;
 	shca->ib_device.query_gid           = ehca_query_gid;
@@ -658,7 +658,7 @@ static struct attribute_group ehca_dev_attr_grp = {
 	.attrs = ehca_dev_attrs
 };
 
-static int __devinit ehca_probe(struct ibmebus_dev *dev,
+static int __devinit ehca_probe(struct of_device *dev,
 				const struct of_device_id *id)
 {
 	struct ehca_shca *shca;
@@ -666,16 +666,16 @@ static int __devinit ehca_probe(struct ibmebus_dev *dev,
 	struct ib_pd *ibpd;
 	int ret;
 
-	handle = of_get_property(dev->ofdev.node, "ibm,hca-handle", NULL);
+	handle = of_get_property(dev->node, "ibm,hca-handle", NULL);
 	if (!handle) {
 		ehca_gen_err("Cannot get eHCA handle for adapter: %s.",
-			     dev->ofdev.node->full_name);
+			     dev->node->full_name);
 		return -ENODEV;
 	}
 
 	if (!(*handle)) {
 		ehca_gen_err("Wrong eHCA handle for adapter: %s.",
-			     dev->ofdev.node->full_name);
+			     dev->node->full_name);
 		return -ENODEV;
 	}
 
@@ -686,9 +686,9 @@ static int __devinit ehca_probe(struct ibmebus_dev *dev,
 	}
 	mutex_init(&shca->modify_mutex);
 
-	shca->ibmebus_dev = dev;
+	shca->ofdev = dev;
 	shca->ipz_hca_handle.handle = *handle;
-	dev->ofdev.dev.driver_data = shca;
+	dev->dev.driver_data = shca;
 
 	ret = ehca_sense_attributes(shca);
 	if (ret < 0) {
@@ -764,7 +764,7 @@ static int __devinit ehca_probe(struct ibmebus_dev *dev,
 		}
 	}
 
-	ret = sysfs_create_group(&dev->ofdev.dev.kobj, &ehca_dev_attr_grp);
+	ret = sysfs_create_group(&dev->dev.kobj, &ehca_dev_attr_grp);
 	if (ret) /* only complain; we can live without attributes */
 		ehca_err(&shca->ib_device,
 			 "Cannot create device attributes  ret=%d", ret);
@@ -814,12 +814,12 @@ probe1:
 	return -EINVAL;
 }
 
-static int __devexit ehca_remove(struct ibmebus_dev *dev)
+static int __devexit ehca_remove(struct of_device *dev)
 {
-	struct ehca_shca *shca = dev->ofdev.dev.driver_data;
+	struct ehca_shca *shca = dev->dev.driver_data;
 	int ret;
 
-	sysfs_remove_group(&dev->ofdev.dev.kobj, &ehca_dev_attr_grp);
+	sysfs_remove_group(&dev->dev.kobj, &ehca_dev_attr_grp);
 
 	if (ehca_open_aqp1 == 1) {
 		int i;
@@ -870,11 +870,11 @@ static struct of_device_id ehca_device_table[] =
 	{},
 };
 
-static struct ibmebus_driver ehca_driver = {
-	.name     = "ehca",
-	.id_table = ehca_device_table,
-	.probe    = ehca_probe,
-	.remove   = ehca_remove,
+static struct of_platform_driver ehca_driver = {
+	.name        = "ehca",
+	.match_table = ehca_device_table,
+	.probe       = ehca_probe,
+	.remove      = ehca_remove,
 };
 
 void ehca_poll_eqs(unsigned long data)
diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index 717b129..a4d4150 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -89,10 +89,10 @@ struct workqueue_struct *ehea_driver_wq;
 struct work_struct ehea_rereg_mr_task;
 
 
-static int __devinit ehea_probe_adapter(struct ibmebus_dev *dev,
+static int __devinit ehea_probe_adapter(struct of_device *dev,
 					const struct of_device_id *id);
 
-static int __devexit ehea_remove(struct ibmebus_dev *dev);
+static int __devexit ehea_remove(struct of_device *dev);
 
 static struct of_device_id ehea_device_table[] = {
 	{
@@ -102,9 +102,9 @@ static struct of_device_id ehea_device_table[] = {
 	{},
 };
 
-static struct ibmebus_driver ehea_driver = {
+static struct of_platform_driver ehea_driver = {
 	.name = "ehea",
-	.id_table = ehea_device_table,
+	.match_table = ehea_device_table,
 	.probe = ehea_probe_adapter,
 	.remove = ehea_remove,
 };
@@ -968,7 +968,7 @@ static int ehea_reg_interrupts(struct net_device *dev)
 	snprintf(port->int_aff_name, EHEA_IRQ_NAME_SIZE - 1, "%s-aff",
 		 dev->name);
 
-	ret = ibmebus_request_irq(NULL, port->qp_eq->attr.ist1,
+	ret = ibmebus_request_irq(port->qp_eq->attr.ist1,
 				  ehea_qp_aff_irq_handler,
 				  IRQF_DISABLED, port->int_aff_name, port);
 	if (ret) {
@@ -986,7 +986,7 @@ static int ehea_reg_interrupts(struct net_device *dev)
 		pr = &port->port_res[i];
 		snprintf(pr->int_send_name, EHEA_IRQ_NAME_SIZE - 1,
 			 "%s-queue%d", dev->name, i);
-		ret = ibmebus_request_irq(NULL, pr->eq->attr.ist1,
+		ret = ibmebus_request_irq(pr->eq->attr.ist1,
 					  ehea_recv_irq_handler,
 					  IRQF_DISABLED, pr->int_send_name,
 					  pr);
@@ -1007,11 +1007,11 @@ out:
 out_free_req:
 	while (--i >= 0) {
 		u32 ist = port->port_res[i].eq->attr.ist1;
-		ibmebus_free_irq(NULL, ist, &port->port_res[i]);
+		ibmebus_free_irq(ist, &port->port_res[i]);
 	}
 
 out_free_qpeq:
-	ibmebus_free_irq(NULL, port->qp_eq->attr.ist1, port);
+	ibmebus_free_irq(port->qp_eq->attr.ist1, port);
 	i = port->num_def_qps;
 
 	goto out;
@@ -1028,14 +1028,14 @@ static void ehea_free_interrupts(struct net_device *dev)
 
 	for (i = 0; i < port->num_def_qps + port->num_add_tx_qps; i++) {
 		pr = &port->port_res[i];
-		ibmebus_free_irq(NULL, pr->eq->attr.ist1, pr);
+		ibmebus_free_irq(pr->eq->attr.ist1, pr);
 		if (netif_msg_intr(port))
 			ehea_info("free send irq for res %d with handle 0x%X",
 				  i, pr->eq->attr.ist1);
 	}
 
 	/* associated events */
-	ibmebus_free_irq(NULL, port->qp_eq->attr.ist1, port);
+	ibmebus_free_irq(port->qp_eq->attr.ist1, port);
 	if (netif_msg_intr(port))
 		ehea_info("associated event interrupt for handle 0x%X freed",
 			  port->qp_eq->attr.ist1);
@@ -2548,7 +2548,7 @@ static struct device *ehea_register_port(struct ehea_port *port,
 	int ret;
 
 	port->ofdev.node = of_node_get(dn);
-	port->ofdev.dev.parent = &port->adapter->ebus_dev->ofdev.dev;
+	port->ofdev.dev.parent = &port->adapter->ofdev->dev;
 	port->ofdev.dev.bus = &ibmebus_bus_type;
 
 	sprintf(port->ofdev.dev.bus_id, "port%d", port_name_cnt++);
@@ -2729,7 +2729,7 @@ static int ehea_setup_ports(struct ehea_adapter *adapter)
 	const u32 *dn_log_port_id;
 	int i = 0;
 
-	lhea_dn = adapter->ebus_dev->ofdev.node;
+	lhea_dn = adapter->ofdev->node;
 	while ((eth_dn = of_get_next_child(lhea_dn, eth_dn))) {
 
 		dn_log_port_id = of_get_property(eth_dn, "ibm,hea-port-no",
@@ -2769,7 +2769,7 @@ static struct device_node *ehea_get_eth_dn(struct ehea_adapter *adapter,
 	struct device_node *eth_dn = NULL;
 	const u32 *dn_log_port_id;
 
-	lhea_dn = adapter->ebus_dev->ofdev.node;
+	lhea_dn = adapter->ofdev->node;
 	while ((eth_dn = of_get_next_child(lhea_dn, eth_dn))) {
 
 		dn_log_port_id = of_get_property(eth_dn, "ibm,hea-port-no",
@@ -2875,31 +2875,31 @@ static ssize_t ehea_remove_port(struct device *dev,
 static DEVICE_ATTR(probe_port, S_IWUSR, NULL, ehea_probe_port);
 static DEVICE_ATTR(remove_port, S_IWUSR, NULL, ehea_remove_port);
 
-int ehea_create_device_sysfs(struct ibmebus_dev *dev)
+int ehea_create_device_sysfs(struct of_device *dev)
 {
-	int ret = device_create_file(&dev->ofdev.dev, &dev_attr_probe_port);
+	int ret = device_create_file(&dev->dev, &dev_attr_probe_port);
 	if (ret)
 		goto out;
 
-	ret = device_create_file(&dev->ofdev.dev, &dev_attr_remove_port);
+	ret = device_create_file(&dev->dev, &dev_attr_remove_port);
 out:
 	return ret;
 }
 
-void ehea_remove_device_sysfs(struct ibmebus_dev *dev)
+void ehea_remove_device_sysfs(struct of_device *dev)
 {
-	device_remove_file(&dev->ofdev.dev, &dev_attr_probe_port);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_remove_port);
+	device_remove_file(&dev->dev, &dev_attr_probe_port);
+	device_remove_file(&dev->dev, &dev_attr_remove_port);
 }
 
-static int __devinit ehea_probe_adapter(struct ibmebus_dev *dev,
+static int __devinit ehea_probe_adapter(struct of_device *dev,
 					const struct of_device_id *id)
 {
 	struct ehea_adapter *adapter;
 	const u64 *adapter_handle;
 	int ret;
 
-	if (!dev || !dev->ofdev.node) {
+	if (!dev || !dev->node) {
 		ehea_error("Invalid ibmebus device probed");
 		return -EINVAL;
 	}
@@ -2907,36 +2907,36 @@ static int __devinit ehea_probe_adapter(struct ibmebus_dev *dev,
 	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
 	if (!adapter) {
 		ret = -ENOMEM;
-		dev_err(&dev->ofdev.dev, "no mem for ehea_adapter\n");
+		dev_err(&dev->dev, "no mem for ehea_adapter\n");
 		goto out;
 	}
 
 	list_add(&adapter->list, &adapter_list);
 
-	adapter->ebus_dev = dev;
+	adapter->ofdev = dev;
 
-	adapter_handle = of_get_property(dev->ofdev.node, "ibm,hea-handle",
+	adapter_handle = of_get_property(dev->node, "ibm,hea-handle",
 					 NULL);
 	if (adapter_handle)
 		adapter->handle = *adapter_handle;
 
 	if (!adapter->handle) {
-		dev_err(&dev->ofdev.dev, "failed getting handle for adapter"
-			" '%s'\n", dev->ofdev.node->full_name);
+		dev_err(&dev->dev, "failed getting handle for adapter"
+			" '%s'\n", dev->node->full_name);
 		ret = -ENODEV;
 		goto out_free_ad;
 	}
 
 	adapter->pd = EHEA_PD_ID;
 
-	dev->ofdev.dev.driver_data = adapter;
+	dev->dev.driver_data = adapter;
 
 
 	/* initialize adapter and ports */
 	/* get adapter properties */
 	ret = ehea_sense_adapter_attr(adapter);
 	if (ret) {
-		dev_err(&dev->ofdev.dev, "sense_adapter_attr failed: %d", ret);
+		dev_err(&dev->dev, "sense_adapter_attr failed: %d", ret);
 		goto out_free_ad;
 	}
 
@@ -2944,18 +2944,18 @@ static int __devinit ehea_probe_adapter(struct ibmebus_dev *dev,
 				      EHEA_NEQ, EHEA_MAX_ENTRIES_EQ, 1);
 	if (!adapter->neq) {
 		ret = -EIO;
-		dev_err(&dev->ofdev.dev, "NEQ creation failed");
+		dev_err(&dev->dev, "NEQ creation failed");
 		goto out_free_ad;
 	}
 
 	tasklet_init(&adapter->neq_tasklet, ehea_neq_tasklet,
 		     (unsigned long)adapter);
 
-	ret = ibmebus_request_irq(NULL, adapter->neq->attr.ist1,
+	ret = ibmebus_request_irq(adapter->neq->attr.ist1,
 				  ehea_interrupt_neq, IRQF_DISABLED,
 				  "ehea_neq", adapter);
 	if (ret) {
-		dev_err(&dev->ofdev.dev, "requesting NEQ IRQ failed");
+		dev_err(&dev->dev, "requesting NEQ IRQ failed");
 		goto out_kill_eq;
 	}
 
@@ -2971,7 +2971,7 @@ static int __devinit ehea_probe_adapter(struct ibmebus_dev *dev,
 
 	ret = ehea_setup_ports(adapter);
 	if (ret) {
-		dev_err(&dev->ofdev.dev, "setup_ports failed");
+		dev_err(&dev->dev, "setup_ports failed");
 		goto out_rem_dev_sysfs;
 	}
 
@@ -2985,7 +2985,7 @@ out_kill_wq:
 	destroy_workqueue(adapter->ehea_wq);
 
 out_free_irq:
-	ibmebus_free_irq(NULL, adapter->neq->attr.ist1, adapter);
+	ibmebus_free_irq(adapter->neq->attr.ist1, adapter);
 
 out_kill_eq:
 	ehea_destroy_eq(adapter->neq);
@@ -2996,9 +2996,9 @@ out:
 	return ret;
 }
 
-static int __devexit ehea_remove(struct ibmebus_dev *dev)
+static int __devexit ehea_remove(struct of_device *dev)
 {
-	struct ehea_adapter *adapter = dev->ofdev.dev.driver_data;
+	struct ehea_adapter *adapter = dev->dev.driver_data;
 	int i;
 
 	for (i = 0; i < EHEA_MAX_PORTS; i++)
@@ -3011,7 +3011,7 @@ static int __devexit ehea_remove(struct ibmebus_dev *dev)
 
 	destroy_workqueue(adapter->ehea_wq);
 
-	ibmebus_free_irq(NULL, adapter->neq->attr.ist1, adapter);
+	ibmebus_free_irq(adapter->neq->attr.ist1, adapter);
 	tasklet_kill(&adapter->neq_tasklet);
 
 	ehea_destroy_eq(adapter->neq);
-- 
1.5.2


