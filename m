Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab0CHTO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:14:59 -0500
Received: from mail2.tundra.com ([142.46.200.162]:46869 "EHLO mx2.tundra.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753458Ab0CHTO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:14:56 -0500
X-ASG-Debug-ID: 1268075692-755f00210000-xx1T2L
X-Barracuda-URL: http://142.46.200.162:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: abounine@tundra.com
Date: Mon, 8 Mar 2010 14:14:46 -0500
From: Alexandre Bounine <abounine@tundra.com>
To: mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       thomas.moll@sysgo.com, abounine@tundra.com
X-ASG-Orig-Subj: [PATCH v2 6/7] RapidIO: Add enabling SRIO port RX and TX
Subject: [PATCH v2 6/7] RapidIO: Add enabling SRIO port RX and TX
Message-ID: <20100308191446.GF4324@amak.tundra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Barracuda-Connect: UNKNOWN[142.46.200.189]
X-Barracuda-Start-Time: 1268075692
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at tundra.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Moll <thomas.moll@sysgo.com>

Add the functionality to enable Input receiver and Output
transmitter of every port, to allow non-maintenance traffic.

Signed-off-by: Thomas Moll <thomas.moll@sysgo.com>
---

 drivers/rapidio/Kconfig    |   11 ++++++
 drivers/rapidio/rio-scan.c |   79 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/rio_regs.h   |    5 ++
 3 files changed, 94 insertions(+), 1 deletion(-)

diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33a/drivers/rapidio/Kconfig w33b/drivers/rapidio/Kconfig
--- w33a/drivers/rapidio/Kconfig	2010-02-24 13:52:17.000000000 -0500
+++ w33b/drivers/rapidio/Kconfig	2010-03-08 11:41:03.651089000 -0500
@@ -8,3 +8,14 @@ config RAPIDIO_DISC_TIMEOUT
 	---help---
 	  Amount of time a discovery node waits for a host to complete
 	  enumeration before giving up.
+
+config RAPIDIO_ENABLE_RX_TX_PORTS
+	bool "Enable RapidIO Input/Output Ports"
+	depends on RAPIDIO
+	---help---
+	  The RapidIO specification describes a Output port transmit
+	  enable and a Input port receive enable. The recommended state
+	  for Input ports and Output ports should be disabled. When
+	  this switch is set the RapidIO subsystem will enable all
+	  ports for Input/Output direction to allow other traffic
+	  than Maintenance transfers.
diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33a/drivers/rapidio/rio-scan.c w33b/drivers/rapidio/rio-scan.c
--- w33a/drivers/rapidio/rio-scan.c	2010-03-08 09:52:21.092257000 -0500
+++ w33b/drivers/rapidio/rio-scan.c	2010-03-08 11:41:03.681060000 -0500
@@ -8,6 +8,10 @@
  * Alex Bounine <alexandre.bounine@idt.com>
  * - Added Port-Write/Error Management initialization and handling
  *
+ * Copyright 2009 Sysgo AG
+ * Thomas Moll <thomas.moll@sysgo.com>
+ * - Added Input- Output- enable functionality, to allow full communication
+ *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
@@ -328,6 +332,65 @@ static int __devinit rio_add_device(stru
 }
 
 /**
+ * rio_enable_rx_tx_port - enable input reciever and output transmitter of
+ * given port
+ * @port: Master port associated with the RIO network
+ * @local: local=1 select local port otherwise a far device is reached
+ * @destid: Destination ID of the device to check host bit
+ * @hopcount: Number of hops to reach the target
+ * @port_num: Port (-number on switch) to enable on a far end device
+ *
+ * Returns 0 or 1 from on General Control Command and Status Register
+ * (EXT_PTR+0x3C)
+ */
+inline int rio_enable_rx_tx_port(struct rio_mport *port,
+				 int local, u16 destid,
+				 u8 hopcount, u8 port_num) {
+#ifdef CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS
+	u32 regval;
+	u32 ext_ftr_ptr;
+
+	/*
+	* enable rx input tx output port
+	*/
+	pr_debug("rio_enable_rx_tx_port(local = %d, destid = %d, hopcount = "
+		 "%d, port_num = %d)\n", local, destid, hopcount, port_num);
+
+	ext_ftr_ptr = rio_mport_get_physefb(port, local, destid, hopcount);
+
+	if (local) {
+		rio_local_read_config_32(port, ext_ftr_ptr +
+				RIO_PORT_N_CTL_CSR(0),
+				&regval);
+	} else {
+		if (rio_mport_read_config_32(port, destid, hopcount,
+		ext_ftr_ptr + RIO_PORT_N_CTL_CSR(port_num), &regval) < 0)
+			return -EIO;
+	}
+
+	if (regval & RIO_PORT_N_CTL_P_TYP_SER) {
+		/* serial */
+		regval = regval | RIO_PORT_N_CTL_EN_RX_SER
+				| RIO_PORT_N_CTL_EN_TX_SER;
+	} else {
+		/* parallel */
+		regval = regval | RIO_PORT_N_CTL_EN_RX_PAR
+				| RIO_PORT_N_CTL_EN_TX_PAR;
+	}
+
+	if (local) {
+		rio_local_write_config_32(port, ext_ftr_ptr +
+					  RIO_PORT_N_CTL_CSR(0), regval);
+	} else {
+		if (rio_mport_write_config_32(port, destid, hopcount,
+		    ext_ftr_ptr + RIO_PORT_N_CTL_CSR(port_num), regval) < 0)
+			return -EIO;
+	}
+#endif
+	return 0;
+}
+
+/**
  * rio_setup_device- Allocates and sets up a RIO device
  * @net: RIO network
  * @port: Master port to send transactions
@@ -430,9 +493,14 @@ static struct rio_dev __devinit *rio_set
 
 		list_add_tail(&rswitch->node, &rio_switches);
 
-	} else
+	} else {
+		if (do_enum)
+			/*Enable Input Output Port (transmitter reviever)*/
+			rio_enable_rx_tx_port(port, 0, destid, hopcount, 0);
+
 		dev_set_name(&rdev->dev, "%02x:e:%04x", rdev->net->id,
 			     rdev->destid);
+	}
 
 	rdev->dev.bus = &rio_bus_type;
 
