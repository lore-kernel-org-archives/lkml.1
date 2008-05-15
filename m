Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYEOGTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYEOGTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 02:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYEOGTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 02:19:24 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:33359 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYEOGTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 02:19:23 -0400
X-IronPort-AV: E=Sophos;i="4.27,490,1204520400"; 
   d="scan'208";a="53572729"
From: Bryan Wu <cooloney@kernel.org>
To: harvey.harrison@gmail.com, david-b@pacbell.net, greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>, Jie Zhang <jie.zhang@analog.com>
Subject: [PATCH 1/1] [usb/host]: use get/put_unaligned_* helpers to fix more potential unaligned issues.
Date: Thu, 15 May 2008 14:19:24 +0800
Message-Id: <1210832364-20012-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/host/isp116x-hcd.c |    4 ++--
 drivers/usb/host/uhci-hub.c    |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index 20b9a0d..97ac6ff 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1024,7 +1024,7 @@ static int isp116x_hub_control(struct usb_hcd *hcd,
 		break;
 	case GetHubStatus:
 		DBG("GetHubStatus\n");
-		*(__le32 *) buf = 0;
+		put_unaligned_le32(0, buf);
 		break;
 	case GetPortStatus:
 		DBG("GetPortStatus\n");
@@ -1033,7 +1033,7 @@ static int isp116x_hub_control(struct usb_hcd *hcd,
 		spin_lock_irqsave(&isp116x->lock, flags);
 		tmp = isp116x_read_reg32(isp116x, (--wIndex) ? HCRHPORT2 : HCRHPORT1);
 		spin_unlock_irqrestore(&isp116x->lock, flags);
-		*(__le32 *) buf = cpu_to_le32(tmp);
+		put_unaligned_le32(tmp, buf);
 		DBG("GetPortStatus: port[%d]  %08x\n", wIndex + 1, tmp);
 		break;
 	case ClearPortFeature:
diff --git a/drivers/usb/host/uhci-hub.c b/drivers/usb/host/uhci-hub.c
index 8e4427a..801fa99 100644
--- a/drivers/usb/host/uhci-hub.c
+++ b/drivers/usb/host/uhci-hub.c
@@ -253,7 +253,7 @@ static int uhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	switch (typeReq) {
 
 	case GetHubStatus:
-		*(__le32 *)buf = cpu_to_le32(0);
+		put_unaligned_le32(0, buf);
 		OK(4);		/* hub power */
 	case GetPortStatus:
 		if (port >= uhci->rh_numports)
@@ -306,8 +306,8 @@ static int uhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			dev_dbg(uhci_dev(uhci), "port %d portsc %04x,%02x\n",
 					wIndex, status, lstatus);
 
-		*(__le16 *)buf = cpu_to_le16(wPortStatus);
-		*(__le16 *)(buf + 2) = cpu_to_le16(wPortChange);
+		put_unaligned_le16(wPortStatus, buf);
+		put_unaligned_le16(wPortChange, buf + 2);
 		OK(4);
 	case SetHubFeature:		/* We don't implement these */
 	case ClearHubFeature:
-- 
1.5.5
