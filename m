Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYKGPnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYKGPnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbYKGPmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:42:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60807 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYKGPmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:42:51 -0500
From: "Dasgupta, Romit" <romit@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 7 Nov 2008 21:12:43 +0530
Subject: FW: [SMC911x ]fix for driver resume
Thread-Topic: [SMC911x ]fix for driver resume
Thread-Index: Ack/+LVEFFKMv5dXQFqoW9Xv9fxw+AA9pHFw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301B34DC4E3@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
     I did not get any reply from anyone yet. Is there any MAINTAINER who can verify the patch below?

Regards,
-Romit


-----Original Message-----
From: Dasgupta, Romit 
Sent: Thursday, November 06, 2008 3:46 PM
To: 'dustin@sensoria.com'; 'jgarzik@pobox.com'; 'nico@cam.org'
Cc: 'netdev@vger.kernel.org'; linux-omap@vger.kernel.org
Subject: [SMC911x ]fix for driver resume and compilation warning 

Hi,
     I am trying out suspend, resume on an OMAP3 based board. What I see during resume is that the SMC911x driver resume routing gets stuck after trying to transmit the packet out of the controller. Some debug messages below:

--> smc911x_drv_resume
eth0: --> smc911x_reset
eth0: smc911x_reset timeout waiting for PM restore
eth0: --> smc911x_enable
eth0: --> smc911x_phy_configure()
eth0: --> smc911x_phy_reset()
eth0: phy caps=0x782d
eth0: phy advertised caps=0x0de1
eth0: --> smc911x_phy_check_media
smc911x_phy_read: phyaddr=0x1, phyreg=0x01, phydata=0x7809
smc911x_phy_read: phyaddr=0x1, phyreg=0x01, phydata=0x7809
eth0: link down
Restarting tasks ... eth0: --> smc911x_hard_start_xmit
eth0: --> smc911x_hardware_send_pkt
eth0: --> smc911x_hard_start_xmit
eth0: --> smc911x_hardware_send_pkt
eth0: --> smc911x_hard_start_xmit
eth0: --> smc911x_hardware_send_pkt
nfs: server 172.24.190.217 not responding, still trying
nfs: server 172.24.190.217 not responding, still trying


The following change makes it work fine: (The change within smc911x_drv_probe function was to get rid of a compilation warning).
Additionally, the SMC9211 data sheet says that when we enter D2 sleep state, we need to set the EDPWRDOWN bit in the PHY Mode control/status register and clear it when we are back to D0. This is not done in the code as far as I can see. So does it mean that the PHY is not powered down but the controller is? I have another patch that fixes it. I will send that as well unless I am missing something.

Thanks,
-Romit


Signed-off-by: Romit Dasgupta <romit@ti.com>

diff --git a/drivers/net/smc911x.c b/drivers/net/smc911x.c
index 5051554..1f26ab0 100644
--- a/drivers/net/smc911x.c
+++ b/drivers/net/smc911x.c
@@ -2050,7 +2050,9 @@ err_out:
  */
 static int smc911x_drv_probe(struct platform_device *pdev)
 {
+#ifdef SMC_DYNAMIC_BUS_CONFIG
 	struct smc911x_platdata *pd = pdev->dev.platform_data;
+#endif
 	struct net_device *ndev;
 	struct resource *res;
 	struct smc911x_local *lp;
@@ -2182,9 +2184,9 @@ static int smc911x_drv_resume(struct platform_device *dev)
 
 		if (netif_running(ndev)) {
 			smc911x_reset(ndev);
-			smc911x_enable(ndev);
 			if (lp->phy_type != 0)
 				smc911x_phy_configure(&lp->phy_configure);
+			smc911x_enable(ndev);
 			netif_device_attach(ndev);
 		}
 	}
