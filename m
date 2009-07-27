Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZG0Wkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZG0Wkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbZG0Wkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:40:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38409 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755118AbZG0Wkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:40:39 -0400
Date: Mon, 27 Jul 2009 23:41:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090727234100.40157e06@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907271500110.25224@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp>
	<20090727161424.GA4233@skywalker>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker>
	<87skgikjr8.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.01.0907271237250.25224@localhost.localdomain>
	<87ocr5dfpb.fsf@devron.myhome.or.jp>
	<20090727224220.0e80b926@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907271500110.25224@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No guarantees. It may or may not compile. It may or may not make any 
> difference. It might do unspeakable things to your pets. It really is 
> meant to be an example of what a "flush" function could/should do. There 
> are probably other things/buffers that may need flushing.

Wrong end of the stick. close() already flushes the transmit buffers
properly (and passes the SuS test suite tests on behaviour). Its the
receive the other end you need to sync which isn't an assumption made or
something with any meaning on real hardware.

> +/* This should probably be a generic function */
> +static void flush_delayed_work(struct delayed_work *work)
> +{
> +	if (cancel_delayed_work(work)) {
> +		schedule_delayed_work(work, 0);
> +		flush_scheduled_work();
> +	}

If the ldisc is busy the scheduled work will not flush the data to the
other tty. The tty->low_latency fix actually works better than this
because it makes tty_flip_buffer_push() force the work through that can
be done as it calls the ldisc work synchronously.

> + *	Called for every close(), whether the last or not

The pty case is "special" and seems to be an accident of implementations
in history. The problem on the pty side is on the input not the output
side.

A normal tty write goes from the ldisc to the device, and in that case
the close behaviour is defined by the close delay and FIFO flush in the
driver. In other words it is already done correctly, only done for the
last close (some apps rely on that as a sneaky way to keep the main
thread from blocking).

The pty race is quite different

A write to the pty is guaranteed to correctly have completed on the
close(). The data may however not have been received by the other end as
the ldisc could be busy or not yet scheduled. If you like the data is
sitting on the virtual wire". Or more exactly its in the "not yet fed to
the ldisc" buffers on the other end.

Adding the EOFPENDING/EOF flag fixes the detection of the EOF by the
receiver but doesn't guarantee the sender blocks. If the sender also
waits for the EOF flag to be set then the sender knows the receiving
ldisc has got all the data. Thats a fairly small mod from the existing
long patch.

Except: The other end could also be in EOFPENDING/EOF wait with both ends
blocked by the ldisc and not accepting data. In which case you just
deadlocked. The close() blocks forever waiting for another end which may
also be close() blocked in the other direction isn't a viable
implementation although one I'm quite keen to try out on a Mac or BSD box
out of curiosity.

