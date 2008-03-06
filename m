Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbYCGDfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbYCGDfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 22:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932418AbYCGDeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 22:34:31 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:64772 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932928AbYCGDe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 22:34:29 -0500
Message-Id: <20080307032237.805326022@mvista.com>
References: <20080307032237.517704747@mvista.com>
User-Agent: quilt/0.46-1
Date: Thu, 06 Mar 2008 00:00:03 -0800
Subject: [PATCH 3/5] net: ehea: locking order correction
From: Daniel Walker <dwalker@mvista.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Disposition: inline; filename=net-ehea-correct-locking-order.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nested locks always need to be taken in the same order. This change
factors out the ehea_fw_handles.lock to make the locking order
consistent.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/net/ehea/ehea_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.24/drivers/net/ehea/ehea_main.c
===================================================================
--- linux-2.6.24.orig/drivers/net/ehea/ehea_main.c
+++ linux-2.6.24/drivers/net/ehea/ehea_main.c
@@ -2567,14 +2567,14 @@ static int ehea_down(struct net_device *
 	if (port->state == EHEA_PORT_DOWN)
 		return 0;
 
+	mutex_lock(&ehea_fw_handles.lock);
+
 	down(&ehea_bcmc_regs.lock);
 	ehea_drop_multicast_list(dev);
 	ehea_broadcast_reg_helper(port, H_DEREG_BCMC);
 
 	ehea_free_interrupts(dev);
 
-	mutex_lock(&ehea_fw_handles.lock);
-
 	port->state = EHEA_PORT_DOWN;
 
 	ehea_update_bcmc_registrations();

-- 
