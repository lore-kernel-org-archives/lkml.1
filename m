Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYA0Apo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYA0Apo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 19:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYA0Apg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 19:45:36 -0500
Received: from ozlabs.org ([203.10.76.45]:49392 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbYA0Apf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 19:45:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18331.54314.379281.960297@cargo.ozlabs.ibm.com>
Date: Sun, 27 Jan 2008 11:45:30 +1100
From: Paul Mackerras <paulus@samba.org>
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
CC: sfr@canb.auug.org.au
Subject: [PATCH] Fix powerpc vio_find_name to not use devices_subsys
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes vio_find_name() in arch/powerpc/kernel/vio.c, which is
currently broken because it tries to use devices_subsys.  That is bad
for two reasons: (1) it's doing (or trying to do) a scan of all
devices when it should only be scanning those on the vio bus, and
(2) devices_subsys was an internal symbol of the device system code
which was never meant for external use and has now gone away, and
thus the kernel fails to compile on pSeries.

The new version uses bus_find_device() on the vio bus (vio_bus_type).

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
Greg, do you want to send this to Linus or will I do that?  Or do you
have a better version? :)

diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 19a5656..b179b7e 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -37,8 +37,6 @@
 #include <asm/iseries/hv_call_xm.h>
 #include <asm/iseries/iommu.h>
 
-extern struct kset devices_subsys; /* needed for vio_find_name() */
-
 static struct bus_type vio_bus_type;
 
 static struct vio_dev vio_bus_device  = { /* fake "parent" device */
@@ -361,19 +359,23 @@ EXPORT_SYMBOL(vio_get_attribute);
 #ifdef CONFIG_PPC_PSERIES
 /* vio_find_name() - internal because only vio.c knows how we formatted the
  * kobject name
- * XXX once vio_bus_type.devices is actually used as a kset in
- * drivers/base/bus.c, this function should be removed in favor of
- * "device_find(kobj_name, &vio_bus_type)"
  */
-static struct vio_dev *vio_find_name(const char *kobj_name)
+static int name_cmp(struct device *dev, void *data)
+{
+	const char *name = data;
+
+	return !strcmp(name, dev->bus_id);
+}
+
+static struct vio_dev *vio_find_name(const char *name)
 {
-	struct kobject *found;
+	struct device *found;
 
-	found = kset_find_obj(&devices_subsys, kobj_name);
+	found = bus_find_device(&vio_bus_type, NULL, (void *)name, name_cmp);
 	if (!found)
 		return NULL;
 
-	return to_vio_dev(container_of(found, struct device, kobj));
+	return to_vio_dev(found);
 }
 
 /**
