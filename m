Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbYFIOSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbYFIOSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYFIOR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:17:56 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:49585 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYFIORz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:17:55 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH][2.6.26] ehea: set mac address fix
Date: Mon, 9 Jun 2008 15:17:37 +0100
User-Agent: KMail/1.8.2
Cc: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, hering2@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806091617.38396.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eHEA has to call firmware functions in order to change the mac address
of a logical port. This patch checks if the logical port is up
when calling the register / deregister mac address calls. If the port
is down these firmware calls would fail and are therefore not executed.

Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

---

diff -Nurp -X dontdiff linux-2.6.26-rc4/drivers/net/ehea/ehea_main.c patched_kernel/drivers/net/ehea/ehea_main.c
--- linux-2.6.26-rc4/drivers/net/ehea/ehea_main.c	2008-05-26 20:08:11.000000000 +0200
+++ patched_kernel/drivers/net/ehea/ehea_main.c	2008-06-09 15:42:17.000000000 +0200
@@ -1766,16 +1766,20 @@ static int ehea_set_mac_addr(struct net_
 	mutex_lock(&ehea_bcmc_regs.lock);
 
 	/* Deregister old MAC in pHYP */
-	ret = ehea_broadcast_reg_helper(port, H_DEREG_BCMC);
-	if (ret)
-		goto out_upregs;
+	if (port->state == EHEA_PORT_UP) {
+		ret = ehea_broadcast_reg_helper(port, H_DEREG_BCMC);
+		if (ret)
+			goto out_upregs;
+	}
 
 	port->mac_addr = cb0->port_mac_addr << 16;
 
 	/* Register new MAC in pHYP */
-	ret = ehea_broadcast_reg_helper(port, H_REG_BCMC);
-	if (ret)
-		goto out_upregs;
+	if (port->state == EHEA_PORT_UP) {
+		ret = ehea_broadcast_reg_helper(port, H_REG_BCMC);
+		if (ret)
+			goto out_upregs;
+	}
 
 	ret = 0;
 
