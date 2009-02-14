Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZBNNXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZBNNXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 08:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZBNNXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 08:23:37 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:39092 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZBNNXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 08:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=DlbxuNK9rfbV1Z2u2MWaUQtTwbu4SUf/WWPdeH5GwTl+UB/Bb/e7SYHJ8kRs12kSRk
         63Jod9tcvEyfPAyf8vNCPEC1ibwds3nDWUVWo+YkFKyRNXXAGicWdmb9kXSYKMNmojCs
         GTLXsqKCCnpEgeYfsnQZGvSHIdJS+D+7OrvYs=
Message-ID: <4996C5CA.9010803@gmail.com>
Date: Sat, 14 Feb 2009 21:23:22 +0800
From: Dave Young <hidave.darkstar@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081010)
MIME-Version: 1.0
To: greg@kroah.com
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] driver-core: do not register a driver with bus_type not
 registered
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If the bus_type is not registerd, driver_register to that bus will cause oops.

I found this bug when test built-in usb serial drivers (ie. aircable driver)
with 'nousb' cmdline params. 

In this patch:
1. set the bus->p=NULL when bus_register failed and unregisterd.
2. if bus->p is NULL, driver_register BUG_ON will be triggered.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
drivers/base/bus.c    |    2 ++
drivers/base/driver.c |    2 ++
2 files changed, 4 insertions(+)

diff -uprN a/drivers/base/bus.c b/drivers/base/bus.c
--- a/drivers/base/bus.c	2009-02-14 20:47:24.441149465 +0800
+++ b/drivers/base/bus.c	2009-02-14 20:49:42.350149362 +0800
@@ -932,6 +932,7 @@ bus_uevent_fail:
 	kset_unregister(&bus->p->subsys);
 	kfree(bus->p);
 out:
+	bus->p = NULL;
 	return retval;
 }
 EXPORT_SYMBOL_GPL(bus_register);
@@ -953,6 +954,7 @@ void bus_unregister(struct bus_type *bus
 	bus_remove_file(bus, &bus_attr_uevent);
 	kset_unregister(&bus->p->subsys);
 	kfree(bus->p);
+	bus->p = NULL;
 }
 EXPORT_SYMBOL_GPL(bus_unregister);
 
diff -uprN a/drivers/base/driver.c b/drivers/base/driver.c
--- a/drivers/base/driver.c	2009-02-14 20:47:38.048149854 +0800
+++ b/drivers/base/driver.c	2009-02-14 20:47:50.692141034 +0800
@@ -216,6 +216,8 @@ int driver_register(struct device_driver
 	int ret;
 	struct device_driver *other;
 
+	BUG_ON(!drv->bus->p);
+
 	if ((drv->bus->probe && drv->probe) ||
 	    (drv->bus->remove && drv->remove) ||
 	    (drv->bus->shutdown && drv->shutdown))
