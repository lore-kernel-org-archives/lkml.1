Return-Path: <linux-kernel-owner+w=401wt.eu-S1759528AbZEMLkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbZEMLkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZEMLj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:39:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:35129 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759562AbZEMLjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:39:55 -0400
Message-ID: <4A0AB18D.9070202@windriver.com>
Date: Wed, 13 May 2009 06:39:57 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: greg@kroah.com, linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] usb hcd: poll hcd device to force writes
References: <Pine.LNX.4.44L0.0905122218180.7989-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0905122218180.7989-100000@netrider.rowland.org>
Content-Type: multipart/mixed;
 boundary="------------000302020306030106050809"
X-OriginalArrivalTime: 13 May 2009 11:39:49.0736 (UTC) FILETIME=[86037E80:01C9D3BF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000302020306030106050809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Alan Stern wrote:
> On Tue, 12 May 2009, Jason Wessel wrote:
>
>   
>> +	if (!urb)
>> +		return;
>>     
>
> Is this test really needed?  
Doesn't look like it.
>
> Maybe you should pass a pointer to a usb_bus structure rather than an
> URB.  Then none of these issues would arise.
>
>   

I changed it to pass in the device instead (see attached)

>> +
>> +	hcd = bus_to_hcd(urb->dev->bus);
>> +	if (hcd)
>> +		usb_hcd_irq(0, hcd);
>>     
>
> This test too looks strange, since it can never fail.  (See the 
> definition of bus_to_hcd to find out why...)
>   

I agree.

Thanks,
Jason.



--------------000302020306030106050809
Content-Type: text/x-diff;
 name="poll_hcd_device.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="poll_hcd_device.patch"

From: Jason Wessel <jason.wessel@windriver.com>
Date: Wed, 11 Feb 2009 18:46:32 -0600
Subject: [PATCH] usb hcd: poll hcd device to force writes

The problem that this patch tries to solve is that data is lost
because there are too many outstanding transmit urb's while trying to
execute printk's to a console.  The same is true if you try something
like "echo t > /proc/sysrq-trigger".

This patch takes the route of forcibly polling the hcd device to drain
the urb queue in order to initiate the bulk write call backs.  This
only happens if the device is a usb serial console device that sets
the max_in_flight_urbs in the serial device structure.

A maximum 3 ms penalty will get incurred to allow the hcd controller
to complete a write urb, else the console data is thrown away.

The max_in_flight_urbs was reduced in the usb_debug driver because it
is highly desired to push things out to the console in a timely
fashion and there is no need to have a queue that large for the
interrupt driven mode of operation when used through the tty
interface.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 drivers/usb/core/hcd.c         |   11 ++++++++++
 drivers/usb/core/hcd.h         |    1 
 drivers/usb/serial/console.c   |   44 +++++++++++++++++++++++++++--------------
 drivers/usb/serial/ftdi_sio.c  |    7 +++---
 drivers/usb/serial/usb_debug.c |    2 -
 5 files changed, 46 insertions(+), 19 deletions(-)

--- a/drivers/usb/serial/usb_debug.c
+++ b/drivers/usb/serial/usb_debug.c
@@ -15,7 +15,7 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
-#define URB_DEBUG_MAX_IN_FLIGHT_URBS	4000
+#define URB_DEBUG_MAX_IN_FLIGHT_URBS	42
 #define USB_DEBUG_MAX_PACKET_SIZE	8
 #define USB_DEBUG_BRK_SIZE		8
 static char USB_DEBUG_BRK[USB_DEBUG_BRK_SIZE] = {
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1760,6 +1760,7 @@ irqreturn_t usb_hcd_irq (int irq, void *
 	local_irq_restore(flags);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(usb_hcd_irq);
 
 /*-------------------------------------------------------------------------*/
 
@@ -2045,6 +2046,16 @@ usb_hcd_platform_shutdown(struct platfor
 }
 EXPORT_SYMBOL_GPL(usb_hcd_platform_shutdown);
 
+void
+usb_hcd_poll_irq(struct usb_device *udev)
+{
+	struct usb_hcd *hcd;
+
+	hcd = bus_to_hcd(udev->bus);
+	usb_hcd_irq(0, hcd);
+}
+EXPORT_SYMBOL_GPL(usb_hcd_poll_irq);
+
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_USB_MON) || defined(CONFIG_USB_MON_MODULE)
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -51,6 +51,9 @@
 #define DRIVER_AUTHOR "Greg Kroah-Hartman <greg@kroah.com>, Bill Ryder <bryder@sgi.com>, Kuba Ober <kuba@mareimbrium.org>"
 #define DRIVER_DESC "USB FTDI Serial Converters Driver"
 
+/* number of outstanding urbs to prevent userspace DoS from happening */
+#define URB_UPPER_LIMIT	42
+
 static int debug;
 static __u16 vendor = FTDI_VID;
 static __u16 product;
@@ -771,6 +774,7 @@ static struct usb_serial_driver ftdi_sio
 	.set_termios =		ftdi_set_termios,
 	.break_ctl =		ftdi_break_ctl,
 	.shutdown =		ftdi_shutdown,
+	.max_in_flight_urbs =	URB_UPPER_LIMIT,
 };
 
 
@@ -781,9 +785,6 @@ static struct usb_serial_driver ftdi_sio
 #define HIGH 1
 #define LOW 0
 
-/* number of outstanding urbs to prevent userspace DoS from happening */
-#define URB_UPPER_LIMIT	42
-
 /*
  * ***************************************************************************
  * Utility functions
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -18,6 +18,7 @@
 #include <linux/console.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include "../core/hcd.h"
 
 static int debug;
 
@@ -185,13 +186,38 @@ reset_open_count:
 goto out;
 }
 
+static void usb_do_console_write(struct usb_serial *serial,
+				 struct usb_serial_port *port,
+				 const char *buf, unsigned count)
+{
+	int retval;
+	int loops = 3;
+try_again:
+	/* pass on to the driver specific version of this function if
+	   it is available */
+	if (serial->type->write)
+		retval = serial->type->write(NULL, port, buf, count);
+	else
+		retval = usb_serial_generic_write(NULL, port, buf, count);
+	if (serial->type->max_in_flight_urbs && loops-- &&
+	    retval >= 0 && retval < count) {
+		/* poll the hcd device because the queue is full and
+		 * try this for a total of 3 ms and give up. */
+		count -= retval;
+		buf += retval;
+		mdelay(1);
+		usb_hcd_poll_irq(serial->dev);
+		goto try_again;
+	}
+	dbg("%s - return value : %d", __func__, retval);
+}
+
 static void usb_console_write(struct console *co,
 					const char *buf, unsigned count)
 {
 	static struct usbcons_info *info = &usbcons_info;
 	struct usb_serial_port *port = info->port;
 	struct usb_serial *serial;
-	int retval = -ENODEV;
 
 	if (!port || port->serial->dev->state == USB_STATE_NOTATTACHED)
 		return;
@@ -218,23 +244,11 @@ static void usb_console_write(struct con
 				break;
 			}
 		}
