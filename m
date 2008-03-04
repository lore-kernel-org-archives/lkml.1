Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbYCDIbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbYCDIbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYCDIar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:30:47 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:46043 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbYCDIao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:30:44 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 06/17] Change the kernel configurated RapidIO system size to auto-probing.
Date: Wed,  5 Mar 2008 00:29:51 +0800
Message-Id: <1204648202-5495-6-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1204648202-5495-5-git-send-email-wei.zhang@freescale.com>
References: <1204648202-5495-1-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-2-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-3-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-4-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-5-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 04 Mar 2008 08:30:34.0922 (UTC) FILETIME=[045320A0:01C87DD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RapidIO system size will auto probe in RIO setup. The route
table and rionet_active in rionet.c are changed to be allocated
dynamically according the system size.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/sysdev/fsl_rio.c |    6 +++++
 drivers/net/rionet.c          |   16 +++++++++++-
 drivers/rapidio/Kconfig       |    8 ------
 drivers/rapidio/rio-scan.c    |   51 +++++++++++++++++++++++++++++------------
 drivers/rapidio/rio-sysfs.c   |    3 +-
 drivers/rapidio/rio.c         |    2 +-
 drivers/rapidio/rio.h         |    9 +-----
 include/linux/rio.h           |   14 +++++-----
 8 files changed, 68 insertions(+), 41 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 5c9af4f..9dae418 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -1010,6 +1010,12 @@ int fsl_rio_setup(struct of_device *dev)
 	rio_register_mport(port);
 
 	priv->regs_win = (u32) ioremap(regs.start, regs.end - regs.start + 1);
+
+	port->sys_size = (in_be32((priv->regs_win + RIO_PEF_CAR))
+					& RIO_PEF_CTLS) >> 4;
+	dev_info(&dev->dev, "RapidIO Common Transport System size: %d\n",
+			port->sys_size ? 65536 : 256);
+
 	priv->atmu_regs = (struct rio_atmu_regs *)(priv->regs_win
 					+ RIO_ATMU_REGS_OFFSET);
 	priv->maint_atmu_regs = priv->atmu_regs + 1;
diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index e7fd08a..6aa9731 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -77,7 +77,7 @@ static int rionet_capable = 1;
  * could be made into a hash table to save memory depending
  * on system trade-offs.
  */
-static struct rio_dev *rionet_active[RIO_MAX_ROUTE_ENTRIES];
+static struct rio_dev **rionet_active;
 
 #define is_rionet_capable(pef, src_ops, dst_ops)		\
 			((pef & RIO_PEF_INB_MBOX) &&		\
@@ -195,7 +195,8 @@ static int rionet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	}
 
 	if (eth->h_dest[0] & 0x01) {
-		for (i = 0; i < RIO_MAX_ROUTE_ENTRIES; i++)
+		for (i = 0; i < RIO_MAX_ROUTE_ENTRIES(rnet->mport->sys_size);
+				i++)
 			if (rionet_active[i])
 				rionet_queue_tx_msg(skb, ndev,
 						    rionet_active[i]);
@@ -385,6 +386,8 @@ static void rionet_remove(struct rio_dev *rdev)
 	struct net_device *ndev = NULL;
 	struct rionet_peer *peer, *tmp;
 
+	free_pages((unsigned long)rionet_active, rdev->net->hport->sys_size ?
+					__ilog2(sizeof(void *)) + 4 : 0);
 	unregister_netdev(ndev);
 	kfree(ndev);
 
@@ -443,6 +446,15 @@ static int rionet_setup_netdev(struct rio_mport *mport)
 		goto out;
 	}
 
+	if (!(rionet_active = (struct rio_dev **)__get_free_pages(GFP_KERNEL,
+				mport->sys_size ? __ilog2(sizeof(void *)) + 4
+				: 0))) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	memset((void *)rionet_active, 0, sizeof(void *) *
+				RIO_MAX_ROUTE_ENTRIES(mport->sys_size));
+
 	/* Set up private area */
 	rnet = (struct rionet_private *)ndev->priv;
 	rnet->mport = mport;
diff --git a/drivers/rapidio/Kconfig b/drivers/rapidio/Kconfig
index 4142115..c32822a 100644
--- a/drivers/rapidio/Kconfig
+++ b/drivers/rapidio/Kconfig
@@ -1,14 +1,6 @@
 #
 # RapidIO configuration
 #
-config RAPIDIO_8_BIT_TRANSPORT
-	bool "8-bit transport addressing"
-	depends on RAPIDIO
-	---help---
-	  By default, the kernel assumes a 16-bit addressed RapidIO
-	  network. By selecting this option, the kernel will support
-	  an 8-bit addressed network.
-
 config RAPIDIO_DISC_TIMEOUT
 	int "Discovery timeout duration (seconds)"
 	depends on RAPIDIO
diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 4442072..ca895d1 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -73,7 +73,7 @@ static u16 rio_get_device_id(struct rio_mport *port, u16 destid, u8 hopcount)
 
 	rio_mport_read_config_32(port, destid, hopcount, RIO_DID_CSR, &result);
 
-	return RIO_GET_DID(result);
+	return RIO_GET_DID(port->sys_size, result);
 }
 
 /**
@@ -88,7 +88,7 @@ static u16 rio_get_device_id(struct rio_mport *port, u16 destid, u8 hopcount)
 static void rio_set_device_id(struct rio_mport *port, u16 destid, u8 hopcount, u16 did)
 {
 	rio_mport_write_config_32(port, destid, hopcount, RIO_DID_CSR,
-				  RIO_SET_DID(did));
+				  RIO_SET_DID(port->sys_size, did));
 }
 
 /**
@@ -100,7 +100,8 @@ static void rio_set_device_id(struct rio_mport *port, u16 destid, u8 hopcount, u
  */
 static void rio_local_set_device_id(struct rio_mport *port, u16 did)
 {
-	rio_local_write_config_32(port, RIO_DID_CSR, RIO_SET_DID(did));
+	rio_local_write_config_32(port, RIO_DID_CSR, RIO_SET_DID(port->sys_size,
+				did));
 }
 
 /**
@@ -350,8 +351,17 @@ static struct rio_dev *rio_setup_device(struct rio_net *net,
 		rswitch->switchid = next_switchid;
 		rswitch->hopcount = hopcount;
 		rswitch->destid = destid;
+		if (!(rswitch->route_table = kzalloc(sizeof(u8)*
+					RIO_MAX_ROUTE_ENTRIES(port->sys_size),
+					GFP_KERNEL))) {
+			kfree(rdev);
+			rdev = NULL;
+			kfree(rswitch);
+			goto out;
+		}
 		/* Initialize switch route table */
