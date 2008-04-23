Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbYDWSPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbYDWSPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbYDWSO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:14:58 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:43246 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbYDWSO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:14:57 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: "Grant Grundler" <grundler@google.com>
Subject: Re: [PATCH] pci_try_set_mwi() in sata_promise
Date: Wed, 23 Apr 2008 21:15:32 +0300
User-Agent: KMail/1.9.7
Cc: "Mikael Pettersson" <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       "Jeff Garzik" <jgarzik@pobox.com>, linux-ide@vger.kernel.org
References: <200804222126.56321.mitov@issp.bas.bg> <200804231633.24603.mitov@issp.bas.bg> <da824cf30804230746o74e8de0bxbcb31d4b13e98b6@mail.gmail.com>
In-Reply-To: <da824cf30804230746o74e8de0bxbcb31d4b13e98b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804232115.33080.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2008 05:46:49 pm Grant Grundler wrote:
> On Wed, Apr 23, 2008 at 6:33 AM, Marin Mitov <mitov@issp.bas.bg> wrote:
> ...
> >  > 2. What improvement does that pci_try_set_mwi() cause? Speed? Fewer errors?
> >
> >  May be speed, but practically hardly observable.
> 
> I expect the difference to be in available memory BW.
> MWI (Memory Write Invalidate) allows the IO controller to write
> partial cachlines without having to do a read/modify/write sequence.

My understanding of MWI is different. It concerns full cache line writes.
In that case the CPU can invalidate the cache line (without flushing it to 
RAM). While in case of partial cache line writes, the processor should 
flush the cache line before the controller writes to corresponding cached 
address and then the controller finishes its partial cache line write to RAM.
In case MWI is NOT enables the CPU should flushe every cache line  touched
by the controller's DMA machine, nevertheless it will be overwritten latter.

But, as usual, I could be wrong :-)

> R/W/M means the cacheline has to cross the memory bus twice.
> The difference in performance will depend on how often the
> Promise SATA controller was doing partial cachline
> transactions with the wrong cacheline size.
> 
> This should be measurable if you run a memory test at the same time
> as you stress the SATA controller with fio. Re-read the same 128KB block
> repeatedly from the Promise controller (I'm expecting that to be cached)
> and measure the available memory BW (e.g. see lmbench for a memtest).
> Repeat with MWI enabled.
> 
> 
> >  > 3. Why call pci_try_set_mwi()? Can't you set the cache line size directly?
> >
> >  pci_set_cacheline_size() is NOT exported, while pci_try_set_mwi() IS and
> > sets (as a side effect) the cache line size.
> 
> Setting the cachline size only makes sense if MWI is enabled.

Agreed.

> Drivers should not longer directly set the cacheline size since it might
> not be what they think it is.

That is the reason why pci_set_mwi() and pci_try_set_mwi() exist.

Marin Mitov

> 
> hth,
> grant
> 


