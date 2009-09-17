Return-Path: <linux-kernel-owner+w=401wt.eu-S1751810AbZIQNRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbZIQNRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZIQNRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:17:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43775 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750788AbZIQNRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:17:43 -0400
Date: Thu, 17 Sep 2009 14:19:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb console,usb-serial: pass initial console baud
 on to first tty open
Message-ID: <20090917141913.47f9451b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090917140828.21341c05@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.0909162344350.24376-100000@netrider.rowland.org>
	<4AB1B860.4080105@windriver.com>
	<20090917101441.478b3e9b@lxorguk.ukuu.org.uk>
	<4AB22892.8000308@windriver.com>
	<20090917140828.21341c05@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 14:08:28 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> 
> > -			memset(&dummy, 0, sizeof(struct ktermios));
> > -			tty->termios = termios;
> > +			tty->termios = &usb_serial_tty_driver->init_termios;
> 
> That will corrupt the master one which is a reference used for many ports.
> 
> 
> You need the serial_install stuff or something similar resurrecting to do
> this properly.

Here's a suggestion on how to do it.

Add a tty->ops->init_termios()

Make tty_init_termios() read

       if (tp == NULL) {
                tp = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
                if (tp == NULL)
                        return -ENOMEM;
                memcpy(tp, &tty->driver->init_termios,
                                                sizeof(struct ktermios));
		if (tty->ops->init_termios)
			tty->ops->init_termios(tty);
                tty->driver->termios[idx] = tp;
        }

Thats a good deal cleaner than the ->install override in the USB patches
Greg inherited and will be usable for cleaning up USB stuff too.

