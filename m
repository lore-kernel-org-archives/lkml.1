Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbXC2JKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbXC2JKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 05:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXC2JKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 05:10:19 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:31042 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbXC2JKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 05:10:15 -0400
Date: Thu, 29 Mar 2007 11:12:11 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg K-H <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Eric Rannaud <eric.rannaud@gmail.com>
Subject: [Patch -mm 1/3] Driver core: suppress uevents via filter.
Message-ID: <20070329111211.7f918aeb@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Suppress uevents for devices if uevent_suppress is set via
dev_uevent_filter(). This makes the driver core suppress all device
uevents, not just the add event in device_add().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc5-mm1.orig/drivers/base/core.c
+++ linux-2.6.21-rc5-mm1/drivers/base/core.c
@@ -134,6 +134,8 @@ static int dev_uevent_filter(struct kset
 
 	if (ktype == &ktype_device) {
 		struct device *dev = to_dev(kobj);
+		if (dev->uevent_suppress)
+			return 0;
 		if (dev->bus)
 			return 1;
 		if (dev->class)
@@ -689,8 +691,7 @@ int device_add(struct device *dev)
 		goto PMError;
 	if ((error = bus_add_device(dev)))
 		goto BusError;
-	if (!dev->uevent_suppress)
-		kobject_uevent(&dev->kobj, KOBJ_ADD);
+	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
