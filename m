Return-Path: <linux-kernel-owner+w=401wt.eu-S965691AbXEOGTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965691AbXEOGTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 02:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761673AbXEOGTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 02:19:41 -0400
Received: from hqemgate01.nvidia.com ([216.228.112.170]:5158 "EHLO
	HQEMGATE01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761637AbXEOGTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 02:19:40 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] drivers/ata: correct a wrong free function for sata_nv driver
Date: Tue, 15 May 2007 14:22:42 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B13CD8F45@hkemmail01.nvidia.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/ata: correct a wrong free function for sata_nv driver
Thread-Index: AceWuXHfxAB1ZFdkQAqnYSvlrhm3Eg==
From: "Peer Chen" <pchen@nvidia.com>
To: <linux-kernel@vger.kernel.org>
Cc: <jeff@garzik.org>, <akpm@linux-foundation.org>
X-OriginalArrivalTime: 15 May 2007 06:19:38.0965 (UTC) FILETIME=[045CB850:01C796B9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For sata_nv driver in kernel 2.6.21 onward, Inside nv_init_one(),use
'hpriv = devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);' but
using the kfree(hpriv) to free that data struction in nv_remove_one(),
which will cause system hang when removing the sata_nv module.

Change the 'kfree()' function to 'devm_kfree' will fix this bug.

The patch base on kernel 2.6.22-rc1.

Signed-off-by: Peer Chen <pchen@nvidia.com>
=====================================
--- linux-2.6.22-rc1/drivers/ata/sata_nv.c.orig
+++ linux-2.6.22-rc1/drivers/ata/sata_nv.c
@@ -1619,7 +1619,7 @@ static void nv_remove_one (struct pci_de
 	struct nv_host_priv *hpriv = host->private_data;
 
 	ata_pci_remove_one(pdev);
-	kfree(hpriv);
+	devm_kfree(&pci_dev->dev, hpriv);
 }
 
 #ifdef CONFIG_PM
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
