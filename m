Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYK0Obk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYK0Obk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYK0Ob3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:31:29 -0500
Received: from mout-bounce.kundenserver.de ([212.227.17.2]:51604 "EHLO
	mout-bounce.kundenserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520AbYK0Ob0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:31:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] usb/serial: Add compat_ioctl pass-through
Date: Thu, 27 Nov 2008 15:31:18 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
References: <1227774576-5503-1-git-send-email-keithp@keithp.com>
In-Reply-To: <1227774576-5503-1-git-send-email-keithp@keithp.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-15?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-15?q?Y=2Ea=5E3zb?=)
 =?iso-8859-15?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-15?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811271531.18498.arnd@arndb.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1+jgfVG4YRyG41iMjeWPROMLQuyVG9t6tgWJug
 rrzpjlN0EP9wrQI3HdIpEYy5YX7PCtnNh/iYfDLUaYxeqadkHO
 W0+qfSt8ayMrOPi3ZBrUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2008, Keith Packard wrote:
> +static long serial_compat_ioctl(struct tty_struct *tty, struct file *file,
> +                              unsigned int cmd, unsigned long arg)
> +{
> +       struct usb_serial_port *port = tty->driver_data;
> +       long retval = -ENODEV;
> +
> +       dbg("%s - port %d, cmd 0x%.4x", __func__, port->number, cmd);
> +
> +       WARN_ON(!port->port.count);
> +
> +       /* pass on to the driver specific version of this function
> +          if it is available */
> +       if (port->serial->type->compat_ioctl) {
> +               lock_kernel();
> +               retval = port->serial->type->compat_ioctl(tty, file, cmd, arg);
> +               unlock_kernel(); 

By convention, compat_ioctl functions should be called without the big kernel
lock held.

The usb-serial driver all still need to be converted to have their
ioctl function called without bkl.

> --- a/include/linux/usb/serial.h
> +++ b/include/linux/usb/serial.h
> @@ -228,6 +228,8 @@ struct usb_serial_driver {
>         int  (*write_room)(struct tty_struct *tty);
>         int  (*ioctl)(struct tty_struct *tty, struct file *file,
>                       unsigned int cmd, unsigned long arg);
> +       long  (*compat_ioctl)(struct tty_struct *tty, struct file *file,
> +                             unsigned int cmd, unsigned long arg);
>         void (*set_termios)(struct tty_struct *tty,
>                         struct usb_serial_port *port, struct ktermios *old);
>         void (*break_ctl)(struct tty_struct *tty, int break_state);

You should probably define compat_ioctl to return an int as well
so that it becomes possible to use the same function for both eventually.
Then again, we can also drop the file argument, which is entirely unused
in all the usb-serial ioctls.
Maybe the best way for now is to make the new compat_ioctl be
int compat_ioctl(struct tty_struct, unsigned int cmd, unsigned long arg);
and leave the old ioctl as it is. When we get around to pushing the
BKL down into ->ioctl, we can change the prototype at the same time
to warn potential out-of-tree drivers.

	Arnd <><
