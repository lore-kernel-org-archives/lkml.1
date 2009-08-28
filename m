Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbZH1UAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbZH1UAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZH1UAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:00:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51655 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753047AbZH1UAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:00:22 -0400
Date: Fri, 28 Aug 2009 21:01:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David VomLehn <dvomlehn@cisco.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com
Subject: Re: [PATCH 1/1, v2]
 usb-use-kfifo-to-buffer-usb-generic-serial-writes.patch
Message-ID: <20090828210106.51b1182a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090828194810.GA10728@cuplxvomd02.corp.sa.net>
References: <20090827013454.GA23601@cuplxvomd02.corp.sa.net>
	<200908271014.54282.oliver@neukum.org>
	<20090827172218.GA3618@cuplxvomd02.corp.sa.net>
	<200908281507.11143.oliver@neukum.org>
	<20090828194810.GA10728@cuplxvomd02.corp.sa.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You may be writing a command. If you clip out a sequence in the middle you
> > might be sending an altered command without telling user space.

Serial has no framing so you can't assume alignments

> Serial output does not provide a reliable delivery mechanism. If you flip a bit
> in the sending UART, you may also send an altered command without telling user
> space. Still, having had some time to think about it, I think discarding the
> rest of the data is at least as reasonable as anything else.

Agreed

> It seems propagating errors back to user space appears somewhat problematic,
> but this is true independent of whether a FIFO is used.

The best I can think of would be to implement socket like behaviour from
networking. That is

- at the start of a write check for an asynchronous error event
- if there is one, clear the event and report it
- if not do the normal write

and keep a single 's**t happened' variable to record such matters.

> > How can this duplicate data? If you know that you need to call
> > usb_serial_generic_write_start, you also know that no further
> > transfer will occur. If you don't test and restart on resume, you
> > get this scenario:
> > 
> > user space writes to device
> > user space waits for answer
> > 
> > kernel transfers 1. buffer
> > system suspension - 2. buffer cannot be transfered,
> > 	as usb_serial_generic_write_start gets -EPERM
> > system resumption - 2. buffer is never transmitted,
> > 	user space times out and reports an error

You would need to handle this in the shutdown - and beyond that you need
to wait for any FIFO in the device before you power it down.

Its not really fixable as it isn't transactional and you have no idea if
the state of the other device also changed. Consider 

ATD foo
oops flight time
suspend

Arrive in Australia
resume
ATD foo

Ouch that was an expensive data call...

So I am not sure that trying to be clever here is actually productive.
