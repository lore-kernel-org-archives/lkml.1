Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbZGHPEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbZGHPEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 11:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZGHPER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 11:04:17 -0400
Received: from emulex.emulex.com ([138.239.112.1]:53308 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbZGHPEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 11:04:15 -0400
From: Chetan.Loke@Emulex.Com
To: <daniel.blueman@gmail.com>, <matthew@wil.cx>, <andi@firstfloor.org>,
       <jens.axboe@oracle.com>, <arjan@infradead.org>
CC: <linux-kernel@vger.kernel.org>
Date: Wed, 8 Jul 2009 08:03:48 -0700
Subject: RE: >10% performance degradation since 2.6.18
Thread-Topic: >10% performance degradation since 2.6.18
Thread-Index: Acn/Txi1jIBAeDPUSbWN+LpoBalcEAAiU7TQ
Message-ID: <412A05BA40734D4887DBC67661F433080CB09178@EXMAIL.ad.emulex.com>
References: <6278d2220907050400k1359df3av4045d3bba07d2be7@mail.gmail.com>
	 <412A05BA40734D4887DBC67661F433080CB08E7A@EXMAIL.ad.emulex.com>
 <6278d2220907071505k23ae1a79l7449becb9b2f4b45@mail.gmail.com>
In-Reply-To: <6278d2220907071505k23ae1a79l7449becb9b2f4b45@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jul 2009 15:03:51.0463 (UTC) FILETIME=[4DC8CB70:01C9FFDD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Daniel J Blueman [mailto:daniel.blueman@gmail.com] 
> Sent: Tuesday, July 07, 2009 6:06 PM
> To: Loke,Chetan; matthew@wil.cx; andi@firstfloor.org; 
> jens.axboe@oracle.com; Arjan van de Ven
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: >10% performance degradation since 2.6.18
> 
> On Mon, Jul 6, 2009 at 10:58 PM, <Chetan.Loke@emulex.com> wrote:
> >> -----Original Message-----
> >> From: linux-kernel-owner@vger.kernel.org
> >> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Daniel J 
> >> Blueman
> >> Sent: Sunday, July 05, 2009 7:01 AM
> >> To: Matthew Wilcox; Andi Kleen
> >> Cc: Linux Kernel; Jens Axboe; Arjan van de Ven
> >> Subject: Re: >10% performance degradation since 2.6.18
> >>
> >> On Jul 3, 9:10 pm, Arjan van de Ven <ar...@infradead.org> wrote:
> >> > On Fri, 3 Jul 2009 21:54:58 +0200
> >> >
> >> > Andi Kleen <a...@firstfloor.org> wrote:
> >> > > > That would seem to be a fruitful avenue of investigation -- 
> >> > > > whether limiting the cards to a single RX/TX 
> interrupt would be 
> >> > > > advantageous, or whether spreading the eight interrupts
> >> out over
> >> > > > the CPUs would be advantageous.
> >> >
> >> > > The kernel should really do the per cpu binding of MSIs
> >> by default.
> >> >
> >> > ... so that you can't do power management on a per socket basis?
> >> > hardly a good idea.
> >> >
> >> > just need to use a new enough irqbalance and it will 
> spread out the 
> >> > interrupts unless your load is low enough to go into low 
> power mode.
> >>
> >> I was finding newer kernels (>~2.6.24) would set the 
> Redirection Hint 
> >> bit in the MSI address vector, allowing the processors to 
> deliver the 
> >> interrupt to the lowest interrupt priority (eg idle, no powersave) 
> >> core (http://www.intel.com/Assets/PDF/manual/253668.pdf 
> pp10-66) and 
> >> older irqbalance daemons would periodically naively rewrite the 
> >> bitmask of cores, delivering the interrupt to a static one.
> >>
> >> Thus, it may be worth checking if disabling any older irqbalance 
> >> daemon gives any win.
> >>
> >> Perhaps there is value in writing different subsets of 
> cores to the 
> >> MSI address vector core bitmask (with the redirection hint 
> enabled) 
> >> for different I/O queues on heavy interrupt sources? By 
> default, it's 
> >> all cores.
> >>
> >
> > Possible enhancement -
> >
> > 1) Drain the responses in the xmit_frame() path. That is, post the 
> > TX-request() and just before returning see if there are
> >   any more responses in the RX-queue. This will 
> minimize(only if the NIC f/w coalesces) interrupt load.
> >   The n/w core should drain the responses rather than calling the 
> > drain-routine from the adapter's xmit_frame() handler. This 
> way there 
> > won't be any need to
> >   modify individual xmit_frame handlers.
> 
> The problem of additional checking on such a hot path, is each
> (synchronous) read over the PCIe bus takes ~1us, which is the 
> same order of cost of executing 1000 instructions (and 
> getting greater with faster processors and deeper serial 
> buses). 

Totally agree. Non-posted transactions are expensive.


> Perhaps it's sufficiently low cost if the NIC's RX 
> queue status/structure was in main memory (vs registers over PCI).
> 

Ok, I was under the impression that the RX-pointers are in the host-memory. And 
so it would be a local mem-read as opposed to a PCI-transaction. So this 
is obviously a NIC-design(ASIC/fw) decision.Nothing much we can do about it.

> If latency is not favoured over throughput, 


> increasing the 
> packet coalescing watermarks may reduce interrupt rate and 
> thus some performance loss?
> 
> Daniel

Well, coalescing goes hand-in-hand.We can't optimize just the 'driver/OS' stack and not optimize the adapter @ all.
Lets assume(and this was my assumption) the (partial)RX-structs are in host's memory.

So,
1) The RX-put ptr is in the host-memory(NIC updates by a posted transaction).
2) The RX-get ptr is on the NIC(host updates by a posted-transaction.PCIe bridge will coalesce the posted-writes).

3) Under heavy load the TX path is getting beat up really heavy. 
  3.1) The modified algo will read(now a local-read) the RX-put ptr and drain(after posting the TX-job) the RX-queue.
  3.2) The host then updates the RX-get ptr on the NIC via a posted-write(don't flush the write,let the bridge coalesce).
       Coalescing has so far worked for us. So it should work for others.But we can't speak for the chipsets.
  3.3) This is where the coalescing algo kicks-in on the NIC(adapter) side.
     3.3.1) The NIC f/w reads(local read) the RX-get ptr and does different things - 
           3.3.1.1) If the host is making good progress then it should reset the interrupt-timer.
           3.3.1.2) If the host is not making enough progress(latency-algorithm) then it should fire the interrupt.
                    This will ensure timely response and lower-latency under bursty loads.

I think some chipsets support a relaxed version of PCI-read. So drivers could use that unless you really want to flush your posted-write.



Chetan Loke