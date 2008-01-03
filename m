Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYACFvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYACFvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 00:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYACFvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 00:51:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:41272 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYACFvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 00:51:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Q/9hImHq90vv5fC2OUUZ6I5xHI3heGnu4HETlhu7TICTCJ6jdsowXLKZAMrxdaPOL+6ogvp9N9nXePY4PTLIe5Lv2Eq25lLMtUdMq3fbTpCXnALr06QHbkeEdBZ4h0tWaodRnLy0kvuISje+6Gg52OPQEdbIUOEWWVK/jddF3TM=
Date: Thu, 3 Jan 2008 13:54:41 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: khali@linux-fr.org
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: [PATCH 2/7] i2c : convert semaphore to mutex in struct class
Message-ID: <20080103055441.GC4885@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mutex instead of semaphore in struct class.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
---
drivers/i2c/i2c-core.c |    9 ++++-----
1 file changed, 4 insertions(+), 5 deletions(-)

diff -upr linux/drivers/i2c/i2c-core.c linux.new/drivers/i2c/i2c-core.c
--- linux/drivers/i2c/i2c-core.c	2007-12-28 10:06:58.000000000 +0800
+++ linux.new/drivers/i2c/i2c-core.c	2008-01-03 09:31:38.000000000 +0800
@@ -34,7 +34,6 @@
 #include <linux/mutex.h>
 #include <linux/completion.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include "i2c-core.h"
 
@@ -597,12 +596,12 @@ int i2c_register_driver(struct module *o
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
@@ -631,7 +630,7 @@ void i2c_del_driver(struct i2c_driver *d
 	 * attached. If so, detach them to be able to kill the driver
 	 * afterwards.
 	 */
-	down(&i2c_adapter_class.sem);
+	mutex_lock(&i2c_adapter_class.mutex);
 	list_for_each_entry(adap, &i2c_adapter_class.devices, dev.node) {
 		if (driver->detach_adapter) {
 			if (driver->detach_adapter(adap)) {
@@ -656,7 +655,7 @@ void i2c_del_driver(struct i2c_driver *d
 			}
 		}
 	}
-	up(&i2c_adapter_class.sem);
+	mutex_unlock(&i2c_adapter_class.mutex);
 
  unregister:
 	driver_unregister(&driver->driver);
