Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZCKIyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZCKIyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbZCKIyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:54:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:18531 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbZCKIyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:54:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,341,1233561600"; 
   d="scan'208";a="496843672"
Subject: [RFC v2: Patch 2/3] net: hand off skb list to other cpu to submit
	to upper layer
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: herbert@gondor.apana.org.au, jesse.brandeburg@intel.com,
       shemminger@vyatta.com, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Mar 2009 16:53:50 +0800
Message-Id: <1236761630.2567.443.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: net: hand off skb list to other cpu to submit to upper layer
From: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>﻿

Add new sysfs interface /sys/class/net/ethXXX/rx_queueXXX/processing_cpu. Admin
could use it to configure the binding between RX and cpu number. So it's convenient
for driver to use the new capability.

Function﻿ alloc_netdev_rxtx_mq is called by drivers to initiate netdev with RX queue.
﻿
Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>

---

--- linux-2.6.29-rc7_backlog/include/linux/netdevice.h	2009-03-11 10:17:08.000000000 +0800
+++ linux-2.6.29-rc7_rxqueue_sysfs/include/linux/netdevice.h	2009-03-11 13:26:23.000000000 +0800
@@ -443,6 +443,10 @@ struct netdev_queue {
 	struct Qdisc		*qdisc_sleeping;
 } ____cacheline_aligned_in_smp;
 
+struct netdev_queue_attr {
+	struct kobject		kobj;
+	int			processing_cpu;
+};
 
 /*
  * This structure defines the management hooks for network devices.
@@ -760,6 +764,10 @@ struct net_device
 
 	struct netdev_queue	rx_queue;
 
+	/* Export by sysfs */
+	struct netdev_queue_attr *_rx_attr;
+	unsigned int		num_rx_queues;
+
 	struct netdev_queue	*_tx ____cacheline_aligned_in_smp;
 
 	/* Number of TX queues allocated at alloc_netdev_mq() time  */
@@ -770,6 +778,7 @@ struct net_device
 
 	unsigned long		tx_queue_len;	/* Max frames per queue allowed */
 	spinlock_t		tx_global_lock;
+
 /*
  * One part is mostly used on xmit path (device)
  */