-		for (rdid = 0; rdid < RIO_MAX_ROUTE_ENTRIES; rdid++)
+		for (rdid = 0; rdid < RIO_MAX_ROUTE_ENTRIES(port->sys_size);
+				rdid++)
 			rswitch->route_table[rdid] = RIO_INVALID_ROUTE;
 		rdev->rswitch = rswitch;
 		sprintf(rio_name(rdev), "%02x:s:%04x", rdev->net->id,
@@ -480,7 +490,7 @@ static u16 rio_get_host_deviceid_lock(struct rio_mport *port, u8 hopcount)
 {
 	u32 result;
 
-	rio_mport_read_config_32(port, RIO_ANY_DESTID, hopcount,
+	rio_mport_read_config_32(port, RIO_ANY_DESTID(port->sys_size), hopcount,
 				 RIO_HOST_DID_LOCK_CSR, &result);
 
 	return (u16) (result & 0xffff);
@@ -571,14 +581,16 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 	}
 
 	/* Attempt to acquire device lock */
-	rio_mport_write_config_32(port, RIO_ANY_DESTID, hopcount,
+	rio_mport_write_config_32(port, RIO_ANY_DESTID(port->sys_size),
+				  hopcount,
 				  RIO_HOST_DID_LOCK_CSR, port->host_deviceid);
 	while ((tmp = rio_get_host_deviceid_lock(port, hopcount))
 	       < port->host_deviceid) {
 		/* Delay a bit */
 		mdelay(1);
 		/* Attempt to acquire device lock again */
-		rio_mport_write_config_32(port, RIO_ANY_DESTID, hopcount,
+		rio_mport_write_config_32(port, RIO_ANY_DESTID(port->sys_size),
+					  hopcount,
 					  RIO_HOST_DID_LOCK_CSR,
 					  port->host_deviceid);
 	}
@@ -590,7 +602,8 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 	}
 
 	/* Setup new RIO device */
-	if ((rdev = rio_setup_device(net, port, RIO_ANY_DESTID, hopcount, 1))) {
+	if ((rdev = rio_setup_device(net, port, RIO_ANY_DESTID(port->sys_size),
+					hopcount, 1))) {
 		/* Add device to the global and bus/net specific list. */
 		list_add_tail(&rdev->net_list, &net->devices);
 	} else
@@ -598,7 +611,8 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 
 	if (rio_is_switch(rdev)) {
 		next_switchid++;
-		sw_inport = rio_get_swpinfo_inport(port, RIO_ANY_DESTID, hopcount);
+		sw_inport = rio_get_swpinfo_inport(port,
+				RIO_ANY_DESTID(port->sys_size), hopcount);
 		rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
 				    port->host_deviceid, sw_inport);
 		rdev->rswitch->route_table[port->host_deviceid] = sw_inport;
@@ -612,7 +626,8 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 		}
 
 		num_ports =
-		    rio_get_swpinfo_tports(port, RIO_ANY_DESTID, hopcount);
+		    rio_get_swpinfo_tports(port, RIO_ANY_DESTID(port->sys_size),
+						hopcount);
 		pr_debug(
 		    "RIO: found %s (vid %4.4x did %4.4x) with %d ports\n",
 		    rio_name(rdev), rdev->vid, rdev->did, num_ports);
@@ -624,13 +639,15 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 			cur_destid = next_destid;
 
 			if (rio_sport_is_active
-			    (port, RIO_ANY_DESTID, hopcount, port_num)) {
+			    (port, RIO_ANY_DESTID(port->sys_size), hopcount,
+			     port_num)) {
 				pr_debug(
 				    "RIO: scanning device on port %d\n",
 				    port_num);
 				rio_route_add_entry(port, rdev->rswitch,
 						    RIO_GLOBAL_TABLE,
-						    RIO_ANY_DESTID, port_num);
+						    RIO_ANY_DESTID(port->sys_size),
+						    port_num);
 
 				if (rio_enum_peer(net, port, hopcount + 1) < 0)
 					return -1;
@@ -735,7 +752,8 @@ rio_disc_peer(struct rio_net *net, struct rio_mport *port, u16 destid,
 				pr_debug(
 				    "RIO: scanning device on port %d\n",
 				    port_num);
-				for (ndestid = 0; ndestid < RIO_ANY_DESTID;
+				for (ndestid = 0;
+				     ndestid < RIO_ANY_DESTID(port->sys_size);
 				     ndestid++) {
 					rio_route_get_entry(port, rdev->rswitch,
 							    RIO_GLOBAL_TABLE,
@@ -917,7 +935,9 @@ static void rio_build_route_tables(void)
 
 	list_for_each_entry(rdev, &rio_devices, global_list)
 	    if (rio_is_switch(rdev))
-		for (i = 0; i < RIO_MAX_ROUTE_ENTRIES; i++) {
+		for (i = 0;
+		     i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
+		     i++) {
 			if (rio_route_get_entry
 			    (rdev->net->hport, rdev->rswitch, RIO_GLOBAL_TABLE,
 			     i, &sport) < 0)
@@ -981,7 +1001,8 @@ int rio_disc_mport(struct rio_mport *mport)
 		del_timer_sync(&rio_enum_timer);
 
 		pr_debug("done\n");
-		if (rio_disc_peer(net, mport, RIO_ANY_DESTID, 0) < 0) {
+		if (rio_disc_peer(net, mport, RIO_ANY_DESTID(mport->sys_size),
+					0) < 0) {
 			printk(KERN_INFO
 			       "RIO: master port %d device has failed discovery\n",
 			       mport->id);
diff --git a/drivers/rapidio/rio-sysfs.c b/drivers/rapidio/rio-sysfs.c
index 659e311..97a147f 100644
--- a/drivers/rapidio/rio-sysfs.c
+++ b/drivers/rapidio/rio-sysfs.c
@@ -43,7 +43,8 @@ static ssize_t routes_show(struct device *dev, struct device_attribute *attr, ch
 	if (!rdev->rswitch)
 		goto out;
 
-	for (i = 0; i < RIO_MAX_ROUTE_ENTRIES; i++) {
+	for (i = 0; i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
+			i++) {
 		if (rdev->rswitch->route_table[i] == RIO_INVALID_ROUTE)
 			continue;
 		str +=
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 80c5f1b..680661a 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -43,7 +43,7 @@ u16 rio_local_get_device_id(struct rio_mport *port)
 
 	rio_local_read_config_32(port, RIO_DID_CSR, &result);
 
-	return (RIO_GET_DID(result));
+	return (RIO_GET_DID(port->sys_size, result));
 }
 
 /**
diff --git a/drivers/rapidio/rio.h b/drivers/rapidio/rio.h
index 80e3f03..7786d02 100644
--- a/drivers/rapidio/rio.h
+++ b/drivers/rapidio/rio.h
@@ -51,10 +51,5 @@ extern struct rio_route_ops __end_rio_route_ops[];
 	DECLARE_RIO_ROUTE_SECTION(.rio_route_ops,			\
 			vid, did, add_hook, get_hook)
 
-#ifdef CONFIG_RAPIDIO_8_BIT_TRANSPORT
-#define RIO_GET_DID(x)	((x & 0x00ff0000) >> 16)
-#define RIO_SET_DID(x)	((x & 0x000000ff) << 16)
-#else
-#define RIO_GET_DID(x)	(x & 0xffff)
-#define RIO_SET_DID(x)	(x & 0xffff)
-#endif
+#define RIO_GET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x00ff0000) >> 16))
+#define RIO_SET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x000000ff) << 16))
diff --git a/include/linux/rio.h b/include/linux/rio.h
index 9ed78dc..4b0156d 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -23,7 +23,6 @@
 #include <linux/device.h>
 #include <linux/rio_regs.h>
 
-#define RIO_ANY_DESTID		0xff
 #define RIO_NO_HOPCOUNT		-1
 #define RIO_INVALID_DESTID	0xffff
 
@@ -39,11 +38,8 @@
 					   entry is invalid (no route
 					   exists for the device ID) */
 
-#ifdef CONFIG_RAPIDIO_8_BIT_TRANSPORT
-#define RIO_MAX_ROUTE_ENTRIES	(1 << 8)
-#else
-#define RIO_MAX_ROUTE_ENTRIES	(1 << 16)
-#endif
+#define RIO_MAX_ROUTE_ENTRIES(size)	(size ? (1 << 16) : (1 << 8))
+#define RIO_ANY_DESTID(size)		(size ? 0xffff : 0xff)
 
 #define RIO_MAX_MBOX		4
 #define RIO_MAX_MSG_SIZE	0x1000
@@ -178,6 +174,10 @@ struct rio_mport {
 	unsigned char id;	/* port ID, unique among all ports */
 	unsigned char index;	/* port index, unique among all port
 				   interfaces of the same type */
+	unsigned int sys_size;	/* RapidIO common transport system size.
+				 * 0 - Small size. 256 devices.
+				 * 1 - Large size, 65536 devices.
+				 */
 	unsigned char name[40];
 	void *priv;		/* Master port private data */
 };
@@ -213,7 +213,7 @@ struct rio_switch {
 	u16 switchid;
 	u16 hopcount;
 	u16 destid;
-	u8 route_table[RIO_MAX_ROUTE_ENTRIES];
+	u8 *route_table;
 	int (*add_entry) (struct rio_mport * mport, u16 destid, u8 hopcount,
 			  u16 table, u16 route_destid, u8 route_port);
 	int (*get_entry) (struct rio_mport * mport, u16 destid, u8 hopcount,
-- 
1.5.4

