Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbZIQMQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbZIQMQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbZIQMQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:16:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:41896 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110AbZIQMQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:16:29 -0400
Message-ID: <4AB22892.8000308@windriver.com>
Date: Thu, 17 Sep 2009 07:16:18 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb console,usb-serial: pass initial console baud
 on to first tty open
References: <Pine.LNX.4.44L0.0909162344350.24376-100000@netrider.rowland.org><4AB1B860.4080105@windriver.com> <20090917101441.478b3e9b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090917101441.478b3e9b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2009 12:16:18.0149 (UTC) FILETIME=[A8DF1150:01CA3790]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> It looked like the API for the tty subsystem was gradually changing such
>> that the ldisc structure could ultimately get shared for use with the
>> console, but this work is not complete, so we are somewhere in between.
> 
> The mechanics of this are already there. A tty drive can manage its own
> termios structs, and the termios structs are pointers in the tty structure
> 
>> The question is what is an acceptable solution?
> 
> Take a look at usb_serial.c:serial_install. You can do the console state
> preservation there and cleanly.
> 


Thanks for the pointer Alan.  That solves the termios initialization
piece nicely.

In the usb git tree the serial_install() got removed, but I can see
the init_termios structure that gets setup in usb_serial_init().


The patch will look something like the code below, but we have to sort
out the patch tree with Alan Stern's changes to usb/serial/console.c.

Thanks,
Jason.


Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 drivers/usb/serial/console.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -65,7 +65,7 @@ static int usb_console_setup(struct cons
 	struct usb_serial_port *port;
 	int retval = 0;
 	struct tty_struct *tty = NULL;
-	struct ktermios *termios = NULL, dummy;
+	struct ktermios dummy;
 
 	dbg("%s", __func__);
 
@@ -136,14 +136,7 @@ static int usb_console_setup(struct cons
 				goto reset_open_count;
 			}
 			kref_init(&tty->kref);
-			termios = kzalloc(sizeof(*termios), GFP_KERNEL);
-			if (!termios) {
-				retval = -ENOMEM;
-				err("no more memory");
-				goto free_tty;
-			}
-			memset(&dummy, 0, sizeof(struct ktermios));
-			tty->termios = termios;
+			tty->termios = &usb_serial_tty_driver->init_termios;
 			tty_port_tty_set(&port->port, tty);
 		}
 
@@ -156,16 +149,15 @@ static int usb_console_setup(struct cons
 
 		if (retval) {
 			err("could not open USB console port");
-			goto free_termios;
+			goto clear_port_tty_set;
 		}
 
 		if (serial->type->set_termios) {
-			termios->c_cflag = cflag;
-			tty_termios_encode_baud_rate(termios, baud, baud);
+			tty->termios->c_cflag = cflag;
+			tty_termios_encode_baud_rate(tty->termios, baud, baud);
 			serial->type->set_termios(tty, port, &dummy);
 
 			tty_port_tty_set(&port->port, NULL);
-			kfree(termios);
 			kfree(tty);
 		}
 	}
@@ -180,13 +172,11 @@ static int usb_console_setup(struct cons
 
 out:
 	return retval;
-free_termios:
-	kfree(termios);
+clear_port_tty_set:
 	tty_port_tty_set(&port->port, NULL);
-free_tty:
 	kfree(tty);
 reset_open_count:
-	port->port.count = 0;
+	--port->port.count;
 	goto out;
 }
 
