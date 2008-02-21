Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbYBUPV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbYBUPV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYBUPVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:21:47 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:36643 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYBUPVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:21:46 -0500
Message-ID: <47BD9721.70907@davidnewall.com>
Date: Fri, 22 Feb 2008 01:52:09 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
References: <47B30291.2040905@davidnewall.com>	<20080214050211.GB1432@kroah.com>	<47B40918.20206@davidnewall.com>	<20080214121026.16a9c510@core>	<47B482B4.9010208@davidnewall.com> <20080214193637.5df1c205@core>
In-Reply-To: <20080214193637.5df1c205@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

Alan Cox wrote:
>> That's a very good point.  Even so: on the 2.4 driver, write_room isn't
>> implemented (refer to a previous message by Alan); and in 2.6, a 1k
>> buffer is built into the driver, with nothing to prevent it being sent
>> when the hardware buffer fills.
>>     
[...]

> Careful - a lot of hardware handles this properly itself, you simply
> don't get the URB completing until its all done.
>   

I am incredibly grateful to you for telling me this.  I didn't know it
and hadn't noticed that that was occurring; it was.  I thought data was
being lost by the converter -- I could see where it was missing on the
screen! -- but it's actually a bug in the tty layer.

Here's what really was happening: The PL2303 contains a 256 byte buffer,
and write URBs don't complete when that's full, as you said.   At such
times, that is when a bulk write was pending, the tty layer could and
would still call pl2303_write, which would return 0.  The tty layer
would loop, trying one byte followed by the remaining count, repeating
until no data remained.  The following clause, from write_chan in
n_tty.c, appears responsible; it is within a while(1) loop:

                if (O_OPOST(tty) && !(test_bit(TTY_HW_COOK_OUT, &tty->flags))) {
                        while (nr > 0) {
                                ssize_t num = opost_block(tty, b, nr);
                                if (num < 0) {
                                        if (num == -EAGAIN)
                                                break;
                                        retval = num;
                                        goto break_out;
                                }
                                b += num;
                                nr -= num;
                                if (nr == 0)
                                        break;
                                get_user(c, b);
                                if (opost(c, tty) < 0)
                                        break;
                                b++; nr--;
                        }
                        if (tty->driver.flush_chars)
                                tty->driver.flush_chars(tty);
                } ...


Note that opost() assumes that driver.putchar (which translates to a
one-byte write) always succeeds.  This behaviour is documented.

By the way, the true cause of the problem was somewhat disguised by the
fact that space in the PL2303's buffer could become available part-way
through the cycle, causing non-deterministic (i.e. not exactly
reproducible) loss of part of a write; it looked exactly like a flow
control problem.

The (2.4, remember) PL2303 driver has no write_room function, which I
gather is the appropriate place to signal that a write cannot be
performed.  Providing one that returns 0 when the (singleton) write urb
is busy, resolves the issue.  The patch that I had previously been
developing is entirely wrong.  Oh well.  Mind you, providing a
write_room function is NOT a real solution; it merely reduces the
condition to a usually-winnable race.  (Ironically, when I back-ported
the 2.6 driver, I excluded its new write_room function.  Mistake.)

Thanks for the nugget.
