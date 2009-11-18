Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZKRBIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZKRBIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbZKRBIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:08:51 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45717 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbZKRBIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:08:50 -0500
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Johan Hovold <jhovold@gmail.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       linux-usb@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
References: <20090924154023.GA27480@localhost>
	<20091003140902.38628d8a@lxorguk.ukuu.org.uk>
	<m13a4df19g.fsf@fess.ebiederm.org>
	<200911171941.34781.oliver@neukum.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 17 Nov 2009 17:08:43 -0800
In-Reply-To: <200911171941.34781.oliver@neukum.org> (Oliver Neukum's message of "Tue\, 17 Nov 2009 19\:41\:34 +0100")
Message-ID: <m1lji4od0k.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Oliver Neukum <oliver@neukum.org> writes:

> Am Dienstag, 17. November 2009 19:35:07 schrieb Eric W. Biederman:
>> Boiled down.  ftdi_chars_in_buffer is essentially
>>  priv->tx_outstanding_bytes. tx_outstanding_bytes is incremented when an
>>  urb request is sent and tx_outstanding_bytes is decremented when an urb
>>  request completes.
>> 
>> It turns out I have a moderately noisy usb line, and so I occasionally
>> get messages like:
>> 
>> ehci_hcd 0000:00:0a.1: detected XactErr len 0/7 retry 31
>> 
>> Which as best as I can tell result in the urb getting abandoned and
>> neither completed nor canceled (because we have hit the maximum
>> retry count and they still don't succeed).
>
> The URB should be finished with an error code in urb->status.
> ftdi_write_bulk_callback() does decrement the counter even in
> the error case.
>
>> Which appears to result in tx_outstanding_bytes getting stuck at
>> some positive number.
>
> Do you see this message
>
>  	if (status) {
> 		dbg("nonzero write bulk status received: %d", status);
> 		return;
> 	}
>
> if you enable debugging output?

Ok.  After a bunch of minor tweaks to the debug messages I finally have a smoking gun trace.

The highlights:

*  ftdi_write port 15, 7 bytes

*  detected XactErr len 0/7 retry 1

*  ftdi_write_bulk_callback - port 15

*  nonzero write bulk status received: -71 countback: 0

*  ftdi_chars_in_buffer - port 15 buffered: 7

We write 7 bytes, we get an error and a completion with status
-EPROTO, but no bytes have actually been transferred so actual_length
less the headers is 0.  Since we don't subtract off any bytes when we
get the completion we figure 7 bytes are actually in flight when they
are not.

Eric


Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 15 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 15
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 14 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 14
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 13 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 13
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 12 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 12
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write port 15, 7 bytes
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: data_offset set to 0
Nov 17 16:44:35 localhost kernel: ftdi_sio ttyUSB15: ftdi_write - length = 7, data = 31 34 33 30 34 0d 0a 
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write write returning: 7
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 31 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 31
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 30 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 30
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 29 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 29
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 28 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 28
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 23 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 23
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 22 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 22
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 21 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 21
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 20 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 20
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 19 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 19
Nov 17 16:44:35 localhost kernel: ehci_hcd 0000:00:0a.1: 9.2 detected XactErr len 0/7 retry 1
Nov 17 16:44:35 localhost kernel: ehci_hcd 0000:00:0a.1: devpath 9.2 ep4out 3strikes
Nov 17 16:44:35 localhost kernel: usb 1-9: clear tt buffer port 2, a12 ep4 t80078048
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 18 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 18
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 17 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 17
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_bulk_callback - port 15
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: nonzero write bulk status received: -71 countback: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 16 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 16
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 15 buffered: 7
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 15
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 14 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 14
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 13 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 13
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 12 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 12
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 31 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 31
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 30 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 30
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 29 buffered: 0
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_write_room - port 29
Nov 17 16:44:35 localhost kernel: /home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/serial/ftdi_sio.c: ftdi_chars_in_buffer - port 28 buffered: 0

Debugging diff attached for anyone who cares.


--=-=-=
Content-Disposition: attachment; filename=usb-debug.diff2

diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 8e67d5c..616ec99 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -26,7 +26,7 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
-#undef TTY_DEBUG_WAIT_UNTIL_SENT
+#define TTY_DEBUG_WAIT_UNTIL_SENT
 
 #undef	DEBUG
 
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 2494599..0766f1b 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -392,7 +392,7 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 	"%s detected XactErr len %zu/%zu retry %d\n",
 	qtd->urb->dev->devpath,
 	qtd->length - QTD_LENGTH(token), qtd->length, qh->xacterrs);
-
+#if 0
 					/* reset the token in the qtd and the
 					 * qh overlay (which still contains
 					 * the qtd) so that we pick up from
@@ -407,6 +407,7 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 					hw->hw_token = cpu_to_hc32(ehci,
 							token);
 					goto retry_xacterr;
+#endif
 				}
 				stopped = 1;
 
diff --git a/drivers/usb/serial/Makefile b/drivers/usb/serial/Makefile
index 66619be..194a1b7 100644
--- a/drivers/usb/serial/Makefile
+++ b/drivers/usb/serial/Makefile
@@ -55,4 +55,3 @@ obj-$(CONFIG_USB_SERIAL_TI)			+= ti_usb_3410_5052.o
 obj-$(CONFIG_USB_SERIAL_VISOR)			+= visor.o
 obj-$(CONFIG_USB_SERIAL_WHITEHEAT)		+= whiteheat.o
 obj-$(CONFIG_USB_SERIAL_XIRCOM)			+= keyspan_pda.o
-
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 9c60d6d..f9065a4 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1949,7 +1949,8 @@ static void ftdi_write_bulk_callback(struct urb *urb)
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
 	if (status) {
-		dbg("nonzero write bulk status received: %d", status);
+		dbg("nonzero write bulk status received: %d countback: %lu",
+			status, countback);
 		return;
 	}
 
@@ -1988,11 +1989,10 @@ static int ftdi_chars_in_buffer(struct tty_struct *tty)
 	int buffered;
 	unsigned long flags;
 
-	dbg("%s - port %d", __func__, port->number);
-
 	spin_lock_irqsave(&priv->tx_lock, flags);
 	buffered = (int)priv->tx_outstanding_bytes;
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
+	dbg("%s - port %d buffered: %d", __func__, port->number, buffered);
 	if (buffered < 0) {
 		dev_err(&port->dev, "%s outstanding tx bytes is negative!\n",
 			__func__);
@@ -2010,7 +2010,9 @@ static int ftdi_process_packet(struct tty_struct *tty,
 	char flag;
 	char *ch;
 
+#if 0
 	dbg("%s - port %d", __func__, port->number);
+#endif
 
 	if (len < 2) {
 		dbg("malformed packet");
@@ -2096,7 +2098,9 @@ static void ftdi_read_bulk_callback(struct urb *urb)
 	struct usb_serial_port *port = urb->context;
 	unsigned long flags;
 
+#if 0
 	dbg("%s - port %d", __func__, port->number);
+#endif
 
 	if (urb->status) {
 		dbg("%s - nonzero read bulk status received: %d",
@@ -2104,8 +2108,10 @@ static void ftdi_read_bulk_callback(struct urb *urb)
 		return;
 	}
 
+#if 0
 	usb_serial_debug_data(debug, &port->dev, __func__,
 				urb->actual_length, urb->transfer_buffer);
+#endif
 	ftdi_process_read(port);
 
 	spin_lock_irqsave(&port->lock, flags);
diff --git a/include/linux/usb.h b/include/linux/usb.h

--=-=-=--
