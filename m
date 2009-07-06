Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZGFV7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZGFV7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZGFV64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:58:56 -0400
Received: from emulex.emulex.com ([138.239.112.1]:59345 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZGFV6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:58:55 -0400
From: Chetan.Loke@Emulex.Com
To: <daniel.blueman@gmail.com>, <matthew@wil.cx>, <andi@firstfloor.org>
CC: <linux-kernel@vger.kernel.org>, <jens.axboe@oracle.com>,
       <arjan@infradead.org>
Date: Mon, 6 Jul 2009 14:58:33 -0700
Subject: RE: >10% performance degradation since 2.6.18
Thread-Topic: >10% performance degradation since 2.6.18
Thread-Index: Acn9X9rbtbE1/DS5R/yNgukxwg7ggwBF76bQ
Message-ID: <412A05BA40734D4887DBC67661F433080CB08E7A@EXMAIL.ad.emulex.com>
References: <6278d2220907050400k1359df3av4045d3bba07d2be7@mail.gmail.com>
In-Reply-To: <6278d2220907050400k1359df3av4045d3bba07d2be7@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 06 Jul 2009 21:58:36.0289 (UTC) FILETIME=[E9786710:01C9FE84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
> Daniel J Blueman
> Sent: Sunday, July 05, 2009 7:01 AM
> To: Matthew Wilcox; Andi Kleen
> Cc: Linux Kernel; Jens Axboe; Arjan van de Ven
> Subject: Re: >10% performance degradation since 2.6.18
> 
> On Jul 3, 9:10 pm, Arjan van de Ven <ar...@infradead.org> wrote:
> > On Fri, 3 Jul 2009 21:54:58 +0200
> >
> > Andi Kleen <a...@firstfloor.org> wrote:
> > > > That would seem to be a fruitful avenue of investigation -- 
> > > > whether limiting the cards to a single RX/TX interrupt would be 
> > > > advantageous, or whether spreading the eight interrupts 
> out over 
> > > > the CPUs would be advantageous.
> >
> > > The kernel should really do the per cpu binding of MSIs 
> by default.
> >
> > ... so that you can't do power management on a per socket basis?
> > hardly a good idea.
> >
> > just need to use a new enough irqbalance and it will spread out the 
> > interrupts unless your load is low enough to go into low power mode.
> 
> I was finding newer kernels (>~2.6.24) would set the 
> Redirection Hint bit in the MSI address vector, allowing the 
> processors to deliver the interrupt to the lowest interrupt 
> priority (eg idle, no powersave) core 
> (http://www.intel.com/Assets/PDF/manual/253668.pdf pp10-66) 
> and older irqbalance daemons would periodically naively 
> rewrite the bitmask of cores, delivering the interrupt to a 
> static one.
> 
> Thus, it may be worth checking if disabling any older 
> irqbalance daemon gives any win.
> 
> Perhaps there is value in writing different subsets of cores 
> to the MSI address vector core bitmask (with the redirection 
> hint enabled) for different I/O queues on heavy interrupt 
> sources? By default, it's all cores.
> 

Possible enhancement - 

1) Drain the responses in the xmit_frame() path. That is, post the TX-request() and just before returning see if there are
   any more responses in the RX-queue. This will minimize(only if the NIC f/w coalesces) interrupt load.
   The n/w core should drain the responses rather than calling the drain-routine from the adapter's xmit_frame() handler. This way there won't be any need to
   modify individual xmit_frame handlers.


PS - I'm not familiar with the networking code.



Chetan Loke