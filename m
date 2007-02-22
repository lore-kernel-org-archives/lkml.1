Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXBVVYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXBVVYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXBVVYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:24:54 -0500
Received: from ik-out-1112.google.com ([66.249.90.178]:57546 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbXBVVYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:24:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lqXyrY8+Kh0KynD8Wd+NJ9YCgv3egfC0Pyb9GbBlEvGJMdmpHwT3ynm5Rywjsp0KliU7lCyIV+icSaw7UaoYrvr8uGjsfZEql8z4/jrAjLrj7nj2nDnGvofiCtwGU4rDxdY9bm4yD+l0TyLKTF8iygEx4L3SnesT+h1nNRoBnxw=
Message-ID: <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
Date: Thu, 22 Feb 2007 13:24:48 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070222125931.GB25788@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu>
	 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
	 <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
	 <20070222125931.GB25788@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/07, Ingo Molnar <mingo@elte.hu> wrote:
> > It is not a TUX anymore - you had 1024 threads, and all of them will
> > be consumed by tcp_sendmsg() for slow clients - rescheduling will kill
> > a machine.
>
> maybe it will, maybe it wont. Lets try? There is no true difference
> between having a 'request structure' that represents the current state
> of the HTTP connection plus a statemachine that moves that request
> between various queues, and a 'kernel stack' that goes in and out of
> runnable state and carries its processing state in its stack - other
> than the amount of RAM they take. (the kernel stack is 4K at a minimum -
> so with a million outstanding requests they would use up 4 GB of RAM.
> With 20k outstanding requests it's 80 MB of RAM - that's acceptable.)

This is a fundamental misconception.  The state machine doesn't have
to do anything but chase pointers through cache.  Done right, it
hardly even branches (although the branch misprediction penalty is a
lot less of a worry on current x86_64 than it was in the
mega-superscalar-out-of-order-speculative-execution days).  It's damn
near free -- but it's a pain in the butt to code, and it has to be
done either in-kernel or in per-CPU OS-atop-the-OS dispatch threads.

The scheduler, on the other hand, has to blow and reload all of the
hidden state associated with force-loading the PC and wherever your
architecture keeps its TLS (maybe not the whole TLB, but not nothing,
either).  The only way around this that I can think of is to make
threadlets promise that they will not touch anything thread-local, and
that when the FPU is handed to them in a specific, known state, they
leave it in that same state.  (Some of the flags can be
unspecified-but-don't-touch-me.)  Then you can schedule threadlets in
bursts with negligible transition cost from one to the next.

There is, however, a substantial setup cost for a burst, because you
have to put the FPU in that known state and lock out TLS access (this
is user code, after all).  If the wrong process is in foreground, you
also need to switch process context at the start of a burst; no
fandangos on other processes' core, please, and to be remotely useful
the threadlets need access to process-global data structures and
synchronization primitives anyway.  That's why you need for threadlets
to have a separate SCHED_THREADLET priority and at least a weak
ordering by PID.  At which point you are outside the feature set of
the O(1) scheduler as I understand it, and you might as well schedule
them from the next tasklet following the softirq dispatcher.

> > My tests show that with 4k connections per second (8k concurrency)
> > more than 20k connections of 80k total block in tcp_sendmsg() over
> > gigabit lan between quite fast machines.
>
> yeah. Note that you can have a million sleeping threads if you want, the
> scheduler wont care. What matters more is the amount of true concurrency
> that is present at any given time. But yes, i agree that overscheduling
> can be a problem.

What matters is that a burst of I/O responses be scheduled efficiently
without taking down the rest of the box.  That, and the ability to
cancel no-longer-interesting I/O requests in bulk, without leaking
memory and synchronization primitives all over the place.  If you
don't have that, this scheme is UNUSABLE for network I/O.

> btw., what is the measurement utility you are using with kevents ('ab'
> perhaps, with a high -c concurrency count?), and which webserver are you
> using? (light-httpd?)

Do me a favor.  Do some floating point math and a memcpy() in between
syscalls in the threadlet.  Actually fiddle with errno and the FPU
rounding flags.  Watch it slow to a crawl and/or break floating point
arithmetic horribly.  Understand why no one with half a brain uses
Java, or any other language which cuts FP corners for the sake of
cheap threads, for calculations that have to be correct.  (Note that
Kahan received the Turing award for contributions to IEEE 754.  If his
polemic is too thick, read
http://www-128.ibm.com/developerworks/java/library/j-jtp0114/.)

Cheers,
- Michael
