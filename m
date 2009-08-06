Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZHFPLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZHFPLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbZHFPLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:11:20 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:28432 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbZHFPLT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com;4:1>);
	Thu, 6 Aug 2009 11:11:19 -0400
Message-Id: <4A7ABA530200005A00051C18@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 Beta 
Date: Thu, 06 Aug 2009 09:11:15 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <paulmck@linux.vnet.ibm.com>, <alacrityvm-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/7] shm-signal: shared-memory signals
References: <20090803171030.17268.26962.stgit@dev.haskins.net>
 <20090803171735.17268.37490.stgit@dev.haskins.net>
 <200908061556.55390.arnd@arndb.de>
In-Reply-To: <200908061556.55390.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

>>> On 8/6/2009 at  9:56 AM, in message <200908061556.55390.arnd@arndb.de>, Arnd
Bergmann <arnd@arndb.de> wrote: 
> On Monday 03 August 2009, Gregory Haskins wrote:
>> shm-signal provides a generic shared-memory based bidirectional
>> signaling mechanism.  It is used in conjunction with an existing
>> signal transport (such as posix-signals, interrupts, pipes, etc) to
>> increase the efficiency of the transport since the state information
>> is directly accessible to both sides of the link.  The shared-memory
>> design provides very cheap access to features such as event-masking
>> and spurious delivery mititgation, and is useful implementing higher
>> level shared-memory constructs such as rings.
> 
> Looks like a very useful feature in general.

Thanks, I was hoping that would be the case.

> 
>> +struct shm_signal_irq {
>> +       __u8                  enabled;
>> +       __u8                  pending;
>> +       __u8                  dirty;
>> +};
> 
> Won't this layout cause cache line ping pong? Other schemes I have
> seen try to separate the bits so that each cache line is written to
> by only one side.

It could possibly use some optimization in that regard.  I generally consider myself an expert at concurrent programming, but this lockless stuff is, um, hard ;)  I was going for correctness first.

Long story short, any suggestions on ways to split this up are welcome (particularly now, before the ABI is sealed ;)

> This gets much more interesting if the two sides
> are on remote ends of an I/O link, e.g. using a nontransparent
> PCI bridge, where you only want to send stores over the wire, but
> never fetches or even read-modify-write cycles.

/me head explodes ;)

> 
> Your code is probably optimal if you only communicate between host
> and guest code on the same CPU, but not so good if it crosses NUMA
> nodes or worse.

Yeah, I wont lie and say it wasn't designed primarily for the former case in mind (since it was my particular itch).  I would certainly appreciate any insight on ways to make it more generally applicable for things like the transparent bridge model, and/or NUMA, though.

> 
>> +struct shm_signal_desc {
>> +       __u32                 magic;
>> +       __u32                 ver;
>> +       struct shm_signal_irq irq[2];
>> +};
> 
> This data structure has implicit padding of two bytes at the end.
> How about adding another '__u16 reserved' to make it explicit?

Good idea.  Will fix.

> 
>> +	/*
>> +	 * We always mark the remote side as dirty regardless of whether
>> +	 * they need to be notified.
>> +	 */
>> +	irq->dirty = 1;
>> +	wmb();   /* dirty must be visible before we test the pending state */
>> +
>> +	if (irq->enabled && !irq->pending) {
>> +		rmb();
>> +
>> +		/*
>> +		 * If the remote side has enabled notifications, and we do
>> +		 * not see a notification pending, we must inject a new one.
>> +		 */
>> +		irq->pending = 1;
>> +		wmb(); /* make it visible before we do the injection */
>> +
>> +		s->ops->inject(s);
>> +	}
> 
> Barriers always confuse me, but the rmb() looks slightly wrong. AFAIU
> it only prevents reads after the barrier from being done before the
> barrier, but you don't do any reads after it.

Its probably overzealous barrier'ing on my part.  I had a conversation with Paul McKenney (CC'd) where I was wondering if a conditional was an implicit barrier.  His response was something to the effect of "on most arches, yes, but not all".  And we concluded that, to be conservative, there should be a rmb() after the if().

That said, tbh I am not sure if its actually needed.  Paul?

> 
> The (irq->enabled && !irq->pending) check could be done before the
> irq->dirty = 1 arrives at the bus, but that does not seem to hurt, it
> would at most cause a duplicate ->inject().
> 
> Regarding the scope of the barrier, did you intentionally use the
> global versions (rmb()/wmb()) and not the lighter single-system
> (smp_rmb()/smp_wmb()) versions? Your version should cope with remote
> links over PCI but looks otherwise optimized for local use, as I
> wrote above.

Yes, it was intentional.  Both for the remote case, as you point out.  Also for the case where local might be mismatched (for instance, a guest compiled as UP).

Thanks Arnd,
-Greg

