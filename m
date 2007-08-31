Return-Path: <linux-kernel-owner+w=401wt.eu-S966311AbXHaVCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966311AbXHaVCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966019AbXHaVCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:02:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35498 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964849AbXHaVCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:02:35 -0400
Date: Fri, 31 Aug 2007 22:11:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Heads Up: Next Batch Of Serial/TTY Changes
Message-ID: <20070831221105.2fce9023@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Firstly some architecture maintainers still haven't updated their
platform for arbitary tty speeds. The kernel is going to start whining
and issuing warnings on your platform if you don't keep up with the
programme (its been 6 months).

Secondly a lot of driver level code for termios methods is very very wrong
indeed. I've been trawling through and fixing the USB stuff in part but
some of it will need maintainer attention once the next changes go in.

- The termios interface says that you hand back the actual mode you set.
This means that if your driver sets a different speed, can't do the
selected parity etc you *MUST* update the passed tty->termios to reflect
your hardware. Mostly this seems to be the lack of support for mark/space
parity but if you've got a very limited specialist device you may need to
write a lot more (indeed the empeg effectively writes the entire termios)

- If your hardware has no termios features don't provide a dummy handler
just don't provide one. In that case the kernel will (as of updates) do
the right thing and preserve the previous speed and other hardware
parameters while updating the software ones.

- We now support seperate input and output speeds. Hardware that does
this wants updating accordingly

- If your hardware is initializing termios structures or copying and
editing them itself it is responsible for encoding c_ispeed/c_ospeed.
Right now there are some hacks to do it for you if you forget in most
cases, they will go away.

- The new code will add two types of helper to deal with the more horrible
bits of all this

	tty_encode_baud_rate(tty, inputbaud, outputbaud)
	tty_termios_encode_baudrate(termios, inputbaud, outputbaud)

and also

	tty_termios_copy_hw(new, old)

which will copy all the hardware implemented bits and speed from old to
new, which may be useful if your hardware needs to copy the old state
over and implements very little.

The speed encoding routines know about Bfoo encoding, arbitary rates and
also provide error tolerances so that programs using the Bfoo style speed
setup generally get Bfoo not BOTHER responses. Please don't put hacks for
this in drivers - if a case breaks then let me know and I'll fix the
encoder centrally.

Once all this is in the kernel will then acquire correct POSIX semantics
and error the ioctl if no requested change can be made.

Next stop after that is likely to be the open/close/hangup path.

Alan
