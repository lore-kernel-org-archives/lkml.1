Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbXEDNn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbXEDNn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbXEDNn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:43:28 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:59704
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbXEDNn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:43:27 -0400
Message-ID: <463B46F4.6090906@microgate.com>
Date: Fri, 04 May 2007 08:45:08 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Antonino Ingargiola <tritemio@gmail.com>
CC: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible
 bug]
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>	 <200705041049.20989.oliver@neukum.org>	 <5486cca80705040229g53933671m658bd028cadca155@mail.gmail.com> <5486cca80705040233y70915a27yf7cbbc08a617e3ba@mail.gmail.com>
In-Reply-To: <5486cca80705040233y70915a27yf7cbbc08a617e3ba@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino Ingargiola wrote:
> Nope. In python I use the flushInput() method of the serial object
> defined by the pyserial library[0]. The method does just this system
> call:
> 
>     termios.tcflush(self.fd, TERMIOS.TCIFLUSH)
> 
> that I think is correct.

There is intermediate buffering between the driver and
the line discipline called the tty flip buffer.

receive data flow:
driver --> tty flip --> line discipline --> application

When you flush input, the line disciplines flush_buffer() method
is called to clear any data residing the in the line discipline.

This does not affect the tty flip buffer
or hardware receive FIFOs.

I suspect the biggest problem is the data in the
tty flip buffer.

A new function to flush the tty flip buffer needs to
be added and then called from tty_io.c:tty_ldisc_flush().

Then a call to tcflush(TCIFLUSH) will clear both buffers.

This still would not clear any data in the hardware
receive FIFOs.

-- 
Paul Fulghum
Microgate Systems, Ltd.
