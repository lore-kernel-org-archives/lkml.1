Return-Path: <linux-kernel-owner+w=401wt.eu-S933995AbXHVRWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995AbXHVRWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765592AbXHVRU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:20:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:65129 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765514AbXHVRUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:20:54 -0400
Message-Id: <20070822170731.984791109@arndb.de>
References: <20070822170124.764128591@arndb.de>
User-Agent: quilt/0.45-1
Date: Wed, 22 Aug 2007 19:01:25 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: paulus@samba.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, Christian Krafft <krafft@de.ibm.com>,
       Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd.bergmann@de.ibm.com>
Subject: [patch 1/5] spu_manage: use newer physical-id attribute
Content-Disposition: inline; filename=36162.diff
X-Provags-ID: V01U2FsdGVkX18zNPpc3UphdVps06XldlI+QfBSAe+em/Lf//m
 17srn7tpB9bPz/Hm5+7Lfp75J4GQz9NwNreGsypnm/egQFbXtn
 hhFmVuqMylZepZM9IU/Zg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Krafft <krafft@de.ibm.com>
Legacy device tree used the reg property for the physical id of an spe.
On newer device tree layouts the reg property contains the "correct" value
in the reg attribute. So there has been intoduced the "physical-id" on newer
devicetree layouts. The id is stored by spu_manage into the spu struct as spe_id.
cbe_thermal has been changed to use the spu->spe_id.
There's no need for the thermal code has to check devicetree attributes for itself.

Signed-off-by: Christian Krafft <krafft@de.ibm.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>

---

Jeremy, please Ack

Index: linux-2.6/arch/powerpc/platforms/cell/cbe_thermal.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/cbe_thermal.c
+++ linux-2.6/arch/powerpc/platforms/cell/cbe_thermal.c
@@ -88,17 +88,13 @@ static struct cbe_pmd_regs __iomem *get_
 /* returns the value for a given spu in a given register */
 static u8 spu_read_register_value(struct sys_device *sysdev, union spe_reg __iomem *reg)
 {
-	const unsigned int *id;
 	union spe_reg value;
 	struct spu *spu;
 
-	/* getting the id from the reg attribute will not work on future device-tree layouts
-	 * in future we should store the id to the spu struct and use it here */
 	spu = container_of(sysdev, struct spu, sysdev);
-	id = of_get_property(spu_devnode(spu), "reg", NULL);
 	value.val = in_be64(&reg->val);
 
-	return value.spe[*id];
+	return value.spe[spu->spe_id];
 }
 
 static ssize_t spu_show_temp(struct sys_device *sysdev, char *buf)
Index: linux-2.6/arch/powerpc/platforms/cell/spu_manage.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spu_manage.c
+++ linux-2.6/arch/powerpc/platforms/cell/spu_manage.c
@@ -48,7 +48,7 @@ static u64 __init find_spu_unit_number(s
 {
 	const unsigned int *prop;
 	int proplen;
-	prop = of_get_property(spe, "unit-id", &proplen);
+	prop = of_get_property(spe, "physical-id", &proplen);
 	if (proplen == 4)
 		return (u64)*prop;
 

--

