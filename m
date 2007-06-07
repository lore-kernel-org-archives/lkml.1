Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbXFGJuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbXFGJuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 05:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXFGJuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 05:50:09 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:39210 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbXFGJuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 05:50:07 -0400
Subject: [PATCH]: complete cleanup of check_region
From: Surya <surya.prabhakar@wipro.com>
To: emoenke@gwdg.de, linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, kernel-janitors <kernel-janitors@lists.osdl.org>,
       trivial <trivial@kernel.org>, hannu@opensound.com
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux COE, Wipro Technologies, Bangalore, India.
Date: Thu, 07 Jun 2007 15:09:29 +0530
Message-Id: <1181209169.2422.12.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 07 Jun 2007 09:39:46.0917 (UTC) FILETIME=[C9290950:01C7A8E7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	This patch cleans up all the instances of check_region and
__check_region and replaces them with request_region and
__request_region. Applies and compiles clean on latest Linus tree.

Files affected:
	drivers/cdrom/sbpcd.c
	drivers/pnp/resource.c
	include/linux/ioport.h
	kernel/resource.c
	sound/oss/pss.c


thanks.


Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
--- 

diff --git a/drivers/cdrom/sbpcd.c b/drivers/cdrom/sbpcd.c
index a1283b1..2c1355e 100644
--- a/drivers/cdrom/sbpcd.c
+++ b/drivers/cdrom/sbpcd.c
@@ -358,6 +358,11 @@
  * Add bio/kdev_t changes for 2.5.x required to make it work again. 
  * Still room for improvement in the request handling here if anyone
  * actually cares.  Bring your own chainsaw.    Paul G.  02/2002
+ *
+ *
+ * Cleaned up the reference for deprecated check_region to 
+ * request_region.
+ * Thu Jun  7 12:14:00 IST 2007 Surya <surya.prabhakar@wipro.com>
  */
 
 
@@ -5670,7 +5675,7 @@ int __init sbpcd_init(void)
 	{
 		addr[1]=sbpcd[port_index];
 		if (addr[1]==0) break;
-		if (check_region(addr[1],4))
+		if (request_region(addr[1],4, "sbpcd driver"))
 		{
 			msg(DBG_INF,"check_region: %03X is not free.\n",addr[1]);
 			continue;
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index a685fbe..2be8001 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -251,7 +251,7 @@ int pnp_check_port(struct pnp_dev * dev, int idx)
 	/* check if the resource is already in use, skip if the
 	 * device is active because it itself may be in use */
 	if(!dev->active) {
-		if (__check_region(&ioport_resource, *port, length(port,end)))
+		if (__request_region(&ioport_resource, *port, length(port,end), "isapnp request-region"))
 			return 0;
 	}
 
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 71ea923..ebe6c22 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -124,19 +124,12 @@ extern struct resource * __request_region(struct resource *,
 
 /* Compatibility cruft */
 #define release_region(start,n)	__release_region(&ioport_resource, (start), (n))
-#define check_mem_region(start,n)	__check_region(&iomem_resource, (start), (n))
+#define check_mem_region(start,n)	__request_region(&iomem_resource, (start), (n), "request-region")
 #define release_mem_region(start,n)	__release_region(&iomem_resource, (start), (n))
 
-extern int __check_region(struct resource *, resource_size_t, resource_size_t);
 extern void __release_region(struct resource *, resource_size_t,
 				resource_size_t);
 
-static inline int __deprecated check_region(resource_size_t s,
-						resource_size_t n)
-{
-	return __check_region(&ioport_resource, s, n);
-}
-
 /* Wrappers for managed devices */
 struct device;
 #define devm_request_region(dev,start,n,name) \
diff --git a/kernel/resource.c b/kernel/resource.c
index 9bd14fd..99a97ca 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -520,36 +520,6 @@ struct resource * __request_region(struct resource *parent,
 EXPORT_SYMBOL(__request_region);
 
 /**
- * __check_region - check if a resource region is busy or free
- * @parent: parent resource descriptor
- * @start: resource start address
- * @n: resource region size
- *
- * Returns 0 if the region is free at the moment it is checked,
- * returns %-EBUSY if the region is busy.
- *
- * NOTE:
- * This function is deprecated because its use is racy.
- * Even if it returns 0, a subsequent call to request_region()
- * may fail because another driver etc. just allocated the region.
- * Do NOT use it.  It will be removed from the kernel.
- */
-int __check_region(struct resource *parent, resource_size_t start,
-			resource_size_t n)
-{
-	struct resource * res;
-
-	res = __request_region(parent, start, n, "check-region");
-	if (!res)
-		return -EBUSY;
-
-	release_resource(res);
-	kfree(res);
-	return 0;
-}
-EXPORT_SYMBOL(__check_region);
-
-/**
  * __release_region - release a previously reserved resource region
  * @parent: parent resource descriptor
  * @start: resource start address
diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index ece428b..c61a1a3 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -54,6 +54,9 @@
  *	    Added __init to probe_pss(), attach_pss() and probe_pss_mpu()
  * 02-Jan-2001: Chris Rankin
  *          Specify that this module owns the coprocessor
+ * 07-Jun-2007: Surya Prabhakar <surya.prabhakar@wipro.com>
+ *	    Cleaned up the reference for deprecated check_region to 
+ * 	    request_region.
  */
 
 
@@ -677,7 +680,7 @@ static void configure_nonsound_components(void)
 	{
 		printk(KERN_INFO "PSS: CDROM port not enabled.\n");
 	}
-	else if(check_region(pss_cdrom_port, 2))
+	else if(request_region(pss_cdrom_port, 2, "CDROM config"))
 	{
 		printk(KERN_ERR "PSS: CDROM I/O port conflict.\n");
 	}


-- 
surya .
07/06/2007
