Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410Ab0ASTqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0ASTqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216Ab0ASTqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:46:08 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39193 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab0ASTqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:46:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KemnbQWmqdEjYlskJhnIeNlgGsCpUEz1fviJvfuv2a/9DeejQ6nNfH7IdFOUbiMLa5
         VLmoY8S0vznBIxPxrOH4CYGtzPyknL+ZTdEwxbmtyq/eh7lGpmPCbNwgm808XW+pjWmd
         5eaGEi6PW8dZrBZkJAkztkOGLoJ2jUHjrN158=
Date: Tue, 19 Jan 2010 20:45:55 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Johan Hovold <jhovold@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
 writes" causes gobi_loader to hang
Message-ID: <20100119194555.GB21373@localhost>
References: <20100117025535.GB7045@srcf.ucam.org>
 <20100119152536.GA2104@localhost>
 <20100119162746.04ba6d9e@lxorguk.ukuu.org.uk>
 <201001191944.54622.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001191944.54622.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 07:44:54PM +0100, Oliver Neukum wrote:
> Am Dienstag, 19. Januar 2010 17:27:46 schrieb Alan Cox:
> > On Tue, 19 Jan 2010 16:25:36 +0100
> > Johan Hovold <jhovold@gmail.com> wrote:
> 
> > > Is it really a fix? If the fifo is already full the write urb should be
> > > in use and Oliver's patch would amount to only a minor optimisation as
> > > usb_serial_generic_write_start would return 0 anyway.
> > 
> > IF the write returns a zero then it will sleep in n_tty waiting for a
> > wakeup when the FIFO level drops sufficiently. If that isn't working
> > check that all cases where data is cleared from the FIFO called
> > tty_wakeup and do so *after* the FIFO has been partly emptied and the
> > locking has ensured the space is visible to the write side.
> > 
> usb_serial_generic_write_bulk_callback() always calls the softint
> in the single URB case. Therefore the test with the patch I sent.
> It is unlikely to be chance that the hang happens just as the FIFO
> is full.

But that is the correct behaviour: for every kfifo_get, exactly one urb
is submitted and on completion softint (tty_wake) is called. I guess we
could call softint from usb_serial_generic_write_start (after the
kfifo_get is made) but we would still have a 1-1 mapping.

In the log posted earlier everything looks fine with respect to fifo
put/get. What is apparent though is that the last write urb submitted
never completes (and consequently, the writing process is never woken).

And by the way, as the application in question is doing megabyte writes
at a time, isn't the fifo quite likely to be full most of the time?

/Johan

