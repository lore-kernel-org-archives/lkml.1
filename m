Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbYE1SL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbYE1SL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 14:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYE1SLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 14:11:52 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:8264 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYE1SLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 14:11:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ockovKMlPajr6f6H/V+ZBlPBjf7WicmnthA0llIX23VTcJUHdU8fsrB+0gnl7LvCzE5GBChSbois+353o2nNlkxayWtbMlwXEiojOjFxc5MX56nUTecxAk4a/0fCFpWvzzuD5DfLQ2SoNxtPRrCGXedQ3xqhnwjPZdBbVAt5xxA=
From: Qinghuang Feng <s3c24xx@gmail.com>
Reply-To: s3c24xx@gmail.com
To: rmk@arm.linux.org.uk
Subject: [PATCH]scsi/arm: check the return value of device_create_file() in powertec.c
Date: Thu, 29 May 2008 02:11:38 +0800
User-Agent: KMail/1.9.1
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805290211.39355.s3c24xx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powertec.c : add code to print an error message while device_create_file() called from powertecscsi_probe() fail
 
Signed-off-by: Qinghuang Feng <s3c24xx@gmail.com>
---
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index d9a546d..14e25a6 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -315,6 +315,7 @@ powertecscsi_probe(struct expansion_card
 	struct powertec_info *info;
 	void __iomem *base;
 	int ret;
+	int ferr;
 
 	ret = ecard_request_resources(ec);
 	if (ret)
@@ -361,7 +362,9 @@ powertecscsi_probe(struct expansion_card
 
 	ecard_setirq(ec, &powertecscsi_ops, info);
 
-	device_create_file(&ec->dev, &dev_attr_bus_term);
+	ferr = device_create_file(&ec->dev, &dev_attr_bus_term);
+	if (ferr)
+		printk(KERN_ERR "powertecscsi :failed to create the attribute file !\n");
 
 	ret = fas216_init(host);
 	if (ret)
@@ -398,7 +401,8 @@ powertecscsi_probe(struct expansion_card
 	fas216_release(host);
 
  out_free:
-	device_remove_file(&ec->dev, &dev_attr_bus_term);
+	if (!ferr)
+		device_remove_file(&ec->dev, &dev_attr_bus_term);
 	scsi_host_put(host);
 
  out_region:
