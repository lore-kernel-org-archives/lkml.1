Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbXETOew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbXETOew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 10:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756321AbXETOeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 10:34:46 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:57755 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270AbXETOep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 10:34:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=kIV1qGaPKtUvqO2TBjvyarz6Q9R7w1Zr5MzPOP14JVVwv8gaaHf49vmsa9XF3Qm1CkVPM9eTreDMAda9T1npaG5TGQssXO+Ry5PVkF/LTUiiLQqIIaiUHNV3GnSYMXyI2JH+6WJnrnHqn8ZaF2we7AyUv0lNEC1Wje7dE5Q4gZI=
Date: Sun, 20 May 2007 23:27:28 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] i2o: fix notifiers when max_drivers is configured
Message-ID: <20070520142728.GB4207@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	Markus Lidel <Markus.Lidel@shadowconnect.com>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxinum number of I2O drivers which could be registered is
configurable by max_drivers module parameter.

But the module parameter is ignored and default value (I2O_MAX_DRIVERS = 8)
is used in the loops to notify all registered drivers.

Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/message/i2o/driver.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: 2.6-mm/drivers/message/i2o/driver.c
===================================================================
--- 2.6-mm.orig/drivers/message/i2o/driver.c
+++ 2.6-mm/drivers/message/i2o/driver.c
@@ -20,6 +20,7 @@
 #include <linux/workqueue.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/log2.h>
 #include "core.h"
 
 #define OSM_NAME	"i2o"
@@ -260,7 +261,7 @@ void i2o_driver_notify_controller_add_al
 	int i;
 	struct i2o_driver *drv;
 
-	for (i = 0; i < I2O_MAX_DRIVERS; i++) {
+	for (i = 0; i < i2o_max_drivers; i++) {
 		drv = i2o_drivers[i];
 
 		if (drv)
@@ -280,7 +281,7 @@ void i2o_driver_notify_controller_remove
 	int i;
 	struct i2o_driver *drv;
 
-	for (i = 0; i < I2O_MAX_DRIVERS; i++) {
+	for (i = 0; i < i2o_max_drivers; i++) {
 		drv = i2o_drivers[i];
 
 		if (drv)
@@ -299,7 +300,7 @@ void i2o_driver_notify_device_add_all(st
 	int i;
 	struct i2o_driver *drv;
 
-	for (i = 0; i < I2O_MAX_DRIVERS; i++) {
+	for (i = 0; i < i2o_max_drivers; i++) {
 		drv = i2o_drivers[i];
 
 		if (drv)
@@ -318,7 +319,7 @@ void i2o_driver_notify_device_remove_all
 	int i;
 	struct i2o_driver *drv;
 
-	for (i = 0; i < I2O_MAX_DRIVERS; i++) {
+	for (i = 0; i < i2o_max_drivers; i++) {
 		drv = i2o_drivers[i];
 
 		if (drv)
@@ -340,8 +341,7 @@ int __init i2o_driver_init(void)
 	spin_lock_init(&i2o_drivers_lock);
 
 	if ((i2o_max_drivers < 2) || (i2o_max_drivers > 64) ||
-	    ((i2o_max_drivers ^ (i2o_max_drivers - 1)) !=
-	     (2 * i2o_max_drivers - 1))) {
+	    !is_power_of_2(i2o_max_drivers)) {
 		osm_warn("max_drivers set to %d, but must be >=2 and <= 64 and "
 			 "a power of 2\n", i2o_max_drivers);
 		i2o_max_drivers = I2O_MAX_DRIVERS;
@@ -349,7 +349,7 @@ int __init i2o_driver_init(void)
 	osm_info("max drivers = %d\n", i2o_max_drivers);
 
 	i2o_drivers =
-	    kzalloc(i2o_max_drivers * sizeof(*i2o_drivers), GFP_KERNEL);
+	    kcalloc(i2o_max_drivers, sizeof(*i2o_drivers), GFP_KERNEL);
 	if (!i2o_drivers)
 		return -ENOMEM;
 
