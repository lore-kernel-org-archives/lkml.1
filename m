Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbYFTUn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbYFTUn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762830AbYFTUYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:24:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58361 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762809AbYFTUYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:24:39 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 68/70] mos7840: remove loads of bogus assignments to status
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:07:14 +0100
Message-ID: <20080620200710.1479.59584.stgit@localhost.localdomain>
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

 drivers/usb/serial/mos7840.c |  400 +++++++++++++++++-------------------------
 1 files changed, 164 insertions(+), 236 deletions(-)


diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 2b1fded..09d8206 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -33,7 +33,7 @@
 #include <linux/serial.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 /*
  * Version Information
@@ -82,8 +82,8 @@
  * Defines used for sending commands to port
  */
 
-#define WAIT_FOR_EVER   (HZ * 0 )	/* timeout urb is wait for ever */
-#define MOS_WDR_TIMEOUT (HZ * 5 )	/* default urb timeout */
+#define WAIT_FOR_EVER   (HZ * 0)	/* timeout urb is wait for ever */
+#define MOS_WDR_TIMEOUT (HZ * 5)	/* default urb timeout */
 
 #define MOS_PORT1       0x0200
 #define MOS_PORT2       0x0300
@@ -102,8 +102,8 @@
 
 #define MAX_NAME_LEN    64
 
-#define ZLP_REG1  0x3A		//Zero_Flag_Reg1    58
-#define ZLP_REG5  0x3E		//Zero_Flag_Reg5    62
+#define ZLP_REG1  0x3A		/* Zero_Flag_Reg1    58 */
+#define ZLP_REG5  0x3E		/* Zero_Flag_Reg5    62 */
 
 /* For higher baud Rates use TIOCEXBAUD */
 #define TIOCEXBAUD     0x5462
@@ -142,7 +142,7 @@
 #define MOS_MSR_DELTA_RI    0x40
 #define MOS_MSR_DELTA_CD    0x80
 
-// Serial Port register Address
+/* Serial Port register Address */
 #define INTERRUPT_ENABLE_REGISTER  ((__u16)(0x01))
 #define FIFO_CONTROL_REGISTER      ((__u16)(0x02))
 #define LINE_CONTROL_REGISTER      ((__u16)(0x03))
