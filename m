Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZI1GHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZI1GHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 02:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZI1GHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 02:07:40 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46936 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751031AbZI1GHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 02:07:39 -0400
Date: Mon, 28 Sep 2009 02:07:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dave Young <hidave.darkstar@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH, fix] Re: [Regression] 2.6.31-git: tty change
  broke resume from hibernation on MSI Wind U100
In-Reply-To: <a8e1da0909272203me287858y2f8d82f3710e07d3@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0909280202280.14348-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009, Dave Young wrote:

> On Mon, Sep 28, 2009 at 2:16 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday 27 September 2009, Alan Stern wrote:
> >> On Sun, 27 Sep 2009, Rafael J. Wysocki wrote:
> >>
> >> > Tested, works.
> >> >
> >> > Greg, could you please consider taking the patch below?  It fixes a recent
> >> > hibernation regression for me, so if not this one, another fix is necessary.
> >>
> >> This patch has a mistake.
> >>
> >> > Index: linux-2.6/drivers/usb/serial/usb-serial.c
> >> > ===================================================================
> >> > --- linux-2.6.orig/drivers/usb/serial/usb-serial.c
> >> > +++ linux-2.6/drivers/usb/serial/usb-serial.c
> >> > @@ -1210,7 +1210,7 @@ static const struct tty_operations seria
> >> >     .chars_in_buffer =      serial_chars_in_buffer,
> >> >     .tiocmget =             serial_tiocmget,
> >> >     .tiocmset =             serial_tiocmset,
> >> > -   .shutdown =             serial_release,
> >> > +   .cleanup =              serial_release,
> >> >     .install =              serial_install,
> >> >     .proc_fops =            &serial_proc_fops,
> >> >  };
> >>
> >> It isn't enough to change the method pointer.  The code in
> >> serial_release() has to be changed too; it must not call tty_shutdown()
> >> any more.
> >
> > Would it be sufficient to remove the tty_shutdown() call from
> > serial_release()?
> 
> I think so, because standard shutdown will be called in queue_release_one_tty.
> 
> Alan, could you confirm about this?  Thus I'd like to update the patch.

Yes, that's right.  Just remove the function call.  But what happens if
the device is a serial console?  Shouldn't the call to tty_shutdown()  
be skipped in that case?  (Eventually this won't matter; the console
code will be straightened out so that we never release a serial console
device.  But for now it's important.)

If you think it would be appropriate, you could also rename
serial_release() to serial_cleanup() -- it's up to you.

Alan Stern

