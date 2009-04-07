Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbZDGOup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbZDGOup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbZDGOuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:50:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34153 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757534AbZDGOuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:50:00 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 03/11] serqt: initial clean up pass for tty side
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Apr 2009 16:48:27 +0100
Message-ID: <20090407154825.18020.44912.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk>
References: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid using port->tty where possible (makes refcount fixing easier later)
Remove unused code (the ioctl path is not used if the device has mget/mset
functions)
Remove various un-needed typecasts and long names so it could read it to do the
changes

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/staging/serqt_usb/serqt_usb.c |  449 ++++++++++++---------------------
 1 files changed, 163 insertions(+), 286 deletions(-)


diff --git a/drivers/staging/serqt_usb/serqt_usb.c b/drivers/staging/serqt_usb/serqt_usb.c
index 1781510..234f332 100644
--- a/drivers/staging/serqt_usb/serqt_usb.c
+++ b/drivers/staging/serqt_usb/serqt_usb.c
@@ -289,7 +289,8 @@ static void serial_unthrottle(struct tty_struct *tty);
 static int serial_break(struct tty_struct *tty, int break_state);
 static int serial_chars_in_buffer(struct tty_struct *tty);
 
-static int qt_open(struct usb_serial_port *port, struct file *filp);
+static int qt_open(struct tty_struct *tty, struct usb_serial_port *port,
+				struct file *filp);
 static int BoxSetPrebufferLevel(struct usb_serial *serial);
 
 static int BoxSetATC(struct usb_serial *serial, __u16 n_Mode);
