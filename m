Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbYEJDTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbYEJDTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 23:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761355AbYEJDRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 23:17:19 -0400
Received: from fmailhost05.isp.att.net ([204.127.217.105]:44296 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761269AbYEJDRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 23:17:16 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 May 2008 23:17:15 EDT
X-Originating-IP: [74.251.48.254]
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, csnook@redhat.com,
       pelle@dsv.su.se, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 3/4] atl1: add shutdown callback
Date: Fri,  9 May 2008 22:12:08 -0500
Message-Id: <1210389129-3868-4-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1210389129-3868-1-git-send-email-jacliburn@bellsouth.net>
References: <1210389129-3868-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a shutdown callback that points to atl1_suspend().  This, along
with a working suspend function, fixes wake-on-lan.

Tested-by: Per Olofsson <pelle@dsv.su.se>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 12fb3e5..b7092a3 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -36,7 +36,6 @@
  * A very incomplete list of things that need to be dealt with:
  *
  * TODO:
- * Wake on LAN.
  * Add more ethtool functions.
  * Fix abstruse irq enable/disable condition described here:
  *	http://marc.theaimsgroup.com/?l=linux-netdev&m=116398508500553&w=2
@@ -2908,6 +2907,13 @@ static int atl1_resume(struct pci_dev *pdev)
 #define atl1_resume NULL
 #endif
 
+static void atl1_shutdown(struct pci_dev *pdev)
+{
+#ifdef CONFIG_PM
+	atl1_suspend(pdev, PMSG_SUSPEND);
+#endif
+}
+
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void atl1_poll_controller(struct net_device *netdev)
 {
@@ -3154,7 +3160,8 @@ static struct pci_driver atl1_driver = {
 	.probe = atl1_probe,
 	.remove = __devexit_p(atl1_remove),
 	.suspend = atl1_suspend,
-	.resume = atl1_resume
+	.resume = atl1_resume,
+	.shutdown = atl1_shutdown
 };
 
 /*
-- 
1.5.4.1

