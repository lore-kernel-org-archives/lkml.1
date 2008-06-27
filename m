Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbYF0NtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbYF0NtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYF0Ns6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:48:58 -0400
Received: from csclub.uwaterloo.ca ([129.97.134.17]:38949 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753624AbYF0Ns5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:48:57 -0400
Date: Fri, 27 Jun 2008 09:48:56 -0400
To: Sergey Lapin <slapinid@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Half-duplex rs-485 on full-duplex UART.
Message-ID: <20080627134856.GB31126@csclub.uwaterloo.ca>
References: <48239d390806261343y6bafbefap6cdaaecaf1969a89@mail.gmail.com> <48239d390806261356m57acbe4er4dd3d928c1493b88@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48239d390806261356m57acbe4er4dd3d928c1493b88@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 12:56:26AM +0400, Sergey Lapin wrote:
> I have a device with normal serial ports (at91sam9260-based) and
> RS-485 half-duplex transceiver
> installed for it and 1 GPIO for duplex control, 1=writing, 0=reading.
> A problem is that I need to hack serial driver to support this GPIO
> control, which I don't like.
> I just need to set it to 1 before transmission and back to 0 when
> transmission ends.
> 
> Most important thing is to set this bit to 1 before transfer starts,
> so I can't just poll UART registers
> from tasklet. So I had to hack into serial driver for that.
> 
> So questions are:
> 
> 1. Is there some generic enough mechanism in kernel to handle such
> tasks? so I mean external
> serial transcievers support?
> 
> 2. Is there any way to implement this task without touching, in my
> case, drivers/serial/atmel_serial.c?

There are a few serial ports in linux that have RS485 support.
crisv10.c for example appears to support RS485.

The way that seems most common (as far as I know) is that drive the
transmit/receive direction using the RTS line, which if the serial port
has one would already support software control.  The user application
would then set RTS, transmit the data, wait for the transmit buffer to
empty, and then when it is empty, toggle the RTS off again, and then
wait for the reply.

The simpler method if you have access to a good UART (like many of the
exars) is to simply let the hardware manage it.  You can enable
autors485 mode in which whenever there is data to transmit, RTS is
asserted, and a few clock cycles after the transmit FIFO empties, the
RTS is deasserted and receive can happen.  In this case the user space
doesn't even need to have a clue about RS485, although in most cases the
application already needed to know about RS485 so it may not be that
much of a gain, but it sure makes it more efficient to not have to wait
for the UART to drain the transmit FIFO.

I think having the user application control the send/receive switch
makes more sense than the driver, but perhaps it doesn't in your case.

-- 
Len Sorensen
