Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934773Ab0BZAin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:38:43 -0500
Received: from www.tglx.de ([62.245.132.106]:36831 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934688Ab0BZAil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:38:41 -0500
Date: Fri, 26 Feb 2010 01:38:32 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Christopher Cordahi <christophercordahi@nanometrics.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Subject: Re: Using UIO
Message-ID: <20100226003832.GB2955@local>
References: <1175780147.764.1267140209364.JavaMail.root@mail.nanometrics.ca>
 <997915920.766.1267140693094.JavaMail.root@mail.nanometrics.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <997915920.766.1267140693094.JavaMail.root@mail.nanometrics.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 06:31:33PM -0500, Christopher Cordahi wrote:
> Hello Hans-Juergen,

Hello Christopher,
one word before answering your questions: Never send private mails to
kernel maintainers. You should always Cc: the mailing list where your
topic is discussed (LKML in this case). You don't need to be subscribed
to LKML to post there. People there will always "reply to all" so you'll
get their responses without being subscribed. Please do the same when
replying and don't remove people from Cc:.

> 
> Thanks for the UIO driver interface, once I figured out where the
> various kernel structures should be declared, I was surprised by
> how little code I had to write.
> 
> I've implemented a platform device using the uio_pdrv_genirq UIO
> driver and noticed that the UIO interface doesn't work exactly
> as described.
> 
> "/dev/uioX is a read-only file. A read() will always block until
> an interrupt occurs. ... The signed 32 bit integer read is the
> interrupt count of your device."
> 
> This worked wonderfully.
> 
> "If the value is one more than the value you read the last time,
> everything is OK. If the difference is greater than one, you
> missed interrupts."
> 
> Unfortunately the uio_pdrv_genirq driver doesn't detect missed
> interrupts.  The problem is that it automatically disables
> interrupts in its interrupt handler so until the user application
> re-enables them it won't detect any missed interrupts.

Yes, you're right. I wrote the paragraphs you quoted above at least
a year before uio_pdrv_genirq came up. It is still true for all
other drivers in mainline.

If you've got the time, it would be nice if you sent a patch that
updates the UIO documentation...

uio_pdrv_genirq was made for special cases, e.g. where you don't
know how to disable an interrupt within some closed external chip.
It is certainly not the general way to implement UIO drivers.

With a few extra lines of code, you can use uio_pdrv, and avoid
the problem. If the chip you're dealing with might be interesting
for other people, you should write a real UIO driver so that your
driver is not tied to your special board.

> 
> I'm also wondering what type of latency do you expect from when
> the interrupt is triggered to when a user space application can
> return from the read.  I've been using a iMX35 (ARM1136J)
> processor on a PHYTEC PCM043 SOM.  Most of the time it responds
> in responds in about 50 us :), however I've seen delays of
> over 200 ms :( while running ltp.

50us is what I'd expect on that platform. 200ms is certainly bad,
but can of course happen under load with a mainline kernel. You
should use the realtime preemption patch:
http://rt.wiki.kernel.org/index.php/Main_Page

RT_PREEMPT shoud bring down worst case latencies to a few hundred
microseconds on that platform.

If you're already using RT_PREEMPT and get 200ms, you're in trouble
and should ask the RT people on their mailing list ;-)

Thanks,
Hans

