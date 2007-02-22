Return-Path: <linux-kernel-owner+w=401wt.eu-S1945933AbXBVBEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945933AbXBVBEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945934AbXBVBEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:04:51 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:61764 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945932AbXBVBEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:04:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Uf0a/XlRuLWJPePGJbWJYivUMB3K9RKq5FRqueyFTrjAnrhP9cFjDDqzE/ii1qEsakCOhNyaZDoxgK46D5zZ+M98B9U0bhk/y8fpYHJEzx8JyzzIkwgjrdno247YUhVJGg38iqi2B76FXOm0XWe4/oCKnNIqMHpik4ikIGvPgWk=
Message-ID: <f2b55d220702211704o549efd70oc0998cc663537ddd@mail.gmail.com>
Date: Wed, 21 Feb 2007 17:04:45 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070221233111.GB5895@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu>
	 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <20070221233111.GB5895@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Ingo Molnar <mingo@elte.hu> wrote:
> threadlets (and syslets) are parallel contexts and they behave so -
> queuing and execution semantics are then ontop of that, implemented
> either by glibc, or implemented by the application. There is no
> 'pipeline' of requests imposed - the structure of pending requests is
> totally free-form. For example in threadlet-test.c i've in essence
> implemented a 'set of requests' with the submission site only interested
> in whether all requests are done or not - but any stricter (or even
> looser) semantics and ordering can be used too.

In short, you have a dataflow model with infinite parallelism,
implemented using threads of control mapped willy-nilly onto the
underlying hardware.  This has not proven to be a successful model in
the past.

> in terms of AIO, the best queueing model is i think what the kernel uses
> internally: freely ordered, with barrier support. (That is equivalent to
> a "queue of sets", where the queue are the barriers, and the sets are
> the requests within barriers. If there is no barrier pending then
> there's just one large freely-ordered set of requests.)

That's a big part of why Linux scales poorly for workloads that
involve a large volume of in-flight I/O transactions.  Unless you
essentially lock one application thread to each CPU core, with a
complete understanding of its cache sharing and latency relationships
to all the other cores, and do your own userspace I/O scheduling and
dispatching state machine -- which is what all industrial-strength
databases and other sorts of transaction engines currently do -- you
get the same old best-effort context-thrashing scheduler we've had
since Solaris 2.0.

Let's do something genuinely better this time, OK?

Cheers,
- Michael