@@ -201,11 +201,11 @@ struct moschip_port {
 	struct async_icount icount;
 	struct usb_serial_port *port;	/* loop back to the owner of this object */
 
-	/*Offsets */
+	/* Offsets */
 	__u8 SpRegOffset;
 	__u8 ControlRegOffset;
 	__u8 DcrRegOffset;
-	//for processing control URBS in interrupt context
+	/* for processing control URBS in interrupt context */
 	struct urb *control_urb;
 	struct usb_ctrlrequest *dr;
 	char *ctrl_buf;
@@ -244,7 +244,7 @@ static int mos7840_set_reg_sync(struct usb_serial_port *port, __u16 reg,
  */
 
 static int mos7840_get_reg_sync(struct usb_serial_port *port, __u16 reg,
-				__u16 * val)
+				__u16 *val)
 {
 	struct usb_device *dev = port->serial->dev;
 	int ret = 0;
@@ -269,16 +269,15 @@ static int mos7840_set_uart_reg(struct usb_serial_port *port, __u16 reg,
 
 	struct usb_device *dev = port->serial->dev;
 	val = val & 0x00ff;
-	// For the UART control registers, the application number need to be Or'ed
+	/* For the UART control registers, the application number need
+	   to be Or'ed */
 	if (port->serial->num_ports == 4) {
-		val |=
-		    (((__u16) port->number - (__u16) (port->serial->minor)) +
-		     1) << 8;
+		val |= (((__u16) port->number -
+				(__u16) (port->serial->minor)) + 1) << 8;
 		dbg("mos7840_set_uart_reg application number is %x\n", val);
 	} else {
 		if (((__u16) port->number - (__u16) (port->serial->minor)) == 0) {
-			val |=
-			    (((__u16) port->number -
+			val |= (((__u16) port->number -
 			      (__u16) (port->serial->minor)) + 1) << 8;
 			dbg("mos7840_set_uart_reg application number is %x\n",
 			    val);
@@ -302,14 +301,15 @@ static int mos7840_set_uart_reg(struct usb_serial_port *port, __u16 reg,
  *	by passing usb_rcvctrlpipe function as parameter.
  */
 static int mos7840_get_uart_reg(struct usb_serial_port *port, __u16 reg,
-				__u16 * val)
+				__u16 *val)
 {
 	struct usb_device *dev = port->serial->dev;
 	int ret = 0;
 	__u16 Wval;
 
-	//dbg("application number is %4x \n",(((__u16)port->number - (__u16)(port->serial->minor))+1)<<8);
-	/*Wval  is same as application number */
+	/* dbg("application number is %4x \n",
+	    (((__u16)port->number - (__u16)(port->serial->minor))+1)<<8); */
+	/* Wval  is same as application number */
 	if (port->serial->num_ports == 4) {
 		Wval =
 		    (((__u16) port->number - (__u16) (port->serial->minor)) +
@@ -317,14 +317,12 @@ static int mos7840_get_uart_reg(struct usb_serial_port *port, __u16 reg,
 		dbg("mos7840_get_uart_reg application number is %x\n", Wval);
 	} else {
 		if (((__u16) port->number - (__u16) (port->serial->minor)) == 0) {
-			Wval =
-			    (((__u16) port->number -
+			Wval = (((__u16) port->number -
 			      (__u16) (port->serial->minor)) + 1) << 8;
 			dbg("mos7840_get_uart_reg application number is %x\n",
 			    Wval);
 		} else {
-			Wval =
-			    (((__u16) port->number -
+			Wval = (((__u16) port->number -
 			      (__u16) (port->serial->minor)) + 2) << 8;
 			dbg("mos7840_get_uart_reg application number is %x\n",
 			    Wval);
@@ -406,11 +404,11 @@ static void mos7840_handle_new_lsr(struct moschip_port *port, __u8 new_lsr)
 	dbg("%s - %02x", __func__, new_lsr);
 
 	if (new_lsr & SERIAL_LSR_BI) {
-		//
-		// Parity and Framing errors only count if they
-		// occur exclusive of a break being
-		// received.
-		//
+		/*
+		 * Parity and Framing errors only count if they
+		 * occur exclusive of a break being
+		 * received.
+		 */
 		new_lsr &= (__u8) (SERIAL_LSR_OE | SERIAL_LSR_BI);
 	}
 
@@ -492,7 +490,7 @@ exit:
 }
 
 static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
-			   __u16 * val)
+			   __u16 *val)
 {
 	struct usb_device *dev = mcs->port->serial->dev;
 	struct usb_ctrlrequest *dr = mcs->dr;
@@ -501,7 +499,7 @@ static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
 
 	dr->bRequestType = MCS_RD_RTYPE;
 	dr->bRequest = MCS_RDREQ;
-	dr->wValue = cpu_to_le16(Wval);	//0;
+	dr->wValue = cpu_to_le16(Wval);	/* 0 */
 	dr->wIndex = cpu_to_le16(reg);
 	dr->wLength = cpu_to_le16(2);
 
@@ -607,7 +605,8 @@ static void mos7840_interrupt_callback(struct urb *urb)
 			}
 		}
 	}
-	if (!(rv < 0)) /* the completion handler for the control urb will resubmit */
+	if (!(rv < 0))
+		/* the completion handler for the control urb will resubmit */
 		return;
 exit:
 	result = usb_submit_urb(urb, GFP_ATOMIC);
@@ -656,8 +655,8 @@ static struct usb_serial *mos7840_get_usb_serial(struct usb_serial_port *port,
 	if (!port ||
 	    mos7840_port_paranoia_check(port, function) ||
 	    mos7840_serial_paranoia_check(port->serial, function)) {
-		/* then say that we don't have a valid usb_serial thing, which will
-		 * end up genrating -ENODEV return values */
+		/* then say that we don't have a valid usb_serial thing,
+		 * which will end up genrating -ENODEV return values */
 		return NULL;
 	}
 
@@ -741,8 +740,8 @@ static void mos7840_bulk_in_callback(struct urb *urb)
 
 /*****************************************************************************
  * mos7840_bulk_out_data_callback
- *	this is the callback function for when we have finished sending serial data
- *	on the bulk out endpoint.
+ *	this is the callback function for when we have finished sending
+ *	serial data on the bulk out endpoint.
  *****************************************************************************/
 
 static void mos7840_bulk_out_data_callback(struct urb *urb)
@@ -848,7 +847,8 @@ static int mos7840_open(struct tty_struct *tty,
 			continue;
 		}
 
-		urb->transfer_buffer = kmalloc(URB_TRANSFER_BUFFER_SIZE, GFP_KERNEL);
+		urb->transfer_buffer = kmalloc(URB_TRANSFER_BUFFER_SIZE,
+								GFP_KERNEL);
 		if (!urb->transfer_buffer) {
 			usb_free_urb(urb);
 			mos7840_port->write_urb_pool[j] = NULL;
@@ -869,9 +869,8 @@ static int mos7840_open(struct tty_struct *tty,
  * 0x08 : SP1/2 Control Reg
  *****************************************************************************/
 
-//NEED to check the following Block
+	/* NEED to check the following Block */
 
-	status = 0;
 	Data = 0x0;
 	status = mos7840_get_reg_sync(port, mos7840_port->SpRegOffset, &Data);
 	if (status < 0) {
@@ -891,36 +890,35 @@ static int mos7840_open(struct tty_struct *tty,
 		dbg("writing Spreg failed\n");
 		return -1;
 	}
-//End of block to be checked
+	/* End of block to be checked */
 
-	status = 0;
 	Data = 0x0;
-	status =
-	    mos7840_get_reg_sync(port, mos7840_port->ControlRegOffset, &Data);
+	status = mos7840_get_reg_sync(port, mos7840_port->ControlRegOffset,
+									&Data);
 	if (status < 0) {
 		dbg("Reading Controlreg failed\n");
 		return -1;
 	}
-	Data |= 0x08;		//Driver done bit
-	Data |= 0x20;		//rx_disable
-	status = mos7840_set_reg_sync(port, mos7840_port->ControlRegOffset, Data);
+	Data |= 0x08;		/* Driver done bit */
+	Data |= 0x20;		/* rx_disable */
+	status = mos7840_set_reg_sync(port,
+				mos7840_port->ControlRegOffset, Data);
 	if (status < 0) {
 		dbg("writing Controlreg failed\n");
 		return -1;
 	}
-	//do register settings here
-	// Set all regs to the device default values.
-	////////////////////////////////////
-	// First Disable all interrupts.
-	////////////////////////////////////
-
+	/* do register settings here */
+	/* Set all regs to the device default values. */
+	/***********************************
+	 * First Disable all interrupts.
+	 ***********************************/
 	Data = 0x00;
 	status = mos7840_set_uart_reg(port, INTERRUPT_ENABLE_REGISTER, Data);
 	if (status < 0) {
 		dbg("disableing interrupts failed\n");
 		return -1;
 	}
-	// Set FIFO_CONTROL_REGISTER to the default value
+	/* Set FIFO_CONTROL_REGISTER to the default value */
 	Data = 0x00;
 	status = mos7840_set_uart_reg(port, FIFO_CONTROL_REGISTER, Data);
 	if (status < 0) {
@@ -947,90 +945,73 @@ static int mos7840_open(struct tty_struct *tty,
 	status = mos7840_get_uart_reg(port, LINE_CONTROL_REGISTER, &Data);
 	mos7840_port->shadowLCR = Data;
 
-	Data |= SERIAL_LCR_DLAB;	//data latch enable in LCR 0x80
+	Data |= SERIAL_LCR_DLAB;	/* data latch enable in LCR 0x80 */
 	status = mos7840_set_uart_reg(port, LINE_CONTROL_REGISTER, Data);
 
 	Data = 0x0c;
-	status = 0;
 	status = mos7840_set_uart_reg(port, DIVISOR_LATCH_LSB, Data);
 
 	Data = 0x0;
-	status = 0;
 	status = mos7840_set_uart_reg(port, DIVISOR_LATCH_MSB, Data);
 
 	Data = 0x00;
-	status = 0;
 	status = mos7840_get_uart_reg(port, LINE_CONTROL_REGISTER, &Data);
 
 	Data = Data & ~SERIAL_LCR_DLAB;
-	status = 0;
 	status = mos7840_set_uart_reg(port, LINE_CONTROL_REGISTER, Data);
 	mos7840_port->shadowLCR = Data;
 
-	//clearing Bulkin and Bulkout Fifo
+	/* clearing Bulkin and Bulkout Fifo */
 	Data = 0x0;
-	status = 0;
 	status = mos7840_get_reg_sync(port, mos7840_port->SpRegOffset, &Data);
 
 	Data = Data | 0x0c;
-	status = 0;
 	status = mos7840_set_reg_sync(port, mos7840_port->SpRegOffset, Data);
 
 	Data = Data & ~0x0c;
-	status = 0;
 	status = mos7840_set_reg_sync(port, mos7840_port->SpRegOffset, Data);
-	//Finally enable all interrupts
-	Data = 0x0;
+	/* Finally enable all interrupts */
 	Data = 0x0c;
-	status = 0;
 	status = mos7840_set_uart_reg(port, INTERRUPT_ENABLE_REGISTER, Data);
 
-	//clearing rx_disable
+	/* clearing rx_disable */
 	Data = 0x0;
-	status = 0;
-	status =
-	    mos7840_get_reg_sync(port, mos7840_port->ControlRegOffset, &Data);
+	status = mos7840_get_reg_sync(port, mos7840_port->ControlRegOffset,
+									&Data);
 	Data = Data & ~0x20;
-	status = 0;
-	status =
-	    mos7840_set_reg_sync(port, mos7840_port->ControlRegOffset, Data);
+	status = mos7840_set_reg_sync(port, mos7840_port->ControlRegOffset,
+									Data);
 
-	// rx_negate
+	/* rx_negate */
 	Data = 0x0;
-	status = 0;
-	status =
-	    mos7840_get_reg_sync(port, mos7840_port->ControlRegOffset, &Data);
+	status = mos7840_get_reg_sync(port, mos7840_port->ControlRegOffset,
+									&Data);
 	Data = Data | 0x10;
-	status = 0;
-	status =
-	    mos7840_set_reg_sync(port, mos7840_port->ControlRegOffset, Data);
+	status = mos7840_set_reg_sync(port, mos7840_port->ControlRegOffset,
+									Data);
 
 	/* force low_latency on so that our tty_push actually forces *
 	 * the data through,otherwise it is scheduled, and with      *
 	 * high data rates (like with OHCI) data can get lost.       */
-
 	if (tty)
 		tty->low_latency = 1;
-/* Check to see if we've set up our endpoint info yet    *
-     * (can't set it up in mos7840_startup as the structures *
-     * were not set up at that time.)                        */
+
+	/* Check to see if we've set up our endpoint info yet    *
+	 * (can't set it up in mos7840_startup as the structures *
+	 * were not set up at that time.)                        */
 	if (port0->open_ports == 1) {
 		if (serial->port[0]->interrupt_in_buffer == NULL) {
-
 			/* set up interrupt urb */
-
 			usb_fill_int_urb(serial->port[0]->interrupt_in_urb,
-					 serial->dev,
-					 usb_rcvintpipe(serial->dev,
-							serial->port[0]->
-							interrupt_in_endpointAddress),
-					 serial->port[0]->interrupt_in_buffer,
-					 serial->port[0]->interrupt_in_urb->
-					 transfer_buffer_length,
-					 mos7840_interrupt_callback,
-					 serial,
-					 serial->port[0]->interrupt_in_urb->
-					 interval);
+				serial->dev,
+				usb_rcvintpipe(serial->dev,
+				serial->port[0]->interrupt_in_endpointAddress),
+				serial->port[0]->interrupt_in_buffer,
+				serial->port[0]->interrupt_in_urb->
+				transfer_buffer_length,
+				mos7840_interrupt_callback,
+				serial,
+				serial->port[0]->interrupt_in_urb->interval);
 
 			/* start interrupt read for mos7840               *
 			 * will continue as long as mos7840 is connected  */
@@ -1085,14 +1066,16 @@ static int mos7840_open(struct tty_struct *tty,
 	memset(&(mos7840_port->icount), 0x00, sizeof(mos7840_port->icount));
 
 	/* initialize our port settings */
-	mos7840_port->shadowMCR = MCR_MASTER_IE;	/* Must set to enable ints! */
+	/* Must set to enable ints! */
+	mos7840_port->shadowMCR = MCR_MASTER_IE;
 	/* send a open port command */
 	mos7840_port->open = 1;
-	//mos7840_change_port_settings(mos7840_port,old_termios);
+	/* mos7840_change_port_settings(mos7840_port,old_termios); */
 	mos7840_port->icount.tx = 0;
 	mos7840_port->icount.rx = 0;
 
-	dbg("\n\nusb_serial serial:%p       mos7840_port:%p\n      usb_serial_port port:%p\n\n", serial, mos7840_port, port);
+	dbg("\n\nusb_serial serial:%p       mos7840_port:%p\n      usb_serial_port port:%p\n\n",
+				serial, mos7840_port, port);
 
 	return 0;
 
@@ -1129,11 +1112,11 @@ static int mos7840_chars_in_buffer(struct tty_struct *tty)
 		return 0;
 	}
 
-	spin_lock_irqsave(&mos7840_port->pool_lock,flags);
+	spin_lock_irqsave(&mos7840_port->pool_lock, flags);
 	for (i = 0; i < NUM_URBS; ++i)
 		if (mos7840_port->busy[i])
 			chars += URB_TRANSFER_BUFFER_SIZE;
-	spin_unlock_irqrestore(&mos7840_port->pool_lock,flags);
+	spin_unlock_irqrestore(&mos7840_port->pool_lock, flags);
 	dbg("%s - returns %d", __func__, chars);
 	return chars;
 
@@ -1161,9 +1144,8 @@ static void mos7840_block_until_tx_empty(struct tty_struct *tty,
 		count = mos7840_chars_in_buffer(tty);
 
 		/* Check for Buffer status */
-		if (count <= 0) {
+		if (count <= 0)
 			return;
-		}
 
 		/* Block the thread for a while */
 		interruptible_sleep_on_timeout(&mos7840_port->wait_chase,
@@ -1245,11 +1227,11 @@ static void mos7840_close(struct tty_struct *tty,
 		}
 		if ((&mos7840_port->control_urb)) {
 			dbg("%s", "Shutdown control read\n");
-			//      usb_kill_urb (mos7840_port->control_urb);
+			/*/      usb_kill_urb (mos7840_port->control_urb); */
 		}
 	}
-//      if(mos7840_port->ctrl_buf != NULL)
-//              kfree(mos7840_port->ctrl_buf);
+/*      if(mos7840_port->ctrl_buf != NULL) */
+/*              kfree(mos7840_port->ctrl_buf); */
 	port0->open_ports--;
 	dbg("mos7840_num_open_ports in close%d:in port%d\n",
 	    port0->open_ports, port->number);
@@ -1262,10 +1244,8 @@ static void mos7840_close(struct tty_struct *tty,
 
 	if (mos7840_port->write_urb) {
 		/* if this urb had a transfer buffer already (old tx) free it */
-
-		if (mos7840_port->write_urb->transfer_buffer != NULL) {
+		if (mos7840_port->write_urb->transfer_buffer != NULL)
 			kfree(mos7840_port->write_urb->transfer_buffer);
-		}
 		usb_free_urb(mos7840_port->write_urb);
 	}
 
@@ -1302,9 +1282,8 @@ static void mos7840_block_until_chase_response(struct tty_struct *tty,
 		count = mos7840_chars_in_buffer(tty);
 
 		/* Check for Buffer status */
-		if (count <= 0) {
+		if (count <= 0)
 			return;
-		}
 
 		/* Block the thread for a while */
 		interruptible_sleep_on_timeout(&mos7840_port->wait_chase,
@@ -1349,9 +1328,8 @@ static void mos7840_break(struct tty_struct *tty, int break_state)
 
 	mos7840_port = mos7840_get_port_private(port);
 
-	if (mos7840_port == NULL) {
+	if (mos7840_port == NULL)
 		return;
-	}
 
 	if (serial->dev)
 		/* flush and block until tx is empty */
@@ -1403,9 +1381,8 @@ static int mos7840_write_room(struct tty_struct *tty)
 
 	spin_lock_irqsave(&mos7840_port->pool_lock, flags);
 	for (i = 0; i < NUM_URBS; ++i) {
-		if (!mos7840_port->busy[i]) {
+		if (!mos7840_port->busy[i])
 			room += URB_TRANSFER_BUFFER_SIZE;
-		}
 	}
 	spin_unlock_irqrestore(&mos7840_port->pool_lock, flags);
 
@@ -1435,45 +1412,41 @@ static int mos7840_write(struct tty_struct *tty, struct usb_serial_port *port,
 	struct moschip_port *mos7840_port;
 	struct usb_serial *serial;
 	struct urb *urb;
-	//__u16 Data;
+	/* __u16 Data; */
 	const unsigned char *current_position = data;
 	unsigned char *data1;
 	dbg("%s \n", "entering ...........");
-	//dbg("mos7840_write: mos7840_port->shadowLCR is %x\n",mos7840_port->shadowLCR);
+	/* dbg("mos7840_write: mos7840_port->shadowLCR is %x\n",
+					mos7840_port->shadowLCR); */
 
 #ifdef NOTMOS7840
 	Data = 0x00;
-	status = 0;
 	status = mos7840_get_uart_reg(port, LINE_CONTROL_REGISTER, &Data);
 	mos7840_port->shadowLCR = Data;
 	dbg("mos7840_write: LINE_CONTROL_REGISTER is %x\n", Data);
 	dbg("mos7840_write: mos7840_port->shadowLCR is %x\n",
 	    mos7840_port->shadowLCR);
 
-	//Data = 0x03;
-	//status = mos7840_set_uart_reg(port,LINE_CONTROL_REGISTER,Data);
-	//mos7840_port->shadowLCR=Data;//Need to add later
+	/* Data = 0x03; */
+	/* status = mos7840_set_uart_reg(port,LINE_CONTROL_REGISTER,Data); */
+	/* mos7840_port->shadowLCR=Data;//Need to add later */
 
-	Data |= SERIAL_LCR_DLAB;	//data latch enable in LCR 0x80
-	status = 0;
+	Data |= SERIAL_LCR_DLAB;	/* data latch enable in LCR 0x80 */
 	status = mos7840_set_uart_reg(port, LINE_CONTROL_REGISTER, Data);
 
-	//Data = 0x0c;
-	//status = mos7840_set_uart_reg(port,DIVISOR_LATCH_LSB,Data);
+	/* Data = 0x0c; */
+	/* status = mos7840_set_uart_reg(port,DIVISOR_LATCH_LSB,Data); */
 	Data = 0x00;
-	status = 0;
 	status = mos7840_get_uart_reg(port, DIVISOR_LATCH_LSB, &Data);
 	dbg("mos7840_write:DLL value is %x\n", Data);
 
 	Data = 0x0;
-	status = 0;
 	status = mos7840_get_uart_reg(port, DIVISOR_LATCH_MSB, &Data);
 	dbg("mos7840_write:DLM value is %x\n", Data);
 
 	Data = Data & ~SERIAL_LCR_DLAB;
 	dbg("mos7840_write: mos7840_port->shadowLCR is %x\n",
 	    mos7840_port->shadowLCR);
-	status = 0;
 	status = mos7840_set_uart_reg(port, LINE_CONTROL_REGISTER, Data);
 #endif
 
@@ -1598,7 +1571,6 @@ static void mos7840_throttle(struct tty_struct *tty)
 	/* if we are implementing RTS/CTS, toggle that line */
 	if (tty->termios->c_cflag & CRTSCTS) {
 		mos7840_port->shadowMCR &= ~MCR_RTS;
-		status = 0;
 		status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER,
 					 mos7840_port->shadowMCR);
 		if (status < 0)
@@ -1610,8 +1582,9 @@ static void mos7840_throttle(struct tty_struct *tty)
 
 /*****************************************************************************
  * mos7840_unthrottle
- *	this function is called by the tty driver when it wants to resume the data
- *	being read from the port (called after SerialThrottle is called)
+ *	this function is called by the tty driver when it wants to resume
+ *	the data being read from the port (called after mos7840_throttle is
+ *	called)
  *****************************************************************************/
 static void mos7840_unthrottle(struct tty_struct *tty)
 {
@@ -1645,7 +1618,6 @@ static void mos7840_unthrottle(struct tty_struct *tty)
 	/* if we are implementing RTS/CTS, toggle that line */
 	if (tty->termios->c_cflag & CRTSCTS) {
 		mos7840_port->shadowMCR |= MCR_RTS;
-		status = 0;
 		status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER,
 					 mos7840_port->shadowMCR);
 		if (status < 0)
@@ -1660,7 +1632,7 @@ static int mos7840_tiocmget(struct tty_struct *tty, struct file *file)
 	unsigned int result;
 	__u16 msr;
 	__u16 mcr;
-	int status = 0;
+	int status;
 	mos7840_port = mos7840_get_port_private(port);
 
 	dbg("%s - port %d", __func__, port->number);
@@ -1731,7 +1703,7 @@ static int mos7840_tiocmset(struct tty_struct *tty, struct file *file,
  *	baud rate.
  *****************************************************************************/
 static int mos7840_calc_baud_rate_divisor(int baudRate, int *divisor,
-					  __u16 * clk_sel_val)
+					  __u16 *clk_sel_val)
 {
 
 	dbg("%s - %d", __func__, baudRate);
@@ -1783,9 +1755,8 @@ static int mos7840_calc_baud_rate_divisor(int baudRate, int *divisor,
 		/* Check for round off */
 		round1 = (__u16) (2304000L / baudrate);
 		round = (__u16) (round1 - (custom * 10));
-		if (round > 4) {
+		if (round > 4)
 			custom++;
-		}
 		*divisor = custom;
 
 		dbg(" Baud %d = %d\n", baudrate, custom);
@@ -1833,16 +1804,15 @@ static int mos7840_send_cmd_write_baud_rate(struct moschip_port *mos7840_port,
 
 	dbg("%s - port = %d, baud = %d", __func__,
 	    mos7840_port->port->number, baudRate);
-	//reset clk_uart_sel in spregOffset
+	/* reset clk_uart_sel in spregOffset */
 	if (baudRate > 115200) {
 #ifdef HW_flow_control
-		//NOTE: need to see the pther register to modify
-		//setting h/w flow control bit to 1;
-		status = 0;
+		/* NOTE: need to see the pther register to modify */
+		/* setting h/w flow control bit to 1 */
 		Data = 0x2b;
 		mos7840_port->shadowMCR = Data;
-		status =
-		    mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER, Data);
+		status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER,
+									Data);
 		if (status < 0) {
 			dbg("Writing spreg failed in set_serial_baud\n");
 			return -1;
@@ -1851,12 +1821,11 @@ static int mos7840_send_cmd_write_baud_rate(struct moschip_port *mos7840_port,
 
 	} else {
 #ifdef HW_flow_control
-		//setting h/w flow control bit to 0;
-		status = 0;
+		/ *setting h/w flow control bit to 0 */
 		Data = 0xb;
 		mos7840_port->shadowMCR = Data;
-		status =
-		    mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER, Data);
+		status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER,
+									Data);
 		if (status < 0) {
 			dbg("Writing spreg failed in set_serial_baud\n");
 			return -1;
@@ -1865,25 +1834,20 @@ static int mos7840_send_cmd_write_baud_rate(struct moschip_port *mos7840_port,
 
 	}
 
-	if (1)			//baudRate <= 115200)
-	{
+	if (1) {		/* baudRate <= 115200) */
 		clk_sel_val = 0x0;
 		Data = 0x0;
-		status = 0;
-		status =
-		    mos7840_calc_baud_rate_divisor(baudRate, &divisor,
+		status = mos7840_calc_baud_rate_divisor(baudRate, &divisor,
 						   &clk_sel_val);
-		status =
-		    mos7840_get_reg_sync(port, mos7840_port->SpRegOffset,
-					 &Data);
+		status = mos7840_get_reg_sync(port, mos7840_port->SpRegOffset,
+								 &Data);
 		if (status < 0) {
 			dbg("reading spreg failed in set_serial_baud\n");
 			return -1;
 		}
 		Data = (Data & 0x8f) | clk_sel_val;
-		status = 0;
-		status =
-		    mos7840_set_reg_sync(port, mos7840_port->SpRegOffset, Data);
+		status = mos7840_set_reg_sync(port, mos7840_port->SpRegOffset,
+								Data);
 		if (status < 0) {
 			dbg("Writing spreg failed in set_serial_baud\n");
 			return -1;
@@ -1915,7 +1879,6 @@ static int mos7840_send_cmd_write_baud_rate(struct moschip_port *mos7840_port,
 		mos7840_set_uart_reg(port, LINE_CONTROL_REGISTER, Data);
 
 	}
-
 	return status;
 }
 
@@ -2006,9 +1969,8 @@ static void mos7840_change_port_settings(struct tty_struct *tty,
 		dbg("%s - parity = none", __func__);
 	}
 
-	if (cflag & CMSPAR) {
+	if (cflag & CMSPAR)
 		lParity = lParity | 0x20;
-	}
 
 	/* Change the Stop bit */
 	if (cflag & CSTOPB) {
@@ -2050,16 +2012,13 @@ static void mos7840_change_port_settings(struct tty_struct *tty,
 	/* set up the MCR register and send it to the mos7840 */
 
 	mos7840_port->shadowMCR = MCR_MASTER_IE;
-	if (cflag & CBAUD) {
+	if (cflag & CBAUD)
 		mos7840_port->shadowMCR |= (MCR_DTR | MCR_RTS);
-	}
 
-	if (cflag & CRTSCTS) {
+	if (cflag & CRTSCTS)
 		mos7840_port->shadowMCR |= (MCR_XON_ANY);
-
-	} else {
+	else
 		mos7840_port->shadowMCR &= ~(MCR_XON_ANY);
-	}
 
 	Data = mos7840_port->shadowMCR;
 	mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER, Data);
@@ -2255,7 +2214,6 @@ static int mos7840_set_modem_info(struct moschip_port *mos7840_port,
 	mos7840_port->shadowMCR = mcr;
 
 	Data = mos7840_port->shadowMCR;
-	status = 0;
 	status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER, Data);
 	if (status < 0) {
 		dbg("setting MODEM_CONTROL_REGISTER Failed\n");
@@ -2276,8 +2234,7 @@ static int mos7840_get_modem_info(struct moschip_port *mos7840_port,
 	unsigned int result = 0;
 	__u16 msr;
 	unsigned int mcr = mos7840_port->shadowMCR;
-	int status = 0;
-	status = mos7840_get_uart_reg(mos7840_port->port,
+        mos7840_get_uart_reg(mos7840_port->port,
 						MODEM_STATUS_REGISTER, &msr);
 	result = ((mcr & MCR_DTR) ? TIOCM_DTR : 0)	/* 0x002 */
 	    |((mcr & MCR_RTS) ? TIOCM_RTS : 0)	/* 0x004 */
@@ -2389,7 +2346,7 @@ static int mos7840_ioctl(struct tty_struct *tty, struct file *file,
 		dbg("%s (%d) TIOCMIWAIT", __func__, port->number);
 		cprev = mos7840_port->icount;
 		while (1) {
-			//interruptible_sleep_on(&mos7840_port->delta_msr_wait);
+			/* interruptible_sleep_on(&mos7840_port->delta_msr_wait); */
 			mos7840_port->delta_msr_cond = 0;
 			wait_event_interruptible(mos7840_port->delta_msr_wait,
 						 (mos7840_port->
@@ -2494,8 +2451,9 @@ static int mos7840_startup(struct usb_serial *serial)
 			goto error;
 		}
 
-		/* Initialize all port interrupt end point to port 0 int endpoint *
-		 * Our device has only one interrupt end point comman to all port */
+		/* Initialize all port interrupt end point to port 0 int
+		 * endpoint. Our device has only one interrupt end point
+		 * common to all port */
 
 		mos7840_port->port = serial->port[i];
 		mos7840_set_port_private(serial->port[i], mos7840_port);
@@ -2531,27 +2489,23 @@ static int mos7840_startup(struct usb_serial *serial)
 			mos7840_port->DcrRegOffset = 0x1c;
 		}
 		mos7840_dump_serial_port(mos7840_port);
-
 		mos7840_set_port_private(serial->port[i], mos7840_port);
 
-		//enable rx_disable bit in control register
-
-		status =
-		    mos7840_get_reg_sync(serial->port[i],
-					 mos7840_port->ControlRegOffset, &Data);
+		/* enable rx_disable bit in control register */
+		status = mos7840_get_reg_sync(serial->port[i],
+				 mos7840_port->ControlRegOffset, &Data);
 		if (status < 0) {
 			dbg("Reading ControlReg failed status-0x%x\n", status);
 			break;
 		} else
 			dbg("ControlReg Reading success val is %x, status%d\n",
 			    Data, status);
-		Data |= 0x08;	//setting driver done bit
-		Data |= 0x04;	//sp1_bit to have cts change reflect in modem status reg
+		Data |= 0x08;	/* setting driver done bit */
+		Data |= 0x04;	/* sp1_bit to have cts change reflect in
+				   modem status reg */
 
-		//Data |= 0x20; //rx_disable bit
-		status = 0;
-		status =
-		    mos7840_set_reg_sync(serial->port[i],
+		/* Data |= 0x20; //rx_disable bit */
+		status = mos7840_set_reg_sync(serial->port[i],
 					 mos7840_port->ControlRegOffset, Data);
 		if (status < 0) {
 			dbg("Writing ControlReg failed(rx_disable) status-0x%x\n", status);
@@ -2560,13 +2514,11 @@ static int mos7840_startup(struct usb_serial *serial)
 			dbg("ControlReg Writing success(rx_disable) status%d\n",
 			    status);
 
-		//Write default values in DCR (i.e 0x01 in DCR0, 0x05 in DCR2 and 0x24 in DCR3
+		/* Write default values in DCR (i.e 0x01 in DCR0, 0x05 in DCR2
+		   and 0x24 in DCR3 */
 		Data = 0x01;
-		status = 0;
-		status =
-		    mos7840_set_reg_sync(serial->port[i],
-					 (__u16) (mos7840_port->DcrRegOffset +
-						  0), Data);
+		status = mos7840_set_reg_sync(serial->port[i],
+			 (__u16) (mos7840_port->DcrRegOffset + 0), Data);
 		if (status < 0) {
 			dbg("Writing DCR0 failed status-0x%x\n", status);
 			break;
@@ -2574,11 +2526,8 @@ static int mos7840_startup(struct usb_serial *serial)
 			dbg("DCR0 Writing success status%d\n", status);
 
 		Data = 0x05;
-		status = 0;
-		status =
-		    mos7840_set_reg_sync(serial->port[i],
-					 (__u16) (mos7840_port->DcrRegOffset +
-						  1), Data);
+		status = mos7840_set_reg_sync(serial->port[i],
+			 (__u16) (mos7840_port->DcrRegOffset + 1), Data);
 		if (status < 0) {
 			dbg("Writing DCR1 failed status-0x%x\n", status);
 			break;
@@ -2586,22 +2535,17 @@ static int mos7840_startup(struct usb_serial *serial)
 			dbg("DCR1 Writing success status%d\n", status);
 
 		Data = 0x24;
-		status = 0;
-		status =
-		    mos7840_set_reg_sync(serial->port[i],
-					 (__u16) (mos7840_port->DcrRegOffset +
-						  2), Data);
+		status = mos7840_set_reg_sync(serial->port[i],
+			 (__u16) (mos7840_port->DcrRegOffset + 2), Data);
 		if (status < 0) {
 			dbg("Writing DCR2 failed status-0x%x\n", status);
 			break;
 		} else
 			dbg("DCR2 Writing success status%d\n", status);
 
-		// write values in clkstart0x0 and clkmulti 0x20
+		/* write values in clkstart0x0 and clkmulti 0x20 */
 		Data = 0x0;
-		status = 0;
-		status =
-		    mos7840_set_reg_sync(serial->port[i],
+		status = mos7840_set_reg_sync(serial->port[i],
 					 CLK_START_VALUE_REGISTER, Data);
 		if (status < 0) {
 			dbg("Writing CLK_START_VALUE_REGISTER failed status-0x%x\n", status);
@@ -2610,9 +2554,8 @@ static int mos7840_startup(struct usb_serial *serial)
 			dbg("CLK_START_VALUE_REGISTER Writing success status%d\n", status);
 
 		Data = 0x20;
-		status =
-		    mos7840_set_reg_sync(serial->port[i], CLK_MULTI_REGISTER,
-					 Data);
+		status = mos7840_set_reg_sync(serial->port[i],
+					CLK_MULTI_REGISTER, Data);
 		if (status < 0) {
 			dbg("Writing CLK_MULTI_REGISTER failed status-0x%x\n",
 			    status);
@@ -2621,11 +2564,10 @@ static int mos7840_startup(struct usb_serial *serial)
 			dbg("CLK_MULTI_REGISTER Writing success status%d\n",
 			    status);
 
-		//write value 0x0 to scratchpad register
+		/* write value 0x0 to scratchpad register */
 		Data = 0x00;
-		status =
-		    mos7840_set_uart_reg(serial->port[i], SCRATCH_PAD_REGISTER,
-					 Data);
+		status = mos7840_set_uart_reg(serial->port[i],
+						SCRATCH_PAD_REGISTER, Data);
 		if (status < 0) {
 			dbg("Writing SCRATCH_PAD_REGISTER failed status-0x%x\n",
 			    status);
@@ -2634,21 +2576,17 @@ static int mos7840_startup(struct usb_serial *serial)
 			dbg("SCRATCH_PAD_REGISTER Writing success status%d\n",
 			    status);
 
-		//Zero Length flag register
+		/* Zero Length flag register */
 		if ((mos7840_port->port_num != 1)
 		    && (serial->num_ports == 2)) {
 
 			Data = 0xff;
-			status = 0;
 			status = mos7840_set_reg_sync(serial->port[i],
-						      (__u16) (ZLP_REG1 +
-							       ((__u16)
-								mos7840_port->
-								port_num)),
-						      Data);
+				      (__u16) (ZLP_REG1 +
+				      ((__u16)mos7840_port->port_num)), Data);
 			dbg("ZLIP offset%x\n",
 			    (__u16) (ZLP_REG1 +
-				     ((__u16) mos7840_port->port_num)));
+					((__u16) mos7840_port->port_num)));
 			if (status < 0) {
 				dbg("Writing ZLP_REG%d failed status-0x%x\n",
 				    i + 2, status);
@@ -2658,13 +2596,9 @@ static int mos7840_startup(struct usb_serial *serial)
 				    i + 2, status);
 		} else {
 			Data = 0xff;
-			status = 0;
 			status = mos7840_set_reg_sync(serial->port[i],
-						      (__u16) (ZLP_REG1 +
-							       ((__u16)
-								mos7840_port->
-								port_num) -
-							       0x1), Data);
+			      (__u16) (ZLP_REG1 +
+			      ((__u16)mos7840_port->port_num) - 0x1), Data);
 			dbg("ZLIP offset%x\n",
 			    (__u16) (ZLP_REG1 +
 				     ((__u16) mos7840_port->port_num) - 0x1));
@@ -2679,14 +2613,16 @@ static int mos7840_startup(struct usb_serial *serial)
 		}
 		mos7840_port->control_urb = usb_alloc_urb(0, GFP_KERNEL);
 		mos7840_port->ctrl_buf = kmalloc(16, GFP_KERNEL);
-		mos7840_port->dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_KERNEL);
-		if (!mos7840_port->control_urb || !mos7840_port->ctrl_buf || !mos7840_port->dr) {
+		mos7840_port->dr = kmalloc(sizeof(struct usb_ctrlrequest),
+								GFP_KERNEL);
+		if (!mos7840_port->control_urb || !mos7840_port->ctrl_buf ||
+							!mos7840_port->dr) {
 			status = -ENOMEM;
 			goto error;
 		}
 	}
 
-	//Zero Length flag enable
+	/* Zero Length flag enable */
 	Data = 0x0f;
 	status = mos7840_set_reg_sync(serial->port[0], ZLP_REG5, Data);
 	if (status < 0) {
@@ -2729,7 +2665,7 @@ static void mos7840_shutdown(struct usb_serial *serial)
 		return;
 	}
 
-	/*      check for the ports to be closed,close the ports and disconnect         */
+	/* check for the ports to be closed,close the ports and disconnect */
 
 	/* free private structure allocated for serial port  *
 	 * stop reads and writes on all ports                */
@@ -2810,20 +2746,12 @@ static int __init moschip7840_init(void)
 
 	/* Register with the usb */
 	retval = usb_register(&io_driver);
-
-	if (retval)
-		goto failed_usb_register;
-
 	if (retval == 0) {
 		dbg("%s\n", "Leaving...");
 		return 0;
 	}
-
-      failed_usb_register:
 	usb_serial_deregister(&moschip7840_4port_device);
-
-      failed_port_device_register:
-
+failed_port_device_register:
 	return retval;
 }
 

