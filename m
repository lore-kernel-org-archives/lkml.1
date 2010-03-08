Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab0CHSvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 13:51:07 -0500
Received: from mail.windriver.com ([147.11.1.11]:56193 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab0CHSu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 13:50:57 -0500
Message-ID: <4B9546F6.6070901@windriver.com>
Date: Mon, 08 Mar 2010 12:50:30 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb-serial: Fix usb serial console open/close regression
References: <1268061698-9846-1-git-send-email-jason.wessel@windriver.com><Pine.LNX.4.44L0.1003081028400.1596-100000@iolanthe.rowland.org> <20100308174027.59284ba4@lxorguk.ukuu.org.uk>
In-Reply-To: <20100308174027.59284ba4@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2010 18:50:29.0999 (UTC) FILETIME=[3985F7F0:01CABEF0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> This is a little unfortunate.  It would be better to prevent
>> tty_port_shutdown() from clearing ASYNCB_INITIALIZED in the first
>> place.  The problem is that the tty core doesn't know when the port is
>> being used as a console.  There ought to be a way to tell it.
> 
> Agreed - there should probably be a port.console flag to push it up into
> the tty_port logic as well.
> 


Alan, are you thinking about something like the patch one listed below?

That led me to wonder if we additionally want to remove the ->console
semi-private variable from the usb-serial port struct. I tested that
and included a patch here as well as an RFC.

If we come to agreement I'll send new patches with appropriate
patch headers.

Thanks,
Jason.


----- PATCH ONE STARTS HERE-----

---
 drivers/char/tty_port.c      |    2 +-
 drivers/usb/serial/console.c |    1 +
 include/linux/serial.h       |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -119,7 +119,7 @@ EXPORT_SYMBOL(tty_port_tty_set);
 static void tty_port_shutdown(struct tty_port *port)
 {
 	mutex_lock(&port->mutex);
-	if (port->ops->shutdown &&
+	if (port->ops->shutdown && !test_bit(ASYNCB_CONSOLE, &port->flags) &&
 		test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags))
 			port->ops->shutdown(port);
 	mutex_unlock(&port->mutex);
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -132,6 +132,7 @@ struct serial_uart_config {
 #define ASYNCB_CONS_FLOW	23 /* flow control for console  */
 #define ASYNCB_BOOT_ONLYMCA	22 /* Probe only if MCA bus */
 #define ASYNCB_FIRST_KERNEL	22
+#define ASYNCB_CONSOLE		21 /* Serial port is console */
 
 #define ASYNC_HUP_NOTIFY	(1U << ASYNCB_HUP_NOTIFY)
 #define ASYNC_SUSPENDED		(1U << ASYNCB_SUSPENDED)
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -181,6 +181,7 @@ static int usb_console_setup(struct cons
 	/* The console is special in terms of closing the device so
 	 * indicate this port is now acting as a system console. */
 	port->console = 1;
+	set_bit(ASYNCB_CONSOLE, &port->port.flags);
 
 	mutex_unlock(&serial->disc_mutex);
 	return retval;


----- PART TWO STARTS HERE -----

Remove the console variable from the usb serial private data.

---
 drivers/usb/serial/console.c    |    5 ++---
 drivers/usb/serial/ftdi_sio.c   |    3 ++-
 drivers/usb/serial/generic.c    |    4 ++--
 drivers/usb/serial/pl2303.c     |    3 ++-
 drivers/usb/serial/usb-serial.c |    4 ++--
 include/linux/usb/serial.h      |    2 --
 6 files changed, 10 insertions(+), 11 deletions(-)

--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -66,7 +66,6 @@ enum port_dev_state {
  * @work: work queue entry for the line discipline waking up.
  * @throttled: nonzero if the read urb is inactive to throttle the device
  * @throttle_req: nonzero if the tty wants to throttle us
- * @console: attached usb serial console
  * @dev: pointer to the serial device
  *
  * This structure is used by the usb-serial core and drivers for the specific
@@ -106,7 +105,6 @@ struct usb_serial_port {
 	struct work_struct	work;
 	char			throttled;
 	char			throttle_req;
-	char			console;
 	unsigned long		sysrq; /* sysrq timeout */
 	struct device		dev;
 	enum port_dev_state	dev_state;
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -180,7 +180,6 @@ static int usb_console_setup(struct cons
 	--port->port.count;
 	/* The console is special in terms of closing the device so
 	 * indicate this port is now acting as a system console. */
-	port->console = 1;
 	set_bit(ASYNCB_CONSOLE, &port->port.flags);
 
 	mutex_unlock(&serial->disc_mutex);
@@ -217,7 +216,7 @@ static void usb_console_write(struct con
 
 	dbg("%s - port %d, %d byte(s)", __func__, port->number, count);
 
-	if (!port->console) {
+	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		dbg("%s - port not opened", __func__);
 		return;
 	}
@@ -313,7 +312,7 @@ void usb_serial_console_exit(void)
 {
 	if (usbcons_info.port) {
 		unregister_console(&usbcons);
-		usbcons_info.port->console = 0;
+		clear_bit(ASYNCB_CONSOLE, &usbcons_info.port->port.flags);
 		usbcons_info.port = NULL;
 	}
 }
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2073,7 +2073,8 @@ static int ftdi_process_packet(struct tt
 		return 0;	/* status only */
 	ch = packet + 2;
 
-	if (!(port->console && port->sysrq) && flag == TTY_NORMAL)
+	if (!(test_bit(ASYNCB_INITIALIZED, &port->port.flags) &&
+	      port->sysrq) && flag == TTY_NORMAL)
 		tty_insert_flip_string(tty, ch, len);
 	else {
 		for (i = 0; i < len; i++, ch++) {
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -437,7 +437,7 @@ static void flush_and_resubmit_read_urb(
 	/* The per character mucking around with sysrq path it too slow for
 	   stuff like 3G modems, so shortcircuit it in the 99.9999999% of cases
 	   where the USB serial is not a console anyway */
-	if (!port->console || !port->sysrq)
+	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags) || !port->sysrq)
 		tty_insert_flip_string(tty, ch, urb->actual_length);
 	else {
 		/* Push data to tty */
@@ -556,7 +556,7 @@ void usb_serial_generic_unthrottle(struc
 int usb_serial_handle_sysrq_char(struct tty_struct *tty,
 			struct usb_serial_port *port, unsigned int ch)
 {
-	if (port->sysrq && port->console) {
+	if (port->sysrq && test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		if (ch && time_before(jiffies, port->sysrq)) {
 			handle_sysrq(ch, tty);
 			port->sysrq = 0;
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -1056,7 +1056,8 @@ static void pl2303_push_data(struct tty_
 	if (line_status & UART_OVERRUN_ERROR)
 		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 
-	if (tty_flag == TTY_NORMAL && !(port->console && port->sysrq))
+	if (tty_flag == TTY_NORMAL &&
+	    !(test_bit(ASYNCB_INITIALIZED, &port->port.flags) && port->sysrq))
 		tty_insert_flip_string(tty, data, urb->actual_length);
 	else {
 		int i;
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -289,7 +289,7 @@ static void serial_down(struct tty_port 
 	 * The console is magical.  Do not hang up the console hardware
 	 * or there will be tears.
 	 */
-	if (port->console)
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 		return;
 	if (drv->close)
 		drv->close(port);
@@ -328,7 +328,7 @@ static void serial_cleanup(struct tty_st
 	/* The console is magical.  Do not hang up the console hardware
 	 * or there will be tears.
 	 */
-	if (port->console)
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 		return;
 
 	dbg("%s - port %d", __func__, port->number);
