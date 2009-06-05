Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbZFEFex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbZFEFex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZFEFeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:34:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58224 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZFEFep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:34:45 -0400
Date: Fri, 5 Jun 2009 15:34:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Craig Shelley <craig@microtron.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: linux-next: manual merge of the usb tree with the ttydev tree
Message-Id: <20090605153445.291acd58.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/serial/cp210x.c between commit
7219905ae9bb14e9c8f7a7ab434b70363b904a7c ("cp210x-func-renames") from the
ttydev tree and commit 8a5870836006ec7dd112082a39e0057b49e5bd91 ("USB:
usb-serial: replace shutdown with disconnect, release") from the usb tree.

I love churn!  :-)

I fixed this up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/serial/cp210x.c
index 16a154d,cf5093f..0000000
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@@ -33,24 -33,25 +33,24 @@@
  /*
   * Function Prototypes
   */
 -static int cp2101_open(struct tty_struct *, struct usb_serial_port *,
 +static int cp210x_open(struct tty_struct *, struct usb_serial_port *,
  							struct file *);
 -static void cp2101_cleanup(struct usb_serial_port *);
 -static void cp2101_close(struct tty_struct *, struct usb_serial_port *,
 -							struct file*);
 -static void cp2101_get_termios(struct tty_struct *,
 +static void cp210x_cleanup(struct usb_serial_port *);
 +static void cp210x_close(struct usb_serial_port *);
 +static void cp210x_get_termios(struct tty_struct *,
  	struct usb_serial_port *port);
 -static void cp2101_get_termios_port(struct usb_serial_port *port,
 +static void cp210x_get_termios_port(struct usb_serial_port *port,
  	unsigned int *cflagp, unsigned int *baudp);
 -static void cp2101_set_termios(struct tty_struct *, struct usb_serial_port *,
 +static void cp210x_set_termios(struct tty_struct *, struct usb_serial_port *,
  							struct ktermios*);
 -static int cp2101_tiocmget(struct tty_struct *, struct file *);
 -static int cp2101_tiocmset(struct tty_struct *, struct file *,
 +static int cp210x_tiocmget(struct tty_struct *, struct file *);
 +static int cp210x_tiocmset(struct tty_struct *, struct file *,
  		unsigned int, unsigned int);
 -static int cp2101_tiocmset_port(struct usb_serial_port *port, struct file *,
 +static int cp210x_tiocmset_port(struct usb_serial_port *port, struct file *,
  		unsigned int, unsigned int);
 -static void cp2101_break_ctl(struct tty_struct *, int);
 -static int cp2101_startup(struct usb_serial *);
 -static void cp2101_disconnect(struct usb_serial *);
 +static void cp210x_break_ctl(struct tty_struct *, int);
 +static int cp210x_startup(struct usb_serial *);
- static void cp210x_shutdown(struct usb_serial *);
++static void cp210x_disconnect(struct usb_serial *);
  
  static int debug;
  
@@@ -122,22 -116,22 +122,22 @@@ static struct usb_driver cp210x_driver 
  	.no_dynamic_id	= 	1,
  };
  
 -static struct usb_serial_driver cp2101_device = {
 +static struct usb_serial_driver cp210x_device = {
  	.driver = {
  		.owner =	THIS_MODULE,
 -		.name = 	"cp2101",
 +		.name = 	"cp210x",
  	},
 -	.usb_driver		= &cp2101_driver,
 +	.usb_driver		= &cp210x_driver,
  	.id_table		= id_table,
  	.num_ports		= 1,
 -	.open			= cp2101_open,
 -	.close			= cp2101_close,
 -	.break_ctl		= cp2101_break_ctl,
 -	.set_termios		= cp2101_set_termios,
 -	.tiocmget 		= cp2101_tiocmget,
 -	.tiocmset		= cp2101_tiocmset,
 -	.attach			= cp2101_startup,
 -	.disconnect		= cp2101_disconnect,
 +	.open			= cp210x_open,
 +	.close			= cp210x_close,
 +	.break_ctl		= cp210x_break_ctl,
 +	.set_termios		= cp210x_set_termios,
 +	.tiocmget 		= cp210x_tiocmget,
 +	.tiocmset		= cp210x_tiocmset,
 +	.attach			= cp210x_startup,
- 	.shutdown		= cp210x_shutdown,
++	.disconnect		= cp210x_disconnect,
  };
  
  /* Config request types */
@@@ -792,7 -773,7 +792,7 @@@ static int cp210x_startup(struct usb_se
  	return 0;
  }
  
- static void cp210x_shutdown(struct usb_serial *serial)
 -static void cp2101_disconnect(struct usb_serial *serial)
++static void cp210x_disconnect(struct usb_serial *serial)
  {
  	int i;
  
