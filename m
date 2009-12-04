Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbZLDQG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbZLDQG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757028AbZLDQG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:06:58 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39165 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756837AbZLDQG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:06:57 -0500
Date: Fri, 4 Dec 2009 11:06:57 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@suse.de>
cc: stable@kernel.org, Oliver Neukum <oliver@neukum.org>,
       Rickard Bellini <rickard.bellini@ericsson.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] Driver core: fix race in dev_driver_string
In-Reply-To: <20091204044337.GE14819@suse.de>
Message-ID: <Pine.LNX.4.44L0.0912041102590.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1310) works around a race in dev_driver_string().  If
the device is unbound while the function is running, dev->driver might
become NULL after we test it and before we dereference it.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: stable@kernel.org

---

Oliver:

We don't have to worry about the device structure being deallocated 
while the routine is running.  If that happens it's a bug in the 
caller: improper refcounting.

Alan Stern


Index: usb-2.6/drivers/base/core.c
===================================================================
--- usb-2.6.orig/drivers/base/core.c
+++ usb-2.6/drivers/base/core.c
@@ -56,7 +56,14 @@ static inline int device_is_not_partitio
  */
 const char *dev_driver_string(const struct device *dev)
 {
-	return dev->driver ? dev->driver->name :
+	struct device_driver *drv;
+
+	/* dev->driver can change to NULL underneath us because of unbinding,
+	 * so be careful about accessing it.  dev->bus and dev->class should
+	 * never change once they are set, so they don't need special care.
+	 */
+	drv = ACCESS_ONCE(dev->driver);
+	return drv ? drv->name :
 			(dev->bus ? dev->bus->name :
 			(dev->class ? dev->class->name : ""));
 }

