Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbXFYN4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbXFYN4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbXFYN4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:56:41 -0400
Received: from mail.atmel.fr ([81.80.104.162]:55889 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbXFYN4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:56:40 -0400
Message-ID: <467FC939.3080603@rfo.atmel.com>
Date: Mon, 25 Jun 2007 15:55:05 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Andrew Victor <andrew@sanpeople.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com> <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com> <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
	 <20070624083849.GA19079@flint.arm.linux.org.uk> <Pine.LNX.4.64.0706241122030.27778@blonde.wat.veritas.com> <20070624105152.GB14099@flint.arm.linux.org.uk>
	 <Pine.LNX.4.64.0706250120560.28286@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0706250120560.28286@blonde.wat.veritas.com>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins :
> On Sun, 24 Jun 2007, Russell King wrote:
>> On Sun, Jun 24, 2007 at 11:24:16AM +0100, Hugh Dickins wrote:
>>> On Sun, 24 Jun 2007, Russell King wrote:
>>>> On Fri, Jun 22, 2007 at 07:39:33PM +0100, Hugh Dickins wrote:
>>>>
>>>> Please forward the original problem report.
>>> Done.
>> Okay, that seems to back up my suspicions - it's definitely AT91-based.
>> Since AT91-based machines do not have a DMA coherent cache,
>> arch_is_coherent() must be defined to '0'.  The only way that kmalloc
>> could be reached is if that were defined to something other than '0',
>> and if that's done on a machine with DMA incoherent caches, that will
>> lead to data corruption.
> 
> Yes, having looked through that now, I agree with you 100%.

AT91 _is_ defined with the arch_is_coherent() switch set to 0 (in 
include/asm-arm/memory.h and not overloaded).

>> I think we need to wait for Nicolas to respond on this issue before
>> running headlong into applying a sticky plaster for something which is
>> actually a deeper issue.
> 
> No need for Nicolas to respond, I think I've found what's "wrong":
> see below.
> 
>> However, the arch_is_coherent() path _is_ buggy as it stands, but in
>> more than the way identified thus far.  Eg, it doesn't set __GFP_DMA
>> appropriately for various DMA masks, so it might return DMA inaccessible
>> memory.

Ok it is bad but, in AT91, all memory is accessible with DMA.

[..]

> The slub allocation which gives rise to Nicolas' oops in not in
> ARM, but (I'm guessing) in drivers/mmc/core/sd.c: one of those
> 	status = kmalloc(64, GFP_KERNEL);
> where status is passed down for the response from mmc_sd_switch.

True, the oops appears after a mmc switch command (#6 command).

[..]

Not sure I can add much to what Hugh has said. If you need some more 
precision anyway, I will try to answer.

Regards,
-- 
Nicolas Ferre


