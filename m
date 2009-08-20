Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbZHTBRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbZHTBRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 21:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZHTBRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 21:17:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46536 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbZHTBRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 21:17:10 -0400
Date: Wed, 19 Aug 2009 21:17:08 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH] dma-debug: fix check_unmap null pointer dereference
Message-ID: <20090820011708.GP25206@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

While it's debatable whether or not a NULL device argument to the
DMA API functions is valid... since it certainly isn't valid on devices
with an IOMMU... dma-debug really shouldn't be dereferencing null
pointers either.

Guard against that in err_printk and the driver_filter functions. A
Fedora rawhide user was seeing this in one of the dvb drivers resulting
in an oops on boot.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
A patch has been sent for testing to the driver, but I feel the
dma debugging support should be fixed as well. (There's still a pile of
legacy garbage in the kernel passing null pointers to
dma_{alloc,free}_*. :(

regards, Kyle

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 65b0d99..58a9f9f 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -156,9 +156,13 @@ static bool driver_filter(struct device *dev)
 		return true;
 
 	/* driver filter on and initialized */
-	if (current_driver && dev->driver == current_driver)
+	if (current_driver && dev && dev->driver == current_driver)
 		return true;
 
+	/* driver filter on, but we can't filter on a NULL device... */
+	if (!dev)
+		return false;
+
 	if (current_driver || !current_driver_name[0])
 		return false;
 
@@ -183,17 +187,17 @@ static bool driver_filter(struct device *dev)
 	return ret;
 }
 
-#define err_printk(dev, entry, format, arg...) do {		\
-		error_count += 1;				\
-		if (driver_filter(dev) &&			\
-		    (show_all_errors || show_num_errors > 0)) {	\
-			WARN(1, "%s %s: " format,		\
-			     dev_driver_string(dev),		\
-			     dev_name(dev) , ## arg);		\
-			dump_entry_trace(entry);		\
-		}						\
-		if (!show_all_errors && show_num_errors > 0)	\
-			show_num_errors -= 1;			\
+#define err_printk(dev, entry, format, arg...) do {			\
+		error_count += 1;					\
+		if (driver_filter(dev) &&				\
+		    (show_all_errors || show_num_errors > 0)) {		\
+			WARN(1, "%s %s: " format,			\
+			     dev ? dev_driver_string(dev) : "NULL",	\
+			     dev ? dev_name(dev) : "NULL", ## arg);	\
+			dump_entry_trace(entry);			\
+		}							\
+		if (!show_all_errors && show_num_errors > 0)		\
+			show_num_errors -= 1;				\
 	} while (0);
 
 /*
