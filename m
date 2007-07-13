Return-Path: <linux-kernel-owner+w=401wt.eu-S937270AbXGMT2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937270AbXGMT2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761608AbXGMT2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:28:25 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:41861
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760672AbXGMT2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:28:24 -0400
Date: Fri, 13 Jul 2007 21:29:46 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 5/5] use mutex instead of semaphore in the FTDI ELAN driver
Message-ID: <20070713192946.GI18159@traven>
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

The FTDI ELAN driver uses a semaphore as mutex. Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index e0f122e..7cc6883 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -44,6 +44,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kref.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <linux/usb.h>
 #include <linux/workqueue.h>
@@ -64,7 +65,7 @@ static struct workqueue_struct *respond_queue;
 * ftdi_module_lock exists to protect access to global variables
 *
 */
-static struct semaphore ftdi_module_lock;
+static struct mutex ftdi_module_lock;
 static int ftdi_instances = 0;
 static struct list_head ftdi_static_list;
 /*
@@ -199,10 +200,10 @@ static void ftdi_elan_delete(struct kref *kref)
         dev_warn(&ftdi->udev->dev, "FREEING ftdi=%p\n", ftdi);
         usb_put_dev(ftdi->udev);
         ftdi->disconnected += 1;
-        down(&ftdi_module_lock);
+        mutex_lock(&ftdi_module_lock);
         list_del_init(&ftdi->ftdi_list);
         ftdi_instances -= 1;
-        up(&ftdi_module_lock);
+        mutex_unlock(&ftdi_module_lock);
         kfree(ftdi->bulk_in_buffer);
         ftdi->bulk_in_buffer = NULL;
 }
@@ -2780,10 +2781,10 @@ static int ftdi_elan_probe(struct usb_interface *interface,
                 return -ENOMEM;
         }
         memset(ftdi, 0x00, sizeof(struct usb_ftdi));
-        down(&ftdi_module_lock);
+        mutex_lock(&ftdi_module_lock);
         list_add_tail(&ftdi->ftdi_list, &ftdi_static_list);
         ftdi->sequence_num = ++ftdi_instances;
-        up(&ftdi_module_lock);
+        mutex_unlock(&ftdi_module_lock);
         ftdi_elan_init_kref(ftdi);
         init_MUTEX(&ftdi->sw_lock);
         ftdi->udev = usb_get_dev(interface_to_usbdev(interface));
@@ -2909,7 +2910,7 @@ static int __init ftdi_elan_init(void)
         int result;
         printk(KERN_INFO "driver %s built at %s on %s\n", ftdi_elan_driver.name,
 	       __TIME__, __DATE__);
-        init_MUTEX(&ftdi_module_lock);
+        mutex_init(&ftdi_module_lock);
         INIT_LIST_HEAD(&ftdi_static_list);
         status_queue = create_singlethread_workqueue("ftdi-status-control");
 	if (!status_queue)

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             If liberty means anything at all, it means the
           right to tell people what they do not want to hear
                            (George Orwell)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
