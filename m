Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbZBHSwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbZBHSwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZBHSwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:52:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:53616 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbZBHSwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:52:32 -0500
Date: Sun, 8 Feb 2009 10:42:40 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, rusty@rustcorp.com.au,
       jkosina@suse.cz, mchehab@infradead.org
Subject: [PATCH 2/3] use the new request_module_nowait() in the hid driver
Message-ID: <20090208104240.3405903f@infradead.org>
In-Reply-To: <20090208104201.6124ab6a@infradead.org>
References: <20090208104201.6124ab6a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From b8c36ec88e272ba2e755e6104579f1e751ee81f8 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 1 Feb 2009 12:02:39 -0800
Subject: [PATCH] use the new request_module_nowait() in the hid driver

Now that there is a request_module_nowait(), use it in the hid driver.
This gets rid of a kernel thread, and also greatly simplifies the code...

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/hid/hid-core.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 6cad69e..d51331f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1812,15 +1812,6 @@ void hid_unregister_driver(struct hid_driver *hdrv)
 }
 EXPORT_SYMBOL_GPL(hid_unregister_driver);
 
-#ifdef CONFIG_HID_COMPAT
-static void hid_compat_load(struct work_struct *ws)
-{
-	request_module("hid-dummy");
-}
-static DECLARE_WORK(hid_compat_work, hid_compat_load);
-static struct workqueue_struct *hid_compat_wq;
-#endif
-
 static int __init hid_init(void)
 {
 	int ret;
@@ -1836,12 +1827,7 @@ static int __init hid_init(void)
 		goto err_bus;
 
 #ifdef CONFIG_HID_COMPAT
-	hid_compat_wq = create_singlethread_workqueue("hid_compat");
-	if (!hid_compat_wq) {
-		hidraw_exit();
-		goto err;
-	}
-	queue_work(hid_compat_wq, &hid_compat_work);
+	request_module_nowait("hid-dummy");
 #endif
 
 	return 0;
@@ -1853,9 +1839,6 @@ err:
 
 static void __exit hid_exit(void)
 {
-#ifdef CONFIG_HID_COMPAT
-	destroy_workqueue(hid_compat_wq);
-#endif
 	hidraw_exit();
 	bus_unregister(&hid_bus_type);
 }
-- 
1.6.0.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
