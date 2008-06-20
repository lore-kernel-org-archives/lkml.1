Return-Path: <linux-kernel-owner+w=401wt.eu-S1764645AbYFTUcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764645AbYFTUcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761702AbYFTUVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:21:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35217 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761648AbYFTUVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:21:21 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 44/70] usb-serial: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:03:56 +0100
Message-ID: <20080620200346.1479.75660.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>



Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/usb-serial.c |  311 +++++++++++++++++++++------------------
 1 files changed, 168 insertions(+), 143 deletions(-)


diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 6a1146a..8882f95 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -12,7 +12,8 @@
  * This driver was originally based on the ACM driver by Armin Fuerst (which was
  * based on a driver by Brad Keryan)
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
  *
  */
 
@@ -28,7 +29,7 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include "pl2303.h"
@@ -59,7 +60,8 @@ static struct usb_driver usb_serial_driver = {
 */
 
 static int debug;
-static struct usb_serial *serial_table[SERIAL_TTY_MINORS];	/* initially all NULL */
+/* initially all NULL */
+static struct usb_serial *serial_table[SERIAL_TTY_MINORS];
 static DEFINE_MUTEX(table_lock);
 static LIST_HEAD(usb_serial_driver_list);
 
@@ -76,7 +78,8 @@ struct usb_serial *usb_serial_get_by_index(unsigned index)
 	return serial;
 }
 
-static struct usb_serial *get_free_serial (struct usb_serial *serial, int num_ports, unsigned int *minor)
+static struct usb_serial *get_free_serial(struct usb_serial *serial,
+					int num_ports, unsigned int *minor)
 {
 	unsigned int i, j;
 	int good_spot;
@@ -122,9 +125,8 @@ static void return_serial(struct usb_serial *serial)
 	if (serial == NULL)
 		return;
 
-	for (i = 0; i < serial->num_ports; ++i) {
+	for (i = 0; i < serial->num_ports; ++i)
 		serial_table[serial->minor + i] = NULL;
-	}
 }
 
 static void destroy_serial(struct kref *kref)
