Return-Path: <linux-kernel-owner+w=401wt.eu-S1750759AbXBWCru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750759AbXBWCru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 21:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbXBWCru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 21:47:50 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:11668 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXBWCrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 21:47:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aUy/SMsJOP+SgKdQ2Ac1QOiZeU3rZ4YF5r2+a18GoPJqrGk8MYBH/oFjzXmm0rVOgDdDVXGi0GQa6srzz2fC7VfqXimVAOx9Wbci6hgaQ8VsgS4jiTAxjZPB+oXn6YX5od46EaOvvBYVZburZSP2sA9yRLSzZjTLPUQ81ar+FM0=
Message-ID: <f2b55d220702221847p6b28f6eehed1bb5b1b0edf9f4@mail.gmail.com>
Date: Thu, 22 Feb 2007 18:47:46 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>, "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070223003018.0d244576@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu>
	 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
	 <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
	 <20070222125931.GB25788@elte.hu>
	 <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
	 <20070223003018.0d244576@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> > to do anything but chase pointers through cache.  Done right, it
> > hardly even branches (although the branch misprediction penalty is a
> > lot less of a worry on current x86_64 than it was in the
> > mega-superscalar-out-of-order-speculative-execution days).  It's damn
>
> Actually it costs a lot more on at least one vendors processor because
> you stall very long pipelines.

You're right; I overreached there.  I haven't measured branch
misprediction penalties in dog's years (I focus more on system latency
issues these days), so I'm just going on rumor.  If your CPU vendor is
still playing the tune-for-SpecINT-at-the-expense-of-real-code game
(*cough* Itanic *cough*), get another CPU vendor -- while you still
can.

> > threadlets promise that they will not touch anything thread-local, and
> > that when the FPU is handed to them in a specific, known state, they
> > leave it in that same state.  (Some of the flags can be
>
> We don't use the FPU in the kernel except in very weird cases where it
> makes an enormous performance difference. The threadlets also have the
> same page tables so they have the same %cr3 so its very cheap to switch,
> basically a predicted jump and some register loads

Do you not understand that real user code touches FPU state at
unpredictable (to the kernel) junctures?  Maybe not in a database or a
web server, but in the GUIs and web-based monitoring applications that
are 99% of the potential customers for kernel AIO?  I have no idea
what a %cr3 is, but if you don't fence off thread-local stuff from the
threadlets you are just begging for end-user Heisenbugs and a place in
the dustheap of history next to Symbolics LISP.

> > Do me a favor.  Do some floating point math and a memcpy() in between
> > syscalls in the threadlet.  Actually fiddle with errno and the FPU
>
> We don't have an errno in the kernel because its a stupid idea. Errno is
> a user space hack for compatibility with 1970's bad design. So its not
> relevant either.

Dude, it's thread-local, and the glibc wrapper around most synchronous
syscalls touches it.  If you don't instantiate a new TLS context (or
whatever the right lingo for that is) for every threadlet, you are
TOAST -- if you let the user call stuff out of <stdlib.h> (let alone
<stdio.h>) from within the threadlet.

Cheers,
- Michael
