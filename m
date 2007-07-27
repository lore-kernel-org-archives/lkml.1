Return-Path: <linux-kernel-owner+w=401wt.eu-S933022AbXG0LfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbXG0LfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 07:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936874AbXG0LdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 07:33:18 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:47204 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765178AbXG0LdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 07:33:15 -0400
Message-Id: <20070727113618.958661048@de.ibm.com>
References: <20070727113348.413110503@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jul 2007 13:33:53 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 5/6] cio: Reorganize initialization.
Content-Disposition: inline; filename=014-cio-init.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

- Localize more of the init calls in init_channel_subsystem().
- Print a warning if init_channel_subsystem() failed.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/chsc.c |   10 ++++++----
 drivers/s390/cio/chsc.h |    2 ++
 drivers/s390/cio/css.c  |   19 ++++++++++++++++---
 3 files changed, 24 insertions(+), 7 deletions(-)

Index: quilt-2.6/drivers/s390/cio/chsc.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/chsc.c
+++ quilt-2.6/drivers/s390/cio/chsc.c
@@ -990,8 +990,7 @@ out:
 	return ret;
 }
 
-static int __init
-chsc_alloc_sei_area(void)
+int __init chsc_alloc_sei_area(void)
 {
 	sei_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sei_page)
@@ -1000,6 +999,11 @@ chsc_alloc_sei_area(void)
 	return (sei_page ? 0 : -ENOMEM);
 }
 
+void __init chsc_free_sei_area(void)
+{
+	kfree(sei_page);
+}
+
 int __init
 chsc_enable_facility(int operation_code)
 {
@@ -1051,8 +1055,6 @@ chsc_enable_facility(int operation_code)
 	return ret;
 }
 
-subsys_initcall(chsc_alloc_sei_area);
-
 struct css_general_char css_general_characteristics;
 struct css_chsc_char css_chsc_characteristics;
 
Index: quilt-2.6/drivers/s390/cio/chsc.h
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/chsc.h
+++ quilt-2.6/drivers/s390/cio/chsc.h
@@ -79,6 +79,8 @@ extern int chsc_get_ssd_info(struct subc
 			     struct chsc_ssd_info *ssd);
 extern int chsc_determine_css_characteristics(void);
 extern int css_characteristics_avail;
+extern int chsc_alloc_sei_area(void);
+extern void chsc_free_sei_area(void);
 
 extern int chsc_enable_facility(int);
 struct channel_subsystem;
Index: quilt-2.6/drivers/s390/cio/css.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/css.c
+++ quilt-2.6/drivers/s390/cio/css.c
@@ -377,8 +377,6 @@ static int __init slow_subchannel_init(v
 	return 0;
 }
 
-subsys_initcall(slow_subchannel_init);
-
 static void css_slow_path_func(struct work_struct *unused)
 {
 	struct subchannel_id schid;
@@ -641,9 +639,20 @@ init_channel_subsystem (void)
 {
 	int ret, i;
 
-	if (chsc_determine_css_characteristics() == 0)
+	ret = chsc_determine_css_characteristics();
+	if (ret == -ENOMEM)
+		goto out; /* No need to continue. */
+	if (ret == 0)
 		css_characteristics_avail = 1;
 
+	ret = chsc_alloc_sei_area();
+	if (ret)
+		goto out;
+
+	ret = slow_subchannel_init();
+	if (ret)
+		goto out;
+
 	if ((ret = bus_register(&css_bus_type)))
 		goto out;
 
@@ -709,6 +718,10 @@ out_unregister:
 out_bus:
 	bus_unregister(&css_bus_type);
 out:
+	chsc_free_sei_area();
+	kfree(slow_subchannel_set);
+	printk(KERN_WARNING"cio: failed to initialize css driver (%d)!\n",
+	       ret);
 	return ret;
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

