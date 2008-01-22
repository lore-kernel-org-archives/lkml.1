Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbYAVGCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbYAVGCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 01:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYAVGCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 01:02:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:56352 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYAVGCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 01:02:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=xzYQD5/0Ma0UKkN6T5IM9ItTrcn9VTdasWfXSh42cu+sHTa8Bpp22B1ciy4GfqpVNfLbsoPd0NYlEEvG+03dLCQJehN6y6hT1JaVkILGmSMi8R26tEudDusFPmx+m4YCLGLtqIw/RvOiCiYyfu1cwpqN5m+JvxBwUwsoBO5J2Uc=
Date: Tue, 22 Jan 2008 14:03:31 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 6/6] spi : use class iteration api
Message-ID: <20080122060331.GG3066@darkstar.te-china.tietoenator.com>
References: <20080112095711.GF2893@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112095711.GF2893@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to use the class iteration api.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
 drivers/spi/spi.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff -upr linux/drivers/spi/spi.c linux.new/drivers/spi/spi.c
--- linux/drivers/spi/spi.c	2008-01-16 08:43:35.000000000 +0800
+++ linux.new/drivers/spi/spi.c	2008-01-16 08:43:35.000000000 +0800
@@ -485,6 +485,15 @@ void spi_unregister_master(struct spi_ma
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
 
+static int __spi_master_match(struct device *dev, void *data)
+{
+	struct spi_master *m;
+	u16 *bus_num = (u16 *)data;
+
+	m = container_of(dev, struct spi_master, dev);
+	return m->bus_num == *bus_num;
+}
+
 /**
  * spi_busnum_to_master - look up master associated with bus_num
  * @bus_num: the master's bus number
@@ -499,17 +508,12 @@ struct spi_master *spi_busnum_to_master(
 {
 	struct device		*dev;
 	struct spi_master	*master = NULL;
-	struct spi_master	*m;
 
-	down(&spi_master_class.sem);
-	list_for_each_entry(dev, &spi_master_class.children, node) {
-		m = container_of(dev, struct spi_master, dev);
-		if (m->bus_num == bus_num) {
-			master = spi_master_get(m);
-			break;
-		}
-	}
-	up(&spi_master_class.sem);
+	dev = class_find_device(&spi_master_class, &bus_num,
+				__spi_master_match);
+	if (dev)
+		master = container_of(dev, struct spi_master, dev);
+	/* reference got in class_find_device */
 	return master;
 }
 EXPORT_SYMBOL_GPL(spi_busnum_to_master);
