Return-Path: <linux-kernel-owner+w=401wt.eu-S939286AbXG3JfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939286AbXG3JfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939301AbXG3Jeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:34:44 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:1554 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939288AbXG3Jel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:34:41 -0400
Date: Mon, 30 Jul 2007 10:34:36 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Robert Hancock <hancockr@shaw.ca>
cc: Lee Howard <faxguy@howardsilvan.com>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
In-Reply-To: <46AA3801.7090204@shaw.ca>
Message-ID: <Pine.LNX.4.64N.0707301023150.12082@blysk.ds.pg.gda.pl>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no> <46A84B4A.6070902@shaw.ca>
 <46A8C6F1.4080309@howardsilvan.com> <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
 <46AA2748.80703@howardsilvan.com> <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
 <46AA3801.7090204@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007, Robert Hancock wrote:

> > The TTY line discipline driver could do that based on the amount of received
> > data present in its buffer.  And it should if asked to (a brief look at
> > drivers/char/n_tty.c reveals it does; obviously there may be a bug 
> 
> Really, where? In my look through the code I haven't found any mechanism that
> would result in RTS being lowered based on TTY buffers filling up, at least
> not in the 8250 case.

 Look for calls to ->throttle() and ->unthrottle().  XON and XOFF might be 
used instead as a result of these calls though, depending on terminal 
settings.

> In this situation, though, it appears it's not the TTY buffers that are
> filling but the UART's own buffer. I would think this must be caused by some
> kind of interrupt latency that results in not draining the FIFO in time.

 Well, the UART only has its FIFO which is rather small, so automatic flow 
control would be useful.  Though, admittedly, tty_insert_flip_char() might 
return some kind of a status related to how much space is left in the 
receive buffer which would indicate that there is a lag in data stream 
processing -- which in turn may relate to the system being loaded, so that 
the receive ISR could decide whether to negate RTS itself for the less 
capable UARTs (i.e. ones with no autoflow and a tiny or no FIFO).

  Maciej