@@ -156,7 +158,8 @@ static void destroy_serial(struct kref *kref)
 	 * not get cleaned up in port_release() as it was never registered with
 	 * the driver core */
 	if (serial->num_ports < serial->num_port_pointers) {
-		for (i = serial->num_ports; i < serial->num_port_pointers; ++i) {
+		for (i = serial->num_ports;
+					i < serial->num_port_pointers; ++i) {
 			port = serial->port[i];
 			if (!port)
 				continue;
@@ -167,7 +170,7 @@ static void destroy_serial(struct kref *kref)
 	usb_put_dev(serial->dev);
 
 	/* free up any memory that we allocated */
-	kfree (serial);
+	kfree(serial);
 }
 
 void usb_serial_put(struct usb_serial *serial)
@@ -180,13 +183,13 @@ void usb_serial_put(struct usb_serial *serial)
 /*****************************************************************************
  * Driver tty interface functions
  *****************************************************************************/
-static int serial_open (struct tty_struct *tty, struct file * filp)
+static int serial_open (struct tty_struct *tty, struct file *filp)
 {
 	struct usb_serial *serial;
 	struct usb_serial_port *port;
 	unsigned int portNumber;
 	int retval;
-	
+
 	dbg("%s", __func__);
 
 	/* get the serial object associated with this tty pointer */
@@ -207,7 +210,7 @@ static int serial_open (struct tty_struct *tty, struct file * filp)
 		retval = -ERESTARTSYS;
 		goto bailout_kref_put;
 	}
-	 
+
 	++port->port.count;
 
 	/* set up our port structure making the tty driver
@@ -228,7 +231,7 @@ static int serial_open (struct tty_struct *tty, struct file * filp)
 		retval = usb_autopm_get_interface(serial->interface);
 		if (retval)
 			goto bailout_module_put;
-		/* only call the device specific open if this 
+		/* only call the device specific open if this
 		 * is the first time the port is opened */
 		retval = serial->type->open(tty, port, filp);
 		if (retval)
@@ -252,7 +255,7 @@ bailout_kref_put:
 	return retval;
 }
 
-static void serial_close(struct tty_struct *tty, struct file * filp)
+static void serial_close(struct tty_struct *tty, struct file *filp)
 {
 	struct usb_serial_port *port = tty->driver_data;
 
@@ -270,7 +273,7 @@ static void serial_close(struct tty_struct *tty, struct file * filp)
 
 	--port->port.count;
 	if (port->port.count == 0)
-		/* only call the device specific close if this 
+		/* only call the device specific close if this
 		 * port is being closed by the last owner */
 		port->serial->type->close(tty, port, filp);
 
@@ -291,7 +294,8 @@ static void serial_close(struct tty_struct *tty, struct file * filp)
 	usb_serial_put(port->serial);
 }
 
-static int serial_write (struct tty_struct * tty, const unsigned char *buf, int count)
+static int serial_write(struct tty_struct *tty, const unsigned char *buf,
+								int count)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	int retval = -ENODEV;
@@ -302,7 +306,7 @@ static int serial_write (struct tty_struct * tty, const unsigned char *buf, int
 	dbg("%s - port %d, %d byte(s)", __func__, port->number, count);
 
 	/* count is managed under the mutex lock for the tty so cannot
-           drop to zero until after the last close completes */
+	   drop to zero until after the last close completes */
 	WARN_ON(!port->port.count);
 
 	/* pass on to the driver specific version of this function */
@@ -312,7 +316,7 @@ exit:
 	return retval;
 }
 
-static int serial_write_room (struct tty_struct *tty) 
+static int serial_write_room(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s - port %d", __func__, port->number);
@@ -321,7 +325,7 @@ static int serial_write_room (struct tty_struct *tty)
 	return port->serial->type->write_room(tty);
 }
 
-static int serial_chars_in_buffer (struct tty_struct *tty) 
+static int serial_chars_in_buffer(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s = port %d", __func__, port->number);
@@ -331,7 +335,7 @@ static int serial_chars_in_buffer (struct tty_struct *tty)
 	return port->serial->type->chars_in_buffer(tty);
 }
 
-static void serial_throttle (struct tty_struct * tty)
+static void serial_throttle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s - port %d", __func__, port->number);
@@ -342,7 +346,7 @@ static void serial_throttle (struct tty_struct * tty)
 		port->serial->type->throttle(tty);
 }
 
-static void serial_unthrottle (struct tty_struct * tty)
+static void serial_unthrottle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s - port %d", __func__, port->number);
@@ -353,7 +357,8 @@ static void serial_unthrottle (struct tty_struct * tty)
 		port->serial->type->unthrottle(tty);
 }
 
-static int serial_ioctl (struct tty_struct *tty, struct file * file, unsigned int cmd, unsigned long arg)
+static int serial_ioctl(struct tty_struct *tty, struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	int retval = -ENODEV;
@@ -362,38 +367,40 @@ static int serial_ioctl (struct tty_struct *tty, struct file * file, unsigned in
 
 	WARN_ON(!port->port.count);
 
-	/* pass on to the driver specific version of this function if it is available */
+	/* pass on to the driver specific version of this function
+	   if it is available */
 	if (port->serial->type->ioctl) {
 		lock_kernel();
 		retval = port->serial->type->ioctl(tty, file, cmd, arg);
 		unlock_kernel();
-	}
-	else
+	} else
 		retval = -ENOIOCTLCMD;
 	return retval;
 }
 
-static void serial_set_termios (struct tty_struct *tty, struct ktermios * old)
+static void serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s - port %d", __func__, port->number);
 
 	WARN_ON(!port->port.count);
-	/* pass on to the driver specific version of this function if it is available */
+	/* pass on to the driver specific version of this function
+	   if it is available */
 	if (port->serial->type->set_termios)
 		port->serial->type->set_termios(tty, port, old);
 	else
 		tty_termios_copy_hw(tty->termios, old);
 }
 
