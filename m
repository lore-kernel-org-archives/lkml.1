Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZHCJhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZHCJhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZHCJhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:37:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32849 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751241AbZHCJhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:37:32 -0400
Date: Mon, 3 Aug 2009 10:37:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
Message-ID: <20090803103746.264c3acf@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by>
	<alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
	<20090802190514.GA3278@localdomain.by>
	<alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
	<87k51l9apo.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
	<20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I wonder if the hack is strictly necessary, or could perhaps at least be 
> moved down a bit. The comment around that area seems to imply there were 
> other issues ("will cause tty->count and state->count to go out of sync"), 
> and that whole tty->count thing is some seriously old code, and the tty 
> layer has changed a lot since 1992.

They will go out of sync for some hardware. Other stuff will get shut
down. 

> So I do get the feeling that it may be just old code that simply nobody 
> has dared remove - it may have made more sense back when then it does 
> now, and has just been carried around.

Alas not: eg

->hangup
uart_hangup
uart_flush_buffer
uart_shutdown
	drops carrier and dtr
	shuts down the port
	frees the IRQ handler
	kills off the transmit buffer & tasklet

whether the resulting mess happens to still work with printk rather
depends upon what ->ops->shutdown does. Even on x86 that will drop a
remote console if the carrier is being used so you won't see printk
messages after that point as you got a modem hangup.

A re-open as a device isn't a problem (we cleared ASYNCB_INITIALIZED) -
its the printk side that kills you, and someone is going to have to read
all the embedded device consoles as they are both the most likely to
break and most used 8(

> If it actually were to cause problems with the tty->count thing, I think 
> Sergey should have seen it thanks to us still doing that old 
> CHECK_TTY_COUNT thing.

Only if you get things like crossing open/close and the port bumps the
counts internally for console uses (where hangup will then set it to zero
and break). USB still does that but the last patches to USB also pushed
hangup/console awareness into USB a bit so it knows at the hardware level
not to shut down the console device entirely.

Alan
