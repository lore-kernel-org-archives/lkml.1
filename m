Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbXGKIMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbXGKIMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757386AbXGKILt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:11:49 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:60145 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759979AbXGKILr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:11:47 -0400
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 04:11:47 EDT
Subject: [PATCH] UBI: cleanup usage of try_module_get
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dedekind@infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1184140531.4608.16.camel@sebastian.kern.oss.ntt.co.jp>
References: <1184140531.4608.16.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 11 Jul 2007 17:11:45 +0900
Message-Id: <1184141505.4608.29.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The use of try_module_get(THIS_MODULE) in ubi_get_device_info does not
offer real protection against unexpected driver unloads, since we could
be preempted before try_modules_get gets executed. It is the caller who
should manipulate the refcounts. Besides, ubi_get_device_info is an
exported symbol which guarantees protection when accessed through
symbol_get.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.22-orig/drivers/mtd/ubi/kapi.c linux-2.6.22/drivers/mtd/ubi/kapi.c
--- linux-2.6.22-orig/drivers/mtd/ubi/kapi.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/drivers/mtd/ubi/kapi.c	2007-07-11 16:34:10.000000000 +0900
@@ -37,12 +37,8 @@ int ubi_get_device_info(int ubi_num, str
 {
 	const struct ubi_device *ubi;
 
-	if (!try_module_get(THIS_MODULE))
-		return -ENODEV;
-
 	if (ubi_num < 0 || ubi_num >= UBI_MAX_DEVICES ||
 	    !ubi_devices[ubi_num]) {
-		module_put(THIS_MODULE);
 		return -ENODEV;
 	}
 
@@ -52,7 +48,6 @@ int ubi_get_device_info(int ubi_num, str
 	di->min_io_size = ubi->min_io_size;
 	di->ro_mode = ubi->ro_mode;
 	di->cdev = MKDEV(ubi->major, 0);
-	module_put(THIS_MODULE);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ubi_get_device_info);


