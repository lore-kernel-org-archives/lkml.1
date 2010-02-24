Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab0BXPVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 10:21:12 -0500
Received: from mail2.tundra.com ([142.46.200.162]:43993 "EHLO mx2.tundra.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753073Ab0BXPVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 10:21:10 -0500
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 10:21:10 EST
X-ASG-Debug-ID: 1267024866-01c300520000-xx1T2L
X-Barracuda-URL: http://142.46.200.162:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: alexb@tundra.com
Date: Wed, 24 Feb 2010 10:20:50 -0500
From: Alexandre Bounine <alexb@tundra.com>
To: mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       thomas.moll@sysgo.com, thomas.moll.ext@nsn.com, abounine@idt.com
X-ASG-Orig-Subj: [PATCH 2/7] RapidIO: Add switch locking during discovery
Subject: [PATCH 2/7] RapidIO: Add switch locking during discovery
Message-ID: <20100224152050.GB13661@kaneng01.tundra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Barracuda-Connect: UNKNOWN[142.46.200.189]
X-Barracuda-Start-Time: 1267024867
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at tundra.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alexandre Bounine <alexandre.bounine@idt.com>

Add switch access locking during RapidIO discovery. Access lock is
required when reading switch routing table contents due to indexed mechanism
of RT addressing.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Tested-by: Thomas Moll <thomas.moll@sysgo.com>
---

 rio-scan.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 79 insertions(+), 9 deletions(-)

diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33r7a/drivers/rapidio/rio-scan.c w33r7b/drivers/rapidio/rio-scan.c
--- w33r7a/drivers/rapidio/rio-scan.c	2010-02-09 15:11:09.141972000 -0500
+++ w33r7b/drivers/rapidio/rio-scan.c	2010-02-10 16:13:56.382802000 -0500
@@ -750,6 +750,7 @@ rio_disc_peer(struct rio_net *net, struc
 	int num_ports;
 	struct rio_dev *rdev;
 	u16 ndestid;
+	u32 result;
 
 	/* Setup new RIO device */
 	if ((rdev = rio_setup_device(net, port, destid, hopcount, 0))) {
@@ -778,6 +779,27 @@ rio_disc_peer(struct rio_net *net, struc
 				pr_debug(
 				    "RIO: scanning device on port %d\n",
 				    port_num);
+
+				/* Attempt to acquire device lock */
+				rio_mport_write_config_32(port, destid,
+							  hopcount,
+							  RIO_HOST_DID_LOCK_CSR,
+							  port->host_deviceid);
+				rio_mport_read_config_32(port, destid, hopcount,
+					RIO_HOST_DID_LOCK_CSR, &result);
+				while (result != port->host_deviceid) {
+					/* Delay a bit */
+					mdelay(1);
+					/* Try to acquire device lock again */
+					rio_mport_write_config_32(port, destid,
+						hopcount,
+						RIO_HOST_DID_LOCK_CSR,
+						port->host_deviceid);
+					rio_mport_read_config_32(port, destid,
+						hopcount,
+						RIO_HOST_DID_LOCK_CSR, &result);
+				}
+
 				for (ndestid = 0;
 				     ndestid < RIO_ANY_DESTID(port->sys_size);
 				     ndestid++) {
@@ -789,6 +811,19 @@ rio_disc_peer(struct rio_net *net, struc
 						break;
 				}
 
+				/* Release device lock */
+				rio_mport_write_config_32(port, destid,
+							  hopcount,
+							  RIO_HOST_DID_LOCK_CSR,
+							  port->host_deviceid);
+				rio_mport_read_config_32(port, destid, hopcount,
+					RIO_HOST_DID_LOCK_CSR, &result);
+				if ((result & 0xffff) != 0xffff) {
+					pr_info("RIO: badness when releasing " \
+						"host lock on %s\n",
+						rio_name(rdev));
+				}
+
 				if (rio_disc_peer
 				    (net, port, ndestid, hopcount + 1) < 0)
 					return -1;
@@ -958,17 +993,45 @@ static void rio_build_route_tables(void)
 	struct rio_dev *rdev;
 	int i;
 	u8 sport;
+	u32 result;
 
 	list_for_each_entry(rdev, &rio_devices, global_list)
-	    if (rio_is_switch(rdev))
-		for (i = 0;
-		     i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
-		     i++) {
-			if (rio_route_get_entry
-			    (rdev->net->hport, rdev->rswitch, RIO_GLOBAL_TABLE,
-			     i, &sport) < 0)
-				continue;
-			rdev->rswitch->route_table[i] = sport;
+		if (rio_is_switch(rdev)) {
+			/* Attempt to acquire device lock */
+			rio_write_config_32(rdev, RIO_HOST_DID_LOCK_CSR,
+					rdev->net->hport->host_deviceid);
+			rio_read_config_32(rdev,
+					RIO_HOST_DID_LOCK_CSR, &result);
+			while (result != rdev->net->hport->host_deviceid) {
+				/* Delay a bit */
+				mdelay(1);
+				/* Attempt to acquire device lock again */
+				rio_write_config_32(rdev, RIO_HOST_DID_LOCK_CSR,
+					rdev->net->hport->host_deviceid);
+				rio_read_config_32(rdev,
+					RIO_HOST_DID_LOCK_CSR, &result);
+			}
+
+			for (i = 0;
+			     i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
+			     i++) {
+				if (rio_route_get_entry
+				    (rdev->net->hport, rdev->rswitch,
+				     RIO_GLOBAL_TABLE, i, &sport) < 0)
+					continue;
+				rdev->rswitch->route_table[i] = sport;
+			}
+
+			/* Release device lock */
+			rio_write_config_32(rdev, RIO_HOST_DID_LOCK_CSR,
+					rdev->net->hport->host_deviceid);
+			rio_read_config_32(rdev,
+					RIO_HOST_DID_LOCK_CSR, &result);
+			if ((result & 0xffff) != 0xffff) {
+				pr_info("RIO: badness when releasing " \
+					"host lock on %s\n", rio_name(rdev));
+			}
+
 		}
 }
 
@@ -1027,6 +1090,13 @@ int __devinit rio_disc_mport(struct rio_
 		del_timer_sync(&rio_enum_timer);
 
 		pr_debug("done\n");
+
+		/* Read DestID assigned by enumerator */
+		rio_local_read_config_32(mport, RIO_DID_CSR,
+					 &mport->host_deviceid);
+		mport->host_deviceid = RIO_GET_DID(mport->sys_size,
+						   mport->host_deviceid);
+
 		if (rio_disc_peer(net, mport, RIO_ANY_DESTID(mport->sys_size),
 					0) < 0) {
 			printk(KERN_INFO

---

Important Notice: This message is intended for the use of the individual to whom it is addressed and may contain information which is privileged, confidential and/or exempt from disclosure under applicable law. If the reader of this message is not the intended recipient, or is not the employee or agent responsible for delivering the message to the intended recipient, you are hereby notified that any dissemination, distribution, or copying of this communication is strictly prohibited. If you have received this communication in error, please notify the sender immediately by telephone or return e-mail and delete the original message from your systems. Thank you. 

