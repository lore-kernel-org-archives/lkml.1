Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418Ab0ASQZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab0ASQZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 11:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029Ab0ASQZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 11:25:43 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51684 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932067Ab0ASQZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 11:25:43 -0500
Date: Tue, 19 Jan 2010 16:27:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Johan Hovold <jhovold@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
 writes" causes gobi_loader to hang
Message-ID: <20100119162746.04ba6d9e@lxorguk.ukuu.org.uk>
In-Reply-To: <20100119152536.GA2104@localhost>
References: <20100117025535.GB7045@srcf.ucam.org>
	<201001191420.29652.oliver@neukum.org>
	<20100119132934.0c1688f7@lxorguk.ukuu.org.uk>
	<201001191457.00504.oliver@neukum.org>
	<20100119142657.02856d15@lxorguk.ukuu.org.uk>
	<20100119152536.GA2104@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010 16:25:36 +0100
Johan Hovold <jhovold@gmail.com> wrote:

> > > The log shows no call to usb_serial_generic_write_room()
> > > Do you consider this a bug in the tty layer?
> > 
> > Actually this all makes sense because of where it was hanging. A reply of
> > 0 to the tty->ops->write will cause it to either return (O_NONBLOCK) or
> > sleep in the n_tty write code waiting for a write_wait wakeup
> > (tty_wakeup(tty))
> > 
> > So the fix does indeed look correct.
> 
> Is it really a fix? If the fifo is already full the write urb should be
> in use and Oliver's patch would amount to only a minor optimisation as
> usb_serial_generic_write_start would return 0 anyway.

IF the write returns a zero then it will sleep in n_tty waiting for a
wakeup when the FIFO level drops sufficiently. If that isn't working
check that all cases where data is cleared from the FIFO called
tty_wakeup and do so *after* the FIFO has been partly emptied and the
locking has ensured the space is visible to the write side.
