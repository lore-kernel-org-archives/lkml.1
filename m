Return-Path: <linux-kernel-owner+w=401wt.eu-S1751559AbXC2AhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbXC2AhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 20:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933930AbXC2AhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 20:37:10 -0400
Received: from smtp003.mail.ukl.yahoo.com ([217.12.11.34]:39260 "HELO
	smtp003.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751559AbXC2AhI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 20:37:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YhPeungVEaRuZras4GWywDwEOLY/oIj5D/fmfbo9NPG/3LFW41IvHI2Jn2PD8GCWqQFIPdyT9vMEuoq5KK41GjmGsaxuDn9PJCMT0HaYhtiTLVj6pA19R4DnNrXz4afcvdYVbMgQbZ4QlTbafW8TcturjhRnqa1zA1HHPrqgvIo=  ;
X-YMail-OSG: EyI8gA8VM1lUnBxVsH2VkUA6djjBxi.BzetTkC5YvVBAFxFFjGaD._uwGWLZZH8JZ5oJGz4DcMcU9pc75azGa52_9wELRfs_t_D70PgcFAOwiGxR
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML - fix I/O hang when multiple devices are in use
Date: Thu, 29 Mar 2007 02:36:43 +0200
User-Agent: KMail/1.9.6
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070328020247.GA12299@c2.user-mode-linux.org>
In-Reply-To: <20070328020247.GA12299@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703290236.44324.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On mercoledì 28 marzo 2007, Jeff Dike wrote:
> [ This patch needs to get into 2.6.21, as it fixes a serious bug
> introduced soon after 2.6.20 ]
>
> Commit 62f96cb01e8de7a5daee472e540f726db2801499 introduced per-devices
> queues and locks, which was fine as far as it went, but left in place
> a global which controlled access to submitting requests to the host.
> This should have been made per-device as well, since it causes I/O
> hangs when multiple block devices are in use.
>
> This patch fixes that by replacing the global with an activity flag in
> the device structure in order to tell whether the queue is currently
> being run.
Finally that variable has a understandable name. However in a mail from Jens 
Axboe, titled:
"Re: [uml-devel] [PATCH 06/11] uml ubd driver: ubd_io_lock usage fixup" , with 
Date: Mon, 30 Oct 2006 09:26:48 +0100, he suggested removing this flag 
altogether, so we may explore this for the future:

> > Add some comments about requirements for ubd_io_lock and expand its use.
> >
> > When an irq signals that the "controller" (i.e. another thread on the
> > host, which does the actual requests and is the only one blocked on I/O
> > on the host) has done some work, we call again the request function
> > ourselves (do_ubd_request).
> >
> > We now do that with ubd_io_lock held - that's useful to protect against
> > concurrent calls to elv_next_request and so on.
>
> Not only useful, required, as I think I complained about a year or more
> ago :-)
>
> > XXX: Maybe we shouldn't call at all the request function. Input needed on
> >  this. Are we supposed to plug and unplug the queue? That code
> > "indirectly" does that by setting a flag, called do_ubd, which makes the
> > request function return (it's a residual of 2.4 block layer interface).
>
> Sometimes you need to. I'd probably just remove the do_ubd check and
> always recall the request function when handling completions, it's
> easier and safe.

Anyway, the main speedups to do on the UBD driver are:
* implement write barriers (so much less fsync) - this is performance killer 
n.1

* possibly to use the new 2.6 request layout with scatter/gather I/O, and 
vectorized I/O on the host
* while at vectorizing I/O using async I/O

* to avoid passing requests on pipes (n.2) - on fast disk I/O becomes 
cpu-bound.
To make a different but related example, with a SpeedScale laptop, it's 
interesting to double CPU frequency and observe tuntap speed double too. 
(with 1GHz I get on TCP numbers like 150 Mbit/s - 100 Mbit/s, depending 
whether UML trasmits or receives data; with 2GHz double rates).
Update: I now get 150Mbit / 200Mbit (Uml receives/Uml sends) at 1GHz, and 
still the double at 2Ghz.
This is a different UML though.

* using futexes instead of pipes for synchronization (required for previous 
one).

-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
