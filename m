Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbYAVHNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbYAVHNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 02:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYAVHMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 02:12:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:35703 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYAVHMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 02:12:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=aERZLcpFeo/URoyc5zIODetCm7DBnvAevN3ZYsrgKU3TzHyA9mRuNswtpQjPXI0i3d1sB0uB0qfV6uZ6Hxu2LltchIwkhCl/lozbHh8ty523C63yYs+6CJ0oVxcxx4esB0tSJME5346q0SErhmFdt1xgwKB67pTRCcKuW4y8HAU=
Date: Tue, 22 Jan 2008 15:14:18 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 6/6] spi : use class iteration api
Message-ID: <20080122071418.GA3725@darkstar.te-china.tietoenator.com>
References: <20080112095711.GF2893@darkstar.te-china.tietoenator.com> <20080122060331.GG3066@darkstar.te-china.tietoenator.com> <200801212256.11484.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801212256.11484.david-b@pacbell.net>
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
--- linux/drivers/spi/spi.c	2008-01-22 15:09:49.000000000 +0800
+++ linux.new/drivers/spi/spi.c	2008-01-22 15:09:49.000000000 +0800
@@ -485,6 +485,15 @@ void spi_unregister_master(struct spi_ma
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
 
+static int __spi_master_match(struct device *dev, void *data)
+{
+	struct spi_master *m;
+	u16 *bus_num = data;
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
