Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbZEYGyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbZEYGyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 02:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZEYGxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 02:53:54 -0400
Received: from ozlabs.org ([203.10.76.45]:47617 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZEYGxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 02:53:53 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <greg@kroah.com>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 25 May 2009 16:53:31 +1000
Subject: [PATCH] devres: WARN() and return, don't crash on device_del() of uninitialized device
Message-Id: <20090525065346.1D991DE2AC@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just debugged an obscure crash caused by a device_del() of a all NULL'd
out struct device (in usb-serial) and found that a patch like this one would
have saved me time (in addition to improved chances of a bug report from
users hitting similar driver bugs).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 drivers/base/devres.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-work.orig/drivers/base/devres.c	2009-05-25 16:43:46.000000000 +1000
+++ linux-work/drivers/base/devres.c	2009-05-25 16:46:36.000000000 +1000
@@ -428,6 +428,11 @@ int devres_release_all(struct device *de
 {
 	unsigned long flags;
 
+	/* Looks like an uninitialized device structure */
+	if (dev->devres_head.next == NULL) {
+		WARN(1);
+		return -ENODEV;
+	}
 	spin_lock_irqsave(&dev->devres_lock, flags);
 	return release_nodes(dev, dev->devres_head.next, &dev->devres_head,
 			     flags);