@@ -812,6 +880,11 @@ static int __devinit rio_enum_peer(struc
 		    rio_name(rdev), rdev->vid, rdev->did, num_ports);
 		sw_destid = next_destid;
 		for (port_num = 0; port_num < num_ports; port_num++) {
+			/*Enable Input Output Port (transmitter reviever)*/
+			rio_enable_rx_tx_port(port, 0,
+					      RIO_ANY_DESTID(port->sys_size),
+					      hopcount, port_num);
+
 			if (sw_inport == port_num) {
 				rdev->rswitch->port_ok |= (1 << port_num);
 				continue;
@@ -1128,6 +1201,10 @@ int __devinit rio_enum_mport(struct rio_
 			rc = -ENOMEM;
 			goto out;
 		}
+
+		/* Enable Input Output Port (transmitter reviever) */
+		rio_enable_rx_tx_port(mport, 1, 0, 0, 0);
+
 		if (rio_enum_peer(net, mport, 0) < 0) {
 			/* A higher priority host won enumeration, bail. */
 			printk(KERN_INFO
diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33a/include/linux/rio_regs.h w33b/include/linux/rio_regs.h
--- w33a/include/linux/rio_regs.h	2010-03-08 09:52:21.345049000 -0500
+++ w33b/include/linux/rio_regs.h	2010-03-08 11:41:03.727024000 -0500
@@ -243,7 +243,12 @@
 #define  RIO_PORT_N_CTL_PWIDTH		0xc0000000
 #define  RIO_PORT_N_CTL_PWIDTH_1	0x00000000
 #define  RIO_PORT_N_CTL_PWIDTH_4	0x40000000
+#define  RIO_PORT_N_CTL_P_TYP_SER	0x00000001
 #define  RIO_PORT_N_CTL_LOCKOUT		0x00000002
+#define  RIO_PORT_N_CTL_EN_RX_SER	0x00200000
+#define  RIO_PORT_N_CTL_EN_TX_SER	0x00400000
+#define  RIO_PORT_N_CTL_EN_RX_PAR	0x08000000
+#define  RIO_PORT_N_CTL_EN_TX_PAR	0x40000000
 
 /*
  * Error Management Extensions (RapidIO 1.3+, Part 8)

---

Important Notice: This message is intended for the use of the individual to whom it is addressed and may contain information which is privileged, confidential and/or exempt from disclosure under applicable law. If the reader of this message is not the intended recipient, or is not the employee or agent responsible for delivering the message to the intended recipient, you are hereby notified that any dissemination, distribution, or copying of this communication is strictly prohibited. If you have received this communication in error, please notify the sender immediately by telephone or return e-mail and delete the original message from your systems. Thank you. 

