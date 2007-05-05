Return-Path: <linux-kernel-owner+w=401wt.eu-S1422726AbXEEPjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422726AbXEEPjO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423000AbXEEPjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:39:14 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:51044 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422726AbXEEPjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=St8oYNkU+u5EpIfyRtUbxYW4n1yRU/7gjj9CU4VMb0X7YOBuiWwshmDZAaui4PyEUNq9bflXb/41ZEuyXHE0NYGVmSOc4GKxGuwDF77oI147cXSmnPDfd3cw4XjRGDpjBcTGYZTHS5D0LwyFH0MAR0OvUStSsJJ1PnZbewEcveY=
Message-ID: <5486cca80705050811k2903710y2bf9054434d8da4b@mail.gmail.com>
Date: Sat, 5 May 2007 17:11:52 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1178353618.3472.1.camel@x2>
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
	 <463BC223.2040304@microgate.com> <1178353618.3472.1.camel@x2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/5, Paul Fulghum <paulkf@microgate.com>:
> On Fri, 2007-05-04 at 17:30 -0600, Paul Fulghum wrote:
> > OK, this behavior is so unexpected I must be missing
> > something basic.
>
> And so I was. Try this patch.
>
> --- a/drivers/char/tty_io.c     2007-05-04 05:46:55.000000000 -0500
> +++ b/drivers/char/tty_io.c     2007-05-05 03:23:46.000000000 -0500

Great! Really good job, Paul. The patch now boot properly and solves
completely the testcase with two serial lines:

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
	Out[10]: 0L
	In [11]: s0.write('test\n')
	In [12]: s1.inWaiting()
	Out[12]: 5L
	In [13]: s1.readline()
	Out[13]: 'test\n'

I've done more tests with other scripts and all works perfectly (the
input buffer is really totally flushed the first time). Many thanks! I
think this patch should be included in mainline, since if one flushes
the input buffer, really want to flush the entire buffer chain and
doesn't want to read any old data _after_ a flush.

However I also tested a usb-serial device (that uses the cdc-acm
driver) and in this case I still need _two_ flushInput() to totally
flush the input buffer.

There can be another *secondary buffer* in the usb-serial driver? Can
this buffer be emptied out too?

I bet the same behavior can be reproduced with another FTDI-based
usb-serial device that I haven't at hand now (but that I can test the
next week).

Many thanks for the help so far.


Regards,

  ~ Antonio