-static void serial_break (struct tty_struct *tty, int break_state)
+static void serial_break(struct tty_struct *tty, int break_state)
 {
 	struct usb_serial_port *port = tty->driver_data;
 
 	dbg("%s - port %d", __func__, port->number);
 
 	WARN_ON(!port->port.count);
-	/* pass on to the driver specific version of this function if it is available */
+	/* pass on to the driver specific version of this function
+	   if it is available */
 	if (port->serial->type->break_ctl) {
 		lock_kernel();
 		port->serial->type->break_ctl(tty, break_state);
@@ -401,7 +408,8 @@ static void serial_break (struct tty_struct *tty, int break_state)
 	}
 }
 
-static int serial_read_proc (char *page, char **start, off_t off, int count, int *eof, void *data)
+static int serial_read_proc(char *page, char **start, off_t off, int count,
+							int *eof, void *data)
 {
 	struct usb_serial *serial;
 	int length = 0;
@@ -410,26 +418,29 @@ static int serial_read_proc (char *page, char **start, off_t off, int count, int
 	char tmp[40];
 
 	dbg("%s", __func__);
-	length += sprintf (page, "usbserinfo:1.0 driver:2.0\n");
+	length += sprintf(page, "usbserinfo:1.0 driver:2.0\n");
 	for (i = 0; i < SERIAL_TTY_MINORS && length < PAGE_SIZE; ++i) {
 		serial = usb_serial_get_by_index(i);
 		if (serial == NULL)
 			continue;
 
-		length += sprintf (page+length, "%d:", i);
+		length += sprintf(page+length, "%d:", i);
 		if (serial->type->driver.owner)
-			length += sprintf (page+length, " module:%s", module_name(serial->type->driver.owner));
-		length += sprintf (page+length, " name:\"%s\"", serial->type->description);
-		length += sprintf (page+length, " vendor:%04x product:%04x", 
-				   le16_to_cpu(serial->dev->descriptor.idVendor), 
-				   le16_to_cpu(serial->dev->descriptor.idProduct));
-		length += sprintf (page+length, " num_ports:%d", serial->num_ports);
-		length += sprintf (page+length, " port:%d", i - serial->minor + 1);
-
+			length += sprintf(page+length, " module:%s",
+				module_name(serial->type->driver.owner));
+		length += sprintf(page+length, " name:\"%s\"",
+				serial->type->description);
+		length += sprintf(page+length, " vendor:%04x product:%04x",
+			le16_to_cpu(serial->dev->descriptor.idVendor),
+			le16_to_cpu(serial->dev->descriptor.idProduct));
+		length += sprintf(page+length, " num_ports:%d",
+							serial->num_ports);
+		length += sprintf(page+length, " port:%d",
+							i - serial->minor + 1);
 		usb_make_path(serial->dev, tmp, sizeof(tmp));
-		length += sprintf (page+length, " path:%s", tmp);
-			
-		length += sprintf (page+length, "\n");
+		length += sprintf(page+length, " path:%s", tmp);
+
+		length += sprintf(page+length, "\n");
 		if ((length + begin) > (off + count)) {
 			usb_serial_put(serial);
 			goto done;
@@ -445,10 +456,10 @@ done:
 	if (off >= (length + begin))
 		return 0;
 	*start = page + (off-begin);
-	return ((count < begin+length-off) ? count : begin+length-off);
+	return (count < begin+length-off) ? count : begin+length-off;
 }
 
-static int serial_tiocmget (struct tty_struct *tty, struct file *file)
+static int serial_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct usb_serial_port *port = tty->driver_data;
 
@@ -460,7 +471,7 @@ static int serial_tiocmget (struct tty_struct *tty, struct file *file)
 	return -EINVAL;
 }
 
-static int serial_tiocmset (struct tty_struct *tty, struct file *file,
+static int serial_tiocmset(struct tty_struct *tty, struct file *file,
 			    unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -482,6 +493,7 @@ void usb_serial_port_softint(struct usb_serial_port *port)
 {
 	schedule_work(&port->work);
 }
+EXPORT_SYMBOL_GPL(usb_serial_port_softint);
 
 static void usb_serial_port_work(struct work_struct *work)
 {
@@ -490,7 +502,7 @@ static void usb_serial_port_work(struct work_struct *work)
 	struct tty_struct *tty;
 
 	dbg("%s - port %d", __func__, port->number);
-	
+
 	if (!port)
 		return;
 
@@ -505,7 +517,7 @@ static void port_release(struct device *dev)
 {
 	struct usb_serial_port *port = to_usb_serial_port(dev);
 
-	dbg ("%s - %s", __func__, dev->bus_id);
+	dbg("%s - %s", __func__, dev->bus_id);
 	port_free(port);
 }
 
@@ -543,9 +555,9 @@ static void port_free(struct usb_serial_port *port)
 	kfree(port);
 }
 
-static struct usb_serial * create_serial (struct usb_device *dev, 
-					  struct usb_interface *interface,
-					  struct usb_serial_driver *driver)
+static struct usb_serial *create_serial(struct usb_device *dev,
+					struct usb_interface *interface,
+					struct usb_serial_driver *driver)
 {
 	struct usb_serial *serial;
 
@@ -564,7 +576,7 @@ static struct usb_serial * create_serial (struct usb_device *dev,
 }
 
 static const struct usb_device_id *match_dynamic_id(struct usb_interface *intf,
-						    struct usb_serial_driver *drv)
+					    struct usb_serial_driver *drv)
 {
 	struct usb_dynid *dynid;
 
@@ -596,7 +608,8 @@ exit:
 	return id;
 }
 
-static struct usb_serial_driver *search_serial_device(struct usb_interface *iface)
+static struct usb_serial_driver *search_serial_device(
+					struct usb_interface *iface)
 {
 	const struct usb_device_id *id;
 	struct usb_serial_driver *drv;
@@ -614,7 +627,7 @@ static struct usb_serial_driver *search_serial_device(struct usb_interface *ifac
 int usb_serial_probe(struct usb_interface *interface,
 			       const struct usb_device_id *id)
 {
-	struct usb_device *dev = interface_to_usbdev (interface);
+	struct usb_device *dev = interface_to_usbdev(interface);
 	struct usb_serial *serial = NULL;
 	struct usb_serial_port *port;
 	struct usb_host_interface *iface_desc;
@@ -643,7 +656,7 @@ int usb_serial_probe(struct usb_interface *interface,
 		return -ENODEV;
 	}
 
-	serial = create_serial (dev, interface, type);
+	serial = create_serial(dev, interface, type);
 	if (!serial) {
 		unlock_kernel();
 		dev_err(&interface->dev, "%s - out of memory\n", __func__);
@@ -656,8 +669,9 @@ int usb_serial_probe(struct usb_interface *interface,
 
 		if (!try_module_get(type->driver.owner)) {
 			unlock_kernel();
-			dev_err(&interface->dev, "module get failed, exiting\n");
-			kfree (serial);
+			dev_err(&interface->dev,
+				"module get failed, exiting\n");
+			kfree(serial);
 			return -EIO;
 		}
 
@@ -667,8 +681,8 @@ int usb_serial_probe(struct usb_interface *interface,
 
 		if (retval) {
 			unlock_kernel();
-			dbg ("sub driver rejected device");
-			kfree (serial);
+			dbg("sub driver rejected device");
+			kfree(serial);
 			return retval;
 		}
 	}
@@ -709,7 +723,7 @@ int usb_serial_probe(struct usb_interface *interface,
 	}
 
 #if defined(CONFIG_USB_SERIAL_PL2303) || defined(CONFIG_USB_SERIAL_PL2303_MODULE)
-	/* BEGIN HORRIBLE HACK FOR PL2303 */ 
+	/* BEGIN HORRIBLE HACK FOR PL2303 */
 	/* this is needed due to the looney way its endpoints are set up */
 	if (((le16_to_cpu(dev->descriptor.idVendor) == PL2303_VENDOR_ID) &&
 	     (le16_to_cpu(dev->descriptor.idProduct) == PL2303_PRODUCT_ID)) ||
@@ -738,7 +752,7 @@ int usb_serial_probe(struct usb_interface *interface,
 		if (num_bulk_in == 0 || num_bulk_out == 0) {
 			unlock_kernel();
 			dev_info(&interface->dev, "PL-2303 hack: descriptors matched but endpoints did not\n");
-			kfree (serial);
+			kfree(serial);
 			return -ENODEV;
 		}
 	}
@@ -750,8 +764,9 @@ int usb_serial_probe(struct usb_interface *interface,
 		num_ports = num_bulk_out;
 		if (num_ports == 0) {
 			unlock_kernel();
-			dev_err(&interface->dev, "Generic device with no bulk out, not allowed.\n");
-			kfree (serial);
+			dev_err(&interface->dev,
+			    "Generic device with no bulk out, not allowed.\n");
+			kfree(serial);
 			return -EIO;
 		}
 	}
@@ -761,11 +776,12 @@ int usb_serial_probe(struct usb_interface *interface,
 		if (type->calc_num_ports) {
 			if (!try_module_get(type->driver.owner)) {
 				unlock_kernel();
-				dev_err(&interface->dev, "module get failed, exiting\n");
-				kfree (serial);
+				dev_err(&interface->dev,
+					"module get failed, exiting\n");
+				kfree(serial);
 				return -EIO;
 			}
-			num_ports = type->calc_num_ports (serial);
+			num_ports = type->calc_num_ports(serial);
 			module_put(type->driver.owner);
 		}
 		if (!num_ports)
@@ -783,7 +799,8 @@ int usb_serial_probe(struct usb_interface *interface,
 			type->description);
 
 	/* create our ports, we need as many as the max endpoints */
-	/* we don't use num_ports here cauz some devices have more endpoint pairs than ports */
+	/* we don't use num_ports here because some devices have more
+	   endpoint pairs than ports */
 	max_endpoints = max(num_bulk_in, num_bulk_out);
 	max_endpoints = max(max_endpoints, num_interrupt_in);
 	max_endpoints = max(max_endpoints, num_interrupt_out);
@@ -791,7 +808,8 @@ int usb_serial_probe(struct usb_interface *interface,
 	serial->num_port_pointers = max_endpoints;
 	unlock_kernel();
 
-	dbg("%s - setting up %d port structures for this device", __func__, max_endpoints);
+	dbg("%s - setting up %d port structures for this device",
+						__func__, max_endpoints);
 	for (i = 0; i < max_endpoints; ++i) {
 		port = kzalloc(sizeof(struct usb_serial_port), GFP_KERNEL);
 		if (!port)
@@ -807,7 +825,7 @@ int usb_serial_probe(struct usb_interface *interface,
 	for (i = 0; i < num_bulk_in; ++i) {
 		endpoint = bulk_in_endpoint[i];
 		port = serial->port[i];
-		port->read_urb = usb_alloc_urb (0, GFP_KERNEL);
+		port->read_urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!port->read_urb) {
 			dev_err(&interface->dev, "No free urbs available\n");
 			goto probe_error;
@@ -815,17 +833,17 @@ int usb_serial_probe(struct usb_interface *interface,
 		buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
 		port->bulk_in_size = buffer_size;
 		port->bulk_in_endpointAddress = endpoint->bEndpointAddress;
-		port->bulk_in_buffer = kmalloc (buffer_size, GFP_KERNEL);
+		port->bulk_in_buffer = kmalloc(buffer_size, GFP_KERNEL);
 		if (!port->bulk_in_buffer) {
-			dev_err(&interface->dev, "Couldn't allocate bulk_in_buffer\n");
+			dev_err(&interface->dev,
+					"Couldn't allocate bulk_in_buffer\n");
 			goto probe_error;
 		}
-		usb_fill_bulk_urb (port->read_urb, dev,
-				   usb_rcvbulkpipe (dev,
-					   	    endpoint->bEndpointAddress),
-				   port->bulk_in_buffer, buffer_size,
-				   serial->type->read_bulk_callback,
-				   port);
+		usb_fill_bulk_urb(port->read_urb, dev,
+				usb_rcvbulkpipe(dev,
+						endpoint->bEndpointAddress),
+				port->bulk_in_buffer, buffer_size,
+				serial->type->read_bulk_callback, port);
 	}
 
 	for (i = 0; i < num_bulk_out; ++i) {
@@ -839,17 +857,17 @@ int usb_serial_probe(struct usb_interface *interface,
 		buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
 		port->bulk_out_size = buffer_size;
 		port->bulk_out_endpointAddress = endpoint->bEndpointAddress;
-		port->bulk_out_buffer = kmalloc (buffer_size, GFP_KERNEL);
+		port->bulk_out_buffer = kmalloc(buffer_size, GFP_KERNEL);
 		if (!port->bulk_out_buffer) {
-			dev_err(&interface->dev, "Couldn't allocate bulk_out_buffer\n");
+			dev_err(&interface->dev,
+					"Couldn't allocate bulk_out_buffer\n");
 			goto probe_error;
 		}
-		usb_fill_bulk_urb (port->write_urb, dev,
-				   usb_sndbulkpipe (dev,
-						    endpoint->bEndpointAddress),
-				   port->bulk_out_buffer, buffer_size, 
-				   serial->type->write_bulk_callback,
-				   port);
+		usb_fill_bulk_urb(port->write_urb, dev,
+				usb_sndbulkpipe(dev,
+					endpoint->bEndpointAddress),
+				port->bulk_out_buffer, buffer_size,
+				serial->type->write_bulk_callback, port);
 	}
 
 	if (serial->type->read_int_callback) {
@@ -858,73 +876,82 @@ int usb_serial_probe(struct usb_interface *interface,
 			port = serial->port[i];
 			port->interrupt_in_urb = usb_alloc_urb(0, GFP_KERNEL);
 			if (!port->interrupt_in_urb) {
-				dev_err(&interface->dev, "No free urbs available\n");
+				dev_err(&interface->dev,
+						"No free urbs available\n");
 				goto probe_error;
 			}
 			buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
-			port->interrupt_in_endpointAddress = endpoint->bEndpointAddress;
-			port->interrupt_in_buffer = kmalloc (buffer_size, GFP_KERNEL);
+			port->interrupt_in_endpointAddress =
+						endpoint->bEndpointAddress;
+			port->interrupt_in_buffer = kmalloc(buffer_size,
+								GFP_KERNEL);
 			if (!port->interrupt_in_buffer) {
-				dev_err(&interface->dev, "Couldn't allocate interrupt_in_buffer\n");
+				dev_err(&interface->dev,
+				    "Couldn't allocate interrupt_in_buffer\n");
 				goto probe_error;
 			}
-			usb_fill_int_urb (port->interrupt_in_urb, dev, 
-					  usb_rcvintpipe (dev,
-							  endpoint->bEndpointAddress),
-					  port->interrupt_in_buffer, buffer_size, 
-					  serial->type->read_int_callback, port, 
-					  endpoint->bInterval);
+			usb_fill_int_urb(port->interrupt_in_urb, dev,
+				usb_rcvintpipe(dev,
+						endpoint->bEndpointAddress),
+				port->interrupt_in_buffer, buffer_size,
+				serial->type->read_int_callback, port,
+				endpoint->bInterval);
 		}
 	} else if (num_interrupt_in) {
 		dbg("the device claims to support interrupt in transfers, but read_int_callback is not defined");
 	}
-	
+
 	if (serial->type->write_int_callback) {
 		for (i = 0; i < num_interrupt_out; ++i) {
 			endpoint = interrupt_out_endpoint[i];
 			port = serial->port[i];
 			port->interrupt_out_urb = usb_alloc_urb(0, GFP_KERNEL);
 			if (!port->interrupt_out_urb) {
-				dev_err(&interface->dev, "No free urbs available\n");
+				dev_err(&interface->dev,
+						"No free urbs available\n");
 				goto probe_error;
 			}
 			buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
 			port->interrupt_out_size = buffer_size;
-			port->interrupt_out_endpointAddress = endpoint->bEndpointAddress;
-			port->interrupt_out_buffer = kmalloc (buffer_size, GFP_KERNEL);
+			port->interrupt_out_endpointAddress =
+						endpoint->bEndpointAddress;
+			port->interrupt_out_buffer = kmalloc(buffer_size,
+								GFP_KERNEL);
 			if (!port->interrupt_out_buffer) {
-				dev_err(&interface->dev, "Couldn't allocate interrupt_out_buffer\n");
+				dev_err(&interface->dev,
+				  "Couldn't allocate interrupt_out_buffer\n");
 				goto probe_error;
 			}
-			usb_fill_int_urb (port->interrupt_out_urb, dev,
-					  usb_sndintpipe (dev,
-							  endpoint->bEndpointAddress),
-					  port->interrupt_out_buffer, buffer_size,
-					  serial->type->write_int_callback, port,
-					  endpoint->bInterval);
+			usb_fill_int_urb(port->interrupt_out_urb, dev,
+				usb_sndintpipe(dev,
+						  endpoint->bEndpointAddress),
+				port->interrupt_out_buffer, buffer_size,
+				serial->type->write_int_callback, port,
+				endpoint->bInterval);
 		}
 	} else if (num_interrupt_out) {
 		dbg("the device claims to support interrupt out transfers, but write_int_callback is not defined");
 	}
-	
+
 	/* if this device type has an attach function, call it */
 	if (type->attach) {
 		if (!try_module_get(type->driver.owner)) {
-			dev_err(&interface->dev, "module get failed, exiting\n");
+			dev_err(&interface->dev,
+					"module get failed, exiting\n");
 			goto probe_error;
 		}
-		retval = type->attach (serial);
+		retval = type->attach(serial);
 		module_put(type->driver.owner);
 		if (retval < 0)
 			goto probe_error;
 		if (retval > 0) {
-			/* quietly accept this device, but don't bind to a serial port
-			 * as it's about to disappear */
+			/* quietly accept this device, but don't bind to a
+			   serial port as it's about to disappear */
 			goto exit;
 		}
 	}
 
-	if (get_free_serial (serial, num_ports, &minor) == NULL) {
+	if (get_free_serial(serial, num_ports, &minor) == NULL) {
 		dev_err(&interface->dev, "No more free serial devices\n");
 		goto probe_error;
 	}
@@ -938,19 +965,20 @@ int usb_serial_probe(struct usb_interface *interface,
 		port->dev.bus = &usb_serial_bus_type;
 		port->dev.release = &port_release;
 
-		snprintf (&port->dev.bus_id[0], sizeof(port->dev.bus_id), "ttyUSB%d", port->number);
-		dbg ("%s - registering %s", __func__, port->dev.bus_id);
+		snprintf(&port->dev.bus_id[0], sizeof(port->dev.bus_id),
+						"ttyUSB%d", port->number);
+		dbg("%s - registering %s", __func__, port->dev.bus_id);
 		retval = device_register(&port->dev);
 		if (retval)
 			dev_err(&port->dev, "Error registering port device, "
 				"continuing\n");
 	}
 
-	usb_serial_console_init (debug, minor);
+	usb_serial_console_init(debug, minor);
 
 exit:
 	/* success */
-	usb_set_intfdata (interface, serial);
+	usb_set_intfdata(interface, serial);
 	return 0;
 
 probe_error:
@@ -986,22 +1014,23 @@ probe_error:
 	/* free up any memory that we allocated */
 	for (i = 0; i < serial->num_port_pointers; ++i)
 		kfree(serial->port[i]);
-	kfree (serial);
+	kfree(serial);
 	return -EIO;
 }
+EXPORT_SYMBOL_GPL(usb_serial_probe);
 
 void usb_serial_disconnect(struct usb_interface *interface)
 {
 	int i;
-	struct usb_serial *serial = usb_get_intfdata (interface);
+	struct usb_serial *serial = usb_get_intfdata(interface);
 	struct device *dev = &interface->dev;
 	struct usb_serial_port *port;
 
 	usb_serial_console_disconnect(serial);
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	mutex_lock(&serial->disc_mutex);
-	usb_set_intfdata (interface, NULL);
+	usb_set_intfdata(interface, NULL);
 	/* must set a flag, to signal subdrivers */
 	serial->disconnected = 1;
 	for (i = 0; i < serial->num_ports; ++i) {
@@ -1018,6 +1047,7 @@ void usb_serial_disconnect(struct usb_interface *interface)
 	usb_serial_put(serial);
 	dev_info(dev, "device disconnected\n");
 }
+EXPORT_SYMBOL_GPL(usb_serial_disconnect);
 
 int usb_serial_suspend(struct usb_interface *intf, pm_message_t message)
 {
@@ -1076,9 +1106,8 @@ static int __init usb_serial_init(void)
 		return -ENOMEM;
 
 	/* Initialize our global data */
-	for (i = 0; i < SERIAL_TTY_MINORS; ++i) {
+	for (i = 0; i < SERIAL_TTY_MINORS; ++i)
 		serial_table[i] = NULL;
-	}
 
 	result = bus_register(&usb_serial_bus_type);
 	if (result) {
@@ -1093,9 +1122,11 @@ static int __init usb_serial_init(void)
 	usb_serial_tty_driver->minor_start = 0;
 	usb_serial_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
 	usb_serial_tty_driver->subtype = SERIAL_TYPE_NORMAL;
-	usb_serial_tty_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	usb_serial_tty_driver->flags = TTY_DRIVER_REAL_RAW |
+						TTY_DRIVER_DYNAMIC_DEV;
 	usb_serial_tty_driver->init_termios = tty_std_termios;
-	usb_serial_tty_driver->init_termios.c_cflag = B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	usb_serial_tty_driver->init_termios.c_cflag = B9600 | CS8 | CREAD
+							| HUPCL | CLOCAL;
 	usb_serial_tty_driver->init_termios.c_ispeed = 9600;
 	usb_serial_tty_driver->init_termios.c_ospeed = 9600;
 	tty_set_operations(usb_serial_tty_driver, &serial_ops);
@@ -1133,7 +1164,7 @@ exit_reg_driver:
 	bus_unregister(&usb_serial_bus_type);
 
 exit_bus:
-	err ("%s - returning with error %d", __func__, result);
+	err("%s - returning with error %d", __func__, result);
 	put_tty_driver(usb_serial_tty_driver);
 	return result;
 }
@@ -1160,7 +1191,7 @@ module_exit(usb_serial_exit);
 		if (!type->function) {					\
 			type->function = usb_serial_generic_##function;	\
 			dbg("Had to override the " #function		\
-				 " usb serial operation with the generic one.");\
+				" usb serial operation with the generic one.");\
 			}						\
 	} while (0)
 
@@ -1177,8 +1208,9 @@ static void fixup_generic(struct usb_serial_driver *device)
 	set_to_generic_if_null(device, resume);
 }
 
-int usb_serial_register(struct usb_serial_driver *driver) /* must be called with BKL held */
+int usb_serial_register(struct usb_serial_driver *driver)
 {
+	/* must be called with BKL held */
 	int retval;
 
 	fixup_generic(driver);
@@ -1191,37 +1223,30 @@ int usb_serial_register(struct usb_serial_driver *driver) /* must be called with
 
 	retval = usb_serial_bus_register(driver);
 	if (retval) {
-		err("problem %d when registering driver %s", retval, driver->description);
+		err("problem %d when registering driver %s",
+						retval, driver->description);
 		list_del(&driver->driver_list);
-	}
-	else
-		info("USB Serial support registered for %s", driver->description);
+	} else
+		info("USB Serial support registered for %s",
+						driver->description);
 
 	return retval;
 }
+EXPORT_SYMBOL_GPL(usb_serial_register);
 
 
-void usb_serial_deregister(struct usb_serial_driver *device) /* must be called with BKL held */
+void usb_serial_deregister(struct usb_serial_driver *device)
 {
+	/* must be called with BKL held */
 	info("USB Serial deregistering driver %s", device->description);
 	list_del(&device->driver_list);
 	usb_serial_bus_deregister(device);
 }
-
-
-
-/* If the usb-serial core is built into the core, the usb-serial drivers
-   need these symbols to load properly as modules. */
-EXPORT_SYMBOL_GPL(usb_serial_register);
 EXPORT_SYMBOL_GPL(usb_serial_deregister);
-EXPORT_SYMBOL_GPL(usb_serial_probe);
-EXPORT_SYMBOL_GPL(usb_serial_disconnect);
-EXPORT_SYMBOL_GPL(usb_serial_port_softint);
-
 
 /* Module information */
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);