-		/* pass on to the driver specific version of this function if
-		   it is available */
-		if (serial->type->write)
-			retval = serial->type->write(NULL, port, buf, i);
-		else
-			retval = usb_serial_generic_write(NULL, port, buf, i);
-		dbg("%s - return value : %d", __func__, retval);
+		usb_do_console_write(serial, port, buf, i);
 		if (lf) {
 			/* append CR after LF */
 			unsigned char cr = 13;
-			if (serial->type->write)
-				retval = serial->type->write(NULL,
-								port, &cr, 1);
-			else
-				retval = usb_serial_generic_write(NULL,
-								port, &cr, 1);
-			dbg("%s - return value : %d", __func__, retval);
+			usb_do_console_write(serial, port, &cr, 1);
 		}
 		buf += i;
 		count -= i;
--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -251,6 +251,7 @@ extern void usb_put_hcd(struct usb_hcd *
 extern int usb_add_hcd(struct usb_hcd *hcd,
 		unsigned int irqnum, unsigned long irqflags);
 extern void usb_remove_hcd(struct usb_hcd *hcd);
+extern void usb_hcd_poll_irq(struct usb_device *udev);
 
 struct platform_device;
 extern void usb_hcd_platform_shutdown(struct platform_device *dev);

--------------000302020306030106050809--
