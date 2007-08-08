Return-Path: <linux-kernel-owner+w=401wt.eu-S933533AbXHHCUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533AbXHHCUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 22:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbXHHCUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 22:20:37 -0400
Received: from perm68-235.ij.net ([209.216.68.235]:1483 "EHLO smirk.3gfp.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756617AbXHHCUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 22:20:36 -0400
Message-ID: <46B92869.4000400@3gfp.com>
Date: Tue, 07 Aug 2007 22:20:25 -0400
From: Harvey Chapman <hchapman-linux-kernel@3gfp.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial inter-character timeout usage with async io
References: <46B8F7FE.3090904@3gfp.com> <20070808021147.10d0e752@the-village.bc.nu>
In-Reply-To: <20070808021147.10d0e752@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> What are you actually trying to achieve ?

I'm trying to reduce the load on embedded systems running Linux and
using serial ports.

I'm trying to alleviate the following typical software scenario:

A Linux program is connected via serial port to some other serial device
using asynchronous I/O and the other serial device sends a 150 byte
sequence to the Linux program. The Linux program will receive 18
intermediate SIGIOs (one for each 8-byte threshold interrupt generated
by the UART) followed by 1 final inter-character timeout (when the UART
FIFO contains the last 6 bytes). The program upon each SIGIO would
read() 8 bytes and do some parsing of the data buffer and realize that
the whole sequence had not yet been received. Repeat 17 more times in
this example.

This doesn't change the Linux program code at all. It reduces the load.

> Firstly we don't want stuff with deep internal knowledge of devices as
> you'll have to modify and test something like 30 device drivers and it
> will rapidly be unmaintainable.

For reference:

IIR : Interrupt identification register (RO)

Bit 3	Bit 2	Bit 1	 	
0	0	0	Modem status change	MSR read
0	0	1	Transmitter holding register empty	IIR read or THR write
0	1	0	Received data available	RBR read
0	1	1	Line status change	LSR read
1	1	0	Character timeout (16550)	RBR read

I agree. However, the inter-character timeout is present (to the best of
my knowledge and google's) in all serial UARTs from the 16550A onward
(starting around 1994 and Windows 3.1). Before that, the IIR timeout
bit(3) was reserved and read 0. In addition, the two drivers modified,
8250.c and pxa.c are already using the inter-character timeout, they
just don't identify it specifically. In the ISRs, they simply check to
see if any of bits 1, 2, or 3 are set. In the example above, on the last
interrupt, the timeout bit(3) and the receive bit(2) would be set
causing a call to serial8250_handle_port(), but the ISR doesn't
(currently) care that it was the timeout that generated the last interrupt.


Some thoughts after writing that:
1. The ioctl should not allow the timeout mode to be set unless the UART
is a 16550A or newer.
2. The ioctl should have a way of determining if the driver supports the
timeout mode in its ISR. If it doesn't the user will sit and wait until
3,584 (4,096-512) bytes have been received. Definitely not the desired
effect, although that would only happen if the user enabled the timeout
mode on a non-supporting driver. This could be implemented with one
additional bit field (Note: I've been trying to minimize the code impact
for this timeout functionality in the hopes of making the changes more
palatable to maintainers).

I hope that has cleared up my motivation, and I'm going to make the
changes noted above to the patch.

Thanks,

Harvey

Further reading (if you're interested):
http://www.lammertbies.nl/comm/info/serial-uart.html#IIR
http://en.wikipedia.org/wiki/16550_UART
http://www.national.com/ds/PC/PC16550D.pdf
http://en.wikibooks.org/wiki/Serial_Programming:8250_UART_Programming

