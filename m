Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbZE2OyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbZE2OyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 10:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758215AbZE2OyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 10:54:10 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:46292 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618AbZE2OyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 10:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:reply-to:to:content-type:organization:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=wDkrJLkBnJE3gXvU1plEpcDIghZ5UXiGMlDyHcz3s2+XTLXSTlfWANdIzc6yMSe68U
         bUQjGK4izxvf20MzaW/jxUCV/FdJETzaJIjwDFvJ+hrQP1m2j4RirZnR1kOtRUtdqonf
         xmqVgIAFyUKneJkRE4jyxx7Nqew3DXu3S5kXw=
Subject: Support for Quatech ESU2-100 USB 2.0 8-port serial adaptor
From: Richard Ash <richardashaudacity@googlemail.com>
Reply-To: richard@audacityteam.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Audacity Developer Team
Date: Fri, 29 May 2009 15:54:04 +0100
Message-Id: <1243608844.20669.61.camel@linux-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quatech have replaced the ESU range of USB 1 to serial adaptors (for
which a driver is in staging/serqt_usb) with a new range of USB2.0
devices. Unfortunately these are significantly different and do not work
with the original driver, and have different USB device IDs.

Quatech have produced a modified version of their driver for these
devices, which is available from

http://www.quatech.com/ManualsDriversFirmware/Communication/serqt_usb2_2.6_1.00.tar.gz

This has all the same problems as the drivers they provide for the USB 1
series of devices (based on old kernel code, doesn't compile with
current kernel, duplicates chunks of the usb-serial subsystem etc), but
also adds some new gotchas:
* the tarball unpacks to create a directory named serqt_usb, which
doesn't match the tarball name, and gets it mixed up with the old USB1
driver.
* The driver compiles to a module named serqt_usb.ko, clashing with the
USB1 driver.
* The driver is not backwards-compatible, so won't drive old USB1
devices.

I have started going through the Quatech driver for the USB2 devices and
the staging driver to see how possible it would be to merge the two
drivers and get support for the USB2 series in the kernel, but am now
uncertain if this is the right approach.

Adding the new device IDs is straightforward, once some conflicting
preprocessor names are changed to make them unique. Once I get to the
serqt_probe function however, there is relatively little in common
between the two drivers, and so the attempt at a merged driver ends up
mainly composed of if statements switching between code for USB1 series
and code for USB2 series devices. This makes me uncertain whether trying
to produce a merged driver is a good idea or not.

