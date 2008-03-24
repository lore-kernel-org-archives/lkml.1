Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYCXTzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYCXTzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYCXTz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:55:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51885 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbYCXTz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:55:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 24 Mar 2008 20:53:34 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/3] ieee1394: ohci1394: missing PPC PMac feature calls in
 failure path
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.525e96701f0759f9@s5r6.in-berlin.de>
Message-ID: <tkrat.beb16d2e088da506@s5r6.in-berlin.de>
References: <tkrat.3b27f4ba701fc1ec@s5r6.in-berlin.de>
 <tkrat.525e96701f0759f9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The failure path of ohci1394_pci_probe() reuses ohci1394_pci_remove().
Doing so it missed to call ohci1394_pmac_off() in a few unlikely early
error cases.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/ohci1394.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/ieee1394/ohci1394.c
===================================================================
--- linux.orig/drivers/ieee1394/ohci1394.c
+++ linux/drivers/ieee1394/ohci1394.c
@@ -3242,7 +3242,7 @@ static void ohci1394_pci_remove(struct p
 
 	ohci = pci_get_drvdata(dev);
 	if (!ohci)
-		return;
+		goto out;
 
 	device = get_device(&ohci->host->device);
 
@@ -3305,14 +3305,14 @@ static void ohci1394_pci_remove(struct p
 		release_mem_region(pci_resource_start(dev, 0),
 				   OHCI1394_REGISTER_SIZE);
 
-		ohci1394_pmac_off(dev);
-
 	case OHCI_INIT_ALLOC_HOST:
 		pci_set_drvdata(dev, NULL);
 	}
 
 	if (device)
 		put_device(device);
+out:
+	ohci1394_pmac_off(dev);
 }
 
 #ifdef CONFIG_PM

-- 
Stefan Richter
-=====-==--- --== ==---
http://arcgraph.de/sr/

