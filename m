Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab0BHIGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 03:06:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:51620 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915Ab0BHIGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 03:06:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,427,1262592000"; 
   d="scan'208";a="593982790"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 6/7] xen: Unified checking for Xen of PV drivers to xenbus_register_frontend()
Date: Mon,  8 Feb 2010 16:05:53 +0800
Message-Id: <1265616354-7384-7-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265616354-7384-1-git-send-email-sheng@linux.intel.com>
References: <1265616354-7384-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 drivers/block/xen-blkfront.c |    3 ---
 drivers/input/xen-kbdfront.c |    3 ---
 drivers/net/xen-netfront.c   |    5 -----
 drivers/video/xen-fbfront.c  |    3 ---
 include/xen/xenbus.h         |    3 +++
 5 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 05a31e5..d6465c1 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1068,9 +1068,6 @@ static struct xenbus_driver blkfront = {
 
 static int __init xlblk_init(void)
 {
-	if (!xen_domain())
-		return -ENODEV;
-
 	if (register_blkdev(XENVBD_MAJOR, DEV_NAME)) {
 		printk(KERN_WARNING "xen_blk: can't get major %d with name %s\n",
 		       XENVBD_MAJOR, DEV_NAME);
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index c721c0a..febffc3 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -338,9 +338,6 @@ static struct xenbus_driver xenkbd_driver = {
 
 static int __init xenkbd_init(void)
 {
-	if (!xen_domain())
-		return -ENODEV;
-
 	/* Nothing to do if running in dom0. */
 	if (xen_initial_domain())
 		return -ENODEV;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index a869b45..d89fd0b 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1804,14 +1804,9 @@ static struct xenbus_driver netfront_driver = {
 
 static int __init netif_init(void)
 {
-	if (!xen_domain())
-		return -ENODEV;
-
 	if (xen_initial_domain())
 		return 0;
 
-	printk(KERN_INFO "Initialising Xen virtual ethernet driver.\n");
-
 	return xenbus_register_frontend(&netfront_driver);
 }
 module_init(netif_init);
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 603598f..daff72f 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -683,9 +683,6 @@ static struct xenbus_driver xenfb_driver = {
 
 static int __init xenfb_init(void)
 {
-	if (!xen_domain())
-		return -ENODEV;
-
 	/* Nothing to do if running in dom0. */
 	if (xen_initial_domain())
 		return -ENODEV;
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index b9763ba..9f68cf5 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -43,6 +43,7 @@
 #include <xen/interface/grant_table.h>
 #include <xen/interface/io/xenbus.h>
 #include <xen/interface/io/xs_wire.h>
+#include <xen/xen.h>
 
 /* Register callback to watch this node. */
 struct xenbus_watch
@@ -112,6 +113,8 @@ static inline int __must_check
 xenbus_register_frontend(struct xenbus_driver *drv)
 {
 	WARN_ON(drv->owner != THIS_MODULE);
+	if (!xen_domain())
+		return -ENODEV;
 	return __xenbus_register_frontend(drv, THIS_MODULE, KBUILD_MODNAME);
 }
 
-- 
1.5.4.5