@@ -300,24 +301,26 @@ static int BoxSetUart(struct usb_serial *serial, unsigned short Uart_Number,
 static int BoxOPenCloseChannel(struct usb_serial *serial, __u16 Uart_Number,
 			       __u16 OpenClose,
 			       struct qt_open_channel_data *pDeviceData);
-static void qt_close(struct usb_serial_port *port, struct file *filp);
+static void qt_close(struct tty_struct *tty, struct usb_serial_port *port,
+					struct file *filp);
 static int BoxGetRegister(struct usb_serial *serial, unsigned short Uart_Number,
 			  unsigned short Register_Num, __u8 *pValue);
 static int BoxSetRegister(struct usb_serial *serial, unsigned short Uart_Number,
 			  unsigned short Register_Num, unsigned short Value);
 static void qt_write_bulk_callback(struct urb *urb);
-static int qt_write(struct usb_serial_port *port, int from_user,
+static int qt_write(struct tty_struct *tty, struct usb_serial_port *port,
 		    const unsigned char *buf, int count);
 static void port_softint(struct work_struct *work);
 static int qt_write_room(struct usb_serial_port *port);
 static int qt_chars_in_buffer(struct usb_serial_port *port);
-static int qt_ioctl(struct usb_serial_port *port, struct file *file,
-		    unsigned int cmd, unsigned long arg);
-static void qt_set_termios(struct usb_serial_port *port,
+static int qt_ioctl(struct tty_struct *tty, struct usb_serial_port *port,
+		struct file *file, unsigned int cmd, unsigned long arg);
+static void qt_set_termios(struct tty_struct *tty,
+			   struct usb_serial_port *port,
 			   struct ktermios *old_termios);
-static int BoxSetHW_FlowCtrl(struct usb_serial *serial, unsigned int UartNumber,
+static int BoxSetHW_FlowCtrl(struct usb_serial *serial, unsigned int index,
 			     int bSet);
-static int BoxDisable_SW_FlowCtrl(struct usb_serial *serial, __u16 UartNumber);
+static int BoxDisable_SW_FlowCtrl(struct usb_serial *serial, __u16 index);
 static int EmulateWriteQMCR_Reg(int index, unsigned uc_value);
 static int EmulateReadQMCR_Reg(int index, unsigned *uc_value);
 static struct usb_serial *find_the_box(unsigned int index);
@@ -336,10 +339,11 @@ static int serial_tiocmset(struct tty_struct *tty, struct file *file,
 			   unsigned int set, unsigned int clear);
 static int serial_tiocmget(struct tty_struct *tty, struct file *file);
 
-static int qt_tiocmset(struct usb_serial_port *port, struct file *file,
-		       unsigned int value);
+static int qt_tiocmset(struct tty_struct *tty, struct usb_serial_port *port,
+		       struct file *file, unsigned int value);
 
-static int qt_tiocmget(struct usb_serial_port *port, struct file *file);
+static int qt_tiocmget(struct tty_struct *tty, struct usb_serial_port *port,
+							struct file *file);
 
 /* Version Information */
 #define DRIVER_VERSION "v2.14"
@@ -818,7 +822,7 @@ static struct usb_serial *get_free_serial(int num_ports, int *minor)
 	return NULL;
 }
 
-static int flip_that(struct tty_struct *tty, __u16 UartNumber,
+static int flip_that(struct tty_struct *tty, __u16 index,
 		     struct usb_serial *serial)
 {
 	tty_flip_buffer_push(tty);
@@ -829,18 +833,18 @@ static int flip_that(struct tty_struct *tty, __u16 UartNumber,
 /* Handles processing and moving data to the tty layer */
 static void port_sofrint(void *private)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)private;
+	struct usb_serial_port *port = private;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	struct tty_struct *tty = port->tty;
 	unsigned char *data = port->read_urb->transfer_buffer;
-	unsigned int UartNumber;
+	unsigned int index;
 	struct urb *urb = port->read_urb;
 	unsigned int RxCount = urb->actual_length;
 	int i, result;
 	int flag, flag_data;
 
-	/* UartNumber = MINOR(port->tty->device) - serial->minor; */
-	UartNumber = tty->index - serial->minor;
+	/* index = MINOR(port->tty->device) - serial->minor; */
+	index = tty->index - serial->minor;
 
 	mydbg("%s - port %d\n", __func__, port->number);
 	mydbg("%s - port->RxHolding = %d\n", __func__, port->RxHolding);
@@ -948,7 +952,7 @@ static void port_sofrint(void *private)
 		      __func__, result);
 	else {
 		if (tty && RxCount)
-			flip_that(tty, UartNumber, serial);
+			flip_that(tty, index, serial);
 	}
 
 	return;
@@ -1097,7 +1101,7 @@ static int serial_open(struct tty_struct *tty, struct file *filp)
 		port->RxHolding = 0;
 		mydbg("%s port->RxHolding = 0\n", __func__);
 
-		retval = qt_open(port, filp);
+		retval = qt_open(tty, port, filp);
 	}
 
 	if (retval)
@@ -1112,11 +1116,12 @@ static int serial_open(struct tty_struct *tty, struct file *filp)
 /*****************************************************************************
  *device's specific driver functions
  *****************************************************************************/
-static int qt_open(struct usb_serial_port *port, struct file *filp)
+static int qt_open(struct tty_struct *tty, struct usb_serial_port *port,
+					struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
 	int result = 0;
-	unsigned int UartNumber;
+	unsigned int index;
 	struct qt_get_device_data DeviceData;
 	struct qt_open_channel_data ChannelData;
 	unsigned short default_divisor = 0x30;		/* gives 9600 baud rate */
@@ -1128,13 +1133,7 @@ static int qt_open(struct usb_serial_port *port, struct file *filp)
 
 	mydbg("%s - port %d\n", __func__, port->number);
 
-	/* force low_latency on so that our tty_push actually forces the data through,
-	   otherwise it is scheduled, and with high data rates (like with OHCI) data
-	   can get lost. */
-	if (port->tty)
-		port->tty->low_latency = 0;
-
-	UartNumber = port->tty->index - serial->minor;
+	index = tty->index - serial->minor;
 
 	status = box_get_device(serial, &DeviceData);
 	if (status < 0) {
@@ -1147,7 +1146,7 @@ static int qt_open(struct usb_serial_port *port, struct file *filp)
 	/* Open uart channel */
 
 	/* Port specific setups */
-	status = BoxOPenCloseChannel(serial, UartNumber, 1, &ChannelData);
+	status = BoxOPenCloseChannel(serial, index, 1, &ChannelData);
 	if (status < 0) {
 		mydbg(__FILE__ "BoxOPenCloseChannel failed\n");
 		return status;
@@ -1161,7 +1160,7 @@ static int qt_open(struct usb_serial_port *port, struct file *filp)
 	    (SERIAL_MSR_CTS | SERIAL_MSR_DSR | SERIAL_MSR_RI | SERIAL_MSR_CD);
 
 	/* Set Baud rate to default and turn off (default)flow control here */
-	status = BoxSetUart(serial, UartNumber, default_divisor, default_LCR);
+	status = BoxSetUart(serial, index, default_divisor, default_LCR);
 	if (status < 0) {
 		mydbg(__FILE__ "BoxSetUart failed\n");
 		return status;
@@ -1169,7 +1168,7 @@ static int qt_open(struct usb_serial_port *port, struct file *filp)
 	mydbg(__FILE__ "BoxSetUart completed.\n");
 
 	/* Put this here to make it responsive to stty and defauls set by the tty layer */
-	qt_set_termios(port, NULL);
+	qt_set_termios(tty, port, NULL);
 
 	/* Initialize the wait que head */
 	init_waitqueue_head(&(port->wait));
@@ -1203,7 +1202,7 @@ static int qt_open(struct usb_serial_port *port, struct file *filp)
 static void serial_close(struct tty_struct *tty, struct file *filp)
 {
 	struct usb_serial_port *port =
-	    (struct usb_serial_port *)tty->driver_data;
+	    tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 
 	if (!serial)
@@ -1226,7 +1225,7 @@ static void serial_close(struct tty_struct *tty, struct file *filp)
 			mydbg("%s - port->closePending = 1\n", __func__);
 
 			if (serial->dev) {
-				qt_close(port, filp);
+				qt_close(tty, port, filp);
 				port->open_count = 0;
 			}
 		}
@@ -1240,20 +1239,21 @@ exit:
 
 }
 
-static void qt_close(struct usb_serial_port *port, struct file *filp)
+static void qt_close(struct tty_struct *tty, struct usb_serial_port *port,
+							struct file *filp)
 {
 	unsigned long jift = jiffies + 10 * HZ;
-	__u8 LSR_Value, MCR_Value;
+	u8 lsr, mcr;
 	struct usb_serial *serial = port->serial;
 	int status;
-	unsigned int UartNumber;
+	unsigned int index;
 
 	struct qt_open_channel_data ChannelData;
 	status = 0;
-	LSR_Value = 0;
+	lsr = 0;
 
 	mydbg("%s - port %d\n", __func__, port->number);
-	UartNumber = port->tty->index - serial->minor;
+	index = tty->index - serial->minor;
 
 	/* shutdown any bulk reads that might be going on */
 	if (serial->num_bulk_out)
@@ -1263,20 +1263,19 @@ static void qt_close(struct usb_serial_port *port, struct file *filp)
 
 	/* wait up to 30 seconds for transmitter to empty */
 	do {
-		status = BoxGetRegister(serial, UartNumber, LINE_STATUS_REGISTER, &LSR_Value);
+		status = BoxGetRegister(serial, index, LINE_STATUS_REGISTER, &lsr);
 		if (status < 0) {
 			mydbg(__FILE__ "box_get_device failed\n");
 			break;
 		}
 
-		if ((LSR_Value & SERIAL_LSR_TEMT)
+		if ((lsr & SERIAL_LSR_TEMT)
 		    && (port->ReadBulkStopped == 1))
 			break;
 		schedule();
 
 	}
-	while (jiffies <= jift)
-		;
+	while (jiffies <= jift);
 
 	if (jiffies > jift)
 		mydbg("%s - port %d timout of checking transmitter empty\n",
@@ -1286,17 +1285,17 @@ static void qt_close(struct usb_serial_port *port, struct file *filp)
 		      __func__, port->number);
 
 	status =
-	    BoxGetRegister(serial, UartNumber, MODEM_CONTROL_REGISTER,
-			   &MCR_Value);
-	mydbg(__FILE__ "BoxGetRegister MCR = 0x%x.\n", MCR_Value);
+	    BoxGetRegister(serial, index, MODEM_CONTROL_REGISTER,
+			   &mcr);
+	mydbg(__FILE__ "BoxGetRegister MCR = 0x%x.\n", mcr);
 
 	if (status >= 0) {
-		MCR_Value &= ~(SERIAL_MCR_DTR | SERIAL_MCR_RTS);
-		/* status = BoxSetRegister(serial, UartNumber, MODEM_CONTROL_REGISTER, MCR_Value); */
+		mcr &= ~(SERIAL_MCR_DTR | SERIAL_MCR_RTS);
+		/* status = BoxSetRegister(serial, index, MODEM_CONTROL_REGISTER, mcr); */
 	}
 
 	/* Close uart channel */
-	status = BoxOPenCloseChannel(serial, UartNumber, 0, &ChannelData);
+	status = BoxOPenCloseChannel(serial, index, 0, &ChannelData);
 	if (status < 0)
 		mydbg("%s - port %d BoxOPenCloseChannel failed.\n",
 		      __func__, port->number);
@@ -1308,12 +1307,10 @@ static void qt_close(struct usb_serial_port *port, struct file *filp)
 static int serial_write(struct tty_struct *tty, const unsigned char *buf,
 			int count)
 {
-	struct usb_serial_port *port =
-	    (struct usb_serial_port *)tty->driver_data;
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial;
 	int retval = -EINVAL;
-	unsigned int UartNumber;
-	int from_user = 0;
+	unsigned int index;
 
 	serial = get_usb_serial(port, __func__);
 	if (serial == NULL)
@@ -1321,7 +1318,7 @@ static int serial_write(struct tty_struct *tty, const unsigned char *buf,
 	/* This can happen if we get disconnected a */
 	if (port->open_count == 0)
 		return -ENODEV;
-	UartNumber = port->tty->index - serial->minor;
+	index = tty->index - serial->minor;
 
 	mydbg("%s - port %d, %d byte(s)\n", __func__, port->number, count);
 	mydbg("%s - port->RxHolding =  %d\n", __func__, port->RxHolding);
@@ -1331,19 +1328,19 @@ static int serial_write(struct tty_struct *tty, const unsigned char *buf,
 		goto exit;
 	}
 
-	retval = qt_write(port, from_user, buf, count);
+	retval = qt_write(tty, port, buf, count);
 
 exit:
 	return retval;
 }
 
-static int qt_write(struct usb_serial_port *port, int from_user,
-		    const unsigned char *buf, int count)
+static int qt_write(struct tty_struct *tty, struct usb_serial_port *port,
+				const unsigned char *buf, int count)
 {
 	int result;
-	unsigned int UartNumber;
-
+	unsigned int index;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
+
 	if (serial == NULL)
 		return -ENODEV;
 
@@ -1354,7 +1351,7 @@ static int qt_write(struct usb_serial_port *port, int from_user,
 		return 0;
 	}
 
-	UartNumber = port->tty->index - serial->minor;
+	index = tty->index - serial->minor;
 	/* only do something if we have a bulk out endpoint */
 	if (serial->num_bulk_out) {
 		if (port->write_urb->status == -EINPROGRESS) {
@@ -1364,14 +1361,7 @@ static int qt_write(struct usb_serial_port *port, int from_user,
 
 		count =
 		    (count > port->bulk_out_size) ? port->bulk_out_size : count;
-
-		if (from_user) {
-			if (copy_from_user
-			    (port->write_urb->transfer_buffer, buf, count))
-				return -EFAULT;
-		} else {
-			memcpy(port->write_urb->transfer_buffer, buf, count);
-		}
+		memcpy(port->write_urb->transfer_buffer, buf, count);
 
 		/* usb_serial_debug_data(__FILE__, __func__, count, port->write_urb->transfer_buffer); */
 
@@ -1449,8 +1439,7 @@ static void port_softint(struct work_struct *work)
 }
 static int serial_write_room(struct tty_struct *tty)
 {
-	struct usb_serial_port *port =
-	    (struct usb_serial_port *)tty->driver_data;
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	int retval = -EINVAL;
 
@@ -1493,8 +1482,7 @@ static int qt_write_room(struct usb_serial_port *port)
 }
 static int serial_chars_in_buffer(struct tty_struct *tty)
 {
-	struct usb_serial_port *port =
-	    (struct usb_serial_port *)tty->driver_data;
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	int retval = -EINVAL;
 
@@ -1537,17 +1525,16 @@ static int serial_tiocmset(struct tty_struct *tty, struct file *file,
 			   unsigned int set, unsigned int clear)
 {
 
-	struct usb_serial_port *port =
-	    (struct usb_serial_port *)tty->driver_data;
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	int retval = -ENODEV;
-	unsigned int UartNumber;
+	unsigned int index;
 	mydbg("In %s \n", __func__);
 
 	if (!serial)
 		return -ENODEV;
 
-	UartNumber = port->tty->index - serial->minor;
+	index = tty->index - serial->minor;
 
 	down(&port->sem);
 
@@ -1559,22 +1546,22 @@ static int serial_tiocmset(struct tty_struct *tty, struct file *file,
 		goto exit;
 	}
 
-	retval = qt_tiocmset(port, file, set);
+	retval = qt_tiocmset(tty, port, file, set);
 
 exit:
 	up(&port->sem);
 	return retval;
 }
 
-static int qt_tiocmset(struct usb_serial_port *port, struct file *file,
-		       unsigned int value)
+static int qt_tiocmset(struct tty_struct *tty, struct usb_serial_port *port,
+		       struct file *file, unsigned int value)
 {
 
-	__u8 MCR_Value;
+	u8 mcr;
 	int status;
-	unsigned int UartNumber;
-
+	unsigned int index;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
+
 	if (serial == NULL)
 		return -ENODEV;
 
@@ -1583,10 +1570,10 @@ static int qt_tiocmset(struct usb_serial_port *port, struct file *file,
     /**************************************************************************************/
     /**  TIOCMGET
      */
-	UartNumber = port->tty->index - serial->minor;
+	index = tty->index - serial->minor;
 	status =
-	    BoxGetRegister(port->serial, UartNumber, MODEM_CONTROL_REGISTER,
-			   &MCR_Value);
+	    BoxGetRegister(port->serial, index, MODEM_CONTROL_REGISTER,
+			   &mcr);
 	if (status < 0)
 		return -ESPIPE;
 
@@ -1594,17 +1581,17 @@ static int qt_tiocmset(struct usb_serial_port *port, struct file *file,
 	 * Turn off the RTS and DTR and loopbcck and then only turn on what was
 	 * asked for
 	 */
-	MCR_Value &= ~(SERIAL_MCR_RTS | SERIAL_MCR_DTR | SERIAL_MCR_LOOP);
+	mcr &= ~(SERIAL_MCR_RTS | SERIAL_MCR_DTR | SERIAL_MCR_LOOP);
 	if (value & TIOCM_RTS)
-		MCR_Value |= SERIAL_MCR_RTS;
+		mcr |= SERIAL_MCR_RTS;
 	if (value & TIOCM_DTR)
-		MCR_Value |= SERIAL_MCR_DTR;
+		mcr |= SERIAL_MCR_DTR;
 	if (value & TIOCM_LOOP)
-		MCR_Value |= SERIAL_MCR_LOOP;
+		mcr |= SERIAL_MCR_LOOP;
 
 	status =
-	    BoxSetRegister(port->serial, UartNumber, MODEM_CONTROL_REGISTER,
-			   MCR_Value);
+	    BoxSetRegister(port->serial, index, MODEM_CONTROL_REGISTER,
+			   mcr);
 	if (status < 0)
 		return -ESPIPE;
 	else
@@ -1614,18 +1601,16 @@ static int qt_tiocmset(struct usb_serial_port *port, struct file *file,
 static int serial_tiocmget(struct tty_struct *tty, struct file *file)
 {
 
-	struct usb_serial_port *port =
-	    (struct usb_serial_port *)tty->driver_data;
-
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	int retval = -ENODEV;
-	unsigned int UartNumber;
+	unsigned int index;
 	mydbg("In %s \n", __func__);
 
 	if (!serial)
 		return -ENODEV;
 
-	UartNumber = port->tty->index - serial->minor;
+	index = tty->index - serial->minor;
 
 	down(&port->sem);
 
@@ -1637,56 +1622,55 @@ static int serial_tiocmget(struct tty_struct *tty, struct file *file)
 		goto exit;
 	}
 
-	retval = qt_tiocmget(port, file);
+	retval = qt_tiocmget(tty, port, file);
 
 exit:
 	up(&port->sem);
 	return retval;
 }
 
-static int qt_tiocmget(struct usb_serial_port *port, struct file *file)
+static int qt_tiocmget(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *file)
 {
 
-	__u8 MCR_Value;
-	__u8 MSR_Value;
+	u8 mcr;
+	u8 msr;
 	unsigned int result = 0;
 	int status;
-	unsigned int UartNumber;
-	struct tty_struct *tty;
+	unsigned int index;
 
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	if (serial == NULL)
 		return -ENODEV;
-	tty = port->tty;
 
 	mydbg("%s - port %d, tty =0x%p\n", __func__, port->number, tty);
 
     /**************************************************************************************/
     /**  TIOCMGET
      */
-	UartNumber = port->tty->index - serial->minor;
+	index = tty->index - serial->minor;
 	status =
-	    BoxGetRegister(port->serial, UartNumber, MODEM_CONTROL_REGISTER,
-			   &MCR_Value);
+	    BoxGetRegister(port->serial, index, MODEM_CONTROL_REGISTER,
+			   &mcr);
 	if (status >= 0) {
 		status =
-		    BoxGetRegister(port->serial, UartNumber,
-				   MODEM_STATUS_REGISTER, &MSR_Value);
+		    BoxGetRegister(port->serial, index,
+				   MODEM_STATUS_REGISTER, &msr);
 
 	}
 
 	if (status >= 0) {
-		result = ((MCR_Value & SERIAL_MCR_DTR) ? TIOCM_DTR : 0)
+		result = ((mcr & SERIAL_MCR_DTR) ? TIOCM_DTR : 0)
 		    /* DTR IS SET */
-		    | ((MCR_Value & SERIAL_MCR_RTS) ? TIOCM_RTS : 0)
+		    | ((mcr & SERIAL_MCR_RTS) ? TIOCM_RTS : 0)
 		    /* RTS IS SET */
-		    | ((MSR_Value & SERIAL_MSR_CTS) ? TIOCM_CTS : 0)
+		    | ((msr & SERIAL_MSR_CTS) ? TIOCM_CTS : 0)
 		    /* CTS is set */
-		    | ((MSR_Value & SERIAL_MSR_CD) ? TIOCM_CAR : 0)
+		    | ((msr & SERIAL_MSR_CD) ? TIOCM_CAR : 0)
 		    /* Carrier detect is set */
-		    | ((MSR_Value & SERIAL_MSR_RI) ? TIOCM_RI : 0)
+		    | ((msr & SERIAL_MSR_RI) ? TIOCM_RI : 0)
 		    /* Ring indicator set */
-		    | ((MSR_Value & SERIAL_MSR_DSR) ? TIOCM_DSR : 0);
+		    | ((msr & SERIAL_MSR_DSR) ? TIOCM_DSR : 0);
 		/* DSR is set */
 		return result;
 
@@ -1698,17 +1682,16 @@ static int serial_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
 
-	struct usb_serial_port *port =
-	    (struct usb_serial_port *)tty->driver_data;
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	int retval = -ENODEV;
-	unsigned int UartNumber;
+	unsigned int index;
 	mydbg("In %s \n", __func__);
 
 	if (!serial)
 		return -ENODEV;
 
-	UartNumber = port->tty->index - serial->minor;
+	index = tty->index - serial->minor;
 
 	down(&port->sem);
 
@@ -1720,125 +1703,34 @@ static int serial_ioctl(struct tty_struct *tty, struct file *file,
 		goto exit;
 	}
 
-	retval = qt_ioctl(port, file, cmd, arg);
+	retval = qt_ioctl(tty, port, file, cmd, arg);
 
 exit:
 	up(&port->sem);
 	return retval;
 }
-static int qt_ioctl(struct usb_serial_port *port, struct file *file,
-		    unsigned int cmd, unsigned long arg)
+static int qt_ioctl(struct tty_struct *tty, struct usb_serial_port *port,
+			struct file *file, unsigned int cmd, unsigned long arg)
 {
-	__u8 MCR_Value;
-	__u8 MSR_Value;
-	unsigned short Prev_MSR_Value;
+	__u8 mcr;
+	__u8 msr;
+	unsigned short prev_msr;
 	unsigned int value, result = 0;
 	int status;
-	unsigned int UartNumber;
-	struct tty_struct *tty;
+	unsigned int index;
 
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	if (serial == NULL)
 		return -ENODEV;
-	tty = port->tty;
 
 	mydbg("%s - port %d, tty =0x%p\n", __func__, port->number, tty);
 
 	/* TIOCMGET */
-	UartNumber = port->tty->index - serial->minor;
-
-	if (cmd == TIOCMGET) {
-		MCR_Value = port->shadowMCR;
-		MSR_Value = port->shadowMSR;
-
-		{
-			result = ((MCR_Value & SERIAL_MCR_DTR) ? TIOCM_DTR : 0)
-			    /* DTR IS SET */
-			    | ((MCR_Value & SERIAL_MCR_RTS) ? TIOCM_RTS : 0)
-			    /* RTS IS SET */
-			    | ((MSR_Value & SERIAL_MSR_CTS) ? TIOCM_CTS : 0)
-			    /* CTS is set */
-			    | ((MSR_Value & SERIAL_MSR_CD) ? TIOCM_CAR : 0)
-			    /* Carrier detect is set */
-			    | ((MSR_Value & SERIAL_MSR_RI) ? TIOCM_RI : 0)
-			    /* Ring indicator set */
-			    | ((MSR_Value & SERIAL_MSR_DSR) ? TIOCM_DSR : 0);
-			/* DSR is set */
-			if (copy_to_user
-			    ((unsigned int *)arg, &result,
-			     sizeof(unsigned int)))
-				return -EFAULT;
-			return 0;
-
-		}
-	}
-
-	/* TIOCMBIS, TIOCMBIC, AND TIOCMSET */
-	if (cmd == TIOCMBIS || cmd == TIOCMBIC || cmd == TIOCMSET) {
-		status =
-		    BoxGetRegister(port->serial, UartNumber,
-				   MODEM_CONTROL_REGISTER, &MCR_Value);
-		if (status < 0)
-			return -ESPIPE;
-		if (copy_from_user
-		    (&value, (unsigned int *)arg, sizeof(unsigned int)))
-			return -EFAULT;
-
-		switch (cmd) {
-		case TIOCMBIS:
-			if (value & TIOCM_RTS)
-				MCR_Value |= SERIAL_MCR_RTS;
-			if (value & TIOCM_DTR)
-				MCR_Value |= SERIAL_MCR_DTR;
-			if (value & TIOCM_LOOP)
-				MCR_Value |= SERIAL_MCR_LOOP;
-			break;
-		case TIOCMBIC:
-			if (value & TIOCM_RTS)
-				MCR_Value &= ~SERIAL_MCR_RTS;
-			if (value & TIOCM_DTR)
-				MCR_Value &= ~SERIAL_MCR_DTR;
-			if (value & TIOCM_LOOP)
-				MCR_Value &= ~SERIAL_MCR_LOOP;
-			break;
-		case TIOCMSET:
-			/*
-			 * Turn off the RTS and DTR and loopbcck and then only
-			 * turn on what was asked for
-			 */
-			MCR_Value &=
-			    ~(SERIAL_MCR_RTS | SERIAL_MCR_DTR |
-			      SERIAL_MCR_LOOP);
-			if (value & TIOCM_RTS)
-				MCR_Value |= SERIAL_MCR_RTS;
-			if (value & TIOCM_DTR)
-				MCR_Value |= SERIAL_MCR_DTR;
-			if (value & TIOCM_LOOP)
-				MCR_Value |= SERIAL_MCR_LOOP;
-			break;
-		default:
-			break;
-
-		}
-		status =
-		    BoxSetRegister(port->serial, UartNumber,
-				   MODEM_CONTROL_REGISTER, MCR_Value);
-		if (status < 0)
-			return -ESPIPE;
-		else {
-			port->shadowMCR = MCR_Value;
-			return 0;
-		}
-
-	}
-    /**************************************************************************************/
-   /**   TIOCMBIS, TIOCMBIC, AND TIOCMSET    end
-   */
-    /**************************************************************************************/
+	index = tty->index - serial->minor;
 
 	if (cmd == TIOCMIWAIT) {
 		DECLARE_WAITQUEUE(wait, current);
-		Prev_MSR_Value = port->shadowMSR & SERIAL_MSR_MASK;
+		prev_msr = port->shadowMSR & SERIAL_MSR_MASK;
 		while (1) {
 			add_wait_queue(&port->wait, &wait);
 			set_current_state(TASK_INTERRUPTIBLE);
@@ -1847,22 +1739,22 @@ static int qt_ioctl(struct usb_serial_port *port, struct file *file,
 			/* see if a signal woke us up */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
-			MSR_Value = port->shadowMSR & SERIAL_MSR_MASK;
-			if (MSR_Value == Prev_MSR_Value)
+			msr = port->shadowMSR & SERIAL_MSR_MASK;
+			if (msr == prev_msr)
 				return -EIO;	/* no change error */
 
 			if ((arg & TIOCM_RNG
-			     && ((Prev_MSR_Value & SERIAL_MSR_RI) ==
-				 (MSR_Value & SERIAL_MSR_RI)))
+			     && ((prev_msr & SERIAL_MSR_RI) ==
+				 (msr & SERIAL_MSR_RI)))
 			    || (arg & TIOCM_DSR
-				&& ((Prev_MSR_Value & SERIAL_MSR_DSR) ==
-				    (MSR_Value & SERIAL_MSR_DSR)))
+				&& ((prev_msr & SERIAL_MSR_DSR) ==
+				    (msr & SERIAL_MSR_DSR)))
 			    || (arg & TIOCM_CD
-				&& ((Prev_MSR_Value & SERIAL_MSR_CD) ==
-				    (MSR_Value & SERIAL_MSR_CD)))
+				&& ((prev_msr & SERIAL_MSR_CD) ==
+				    (msr & SERIAL_MSR_CD)))
 			    || (arg & TIOCM_CTS
-				&& ((Prev_MSR_Value & SERIAL_MSR_CTS) ==
-				    (MSR_Value & SERIAL_MSR_CTS)))) {
+				&& ((prev_msr & SERIAL_MSR_CTS) ==
+				    (msr & SERIAL_MSR_CTS)))) {
 				return 0;
 			}
 
@@ -1878,7 +1770,7 @@ static int qt_ioctl(struct usb_serial_port *port, struct file *file,
 static void serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	struct usb_serial_port *port =
-	    (struct usb_serial_port *)tty->driver_data;
+	    tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 
 	if (!serial)
@@ -1894,22 +1786,22 @@ static void serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 	}
 
 	/* pass on to the driver specific version of this function if it is available */
-	qt_set_termios(port, old);
+	qt_set_termios(tty, port, old);
 
 exit:
 	up(&port->sem);
 }
 
-static void qt_set_termios(struct usb_serial_port *port,
+static void qt_set_termios(struct tty_struct *tty,
+			   struct usb_serial_port *port,
 			   struct ktermios *old_termios)
 {
 	unsigned int cflag;
 	int baud, divisor, remainder;
-	unsigned char LCR_change_to = 0;
-	struct tty_struct *tty;
+	unsigned char new_LCR = 0;
 	int status;
 	struct usb_serial *serial;
-	__u16 UartNumber;
+	__u16 index;
 	__u16 tmp, tmp2;
 
 	mydbg("%s - port %d\n", __func__, port->number);
@@ -1921,59 +1813,46 @@ static void qt_set_termios(struct usb_serial_port *port,
 	tmp2 = serial->minor;
 	mydbg("%s - serial->minor =  %d\n", __func__, tmp2);
 
-	UartNumber = port->tty->index - serial->minor;
-
-	tty = port->tty;
+	index = port->tty->index - serial->minor;
 
 	cflag = tty->termios->c_cflag;
 
-	if (old_termios) {
-		if ((cflag == old_termios->c_cflag)
-		    && (RELEVANT_IFLAG(tty->termios->c_iflag) ==
-			RELEVANT_IFLAG(old_termios->c_iflag))) {
-			mydbg("%s - Nothing to change\n", __func__);
-			return;
-		}
-
-	}
-
 	mydbg("%s - 3\n", __func__);
 
 	switch (cflag) {
 	case CS5:
-		LCR_change_to |= SERIAL_5_DATA;
+		new_LCR |= SERIAL_5_DATA;
 		break;
 	case CS6:
-		LCR_change_to |= SERIAL_6_DATA;
+		new_LCR |= SERIAL_6_DATA;
 		break;
 	case CS7:
-		LCR_change_to |= SERIAL_7_DATA;
+		new_LCR |= SERIAL_7_DATA;
 		break;
 	default:
 	case CS8:
-		LCR_change_to |= SERIAL_8_DATA;
+		new_LCR |= SERIAL_8_DATA;
 		break;
 	}
 
 	/* Parity stuff */
 	if (cflag & PARENB) {
 		if (cflag & PARODD)
-			LCR_change_to |= SERIAL_ODD_PARITY;
+			new_LCR |= SERIAL_ODD_PARITY;
 		else
-			LCR_change_to |= SERIAL_EVEN_PARITY;
+			new_LCR |= SERIAL_EVEN_PARITY;
 	}
 	if (cflag & CSTOPB)
-		LCR_change_to |= SERIAL_TWO_STOPB;
+		new_LCR |= SERIAL_TWO_STOPB;
 	else
-		LCR_change_to |= SERIAL_TWO_STOPB;
+		new_LCR |= SERIAL_TWO_STOPB;
 
 	mydbg("%s - 4\n", __func__);
 	/* Thats the LCR stuff, go ahead and set it */
 	baud = tty_get_baud_rate(tty);
-	if (!baud) {
+	if (!baud)
 		/* pick a default, any default... */
 		baud = 9600;
-	}
 
 	mydbg("%s - got baud = %d\n", __func__, baud);
 
@@ -1986,9 +1865,7 @@ static void qt_set_termios(struct usb_serial_port *port,
 	/*
 	 * Set Baud rate to default and turn off (default)flow control here
 	 */
-	status =
-	    BoxSetUart(serial, UartNumber, (unsigned short)divisor,
-		       LCR_change_to);
+	status = BoxSetUart(serial, index, (unsigned short)divisor, new_LCR);
 	if (status < 0) {
 		mydbg(__FILE__ "BoxSetUart failed\n");
 		return;
@@ -2000,7 +1877,7 @@ static void qt_set_termios(struct usb_serial_port *port,
 		      port->number);
 
 		/* Enable RTS/CTS flow control */
-		status = BoxSetHW_FlowCtrl(serial, UartNumber, 1);
+		status = BoxSetHW_FlowCtrl(serial, index, 1);
 
 		if (status < 0) {
 			mydbg(__FILE__ "BoxSetHW_FlowCtrl failed\n");
@@ -2011,7 +1888,7 @@ static void qt_set_termios(struct usb_serial_port *port,
 		mydbg("%s - disabling HW flow control port %d\n", __func__,
 		      port->number);
 
-		status = BoxSetHW_FlowCtrl(serial, UartNumber, 0);
+		status = BoxSetHW_FlowCtrl(serial, index, 0);
 		if (status < 0) {
 			mydbg(__FILE__ "BoxSetHW_FlowCtrl failed\n");
 			return;
@@ -2025,19 +1902,20 @@ static void qt_set_termios(struct usb_serial_port *port,
 		unsigned char stop_char = STOP_CHAR(tty);
 		unsigned char start_char = START_CHAR(tty);
 		status =
-		    BoxSetSW_FlowCtrl(serial, UartNumber, stop_char,
+		    BoxSetSW_FlowCtrl(serial, index, stop_char,
 				      start_char);
 		if (status < 0)
 			mydbg(__FILE__ "BoxSetSW_FlowCtrl (enabled) failed\n");
 
 	} else {
 		/* disable SW flow control */
-		status = BoxDisable_SW_FlowCtrl(serial, UartNumber);
+		status = BoxDisable_SW_FlowCtrl(serial, index);
 		if (status < 0)
 			mydbg(__FILE__ "BoxSetSW_FlowCtrl (diabling) failed\n");
 
 	}
-
+	tty->termios->c_cflag &= ~CMSPAR;
+	/* FIXME: Error cases should be returning the actual bits changed only */
 }
 
 /****************************************************************************
@@ -2237,11 +2115,11 @@ static int BoxSetUart(struct usb_serial *serial, unsigned short Uart_Number,
 	return result;
 }
 
-static int BoxSetHW_FlowCtrl(struct usb_serial *serial, unsigned int UartNumber,
+static int BoxSetHW_FlowCtrl(struct usb_serial *serial, unsigned int index,
 			     int bSet)
 {
-	__u8 MCR_Value = 0;
-	__u8 MSR_Value = 0, MOUT_Value = 0;
+	__u8 mcr = 0;
+	__u8 msr = 0, MOUT_Value = 0;
 	struct usb_serial_port *port;
 	unsigned int status;
 
@@ -2249,34 +2127,34 @@ static int BoxSetHW_FlowCtrl(struct usb_serial *serial, unsigned int UartNumber,
 
 	if (bSet == 1) {
 		/* flow control, box will clear RTS line to prevent remote */
-		MCR_Value = SERIAL_MCR_RTS;
+		mcr = SERIAL_MCR_RTS;
 	}			/* device from xmitting more chars */
 	else {
 		/* no flow control to remote device */
-		MCR_Value = 0;
+		mcr = 0;
 
 	}
-	MOUT_Value = MCR_Value << 8;
+	MOUT_Value = mcr << 8;
 
 	if (bSet == 1) {
 		/* flow control, box will inhibit xmit data if CTS line is
 		 * asserted */
-		MSR_Value = SERIAL_MSR_CTS;
+		msr = SERIAL_MSR_CTS;
 	} else {
 		/* Box will not inhimbe xmit data due to CTS line */
-		MSR_Value = 0;
+		msr = 0;
 	}
-	MOUT_Value |= MSR_Value;
+	MOUT_Value |= msr;
 
 	status =
 	    usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 			    QT_HW_FLOW_CONTROL_MASK, 0x40, MOUT_Value,
-			    UartNumber, NULL, 0, 300);
+			    index, NULL, 0, 300);
 	return status;
 
 }
 
-static int BoxSetSW_FlowCtrl(struct usb_serial *serial, __u16 UartNumber,
+static int BoxSetSW_FlowCtrl(struct usb_serial *serial, __u16 index,
 			     unsigned char stop_char, unsigned char start_char)
 {
 	__u16 nSWflowout;
@@ -2288,17 +2166,17 @@ static int BoxSetSW_FlowCtrl(struct usb_serial *serial, __u16 UartNumber,
 	result =
 	    usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 			    QT_SW_FLOW_CONTROL_MASK, 0x40, nSWflowout,
-			    UartNumber, NULL, 0, 300);
+			    index, NULL, 0, 300);
 	return result;
 
 }
-static int BoxDisable_SW_FlowCtrl(struct usb_serial *serial, __u16 UartNumber)
+static int BoxDisable_SW_FlowCtrl(struct usb_serial *serial, __u16 index)
 {
 	int result;
 
 	result =
 	    usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			    QT_SW_FLOW_CONTROL_DISABLE, 0x40, 0, UartNumber,
+			    QT_SW_FLOW_CONTROL_DISABLE, 0x40, 0, index,
 			    NULL, 0, 300);
 	return result;
 
@@ -2307,7 +2185,7 @@ static int BoxDisable_SW_FlowCtrl(struct usb_serial *serial, __u16 UartNumber)
 static void serial_throttle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port =
-	    (struct usb_serial_port *)tty->driver_data;
+	    tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	mydbg("%s - port %d\n", __func__, port->number);
 
@@ -2334,7 +2212,7 @@ exit:
 static void serial_unthrottle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port =
-	    (struct usb_serial_port *)tty->driver_data;
+	    tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	unsigned int result;
 
@@ -2380,20 +2258,19 @@ exit:
 
 static int serial_break(struct tty_struct *tty, int break_state)
 {
-	struct usb_serial_port *port =
-	    (struct usb_serial_port *)tty->driver_data;
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
-	__u16 UartNumber, Break_Value;
+	u16 index, onoff;
 	unsigned int result;
 
-	UartNumber = port->tty->index - serial->minor;
+	index = tty->index - serial->minor;
 	if (!serial)
 		return -ENODEV;
 
 	if (break_state == -1)
-		Break_Value = 1;
+		onoff = 1;
 	else
-		Break_Value = 0;
+		onoff = 0;
 
 	down(&port->sem);
 
@@ -2406,7 +2283,7 @@ static int serial_break(struct tty_struct *tty, int break_state)
 
 	result =
 	    usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			    QT_BREAK_CONTROL, 0x40, Break_Value, UartNumber,
+			    QT_BREAK_CONTROL, 0x40, onoff, index,
 			    NULL, 0, 300);
 
 exit:

