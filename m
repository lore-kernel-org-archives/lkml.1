Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZJBBd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZJBBd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZJBBdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:54 -0400
Received: from kroah.org ([198.145.64.141]:33387 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811AbZJBBdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:22 2009
Message-Id: <20091002012421.975071873@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [095/136] usb-serial: change logic of serial lookups
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-change-logic-of-serial-lookups.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 8bc2c1b2daf95029658868cb1427baea2da87139 upstream.

This patch (as1286) changes usb_serial_get_by_index().  Now the
routine will check whether the serial device has been disconnected; if
it has then the return value will be NULL.  If the device hasn't been
disconnected then the routine will return with serial->disc_mutex
held, so that the caller can use the structure without fear of racing
against driver unloads.

This permits the scope of table_mutex in destroy_serial() to be
reduced.  Instead of protecting the entire function, it suffices to
protect the part that actually uses serial_table[], i.e., the call to
return_serial().  There's no longer any danger of the refcount being
incremented after it reaches 0 (which was the reason for having the
large scope previously), because it can't reach 0 until the serial
device has been disconnected.

Also, the patch makes serial_install() check that serial is non-NULL
before attempting to use it.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -66,6 +66,11 @@ static struct usb_serial *serial_table[S
 static DEFINE_MUTEX(table_lock);
 static LIST_HEAD(usb_serial_driver_list);
 
+/*
+ * Look up the serial structure.  If it is found and it hasn't been
+ * disconnected, return with its disc_mutex held and its refcount
+ * incremented.  Otherwise return NULL.
+ */
 struct usb_serial *usb_serial_get_by_index(unsigned index)
 {
 	struct usb_serial *serial;
@@ -73,8 +78,15 @@ struct usb_serial *usb_serial_get_by_ind
 	mutex_lock(&table_lock);
 	serial = serial_table[index];
 
-	if (serial)
-		kref_get(&serial->kref);
+	if (serial) {
+		mutex_lock(&serial->disc_mutex);
+		if (serial->disconnected) {
+			mutex_unlock(&serial->disc_mutex);
+			serial = NULL;
+		} else {
+			kref_get(&serial->kref);
+		}
+	}
 	mutex_unlock(&table_lock);
 	return serial;
 }
@@ -123,8 +135,10 @@ static void return_serial(struct usb_ser
 
 	dbg("%s", __func__);
 
+	mutex_lock(&table_lock);
 	for (i = 0; i < serial->num_ports; ++i)
 		serial_table[serial->minor + i] = NULL;
+	mutex_unlock(&table_lock);
 }
 
 static void destroy_serial(struct kref *kref)
@@ -158,9 +172,7 @@ static void destroy_serial(struct kref *
 
 void usb_serial_put(struct usb_serial *serial)
 {
-	mutex_lock(&table_lock);
 	kref_put(&serial->kref, destroy_serial);
-	mutex_unlock(&table_lock);
 }
 
 /*****************************************************************************
@@ -190,9 +202,12 @@ static int serial_install(struct tty_dri
 			return retval;
 		/* allow the driver to update it */
 		serial = usb_serial_get_by_index(tty->index);
-		if (serial->type->init_termios)
-			serial->type->init_termios(tty);
-		usb_serial_put(serial);
+		if (serial) {
+			if (serial->type->init_termios)
+				serial->type->init_termios(tty);
+			usb_serial_put(serial);
+			mutex_unlock(&serial->disc_mutex);
+		}
 	}
 	/* Final install (we use the default method) */
 	tty_driver_kref_get(driver);
@@ -218,7 +233,6 @@ static int serial_open (struct tty_struc
 		return -ENODEV;
 	}
 
-	mutex_lock(&serial->disc_mutex);
 	portNumber = tty->index - serial->minor;
 	port = serial->port[portNumber];
 	if (!port || serial->disconnected)
@@ -529,6 +543,7 @@ static int serial_proc_show(struct seq_f
 
 		seq_putc(m, '\n');
 		usb_serial_put(serial);
+		mutex_unlock(&serial->disc_mutex);
 	}
 	return 0;
 }


