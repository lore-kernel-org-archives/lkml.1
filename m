Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbYAPAtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbYAPAtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYAPAt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:49:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:38039 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbYAPAt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:49:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=g8RQ9uQg+aa7t+fTprzWnCUS8iTPQ9xWdKr5PcnRTxno9mdUjDmXlYvIhiNfLmNYjyt7i9cReGVI2K3gvb4i+xEgvR1/Np6locDs9vowUmUB2SawY7KV2ZGySAs3QjBdmX19zHUsG37/CCVgJKpL8Y2lZE/rcibBclnWepjw6qI=
Date: Wed, 16 Jan 2008 08:52:38 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 6/7] spi : use class iteration api
Message-ID: <20080116005238.GC2929@darkstar.te-china.tietoenator.com>
References: <20080112095711.GF2893@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112095711.GF2893@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the patch with minor return path changes in match function:

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
