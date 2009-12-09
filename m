Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZLINu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZLINu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 08:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbZLINuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 08:50:24 -0500
Received: from smtp.nokia.com ([192.100.122.230]:61248 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbZLINt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 08:49:57 -0500
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: dbrownell@users.sourceforge.net, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, dsilvers@simtec.co.uk, ben@simtec.co.uk,
       Artem.Bityutskiy@nokia.com, akpm@linux-foundation.org,
       ext-jani.1.nikula@nokia.com
Subject: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use gpioN for device names
Date: Wed,  9 Dec 2009 15:49:04 +0200
Message-Id: <8859db84eb13c0056e20c5edd5dba6837cb60c27.1260364108.git.ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
 <30f1f2c867089bb78cdb9fe3c2032c091bed106a.1260364108.git.ext-jani.1.nikula@nokia.com>
 <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com>
In-Reply-To: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
X-OriginalArrivalTime: 09 Dec 2009 13:49:18.0029 (UTC) FILETIME=[67066FD0:01CA78D6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restore gpiolib sysfs device naming back to /sys/class/gpio/gpioN, where
N is the GPIO number. Use the chip->names mechanism for creating
symlinks to those devices instead of creating the devices using
chip->names. All GPIO naming (other than gpioN) in gpiolib sysfs is now
done using symlinks.

While the device names are now unique again, collisions in chip->names
will still prevent duplicates from being exported to sysfs.

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
---
 drivers/gpio/gpiolib.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f254195..fe7ffad 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -740,7 +740,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 		struct device	*dev;
 
 		dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
-				desc, ioname ? ioname : "gpio%d", gpio);
+				desc, "gpio%d", gpio);
 		if (!IS_ERR(dev)) {
 			if (direction_may_change)
 				status = sysfs_create_group(&dev->kobj,
@@ -756,6 +756,10 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 				status = device_create_file(dev,
 						&dev_attr_edge);
 
+			if (!status && ioname != NULL)
+				status = create_link(gpio, NULL, &dev->kobj,
+						ioname);
+
 			if (status != 0)
 				device_unregister(dev);
 		} else
-- 
1.6.5.2

