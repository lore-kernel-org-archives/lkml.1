Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbYE0SYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbYE0SYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbYE0SY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:24:29 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:35489 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbYE0SY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:24:28 -0400
Date: Tue, 27 May 2008 11:23:37 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805271043150.7453@t2.domain.actdsltmp>
References: <1211852026.3286.36.camel@pasglop>  <20080526.184047.88207142.davem@davemloft.net>
  <1211854540.3286.42.camel@pasglop>  <20080526.192812.184590464.davem@davemloft.net>
 <1211859542.3286.46.camel@pasglop> <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008, Linus Torvalds wrote:
> On Tue, 27 May 2008, Benjamin Herrenschmidt wrote:
>>
>> Yes. As it is today, tg3 for example is potentially broken on all archs
>> with newer gcc unless we either add "memory" clobber to readl/writel or
>> stick some wmb's in there (just a random driver I picked).
>>
>> So Linus, what is your take on that matter ?
>
> Let's just serialize the damn things, and add a memory clobber to them.
>
> Expecting people to fix up all drivers is simply not going to happen. And
> serializing things shouldn't be *that* expensive. People who cannot take
> the expense can continue to use the magic __raw_writel() etc stuff.

Is there an issue with anything _besides_ coherent DMA?

Could one have a special version of the accessors for drivers that want to
assume they are strictly ordered vs coherent DMA memory?  That would be much
easier to get right, without slowing _everything_ down.  The problem with the
raw versions is that on some arches they are much more raw than just not being
ordered w.r.t normal memory.

__raw_writel()
No ordering beyond what the arch provides natively.  The only thing you can
assume is that reads and writes to the same location on the same CPU are
ordered.

writel()
Strictly ordered with respect to any other IO, but not to normal memory. 
(this is what Documentation/memory-barriers.txt claims).  Should probably be
strictly ordered vs locks as well.  Would be strictly ordered w.r.t. the
streaming DMA sync calls of course.

strict_writel()
Strictly ordered with respect to normal (incl. coherent DMA) memory as well.

One could even go as far as to allow a driver to "#define WANT_STRICT_IO" and
then it would get the strict versions.  Add that to any driver that uses DMA
and then worry about vetting those drivers.

It's also worth nothing that adding barriers to IO accessors doesn't mean you
never have to worry about barriers with coherent DMA.  Inherent with coherent
DMA, and driving hardware in general, there are various sequence points where
one must be sure one operation has finished before starting the next.  Making
sure you're doing with DMA memory before telling the hardware to do something
with it a common example.  Often the "telling the hardware to do something" is
done via an IO accessor function, but not always.

You can have buffer descriptors in DMA memory that describe the DMA buffers to
the hardware.  It would be critical to be finished reading a DMA buffer before
updating the descriptor to indicate that it's empty.  You could trigger a DMA
operation not by a call to an IO accessor, but with an atomic operation to a
variable shared with an ISR.  When the ISR runs it sees the change and does
the necessary IO.
