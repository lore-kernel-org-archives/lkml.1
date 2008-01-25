Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbYAYIFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbYAYIFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762843AbYAYH7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:59:50 -0500
Received: from ns2.suse.de ([195.135.220.15]:53541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764052AbYAYH7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:41 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 192/196] spi: use class iteration api
Date: Thu, 24 Jan 2008 23:33:41 -0800
Message-Id: <1201246425-5058-113-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>

Convert to use the class iteration api.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/spi/spi.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 93e9de4..682a6a4 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -485,6 +485,15 @@ void spi_unregister_master(struct spi_master *master)
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
@@ -499,17 +508,12 @@ struct spi_master *spi_busnum_to_master(u16 bus_num)
 {
 	struct device		*dev;
 	struct spi_master	*master = NULL;
-	struct spi_master	*m;
-
-	down(&spi_master_class.sem);
-	list_for_each_entry(dev, &spi_master_class.children, node) {
-		m = container_of(dev, struct spi_master, dev);
-		if (m->bus_num == bus_num) {
-			master = spi_master_get(m);
-			break;
-		}
-	}
-	up(&spi_master_class.sem);
+
+	dev = class_find_device(&spi_master_class, &bus_num,
+				__spi_master_match);
+	if (dev)
+		master = container_of(dev, struct spi_master, dev);
+	/* reference got in class_find_device */
 	return master;
 }
 EXPORT_SYMBOL_GPL(spi_busnum_to_master);
-- 
1.5.3.8

