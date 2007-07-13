Return-Path: <linux-kernel-owner+w=401wt.eu-S937081AbXGMTZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937081AbXGMTZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933152AbXGMTZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:25:37 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:39826
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932105AbXGMTZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:25:37 -0400
Date: Fri, 13 Jul 2007 21:26:59 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 3/5] use mutex instead of semaphore in the ELAN U132 adapter driver
Message-ID: <20070713192659.GG18159@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070713192023.GD18159@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713192023.GD18159@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The ELAN U132 adapter driver uses the semaphore u132_module_lock
as mutex. Use the mutex API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index e98df2e..7f765ec 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -52,6 +52,7 @@
 #include <linux/workqueue.h>
 #include <linux/platform_device.h>
 #include <linux/pci_ids.h>
+#include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/system.h>
@@ -83,7 +84,7 @@ static DECLARE_WAIT_QUEUE_HEAD(u132_hcd_wait);
 * u132_module_lock exists to protect access to global variables
 *
 */
-static struct semaphore u132_module_lock;
+static struct mutex u132_module_lock;
 static int u132_exiting = 0;
 static int u132_instances = 0;
 static struct list_head u132_static_list;
@@ -258,10 +259,10 @@ static void u132_hcd_delete(struct kref *kref)
         struct platform_device *pdev = u132->platform_dev;
         struct usb_hcd *hcd = u132_to_hcd(u132);
         u132->going += 1;
-        down(&u132_module_lock);
+        mutex_lock(&u132_module_lock);
         list_del_init(&u132->u132_list);
         u132_instances -= 1;
-        up(&u132_module_lock);
+        mutex_unlock(&u132_module_lock);
         dev_warn(&u132->platform_dev->dev, "FREEING the hcd=%p and thus the u13"
                 "2=%p going=%d pdev=%p\n", hcd, u132, u132->going, pdev);
         usb_put_hcd(hcd);
@@ -3111,10 +3112,10 @@ static int __devinit u132_probe(struct platform_device *pdev)
                 int retval = 0;
                 struct u132 *u132 = hcd_to_u132(hcd);
                 hcd->rsrc_start = 0;
-                down(&u132_module_lock);
+                mutex_lock(&u132_module_lock);
                 list_add_tail(&u132->u132_list, &u132_static_list);
                 u132->sequence_num = ++u132_instances;
-                up(&u132_module_lock);
+                mutex_unlock(&u132_module_lock);
                 u132_u132_init_kref(u132);
                 u132_initialise(u132, pdev);
                 hcd->product_desc = "ELAN U132 Host Controller";
@@ -3216,7 +3217,7 @@ static int __init u132_hcd_init(void)
         INIT_LIST_HEAD(&u132_static_list);
         u132_instances = 0;
         u132_exiting = 0;
-        init_MUTEX(&u132_module_lock);
+        mutex_init(&u132_module_lock);
         if (usb_disabled())
                 return -ENODEV;
         printk(KERN_INFO "driver %s built at %s on %s\n", hcd_name, __TIME__,
@@ -3232,9 +3233,9 @@ static void __exit u132_hcd_exit(void)
 {
         struct u132 *u132;
         struct u132 *temp;
-        down(&u132_module_lock);
+        mutex_lock(&u132_module_lock);
         u132_exiting += 1;
-        up(&u132_module_lock);
+        mutex_unlock(&u132_module_lock);
         list_for_each_entry_safe(u132, temp, &u132_static_list, u132_list) {
                 platform_device_unregister(u132->platform_dev);
         } platform_driver_unregister(&u132_platform_driver);

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona


  The salvation of mankind lies only in making everything the concern of all
                         (Alexander Solzhenitsyn)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
