Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbXG1J3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbXG1J3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 05:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbXG1J3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 05:29:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35511 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbXG1J3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 05:29:09 -0400
Date: Sat, 28 Jul 2007 10:28:42 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Lee Howard <faxguy@howardsilvan.com>, linux-serial@vger.kernel.org,
       tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
Message-ID: <20070728092842.GC26443@flint.arm.linux.org.uk>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no> <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com> <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl> <46AA2748.80703@howardsilvan.com> <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl> <46AA3801.7090204@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AA3801.7090204@shaw.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 12:22:57PM -0600, Robert Hancock wrote:
> Maciej W. Rozycki wrote:
> > The TTY line discipline driver could do that based on the amount of 
> >received data present in its buffer.  And it should if asked to (a brief 
> >look at drivers/char/n_tty.c reveals it does; obviously there may be a bug 
> 
> Really, where? In my look through the code I haven't found any mechanism 
> that would result in RTS being lowered based on TTY buffers filling up, 
> at least not in the 8250 case.

That's something for the line discipline to decide.

> In this situation, though, it appears it's not the TTY buffers that are 
> filling but the UART's own buffer. I would think this must be caused by 
> some kind of interrupt latency that results in not draining the FIFO in 
> time.

Correct, and suggested approach to tracking down the culpret has been
mentioned in a previous email.

Also note that there's nothing the serial driver can do to detect this
condition before it occurs.  The problem occurs because the serial driver
is starved of CPU time due to other parts of the system, and the driver
has precisely zero knowledge as to when that's going to happen.

There are two possible scenarios when such starvation can occur:

1. interrupts are disabled for a long period.
2. the serial interrupt has started to run, but has been interrupted
   by _another_ interrupt which runs for a long period.

Essentially, any complex interrupt handler (such as an IDE interrupt
doing a multi-sector PIO transfer _in interrupt context_) can cause this
kind of starvation.  That's why Linux 1.x had bottom halves - so that
the time consuming work could be moved out of the interrupt handler,
thereby causing minimal the blockage of other interrupts.

Unfortunately, that kind of design has been long since forgotten.
Apparantly modern machines are fast enough that it doesn't have to be
worried about anymore...  Or are they?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