@@ -1773,10 +1782,28 @@ static inline void netif_addr_unlock_bh(
 
 extern void		ether_setup(struct net_device *dev);
 
+static inline int netif_rx_processing_cpu(struct net_device *dev, int rx_num)
+{
+	int cpu = -1;
+
+	if (rx_num >= 0 && rx_num < dev->num_rx_queues)
+		cpu = dev->_rx_attr[rx_num].processing_cpu;
+
+	if (cpu == -1)
+		cpu = smp_processor_id();
+
+	return cpu;
+}
+
 /* Support for loadable net-drivers */
 extern struct net_device *alloc_netdev_mq(int sizeof_priv, const char *name,
 				       void (*setup)(struct net_device *),
 				       unsigned int queue_count);
+extern struct net_device *alloc_netdev_rxtx_mq(int sizeof_priv,
+				const char *name,
+				void (*setup)(struct net_device *),
+				unsigned int rx_queue_count,
+				unsigned int tx_queue_count);
 #define alloc_netdev(sizeof_priv, name, setup) \
 	alloc_netdev_mq(sizeof_priv, name, setup, 1)
 extern int		register_netdev(struct net_device *dev);
--- linux-2.6.29-rc7_backlog/include/linux/etherdevice.h	2009-03-11 10:16:16.000000000 +0800
+++ linux-2.6.29-rc7_rxqueue_sysfs/include/linux/etherdevice.h	2009-03-10 12:53:59.000000000 +0800
@@ -51,6 +51,9 @@ extern int eth_validate_addr(struct net_
 extern struct net_device *alloc_etherdev_mq(int sizeof_priv, unsigned int queue_count);
 #define alloc_etherdev(sizeof_priv) alloc_etherdev_mq(sizeof_priv, 1)
 
+extern struct net_device *alloc_etherdev_rxtx_mq(int sizeof_priv,
+		unsigned int rx_queue_count, unsigned int tx_queue_count);
+
 /**
  * is_zero_ether_addr - Determine if give Ethernet address is all zeros.
  * @addr: Pointer to a six-byte array containing the Ethernet address
--- linux-2.6.29-rc7_backlog/net/core/dev.c	2009-03-11 10:27:57.000000000 +0800
+++ linux-2.6.29-rc7_rxqueue_sysfs/net/core/dev.c	2009-03-11 13:26:23.000000000 +0800
@@ -4862,6 +4862,39 @@ struct net_device *alloc_netdev_mq(int s
 }
 EXPORT_SYMBOL(alloc_netdev_mq);
 
+struct net_device *alloc_netdev_rxtx_mq(int sizeof_priv,
+		const char *name,
+		void (*setup)(struct net_device *),
+		unsigned int rx_queue_count,
+		unsigned int tx_queue_count)
+{
+	struct netdev_queue_attr *rx;
+	struct net_device *dev;
+	int i;
+
+	dev = alloc_netdev_mq(sizeof_priv, name, setup, tx_queue_count);
+	if (dev && rx_queue_count) {
+		rx = kcalloc(rx_queue_count,
+			sizeof(struct netdev_queue_attr),
+			GFP_KERNEL);
+		if (!rx) {
+			printk(KERN_ERR "alloc_netdev: Unable to allocate "
+					"rx attributes.\n");
+			free_netdev(dev);
+			return NULL;
+		}
+
+		for (i = 0; i < rx_queue_count; i ++)
+			rx[i].processing_cpu = -1;
+
+		dev->_rx_attr = rx;
+		dev->num_rx_queues = rx_queue_count;
+	}
+
+	return dev;
+}
+EXPORT_SYMBOL(alloc_netdev_rxtx_mq);
+
 /**
  *	free_netdev - free network device
  *	@dev: device
@@ -4877,6 +4910,7 @@ void free_netdev(struct net_device *dev)
 	release_net(dev_net(dev));
 
 	kfree(dev->_tx);
+	kfree(dev->_rx_attr);
 
 	list_for_each_entry_safe(p, n, &dev->napi_list, dev_list)
 		netif_napi_del(p);
--- linux-2.6.29-rc7_backlog/net/core/net-sysfs.c	2009-03-11 10:15:23.000000000 +0800
+++ linux-2.6.29-rc7_rxqueue_sysfs/net/core/net-sysfs.c	2009-03-11 13:18:45.000000000 +0800
@@ -419,6 +419,83 @@ static struct attribute_group wireless_g
 };
 #endif
 
+#define to_rx_queue_attr(k)	container_of(k, struct netdev_queue_attr, kobj)
+#define RX_QUEUE_ATTR(name)				\
+static struct kobj_attribute name##_attr =		\
+	__ATTR(name, 0644, show_##name, store_##name);
+
+static ssize_t show_processing_cpu(struct kobject *kobj,
+			struct kobj_attribute *attr,
+			char *buf)
+{
+	return sprintf(buf, "%d", to_rx_queue_attr(kobj)->processing_cpu);
+}
+
+static ssize_t store_processing_cpu(struct kobject *kobj,
+		struct kobj_attribute *attr,
+		const char *buf,
+		size_t count)
+{
+	int var;
+	sscanf(buf, "%d", &var);
+	if ((var >= 0 && var < nr_cpu_ids) || var == -1) {
+		to_rx_queue_attr(kobj)->processing_cpu = var;
+		return count;
+	} else
+		return -EINVAL;
+}
+
+RX_QUEUE_ATTR(processing_cpu);
+
+static struct attribute *rx_queue_attrs[] = {
+	&processing_cpu_attr.attr,
+	NULL
+};
+
+static struct kobj_type ktype_rx_queue = {
+	.sysfs_ops      = &kobj_sysfs_ops,
+	.default_attrs  = rx_queue_attrs
+};
+
+static int sysfs_net_remove_rx_queue(struct net_device *net,
+		int rx_queue_count)
+{
+	int i;
+
+	for (i = 0; i < rx_queue_count; i ++)
+		kobject_put(&net->_rx_attr[i].kobj);
+
+	return 0;
+}
+
+int sysfs_net_add_rx_queue(struct net_device *net)
+{
+	char *queue_name;
+	int retval = 0;
+	int i;
+
+	if (!net->num_rx_queues)
+		return 0;
+
+	queue_name = kmalloc(4096, GFP_KERNEL);
+	if (!queue_name)
+		return -ENOMEM;
+
+	for (i = 0; i < net->num_rx_queues; i ++) {
+		sprintf(queue_name, "rx_queue%d", i);
+		retval = kobject_init_and_add(&net->_rx_attr[i].kobj,
+				&ktype_rx_queue,
+				&net->dev.kobj, "%s", queue_name);
+		if (retval < 0) {
+			sysfs_net_remove_rx_queue(net, i);
+			break;
+		}
+	}
+
+	kfree(queue_name);
+	return retval;
+}
+
 #endif /* CONFIG_SYSFS */
 
 #ifdef CONFIG_HOTPLUG
@@ -482,6 +559,10 @@ void netdev_unregister_kobject(struct ne
 	if (dev_net(net) != &init_net)
 		return;
 
+#ifdef CONFIG_SYSFS
+	sysfs_net_remove_rx_queue(net, net->num_rx_queues);
+#endif
+
 	device_del(dev);
 }
 
@@ -490,6 +571,7 @@ int netdev_register_kobject(struct net_d
 {
 	struct device *dev = &(net->dev);
 	struct attribute_group **groups = net->sysfs_groups;
+	int retval;
 
 	dev->class = &net_class;
 	dev->platform_data = net;
@@ -510,7 +592,17 @@ int netdev_register_kobject(struct net_d
 	if (dev_net(net) != &init_net)
 		return 0;
 
-	return device_add(dev);
+	retval =  device_add(dev);
+
+#ifdef CONFIG_SYSFS
+	if (!retval) {
+		retval = sysfs_net_add_rx_queue(net);
+		if (retval)
+			device_del(dev);
+	}
+#endif
+
+	return retval;
 }
 
 int netdev_class_create_file(struct class_attribute *class_attr)
--- linux-2.6.29-rc7_backlog/net/ethernet/eth.c	2009-03-11 10:15:22.000000000 +0800
+++ linux-2.6.29-rc7_rxqueue_sysfs/net/ethernet/eth.c	2009-03-10 12:55:26.000000000 +0800
@@ -374,6 +374,14 @@ struct net_device *alloc_etherdev_mq(int
 }
 EXPORT_SYMBOL(alloc_etherdev_mq);
 
+struct net_device *alloc_etherdev_rxtx_mq(int sizeof_priv,
+		unsigned int rx_queue_count, unsigned int tx_queue_count)
+{
+	return alloc_netdev_rxtx_mq(sizeof_priv, "eth%d", ether_setup,
+			rx_queue_count, tx_queue_count);
+}
+EXPORT_SYMBOL(alloc_etherdev_rxtx_mq);
+
 static size_t _format_mac_addr(char *buf, int buflen,
 				const unsigned char *addr, int len)
 {


