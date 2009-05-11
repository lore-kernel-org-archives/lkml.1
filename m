Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZEKTlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZEKTlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbZEKTk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:40:58 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:41937 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZEKTk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:40:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WSbZ4kFybAZ1s8HBAaVG2QpETUB3+8YNHTooTgDlPGiYTf+4QopcGmEWjyuMFA8Fwh
         C4msDEKn8ruD0l8pvN8Wb6Cgo5Cruz+z4Bqs8NYArMM2RdPC5nkt7lQ55AlQ42KjRGWf
         WHhz+HNBNgClHTFa4zpnriFaO4MpYg2eYbTU8=
Message-ID: <4A087F49.7040204@gmail.com>
Date: Mon, 11 May 2009 21:40:57 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: jeremy@xensource.com
CC: virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 3] xen-netfront: remove driver_data direct access of struct
 device
References: <4A08775C.20305@gmail.com> <4A0878DC.8040907@gmail.com>
In-Reply-To: <4A0878DC.8040907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid direct access to the driver_data pointer in struct device, the
functions dev_get_drvdata() and dev_set_drvdata() should be used.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index f673253..8d88dae 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1212,7 +1212,7 @@ static int __devinit netfront_probe(struct xenbus_device *dev,
 	}
 
 	info = netdev_priv(netdev);
-	dev->dev.driver_data = info;
+	dev_set_drvdata(&dev->dev, info);
 
 	err = register_netdev(info->netdev);
 	if (err) {
@@ -1233,7 +1233,7 @@ static int __devinit netfront_probe(struct xenbus_device *dev,
 
  fail:
 	free_netdev(netdev);
-	dev->dev.driver_data = NULL;
+	dev_set_drvdata(&dev->dev, NULL);
 	return err;
 }
 
@@ -1275,7 +1275,7 @@ static void xennet_disconnect_backend(struct netfront_info *info)
  */
 static int netfront_resume(struct xenbus_device *dev)
 {
-	struct netfront_info *info = dev->dev.driver_data;
+	struct netfront_info *info = dev_get_drvdata(&dev->dev);
 
 	dev_dbg(&dev->dev, "%s\n", dev->nodename);
 
@@ -1600,7 +1600,7 @@ static int xennet_connect(struct net_device *dev)
 static void backend_changed(struct xenbus_device *dev,
 			    enum xenbus_state backend_state)
 {
-	struct netfront_info *np = dev->dev.driver_data;
+	struct netfront_info *np = dev_get_drvdata(&dev->dev);
 	struct net_device *netdev = np->netdev;
 
 	dev_dbg(&dev->dev, "%s\n", xenbus_strstate(backend_state));
@@ -1774,7 +1774,7 @@ static struct xenbus_device_id netfront_ids[] = {
 
 static int __devexit xennet_remove(struct xenbus_device *dev)
 {
-	struct netfront_info *info = dev->dev.driver_data;
+	struct netfront_info *info = dev_get_drvdata(&dev->dev);
 
 	dev_dbg(&dev->dev, "%s\n", dev->nodename);
 
