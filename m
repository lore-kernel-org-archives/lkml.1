Return-Path: <linux-kernel-owner+w=401wt.eu-S934246AbXEESH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934246AbXEESH5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934249AbXEESH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:07:57 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:20319 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934246AbXEESH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:07:56 -0400
Message-ID: <5486cca80705050319q57cfcdb0n646c56097c789c28@mail.gmail.com>
Date: Sat, 5 May 2007 12:19:51 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <5486cca80705050253u35731411ma7c09b3a678c2d49@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <1178299247.3769.0.camel@amdx2.microgate.com>
	 <5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>
	 <1178300493.3619.1.camel@amdx2.microgate.com>
	 <5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>
	 <5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>
	 <1178308173.3743.14.camel@amdx2.microgate.com>
	 <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
	 <1178276265.3417.3.camel@x2>
	 <5486cca80705050253u35731411ma7c09b3a678c2d49@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/07, Antonino Ingargiola <tritemio@gmail.com> wrote:
> On 5/4/07, Paul Fulghum <paulkf@microgate.com> wrote:
> > Antonino:
> >
> > Can you try two tests (with my patch applied):
> >
> > 1. comment out the tty_flush_buffer() call in tty_ldisc_flush() and test
> >
> > 2. uncomment (reenable) the above call and comment out the
> > tty_flush_buffer() call in tty_ioctl() and test
>
> I assume you meant tty_buffer_flush(). I've built kernel 1). In kernel
> 2), do you mean:
>
>     /*if (ld->ioctl)
>             tty_buffer_flush(tty);*/
>     tty_ldisc_deref(ld);
>
> right? This is what I'm building... I'll report these new tests soon.

Ok test done.

With kernel 1. the behavior is the same as with your plain second
patch only (flush input works but I cannot read anymore from the
serial that was flushed without closing and reopening the port). See
previous mail for the details of the test.

With kernel 2 the behavior is the same as mainline (multiple flushes
are needed to completely empty the buffers). And I _can_ read further
chars from the serial line after the flush. Here it is the ipython
session that document the test with kernel 2:

	In [1]: import serial

	In [2]: s0 = serial.Serial(0, timeout=1)

	In [3]: s1 = serial.Serial(1, timeout=1)

	In [4]: s0.write('test\n')

	In [5]: s1.inWaiting()
	Out[5]: 5L

	In [6]: s1.readline()
	Out[6]: 'test\n'

	In [7]: for i in xrange(1000):
	   ...:     s0.write(str(i).zfill(8)+'\n')
	   ...:

	In [8]: s1.inWaiting()
	Out[8]: 4095L

	In [9]: s1.flushInput()

	In [10]: s1.inWaiting()
	Out[10]: 4095L                               # NOTE the buffer is still full!

	In [11]: s1.flushInput()

	In [12]: s1.inWaiting()
	Out[12]: 810L                                # The buffer beginning
to be drained

	In [13]: s1.flushInput()

	In [14]: s1.inWaiting()
	Out[14]: 0L                                   # Now the buffer is empty

	In [15]: s0.write('test\n')                  # An reading further chars works

	In [16]: s1.inWaiting()
	Out[16]: 5L

	In [17]: s1.readline()
	Out[17]: 'test\n'


Regards,

  ~ Antonio
