Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbXL2BES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbXL2BES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXL2BEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:04:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:14165 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbXL2BEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:04:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=TPHDuXEa3fl9fHd+ftGuYuYICpqnG+saHvKuCBnMW92Rkk4HB8xFZlhL/jg0rb9HAUY1wtAzL7QhPYnXPqQHSXuuPcyp+KRuKCqxaxvllhD5QCZNs7UsyftVvSBxafDCHlIIrvNaXBDQQDiEBPaHi3xkbtfhQC45bVpWJiIpTVQ=
Date: Sat, 29 Dec 2007 09:07:51 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: khali@linux-fr.org
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: [PATCH 04/12] i2c : Use mutex instead of semaphore in driver core
Message-ID: <20071229010751.GE2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/i2c/i2c-core.c |   10 +++++-----
1 file changed, 5 insertions(+), 5 deletions(-)

diff -upr linux/drivers/i2c/i2c-core.c linux.new/drivers/i2c/i2c-core.c
--- linux/drivers/i2c/i2c-core.c	2007-12-28 10:06:58.000000000 +0800
+++ linux.new/drivers/i2c/i2c-core.c	2007-12-28 10:08:58.000000000 +0800
@@ -33,8 +33,8 @@
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/completion.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include "i2c-core.h"
 
@@ -597,12 +597,12 @@ int i2c_register_driver(struct module *o
 	if (driver->attach_adapter) {
 		struct i2c_adapter *adapter;
 
-		down(&i2c_adapter_class.sem);
+		mutex_lock(&i2c_adapter_class.mutex);
 		list_for_each_entry(adapter, &i2c_adapter_class.devices,
 				    dev.node) {
 			driver->attach_adapter(adapter);
 		}
-		up(&i2c_adapter_class.sem);
+		mutex_unlock(&i2c_adapter_class.mutex);
 	}
 
 	mutex_unlock(&core_lock);
@@ -631,7 +631,7 @@ void i2c_del_driver(struct i2c_driver *d
 	 * attached. If so, detach them to be able to kill the driver
 	 * afterwards.
 	 */
-	down(&i2c_adapter_class.sem);
+	mutex_lock(&i2c_adapter_class.mutex);
 	list_for_each_entry(adap, &i2c_adapter_class.devices, dev.node) {
 		if (driver->detach_adapter) {
 			if (driver->detach_adapter(adap)) {
@@ -656,7 +656,7 @@ void i2c_del_driver(struct i2c_driver *d
 			}
 		}
 	}
-	up(&i2c_adapter_class.sem);
+	mutex_unlock(&i2c_adapter_class.mutex);
 
  unregister:
 	driver_unregister(&driver->driver);
