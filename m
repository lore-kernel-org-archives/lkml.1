Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbYDTOKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbYDTOKD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbYDTOJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:09:50 -0400
Received: from calf.ext.ti.com ([198.47.26.144]:40267 "EHLO calf.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757600AbYDTOJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:09:48 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: Higer latency with dynamic tick (need for an io-ondemand govenor?)
Date: Sun, 20 Apr 2008 09:09:12 -0500
Message-ID: <3B6D69C3A9EBCA4BA5DA60D9130274290413207C@dlee13.ent.ti.com>
In-Reply-To: <20080419231948.149f2783@laptopd505.fenrus.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Higer latency with dynamic tick (need for an io-ondemand govenor?)
Thread-Index: AciirpchtQGKC3aAQMSIeLw/7KWgjAAPR4/g
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com><1179396659.3764.40.camel@chaos><3B6D69C3A9EBCA4BA5DA60D913027429010258E8@dlee13.ent.ti.com><1179434296.12981.14.camel@chaos><3B6D69C3A9EBCA4BA5DA60D913027429010259ED@dlee13.ent.ti.com><1179474567.12981.53.camel@chaos><3B6D69C3A9EBCA4BA5DA60D91302742904131BED@dlee13.ent.ti.com> <20080419231948.149f2783@laptopd505.fenrus.org>
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>
X-OriginalArrivalTime: 20 Apr 2008 14:09:13.0579 (UTC) FILETIME=[1C9A63B0:01C8A2F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 1:20: -0500
"Arjan van de Ven" < arjan@infradead.org > wrote:

> So right now we have the pmqos framework (and before that we had a
> simpler version of this);
> so if your realtime (or realtime-like) system cannot deal with latency
> longer then X usec,
> you can just tell the kernel,, and the deeper power states that have
> this latency, just won't get used.

Yes.  We're already using the older version today (sparingly) to set worst acceptable latency before failure.  This does work.

> What you're mentioning is sort-of-kinda different. It's the "most of the
> time go as deep as you can,
> but when I do IO, it hurts throughput".

That's 100% correct.

> There's two approaches to that in principle
> 1) Work based on historic behavior, and go less deep when there's lots
> of activity in the (recent) past
>    A few folks at Intel are working on something like this

Any data to share here? 

Interrupt frequency seemed like a good pivot, I thought I might experiment starting here.  Opinion?

> 2) You have the IO layer tell the kernel "heads up, something coming
> down soon"
>    This is more involved, especially since it's harder to predict when
> the disk will be done.
>    (it could be a 10msec seek, but it could also be in the disks cache
> memory, or it could be an SSD or,
>    the disk may have to read the sector 5 times because of weak
> magnetics... it's all over the map)
>    Another complication is that we need to only do this for
> "synchronous" IO's.. which is known at higher layers
>    in the block stack, but I think gets lost towards the bottom.

Not so many phones have a disk to care about the above device example.  However, I been wondering if the use of an mmap to non-file-backed devices and the use of the fadvice() hint might be useful for other classes of devices.  We have some media devices which do special mappings.

For UMPC's is the disk the main problem device which is slowing down the system?

Some of the slow downs I was talking about were happening in HS-USB devices.

> There's another problem with 2); in a multicore world; all packages
> EXACPT for the one which will get the irq can go to a deeper state
> anyway....
> but it might be hard to predict which CPU will get the completion irq.

I see. I expect there are some interesting problems there.  I would hope some affinity would keep an IRQ on the same CPU most of the time.  But like you say if its offline or in a very high latency state you would have to re-route that IRQ to a machine capable of handling it.

I know of some IRQ IP blocks with some QOS features, this seems like a place to use these.

Regards,
Richard W.

