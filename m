Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZGGWGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZGGWGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 18:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757983AbZGGWF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 18:05:56 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:32956 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbZGGWFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 18:05:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pjjbDQssFycdA6MLGkkTbAr+tURY7R5kRfjG99r1GYRfalHPlSKK4Yep3mrXY0KvQj
         hdMX7wxqPpvXW1K6YtzruN+379EeE0/xsTAXo6Mm+pANwt9Jf36CVh21XptxVwoRlY6f
         T/eemtQ5bJXYszFz7hiUkHxIq8asRod5jzb5s=
MIME-Version: 1.0
In-Reply-To: <412A05BA40734D4887DBC67661F433080CB08E7A@EXMAIL.ad.emulex.com>
References: <6278d2220907050400k1359df3av4045d3bba07d2be7@mail.gmail.com>
	 <412A05BA40734D4887DBC67661F433080CB08E7A@EXMAIL.ad.emulex.com>
Date: Tue, 7 Jul 2009 23:05:48 +0100
Message-ID: <6278d2220907071505k23ae1a79l7449becb9b2f4b45@mail.gmail.com>
Subject: Re: >10% performance degradation since 2.6.18
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Chetan.Loke@emulex.com, matthew@wil.cx, andi@firstfloor.org,
       jens.axboe@oracle.com, Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 6, 2009 at 10:58 PM, <Chetan.Loke@emulex.com> wrote:
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org
>> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of
>> Daniel J Blueman
>> Sent: Sunday, July 05, 2009 7:01 AM
>> To: Matthew Wilcox; Andi Kleen
>> Cc: Linux Kernel; Jens Axboe; Arjan van de Ven
>> Subject: Re: >10% performance degradation since 2.6.18
>>
>> On Jul 3, 9:10 pm, Arjan van de Ven <ar...@infradead.org> wrote:
>> > On Fri, 3 Jul 2009 21:54:58 +0200
>> >
>> > Andi Kleen <a...@firstfloor.org> wrote:
>> > > > That would seem to be a fruitful avenue of investigation --
>> > > > whether limiting the cards to a single RX/TX interrupt would be
>> > > > advantageous, or whether spreading the eight interrupts
>> out over
>> > > > the CPUs would be advantageous.
>> >
>> > > The kernel should really do the per cpu binding of MSIs
>> by default.
>> >
>> > ... so that you can't do power management on a per socket basis?
>> > hardly a good idea.
>> >
>> > just need to use a new enough irqbalance and it will spread out the
>> > interrupts unless your load is low enough to go into low power mode.
>>
>> I was finding newer kernels (>~2.6.24) would set the
>> Redirection Hint bit in the MSI address vector, allowing the
>> processors to deliver the interrupt to the lowest interrupt
>> priority (eg idle, no powersave) core
>> (http://www.intel.com/Assets/PDF/manual/253668.pdf pp10-66)
>> and older irqbalance daemons would periodically naively
>> rewrite the bitmask of cores, delivering the interrupt to a
>> static one.
>>
>> Thus, it may be worth checking if disabling any older
>> irqbalance daemon gives any win.
>>
>> Perhaps there is value in writing different subsets of cores
>> to the MSI address vector core bitmask (with the redirection
>> hint enabled) for different I/O queues on heavy interrupt
>> sources? By default, it's all cores.
>>
>
> Possible enhancement -
>
> 1) Drain the responses in the xmit_frame() path. That is, post the TX-request() and just before returning see if there are
>   any more responses in the RX-queue. This will minimize(only if the NIC f/w coalesces) interrupt load.
>   The n/w core should drain the responses rather than calling the drain-routine from the adapter's xmit_frame() handler. This way there won't be any need to
>   modify individual xmit_frame handlers.

The problem of additional checking on such a hot path, is each
(synchronous) read over the PCIe bus takes ~1us, which is the same
order of cost of executing 1000 instructions (and getting greater with
faster processors and deeper serial buses). Perhaps it's sufficiently
low cost if the NIC's RX queue status/structure was in main memory (vs
registers over PCI).

If latency is not favoured over throughput, increasing the packet
coalescing watermarks may reduce interrupt rate and thus some
performance loss?

Daniel
-- 
Daniel J Blueman
