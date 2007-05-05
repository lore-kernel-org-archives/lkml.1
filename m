Return-Path: <linux-kernel-owner+w=401wt.eu-S1423291AbXEEPvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423291AbXEEPvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423298AbXEEPvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:51:44 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:59830 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423291AbXEEPvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:51:41 -0400
Message-ID: <5486cca80705050253u35731411ma7c09b3a678c2d49@mail.gmail.com>
Date: Sat, 5 May 2007 11:53:39 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1178276265.3417.3.camel@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <5486cca80705041013pf481c2an9e639fc9285ba88e@mail.gmail.com>
	 <1178299247.3769.0.camel@amdx2.microgate.com>
	 <5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>
	 <1178300493.3619.1.camel@amdx2.microgate.com>
	 <5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>
	 <5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>
	 <1178308173.3743.14.camel@amdx2.microgate.com>
	 <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
	 <1178276265.3417.3.camel@x2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Paul Fulghum <paulkf@microgate.com> wrote:
> Antonino:
>
> Can you try two tests (with my patch applied):
>
> 1. comment out the tty_flush_buffer() call in tty_ldisc_flush() and test
>
> 2. uncomment (reenable) the above call and comment out the
> tty_flush_buffer() call in tty_ioctl() and test

I assume you meant tty_buffer_flush(). I've built kernel 1). In kernel
2), do you mean:

    /*if (ld->ioctl)
            tty_buffer_flush(tty);*/
    tty_ldisc_deref(ld);

right? This is what I'm building... I'll report these new tests soon.

While waiting for kernel building I'll document the testing procedure.
In this way someone else can easily try to reproduce the problem.

1. Hardware.

Two serial ports required. Connect the two port witth a null-modem
cable, or patch, for each port the Tx pin with the Rx of the other
port[0].

2. Software

I assume python is installed. Install also pyserial[1] (in debian
python-serial), if you manually download the package you can put the
"serial" dir in the dir you use to perform the test (no need to
install system-wide). If you can, install also the ipython shell that
has colored output and auto-completition.

3. Test

>From the python shell:

    import serial
    s0 = serial.Serial(0, timeout=1)

open the /dev/ttyS0 port with default values, hit 's0' [enter] to see
the serial parameters.

    s1 = serial.Serial(1, timeout=1)

with the previous comma we open /dev/ttyS1 with the same serial port
settings. To write to one serial port:

    s0.write('test\n')

and to read use the .read() or .readline() method:

    s1.readline()

The .inWaiting() methods gives the numbers of bytes in the input
buffer. The .flushInput() method flushes the input buffer:

	In [6]: s0.write('test\n')

	In [7]: s1.inWaiting()
	Out[7]: 5L

	In [8]: s1.readline()
	Out[8]: 'test\n'

	In [9]: s1.inWaiting()
	Out[9]: 0L

If all works, now fill one serial port with a bunch of data (an
increasing 8-digit number):

    for i in xrange(10000):
        s0.write(str(i).zfill(8)+'\n')

we can see that the s1 input buffer is full:

    s1.inWaiting()
    Out[21]: 4095L

then empty the buffer and see what happens:

	In [22]: s1.flushInput()
	In [23]: s1.inWaiting()
	Out[23]: 4095L

the buffer is still full. You have to flush the buffer more then once
to completely flush all the buffer chain (including the flip buffer).
With the patched kernel at this point I get correctly:

	In [22]: s1.flushInput()
	In [23]: s1.inWaiting()
	Out[23]: 0L

but then I can't read any other byte from the serial without closing
and reopening it:

	In [24]: s0.write('test\n')

	In [25]: s1.inWaiting()
	Out[25]: 0L

	In [26]: s1.read()
	Out[26]: ''

	In [27]: s1.close()

	In [28]: s1.open()

	In [29]: s1.inWaiting()
	Out[29]: 0L

	In [30]: s0.write('test\n')

	In [31]: s1.inWaiting()
	Out[31]: 5L

	In [32]: s1.readline()
	Out[32]: 'test\n'

Hope the explanation is clear If someone else want to try...

Regards,

  ~ Antonio
