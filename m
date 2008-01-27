Return-Path: <linux-kernel-owner+w=401wt.eu-S1760391AbYA0Xle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391AbYA0Xle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760267AbYA0Xka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:40:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:51237 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760220AbYA0Xk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:40:29 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/5] PPC: Fix powerpc vio_find_name to not use devices_subsys
Date: Sun, 27 Jan 2008 15:38:42 -0800
Message-Id: <1201477122-4541-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080127233751.GA4524@kroah.com>
References: <20080127233751.GA4524@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>

This fixes vio_find_name() in arch/powerpc/kernel/vio.c, which is
currently broken because it tries to use devices_subsys.  That is bad
for two reasons: (1) it's doing (or trying to do) a scan of all
devices when it should only be scanning those on the vio bus, and
(2) devices_subsys was an internal symbol of the device system code
which was never meant for external use and has now gone away, and
thus the kernel fails to compile on pSeries.

The new version uses bus_find_device_by_name() on the vio bus
(vio_bus_type).

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/kernel/vio.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 19a5656..f0bad70 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -37,8 +37,6 @@
 #include <asm/iseries/hv_call_xm.h>
 #include <asm/iseries/iommu.h>
 
-extern struct kset devices_subsys; /* needed for vio_find_name() */
-
 static struct bus_type vio_bus_type;
 
 static struct vio_dev vio_bus_device  = { /* fake "parent" device */
@@ -361,19 +359,16 @@ EXPORT_SYMBOL(vio_get_attribute);
 #ifdef CONFIG_PPC_PSERIES
 /* vio_find_name() - internal because only vio.c knows how we formatted the
  * kobject name
- * XXX once vio_bus_type.devices is actually used as a kset in
- * drivers/base/bus.c, this function should be removed in favor of
- * "device_find(kobj_name, &vio_bus_type)"
  */
-static struct vio_dev *vio_find_name(const char *kobj_name)
+static struct vio_dev *vio_find_name(const char *name)
 {
-	struct kobject *found;
+	struct device *found;
 
-	found = kset_find_obj(&devices_subsys, kobj_name);
+	found = bus_find_device_by_name(&vio_bus_type, NULL, name);
 	if (!found)
 		return NULL;
 
-	return to_vio_dev(container_of(found, struct device, kobj));
+	return to_vio_dev(found);
 }
 
 /**
-- 
1.5.3.8