I have included the patch I have produced (works on 2.6.30-rc7 git or
Greg k-h's patch tree), not because it meets standard or is worth
applying but to give some idea of the changes needed to merge the two
drivers. I have tried to avoid cleaning up the existing driver at the
same time, although some blocks of in-line initialisation code have
become helper functions to avoid huge if statements.

The main reason the initialisation code is different for the two sets of
devices is because they communicate via different USB endpoints. Whilst
the USB1 devices have one bulk end-point per port (a fact that the
driver uses implicitly all over the place), the USB2 devices all have
one bulk in and one bulk out end point, regardless of the number of
ports. The process for powering up the device hardware is also
completely different (the ESU2-100 has a Cyprus Semiconductor USB host
chip and a Spartan 3 FPGA inside, and does nothing useful until the FPGA
is turned on, when all the port status LEDs come on red. The PCB is
common to the 2, 4 and 8 port RS232 and RS232/442/485 models).

For information the device concerned is listed in the kernel log like
this (note that the Product string is wrong - it's actually an ESU2-100
Eight-port RS-232 USB adapter):
May 29 14:54:21 [kernel] usb 1-1: New USB device found, idVendor=061d,
idProduct=c180
May 29 14:54:21 [kernel] usb 1-1: New USB device strings: Mfr=1,
Product=2, SerialNumber=8
May 29 14:54:21 [kernel] usb 1-1: Product: ESU-100 Eight-port RS-232 USB
adapter
May 29 14:54:21 [kernel] usb 1-1: Manufacturer: Quatech, Inc.
May 29 14:54:21 [kernel] usb 1-1: SerialNumber: C18000001297

I should point out that I have no relationship with Quatech apart from
having bought two of the 8-port units for a project at work, and now
trying to get them to work.

I have a reasonable amount of experience writing C programs and am a
developer on the Audacity project, but have no experience of kernel
development. What is the best way to progress towards getting these
devices working with a standard Linux kernel?

Richard Ash

diff --git a/drivers/staging/serqt_usb/serqt_usb.c b/drivers/staging/serqt_usb/serqt_usb.c
index 234f332..f969578 100644
--- a/drivers/staging/serqt_usb/serqt_usb.c
+++ b/drivers/staging/serqt_usb/serqt_usb.c
@@ -105,6 +106,8 @@
 #define QT_SW_FLOW_CONTROL_MASK     0xc6
 #define QT_SW_FLOW_CONTROL_DISABLE  0xc7
 #define QT_BREAK_CONTROL            0xc8
+/* RA add from 2.0 */
+#define QT_GET_SET_QMCR             0xe1
 
 #define SERIALQT_PCI_IOC_MAGIC 'k'
 #define SERIALQT_WRITE_QOPR _IOW(SERIALQT_PCI_IOC_MAGIC, 0, int)
@@ -176,7 +185,9 @@ struct usb_serial_port {
 	int RxHolding;
 	char closePending;
 	int ReadBulkStopped;
-
+/* USB2 added */
+        struct semaphore        pend_xmit_sem;          /* locks this structure */
+        
 	void *private;		/* data private to the specific port */
 };
 
@@ -345,6 +356,14 @@ static int qt_tiocmset(struct tty_struct *tty, struct usb_serial_port *port,
 static int qt_tiocmget(struct tty_struct *tty, struct usb_serial_port *port,
 							struct file *file);
 
+static int BoxSetQMCR(struct usb_serial *serial, __u16 Uart_Number,__u8 QMCR_Value);
+
+/* helper functions (at end of file) */
+int qt1_poweron(struct usb_serial *serial);
+int qt2_poweron(struct usb_serial *serial);
+int qt1_precon(struct usb_serial *serial);
+int qt2_precon(struct usb_serial *serial);
+
 /* Version Information */
 #define DRIVER_VERSION "v2.14"
 #define DRIVER_AUTHOR "Tim Gobeli, Quatech, Inc"
@@ -369,6 +388,14 @@ static int qt_tiocmget(struct tty_struct *tty, struct usb_serial_port *port,
 #define DEVICE_ID_QUATECH_RS422_16_PORT_B	0xC0B1	/* HSU200B */
 #define DEVICE_ID_QUATECH_RS422_16_PORT_C	0xC0B2	/* HSU200C */
 #define DEVICE_ID_QUATECH_RS422_16_PORT_D	0xC0B3	/* HSU200D */
+/* Added in USB 2.0 versions of devices */
+#define DEVICE_ID_QUATECH_U2_RS232_SINGLE_PORT   0xC120  /* SSU100_2 */
+#define DEVICE_ID_QUATECH_U2_RS232_DUAL_PORT     0xC140  /* DSU100_2 */
+#define DEVICE_ID_QUATECH_U2_RS400_DUAL_PORT     0xC150  /* DSU400_2 */
+#define DEVICE_ID_QUATECH_U2_RS232_FOUR_PORT     0xC160  /* QSU100_2 */
+#define DEVICE_ID_QUATECH_U2_RS400_FOUR_PORT     0xC170  /* QSU400_2 */
+#define DEVICE_ID_QUATECH_U2_RS232_EIGHT_PORT    0xC180  /* ESU400_2 */
+#define DEVICE_ID_QUATECH_U2_RS400_EIGHT_PORT    0xC1A0  /* ESU100_2 */
 
 /* table of Quatech devices  */
 static struct usb_device_id serqt_table[] = {
@@ -396,6 +423,14 @@ static struct usb_device_id serqt_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_QUATECH, DEVICE_ID_QUATECH_RS422_16_PORT_B)},
 	{USB_DEVICE(USB_VENDOR_ID_QUATECH, DEVICE_ID_QUATECH_RS422_16_PORT_C)},
 	{USB_DEVICE(USB_VENDOR_ID_QUATECH, DEVICE_ID_QUATECH_RS422_16_PORT_D)},
+	/* entries for USB 2.0 versions of devices */
+    {USB_DEVICE(USB_VENDOR_ID_QUATECH, DEVICE_ID_QUATECH_U2_RS232_SINGLE_PORT)},
+    {USB_DEVICE(USB_VENDOR_ID_QUATECH, DEVICE_ID_QUATECH_U2_RS232_DUAL_PORT)},
+    {USB_DEVICE(USB_VENDOR_ID_QUATECH, DEVICE_ID_QUATECH_U2_RS400_DUAL_PORT)},
+    {USB_DEVICE(USB_VENDOR_ID_QUATECH, DEVICE_ID_QUATECH_U2_RS232_FOUR_PORT)},
+    {USB_DEVICE(USB_VENDOR_ID_QUATECH, DEVICE_ID_QUATECH_U2_RS400_FOUR_PORT)},
+    {USB_DEVICE(USB_VENDOR_ID_QUATECH, DEVICE_ID_QUATECH_U2_RS232_EIGHT_PORT)},
+    {USB_DEVICE(USB_VENDOR_ID_QUATECH, DEVICE_ID_QUATECH_U2_RS400_EIGHT_PORT)},
 	{}			/* Terminating entry */
 };
 
@@ -415,6 +450,9 @@ static unsigned int serqt_422_table[] = {
 	DEVICE_ID_QUATECH_RS422_16_PORT_B,
 	DEVICE_ID_QUATECH_RS422_16_PORT_C,
 	DEVICE_ID_QUATECH_RS422_16_PORT_D,
+    DEVICE_ID_QUATECH_U2_RS400_DUAL_PORT,
+    DEVICE_ID_QUATECH_U2_RS400_FOUR_PORT,
+    DEVICE_ID_QUATECH_U2_RS400_EIGHT_PORT,
 	0			/* terminate with zero */
 };
 
@@ -483,7 +521,7 @@ static int serqt_probe(struct usb_interface *interface,
 {
 	struct usb_device *dev = interface_to_usbdev(interface);
 	struct usb_serial *serial = NULL;
-	struct usb_serial_port *port;
+	struct usb_serial_port *port = NULL;
 	struct usb_endpoint_descriptor *endpoint;
 	struct usb_endpoint_descriptor *interrupt_in_endpoint[MAX_NUM_PORTS];
 	struct usb_endpoint_descriptor *bulk_in_endpoint[MAX_NUM_PORTS];
@@ -496,12 +534,34 @@ static int serqt_probe(struct usb_interface *interface,
 	int num_bulk_in = 0;
 	int num_bulk_out = 0;
 	int num_ports;
-	struct qt_get_device_data DeviceData;
 	int status;
-
-	mydbg("In %s\n", __func__);
-
-	/* let's find the endpoints needed */
+        /* USB2 extras */
+        int found;
+        const struct usb_device_id *id_pattern = NULL;  /* for hunting down devices */
+        int flag_as_400 = false;        /* marker for multi-standard units */
+        int is2series = false;          /* marker for USB2 devices */
+
+	mydbg("%s running", __func__);
+        /* Added from USB2 driver */
+        /* loop through our list of known serial converters, and see if this
+        device matches. */
+        found = 0;
+
+        id_pattern = usb_match_id(interface, serqt_table);
+        if (id_pattern != NULL)
+        {
+            mydbg("%s - descriptor matches\n", __FUNCTION__);
+            found = 1;
+        }
+
+        if (!found)
+        {
+            /* no match */
+            mydbg("%s - none matched\n",__FUNCTION__);
+            return-ENODEV;
+        }
+        /* end of USB2 extras */
+        /* descriptor matches, let's find the endpoints needed */
 	/* check out the endpoints */
 	iface_desc = interface->cur_altsetting;;
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
@@ -534,13 +594,48 @@ static int serqt_probe(struct usb_interface *interface,
 
 	/* found all that we need */
 	dev_info(&interface->dev, "Quatech converter detected\n");
-	num_ports = num_bulk_out;
-	if (num_ports == 0) {
+
+	if (num_bulk_out == 0) {
 		err("Quatech device with no bulk out, not allowed.");
 		return -ENODEV;
-
 	}
-
+        /*
+        * This bit gets a bit more complex in the merged driver. USB1 series devices have one bulk out
+        * per port. USB2 series have one bulk out and one bulk in regardless of the number of ports.
+        */
+        switch (dev->descriptor.idProduct)
+        {
+            case DEVICE_ID_QUATECH_U2_RS232_SINGLE_PORT:
+                num_ports = 1;
+                is2series = true;
+                break;
+
+            case DEVICE_ID_QUATECH_U2_RS400_DUAL_PORT:
+                flag_as_400 = true;
+            case DEVICE_ID_QUATECH_U2_RS232_DUAL_PORT:
+                num_ports = 2;
+                is2series = true;
+                break;
+
+            case DEVICE_ID_QUATECH_U2_RS232_FOUR_PORT:
+                flag_as_400 = true;
+            case DEVICE_ID_QUATECH_U2_RS400_FOUR_PORT:
+                num_ports = 4;
+                is2series = true;
+                break;
+
+            case DEVICE_ID_QUATECH_U2_RS400_EIGHT_PORT:
+                flag_as_400 = true;
+            case DEVICE_ID_QUATECH_U2_RS232_EIGHT_PORT:
+                num_ports = 8;
+                is2series = true;
+                break;
+
+            default:    /* All USB1 devices fall through here */
+                num_ports = num_bulk_out;
+                break;
+        }
+        
 	serial = get_free_serial(num_ports, &minor);
 	if (serial == NULL) {
 		err("No more free serial devices");
@@ -605,10 +700,12 @@ static int serqt_probe(struct usb_interface *interface,
 
 	}
 
-	/* For us numb of bulkin  or out = number of ports */
+	/* For USB1 number of bulkin or out = number of ports, for
+        * USB2, 1 in and 1 out, but serial->num_ports is set to number of
+         * ports either way */
 	mydbg("%s - setting up %d port structures for this device\n",
-	      __func__, num_bulk_in);
-	for (i = 0; i < num_bulk_in; ++i) {
+              __func__, serial->num_ports);
+        for (i = 0; i < serial->num_ports; ++i) {
 		port = &serial->port[i];
 		port->number = i + serial->minor;
 		port->serial = serial;
@@ -616,104 +713,38 @@ static int serqt_probe(struct usb_interface *interface,
 		INIT_WORK(&port->work, port_softint);
 
 		init_MUTEX(&port->sem);
-
-	}
-	status = box_get_device(serial, &DeviceData);
-	if (status < 0) {
-		mydbg(__FILE__ "box_get_device failed");
-		goto probe_error;
-	}
-
-	mydbg(__FILE__ "DeviceData.portb = 0x%x", DeviceData.portb);
-
-	DeviceData.portb &= ~FULLPWRBIT;
-	mydbg(__FILE__ "Changing DeviceData.portb to 0x%x", DeviceData.portb);
-
-	status = box_set_device(serial, &DeviceData);
-	if (status < 0) {
-		mydbg(__FILE__ "box_set_device failed\n");
-		goto probe_error;
-	}
+                init_MUTEX (&port->pend_xmit_sem);  /* USB2 */
+	}
+        /* Turn the unit on ready for use */
+        if (is2series == true ) {
+                status = qt2_poweron(serial); /* switch it on (USB2) */
+                if (status < 0 )
+                        goto probe_error;
+        } else {
+                status = qt1_poweron(serial); /* switch it on (USB1) */
+                if (status < 0 )
+                        goto probe_error;
+        }
 
 	/* initialize the devfs nodes for this device and let the user know what ports we are bound to */
 	for (i = 0; i < serial->num_ports; ++i) {
-		dev_info(&interface->dev,
+                dev_info(&interface->dev,
 			 "Converter now attached to ttyUSB%d (or usb/tts/%d for devfs)",
 			 serial->port[i].number, serial->port[i].number);
 	}
 
 	/* usb_serial_console_init (debug, minor); */
 
-	/***********TAG add start next board here ****/
-	status = box_get_device(serial, &DeviceData);
-	if (status < 0) {
-		mydbg(__FILE__ "box_get_device failed");
-		goto probe_error;
-	}
-	/*
-	 * and before we power up lets initialiaze parnent device stuff here before
-	 * we set thmem via any other method such as the property pages
-	 */
-	switch (serial->product) {
-	case DEVICE_ID_QUATECH_RS232_SINGLE_PORT:
-	case DEVICE_ID_QUATECH_RS232_DUAL_PORT:
-	case DEVICE_ID_QUATECH_RS232_FOUR_PORT:
-	case DEVICE_ID_QUATECH_RS232_EIGHT_PORT_A:
-	case DEVICE_ID_QUATECH_RS232_EIGHT_PORT_B:
-	case DEVICE_ID_QUATECH_RS232_16_PORT_A:
-	case DEVICE_ID_QUATECH_RS232_16_PORT_B:
-	case DEVICE_ID_QUATECH_RS232_16_PORT_C:
-	case DEVICE_ID_QUATECH_RS232_16_PORT_D:
-		DeviceData.porta &= ~(RR_BITS | DUPMODE_BITS);
-		DeviceData.porta |= CLKS_X4;
-		DeviceData.portb &= ~(LOOPMODE_BITS);
-		DeviceData.portb |= RS232_MODE;
-		break;
-
-	case DEVICE_ID_QUATECH_RS422_SINGLE_PORT:
-	case DEVICE_ID_QUATECH_RS422_DUAL_PORT:
-	case DEVICE_ID_QUATECH_RS422_FOUR_PORT:
-	case DEVICE_ID_QUATECH_RS422_EIGHT_PORT_A:
-	case DEVICE_ID_QUATECH_RS422_EIGHT_PORT_B:
-	case DEVICE_ID_QUATECH_RS422_16_PORT_A:
-	case DEVICE_ID_QUATECH_RS422_16_PORT_B:
-	case DEVICE_ID_QUATECH_RS422_16_PORT_C:
-	case DEVICE_ID_QUATECH_RS422_16_PORT_D:
-		DeviceData.porta &= ~(RR_BITS | DUPMODE_BITS);
-		DeviceData.porta |= CLKS_X4;
-		DeviceData.portb &= ~(LOOPMODE_BITS);
-		DeviceData.portb |= ALL_LOOPBACK;
-		break;
-	default:
-		DeviceData.porta &= ~(RR_BITS | DUPMODE_BITS);
-		DeviceData.porta |= CLKS_X4;
-		DeviceData.portb &= ~(LOOPMODE_BITS);
-		DeviceData.portb |= RS232_MODE;
-		break;
-
-	}
-	status = BoxSetPrebufferLevel(serial);	/* sets to default vaue */
-	if (status < 0) {
-		mydbg(__FILE__ "BoxSetPrebufferLevel failed\n");
-		goto probe_error;
-	}
-
-	status = BoxSetATC(serial, ATC_DISABLED);
-	if (status < 0) {
-		mydbg(__FILE__ "BoxSetATC failed\n");
-		goto probe_error;
-	}
-	/**********************************************************/
-	mydbg(__FILE__ "DeviceData.portb = 0x%x", DeviceData.portb);
-
-	DeviceData.portb |= NEXT_BOARD_POWER_BIT;
-	mydbg(__FILE__ "Changing DeviceData.portb to 0x%x", DeviceData.portb);
-
-	status = box_set_device(serial, &DeviceData);
-	if (status < 0) {
-		mydbg(__FILE__ "box_set_device failed\n");
-		goto probe_error;
-	}
+        /* pre-configure the ports to some sane starting values */
+        if (is2series == true ) {
+                status = qt2_precon(serial); /* preconfigure USB2 unit */
+                if (status < 0 )
+                        goto probe_error;
+        } else {
+                status = qt1_precon(serial); /* preconfigure USB1 unit */
+                if (status < 0 )
+                        goto probe_error;
+        }
 
 	mydbg("Exit Success %s\n", __func__);
 
@@ -739,6 +770,17 @@ probe_error:
 		kfree(port->interrupt_in_buffer);
 	}
 
+        for (i = 0; i < serial->num_ports; ++i)
+        {
+            if (port->xfer_to_tty_buffer)
+                kfree (port->xfer_to_tty_buffer);
+            if (port->write_urb)
+                usb_free_urb (port->write_urb);
+            if (port->bulk_out_buffer)
+                kfree (port->bulk_out_buffer);
+
+        }
+        
 	/* return the minor range that this device had */
 	return_serial(serial);
 	mydbg("Exit fail %s\n", __func__);
@@ -991,6 +1033,17 @@ static void ProcessRxChar(struct usb_serial_port *port, unsigned char Data)
 	return;
 }
 
+/* From USB2 driver */
+/*static void ProcessRcvFlush(struct usb_serial_port *port)
+{
+        port->Rcv_Flush = true;
+}
+static void ProcessXmitFlush(struct usb_serial_port *port)
+{
+        port->Xmit_Flush = true;
+}*/
+/* end from USB2 driver */
+
 static void ProcessLineStatus(struct usb_serial_port *port,
 			      unsigned char line_status)
 {
@@ -1010,6 +1063,29 @@ static void ProcessModemStatus(struct usb_serial_port *port,
 	return;
 }
 
+/* from USB2 driver */
+/*static void ProcessPortChange(struct usb_serial_port *port, unsigned char New_Current_Port)
+{
+        struct usb_serial *serial;
+        serial = port->serial;
+        serial->Current_Port = &serial->port[New_Current_Port];
+     //schedule_work(&port->work);
+        return;
+}
+*/
+
+/*static void ProcessXmitEmpty(struct usb_serial_port *port, unsigned char fourth_char, unsigned char fifth_char)
+{
+        int byte_count;
+
+        byte_count = (int)(fifth_char * 16);
+        byte_count +=  (int)fourth_char;
+
+        port->xmit_pending_bytes -= (int)byte_count;
+        port->xmit_fifo_room_bytes = FIFO_DEPTH;
+}*/
+/* end USB2 driver */
+
 static void serqt_usb_disconnect(struct usb_interface *interface)
 {
 	struct usb_serial *serial = usb_get_intfdata(interface);
@@ -1025,6 +1101,11 @@ static void serqt_usb_disconnect(struct usb_interface *interface)
 		for (i = 0; i < serial->num_ports; ++i)
 			serial->port[i].open_count = 0;
 
+                /* USB2 usb_unlink_urb (serial->read_urb);
+                usb_free_urb (serial->read_urb);
+                if (serial->bulk_in_buffer)
+                        kfree (serial->bulk_in_buffer);*/
+
 		for (i = 0; i < serial->num_bulk_in; ++i) {
 			port = &serial->port[i];
 			usb_unlink_urb(port->read_urb);
@@ -1043,7 +1124,16 @@ static void serqt_usb_disconnect(struct usb_interface *interface)
 			usb_free_urb(port->interrupt_in_urb);
 			kfree(port->interrupt_in_buffer);
 	}
-
+                for (i = 0; i < serial->num_ports; ++i) {
+                        port = &serial->port[i];
+                        if (port->write_urb)
+                        {
+                                usb_unlink_urb (port->write_urb);
+                                usb_free_urb (port->write_urb);
+                        }
+                        if (port->bulk_out_buffer)
+                                kfree (port->bulk_out_buffer);
+                }
 		/* return the minor range that this device had */
 		return_serial(serial);
 
@@ -1053,7 +1143,7 @@ static void serqt_usb_disconnect(struct usb_interface *interface)
 	} else {
 		dev_info(&interface->dev, "device disconnected");
 	}
-
+        mydbg ("%s exit \n", __FUNCTION__);
 }
 
 static struct usb_serial *get_serial_by_minor(unsigned int minor)
@@ -2648,6 +2738,151 @@ static void __exit serqt_usb_exit(void)
 	unregister_chrdev(major_number, "SerialQT_USB");
 }
 
+/* Helper functions factored out from elsewhere in the code for understanding */
+
+/* Turn the power on for USB1 series devices (factored out out probe function).
+ * Returns 0 for sucess and -EIO on error*/
+int qt1_poweron(struct usb_serial *serial)
+{
+        int status;
+        struct qt_get_device_data DeviceData;
+        status = box_get_device(serial, &DeviceData);
+        if (status < 0) {
+            mydbg(__FILE__ "box_get_device failed");
+            return -EIO;
+        }
+        mydbg(__FILE__ "DeviceData.portb = 0x%x", DeviceData.portb);
+
+        DeviceData.portb &= ~FULLPWRBIT;
+        mydbg(__FILE__ "Changing DeviceData.portb to 0x%x", DeviceData.portb);
+
+        status = box_set_device(serial, &DeviceData);
+        if (status < 0) {
+            mydbg(__FILE__ "box_set_device failed\n");
+            return -EIO;
+        }
+        return 0;
+}
+
+/* Turn on power for USB2 devices (formerly known as BoxSetDevice() in USB2 driver)
+ * Monumental black magic here, hopefully it works */
+int qt2_poweron(struct usb_serial *serial)
+{
+        int result;
+        __u8  Direcion = USBD_TRANSFER_DIRECTION_OUT;
+        unsigned int pipe;
+        pipe = usb_rcvctrlpipe(serial->dev, 0);
+        result = usb_control_msg (serial->dev, pipe, QT_SET_GET_DEVICE,
+                                  Direcion, 0x8000, 0x00, NULL, 0x00, 5000);
+        return result;
+}
+/* default configuration of USB1 device ports */
+int qt1_precon(struct usb_serial *serial)
+{
+        int status;
+        struct qt_get_device_data DeviceData;
+        
+        status = box_get_device(serial, &DeviceData);
+        if (status < 0) {
+                mydbg(__FILE__ "box_get_device failed");
+                return -EIO;
+        }
+
+        switch (serial->product) {
+        /* USB1 RS232 devices */
+        case DEVICE_ID_QUATECH_RS232_SINGLE_PORT:
+        case DEVICE_ID_QUATECH_RS232_DUAL_PORT:
+        case DEVICE_ID_QUATECH_RS232_FOUR_PORT:
+        case DEVICE_ID_QUATECH_RS232_EIGHT_PORT_A:
+        case DEVICE_ID_QUATECH_RS232_EIGHT_PORT_B:
+        case DEVICE_ID_QUATECH_RS232_16_PORT_A:
+        case DEVICE_ID_QUATECH_RS232_16_PORT_B:
+        case DEVICE_ID_QUATECH_RS232_16_PORT_C:
+        case DEVICE_ID_QUATECH_RS232_16_PORT_D:
+                DeviceData.porta &= ~(RR_BITS | DUPMODE_BITS);
+                DeviceData.porta |= CLKS_X4;
+                DeviceData.portb &= ~(LOOPMODE_BITS);
+                DeviceData.portb |= RS232_MODE;
+                break;
+        /* USB1 RS422 devices */
+        case DEVICE_ID_QUATECH_RS422_SINGLE_PORT:
+        case DEVICE_ID_QUATECH_RS422_DUAL_PORT:
+        case DEVICE_ID_QUATECH_RS422_FOUR_PORT:
+        case DEVICE_ID_QUATECH_RS422_EIGHT_PORT_A:
+        case DEVICE_ID_QUATECH_RS422_EIGHT_PORT_B:
+        case DEVICE_ID_QUATECH_RS422_16_PORT_A:
+        case DEVICE_ID_QUATECH_RS422_16_PORT_B:
+        case DEVICE_ID_QUATECH_RS422_16_PORT_C:
+        case DEVICE_ID_QUATECH_RS422_16_PORT_D:
+                DeviceData.porta &= ~(RR_BITS | DUPMODE_BITS);
+                DeviceData.porta |= CLKS_X4;
+                DeviceData.portb &= ~(LOOPMODE_BITS);
+                DeviceData.portb |= ALL_LOOPBACK;
+                break;
+        default:
+                DeviceData.porta &= ~(RR_BITS | DUPMODE_BITS);
+                DeviceData.porta |= CLKS_X4;
+                DeviceData.portb &= ~(LOOPMODE_BITS);
+                DeviceData.portb |= RS232_MODE;
+                break;
+        }
+        status = BoxSetPrebufferLevel(serial);  /* sets to default vaue */
+        if (status < 0) {
+                mydbg(__FILE__ "BoxSetPrebufferLevel failed\n");
+                return -EIO;
+        }
+
+        status = BoxSetATC(serial, ATC_DISABLED);
+        if (status < 0) {
+                mydbg(__FILE__ "BoxSetATC failed\n");
+                return -EIO;
+        }
+        /**********************************************************/
+        mydbg(__FILE__ "DeviceData.portb = 0x%x", DeviceData.portb);
+
+        DeviceData.portb |= NEXT_BOARD_POWER_BIT;
+        mydbg(__FILE__ "Changing DeviceData.portb to 0x%x", DeviceData.portb);
+
+        status = box_set_device(serial, &DeviceData);
+        if (status < 0) {
+                mydbg(__FILE__ "box_set_device failed\n");
+                return -EIO;
+        }
+        return 0;
+}
+
+/* default configuration of USB2 device ports */
+int qt2_precon(struct usb_serial *serial)
+{
+        int i;
+        for (i = 0; i < serial->num_ports; ++i)
+        {
+                if (BoxSetQMCR(serial, i,0x40) < 0)//set default value to RS232
+                        mydbg("Error in BoxSetQMCR() for port %d", i);
+        }
+        return 0;
+}
+
+/****************************************************************************
+ * BoxSetQMCR
+ *      issuse a QT_GET_SET_QMCR vendor-spcific request on the default control pipe
+ *      If successful returns the number of bytes written, otherwise it returns
+ *      a negative error number of the problem.
+ ****************************************************************************/
+static int BoxSetQMCR(struct usb_serial *serial, __u16 Uart_Number,__u8 QMCR_Value)
+{
+        int result;
+        __u16 PortSettings;
+
+        PortSettings = (__u16)(QMCR_Value);
+
+        mydbg("%s - PortSettings = 0x%x\n", __FUNCTION__, PortSettings);
+
+        result = usb_control_msg (serial->dev, usb_sndctrlpipe(serial->dev, 0), QT_GET_SET_QMCR,
+                                  0x40, PortSettings, (__u16)Uart_Number, NULL, 0, 5000);
+
+        return result;
+}
 module_init(serqt_usb_init);
 module_exit(serqt_usb_exit);


