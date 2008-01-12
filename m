Return-Path: <linux-kernel-owner+w=401wt.eu-S1763612AbYALJx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763612AbYALJx6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762311AbYALJxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:53:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:20449 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762257AbYALJxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:53:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=XBST54pDEXrcgwbls/sMHOnHCQYPsmBGwec2fjfFTS9TTwcRVf0N/7oG32N9sH6Nn8I6T3MjWLGXEG9T1gtZF8CM3+Oj8VIR0mWhGTFujFrDaZUmRgMp6b6ZW/srOEbKwMbmIhq7b92c1fdZVJR7DOhQwbYriKJ/Q5VIbQUWIj0=
Date: Sat, 12 Jan 2008 17:57:11 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 6/7] spi : use class iteration api
Message-ID: <20080112095711.GF2893@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to use the class iteration api.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
 drivers/spi/spi.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -upr linux/drivers/spi/spi.c linux.new/drivers/spi/spi.c
--- linux/drivers/spi/spi.c	2008-01-11 18:06:38.000000000 +0800
+++ linux.new/drivers/spi/spi.c	2008-01-11 18:06:38.000000000 +0800
@@ -485,6 +485,17 @@ void spi_unregister_master(struct spi_ma
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
 
+static int __spi_master_match(struct device *dev, void *data)
+{
+	struct spi_master *m;
+	u16 *bus_num = (u16 *)data;
+
+	m = container_of(dev, struct spi_master, dev);
+	if (m->bus_num == *bus_num)
+		return 1;
+	return 0;
+}
+
 /**
  * spi_busnum_to_master - look up master associated with bus_num
  * @bus_num: the master's bus number
@@ -499,17 +510,12 @@ struct spi_master *spi_busnum_to_master(
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
