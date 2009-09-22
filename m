Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZIVUyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZIVUyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 16:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZIVUyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 16:54:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:54501 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZIVUys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 16:54:48 -0400
Message-ID: <4AB93983.5070404@windriver.com>
Date: Tue, 22 Sep 2009 15:54:27 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb console,usb-serial: pass initial console baud
 on to first tty open
References: <Pine.LNX.4.44L0.0909162344350.24376-100000@netrider.rowland.org><4AB1B860.4080105@windriver.com><20090917101441.478b3e9b@lxorguk.ukuu.org.uk><4AB22892.8000308@windriver.com><20090917140828.21341c05@lxorguk.ukuu.org.uk><20090917141913.47f9451b@lxorguk.ukuu.org.uk><4AB244E0.1060109@windriver.com> <20090917170233.61eecc4f@lxorguk.ukuu.org.uk>
In-Reply-To: <20090917170233.61eecc4f@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Sep 2009 20:54:29.0716 (UTC) FILETIME=[E0F47140:01CA3BC6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> 
> I think the console should probably have a ktermios structure and that is
> something which in future could become more generic (arguably in a saner
> world the termios would belong to the tty_port in the end as and when
> everything is a tty port - which would make a whole ton of things a lot
> lot more logical)


What about something like the patch shown below?

I did come up with a question.  I was curious where you envisioned the kfree() for the ktermios allocated in the usb serial?

Perhaps we don't care because it will never go away but I don't want to add a memory leak.  Another option would to make the termios in the struct console not be a pointer, but that obviously makes the structure a bit bigger.  Did you have a suggestion?

Thanks,
Jason.


---
 drivers/char/tty_io.c           |    2 ++
 drivers/usb/serial/console.c    |   25 +++++++++++++------------
 drivers/usb/serial/usb-serial.c |   15 +++++++++++++--
 include/linux/console.h         |    1 +
 include/linux/tty_driver.h      |    1 +
 include/linux/usb/serial.h      |    2 +-
 6 files changed, 31 insertions(+), 15 deletions(-)

--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -66,7 +66,7 @@ static int usb_console_setup(struct cons
 	struct usb_serial_port *port;
 	int retval;
 	struct tty_struct *tty = NULL;
-	struct ktermios *termios = NULL, dummy;
+	struct ktermios dummy;
 
 	dbg("%s", __func__);
 
@@ -141,14 +141,17 @@ static int usb_console_setup(struct cons
 				goto reset_open_count;
 			}
 			kref_init(&tty->kref);
-			termios = kzalloc(sizeof(*termios), GFP_KERNEL);
-			if (!termios) {
+
+			if (!co->termios)
+				co->termios = kzalloc(sizeof(struct ktermios),
+						      GFP_KERNEL);
+			if (!co->termios) {
 				retval = -ENOMEM;
 				err("no more memory");
 				goto free_tty;
 			}
 			memset(&dummy, 0, sizeof(struct ktermios));
-			tty->termios = termios;
+			tty->termios = co->termios;
 			tty_port_tty_set(&port->port, tty);
 		}
 
@@ -161,16 +164,15 @@ static int usb_console_setup(struct cons
 
 		if (retval) {
 			err("could not open USB console port");
-			goto free_termios;
+			goto free_port;
 		}
 
 		if (serial->type->set_termios) {
-			termios->c_cflag = cflag;
-			tty_termios_encode_baud_rate(termios, baud, baud);
+			co->termios->c_cflag = cflag;
+			tty_termios_encode_baud_rate(co->termios, baud, baud);
 			serial->type->set_termios(tty, port, &dummy);
 
 			tty_port_tty_set(&port->port, NULL);
-			kfree(termios);
 			kfree(tty);
 		}
 		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
@@ -180,13 +182,12 @@ static int usb_console_setup(struct cons
 	--port->port.count;
 	/* The console is special in terms of closing the device so
 	 * indicate this port is now acting as a system console. */
-	port->console = 1;
+	port->console = co;
 
 	mutex_unlock(&serial->disc_mutex);
 	return retval;
 
- free_termios:
-	kfree(termios);
+ free_port:
 	tty_port_tty_set(&port->port, NULL);
  free_tty:
 	kfree(tty);
@@ -312,7 +313,7 @@ void usb_serial_console_exit(void)
 {
 	if (usbcons_info.port) {
 		unregister_console(&usbcons);
-		usbcons_info.port->console = 0;
+		usbcons_info.port->console = NULL;
 		usbcons_info.port = NULL;
 	}
 }
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -104,6 +104,7 @@ struct console {
 	short	flags;
 	short	index;
 	int	cflag;
+	struct ktermios *termios;
 	void	*data;
 	struct	 console *next;
 };
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1175,6 +1175,8 @@ int tty_init_termios(struct tty_struct *
 		memcpy(tp, &tty->driver->init_termios,
 						sizeof(struct ktermios));
 		tty->driver->termios[idx] = tp;
+		if (tty->ops->init_termios)
+			tty->ops->init_termios(tty);
 	}
 	tty->termios = tp;
 	tty->termios_locked = tp + 1;
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -259,6 +259,7 @@ struct tty_operations {
 			unsigned int set, unsigned int clear);
 	int (*resize)(struct tty_struct *tty, struct winsize *ws);
 	int (*set_termiox)(struct tty_struct *tty, struct termiox *tnew);
+	void (*init_termios)(struct tty_struct *tty);
 #ifdef CONFIG_CONSOLE_POLL
 	int (*poll_init)(struct tty_driver *driver, int line, char *options);
 	int (*poll_get_char)(struct tty_driver *driver, int line);
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -35,6 +35,7 @@
 #include <linux/serial.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/console.h>
 #include "pl2303.h"
 
 /*
@@ -212,6 +213,7 @@ static int serial_install(struct tty_dri
 	if (!try_module_get(serial->type->driver.owner))
 		goto error_module_get;
 
+	tty->driver_data = port;
 	/* perform the standard setup */
 	retval = tty_init_termios(tty);
 	if (retval)
@@ -227,8 +229,6 @@ static int serial_install(struct tty_dri
 	if (serial->type->init_termios)
 		serial->type->init_termios(tty);
 
-	tty->driver_data = port;
-
 	/* Final install (we use the default method) */
 	tty_driver_kref_get(driver);
 	tty->count++;
@@ -237,6 +237,7 @@ static int serial_install(struct tty_dri
 
  error_get_interface:
  error_init_termios:
+	tty->driver_data = NULL;
 	module_put(serial->type->driver.owner);
  error_module_get:
  error_no_port:
@@ -245,6 +246,15 @@ static int serial_install(struct tty_dri
 	return retval;
 }
 
+static void serial_init_termios(struct tty_struct *tty)
+{
+	struct usb_serial_port *port = tty->driver_data;
+
+	if (port->console && port->console->termios)
+		memcpy(tty->driver->termios[tty->index],
+		       port->console->termios, sizeof(struct ktermios));
+}
+
 static int serial_open(struct tty_struct *tty, struct file *filp)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -1202,6 +1212,7 @@ static const struct tty_operations seria
 	.shutdown = 		serial_release,
 	.install = 		serial_install,
 	.proc_fops =		&serial_proc_fops,
+	.init_termios =		serial_init_termios,
 };
 
 
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -106,7 +106,7 @@ struct usb_serial_port {
 	struct work_struct	work;
 	char			throttled;
 	char			throttle_req;
-	char			console;
+	struct console		*console;
 	unsigned long		sysrq; /* sysrq timeout */
 	struct device		dev;
 	enum port_dev_state	dev_state;
