Return-Path: <linux-kernel-owner+w=401wt.eu-S1761691AbXGXNL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761691AbXGXNL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbXGXNLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:11:50 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:42572 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753345AbXGXNLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:11:49 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.22+: BUG: sleeping function called from invalid context at /home/jeremy/hg/xen/paravirt/linux/drivers/usb/core/urb.c:524, in_atomic():1, irqs_disabled():0
Date: Tue, 24 Jul 2007 15:13:42 +0200
User-Agent: KMail/1.9.7
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Kevin Lloyd <linux@sierrawireless.com>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
References: <Pine.LNX.4.44L0.0707231649200.2702-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707231649200.2702-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241513.42892.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Clearly there's a bug in 
> drivers/usb/serial/usb-serial.c:usb_serial_put().  It shouldn't call 
> kref_put() while holding a spinlock.

As I was reminded, I polluted the namespace. Here's a better
version. Does it fix your problem?

	Regards
		Oliver
Signed-off-by: Oliver Neukum <oneukum@suse.de>
---

--- a/drivers/usb/serial/usb-serial.c	2007-07-23 08:47:35.000000000 +0200
+++ b/drivers/usb/serial/usb-serial.c	2007-07-24 15:07:05.000000000 +0200
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
@@ -1128,7 +1128,6 @@ static int __init usb_serial_init(void)
 		return -ENOMEM;
 
 	/* Initialize our global data */
-	spin_lock_init(&table_lock);
 	for (i = 0; i < SERIAL_TTY_MINORS; ++i) {
 		serial_table[i] = NULL;
 	}
