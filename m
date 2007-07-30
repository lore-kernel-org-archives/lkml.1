Return-Path: <linux-kernel-owner+w=401wt.eu-S968184AbXG3TOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968184AbXG3TOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968177AbXG3TOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:14:08 -0400
Received: from ns.suse.de ([195.135.220.2]:55107 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968191AbXG3TOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:14:07 -0400
Subject: patch usb-fix-bug-sleeping-function-called-from-invalid-context-at-home-jeremy-hg-xen-paravirt-linux-drivers-usb-core-urb.c-524-in_atomic-1-irqs_disabled-0.patch added to gregkh-2.6 tree
To: oliver@neukum.org, gregkh@suse.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       linux@sierrawireless.com, oneukum@suse.de, stern@rowland.harvard.edu
From: <gregkh@suse.de>
Date: Mon, 30 Jul 2007 12:13:55 -0700
In-Reply-To: <200707241513.42892.oliver@neukum.org>
Message-Id: <20070730191403.AFF4014458DB@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: fix BUG: sleeping function called from invalid context at /home/jeremy/hg/xen/paravirt/linux/drivers/usb/core/urb.c:524, in_atomic():1, irqs_disabled():0

to my gregkh-2.6 tree.  Its filename is

     usb-fix-bug-sleeping-function-called-from-invalid-context-at-home-jeremy-hg-xen-paravirt-linux-drivers-usb-core-urb.c-524-in_atomic-1-irqs_disabled-0.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From oliver@neukum.org Tue Jul 24 06:11:50 2007
From: Oliver Neukum <oliver@neukum.org>
Date: Tue, 24 Jul 2007 15:13:42 +0200
Subject: USB: fix BUG: sleeping function called from invalid context at /home/jeremy/hg/xen/paravirt/linux/drivers/usb/core/urb.c:524, in_atomic():1, irqs_disabled():0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Kevin Lloyd <linux@sierrawireless.com>, Greg KH <gregkh@suse.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
Message-ID: <200707241513.42892.oliver@neukum.org>
Content-Disposition: inline



Clearly there's a bug in
drivers/usb/serial/usb-serial.c:usb_serial_put().  It shouldn't call
kref_put() while holding a spinlock.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -60,19 +60,19 @@ static struct usb_driver usb_serial_driv
 
 static int debug;
 static struct usb_serial *serial_table[SERIAL_TTY_MINORS];	/* initially all NULL */
-static spinlock_t table_lock;
+static DEFINE_MUTEX(table_lock);
 static LIST_HEAD(usb_serial_driver_list);
 
 struct usb_serial *usb_serial_get_by_index(unsigned index)
 {
 	struct usb_serial *serial;
 
-	spin_lock(&table_lock);
+	mutex_lock(&table_lock);
 	serial = serial_table[index];
 
 	if (serial)
 		kref_get(&serial->kref);
-	spin_unlock(&table_lock);
+	mutex_unlock(&table_lock);
 	return serial;
 }
 
@@ -84,7 +84,7 @@ static struct usb_serial *get_free_seria
 	dbg("%s %d", __FUNCTION__, num_ports);
 
 	*minor = 0;
-	spin_lock(&table_lock);
+	mutex_lock(&table_lock);
 	for (i = 0; i < SERIAL_TTY_MINORS; ++i) {
 		if (serial_table[i])
 			continue;
@@ -106,10 +106,10 @@ static struct usb_serial *get_free_seria
 			serial_table[i] = serial;
 			serial->port[j++]->number = i;
 		}
-		spin_unlock(&table_lock);
+		mutex_unlock(&table_lock);
 		return serial;
 	}
-	spin_unlock(&table_lock);
+	mutex_unlock(&table_lock);
 	return NULL;
 }
 
@@ -172,9 +172,9 @@ static void destroy_serial(struct kref *
 
 void usb_serial_put(struct usb_serial *serial)
 {
-	spin_lock(&table_lock);
+	mutex_lock(&table_lock);
 	kref_put(&serial->kref, destroy_serial);
-	spin_unlock(&table_lock);
+	mutex_unlock(&table_lock);
 }
 
 /*****************************************************************************
@@ -1129,7 +1129,6 @@ static int __init usb_serial_init(void)
 		return -ENOMEM;
 
 	/* Initialize our global data */
-	spin_lock_init(&table_lock);
 	for (i = 0; i < SERIAL_TTY_MINORS; ++i) {
 		serial_table[i] = NULL;
 	}


Patches currently in gregkh-2.6 which might be from oliver@neukum.org are

usb/usb-fix-bug-sleeping-function-called-from-invalid-context-at-home-jeremy-hg-xen-paravirt-linux-drivers-usb-core-urb.c-524-in_atomic-1-irqs_disabled-0.patch
usb/usb-nikon-d50-is-an-unusual-device.patch
usb/usb-yet-another-quirky-device.patch
usb/usb-more-quirky-devices.patch
