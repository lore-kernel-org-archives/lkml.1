Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZGUQ1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZGUQ1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbZGUQ1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:27:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41031 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755448AbZGUQ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:27:36 -0400
Date: Tue, 21 Jul 2009 17:28:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Mack <daniel@caiaq.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090721172841.36b20638@lxorguk.ukuu.org.uk>
In-Reply-To: <20090721161928.GD13236@buzzloop.caiaq.de>
References: <20090721004531.1036d9af@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0907211141180.2652-100000@iolanthe.rowland.org>
	<20090721171625.6e2c54e4@lxorguk.ukuu.org.uk>
	<20090721161928.GD13236@buzzloop.caiaq.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It was, at least in my case. Did some printk debugging and it showed
> that the hangup callback was entered what freed the serial device.

Ok 
> 
> > > This is only a lockdep warning, and I don't understand its
> > > significance.  Even worse, when I plugged in a USB flash drive
> > > afterward this appeared:
> > 
> > Looks like something freed the resources but didn't hang up when the
> > disconnect occurred
> 
> Probably the real fix would be to let the tty layer know the device died
> from the hangup handler.

The hangup event means the physical hardware must no longer be touched so
that's already the case and we use it for a lot of things (from ISAPnP to
PCMCIA to USB).

The USB code does slightly misimplement it - it calls tty_hangup() in
usb_serial_disconnect when it should call tty_vhangup() as it needs the
event to be synchronous. That is the hangup of the tty should be done
before the USB layer can sneak off and free stuff.

I don't at this point see that as explaining the bug however
