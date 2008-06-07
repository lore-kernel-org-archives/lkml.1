Return-Path: <linux-kernel-owner+w=401wt.eu-S1763646AbYFGSP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763646AbYFGSP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 14:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761684AbYFGSPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 14:15:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:50100 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761583AbYFGSPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 14:15:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SMRKCfy6SFn/v7LgB/E4Ow4LKEyRtOZDiy5VfJENtJCjscMC04bm+fkePpxdh17jQT
         zwTwCs14ihdSo6sP9+L0b+6SQbp5B3cD/KIpgManQxDq0sNSzmE82souFhngFpJpXwpm
         ATWJNffdk51HS7UaabHZLg1sIkn4IJM2Kk1+k=
Message-ID: <19f34abd0806071115s3e50d662p190a65fa2f091c7b@mail.gmail.com>
Date: Sat, 7 Jun 2008 20:15:17 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] kmemcheck: don't track pages allocated with interrupts disabled
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <484AC165.7000702@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080607143242.GA2893@damson.getinternet.no>
	 <484AC165.7000702@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 7:12 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Vegard Nossum wrote:
>> It seems that I was wrong regarding the set_memory_4k() approach. It seems
>> to only have worked because we were lucky.
>
> You just put it in the wrong place I think.
>

It is called when the slab allocator has allocated a new slab page.
But slab allocations can be made from irq_disabled() context...

I don't know where we may otherwise place it. It would be really nice
to be able to ask the page allocator for 4k-physical (already split)
pages. This means that we could request (only) those pages for new
slabs, and give out the large pages to others that don't need this.

>> We may later reinstate the code
>> to disable PSE, but this time not unconditionally, perhaps with a config
>> option or boot-time option.
>
> It would be kind of guaranteed (not sure 100%) together with
> CONFOG_DEBUG_PAGEALLOC and Thomas' page table pool (the pool is ifdefed
> on that)
>
> But a far better solution is to just split all the pages in  the system
> with set_memory_4k() at boot time  (and memory hot add time) when you
> know you're not in interrupt context.
>
> I believe that would be the right solution for DEBUG_PAGEALLOC too.

Yes, but this is kind of the same approach that we had before by
disabling PSE entirely. The drawback here is that a kernel configured
with KMEMCHECK=y and booted without kmemcheck=1 will still call
set_memory_4k(), even though it isn't necessary (kmemcheck may never
be used on the system and the system is capable of using large pages).

Maybe we can do the splitting when kmemcheck is enabled for the first
time, either with the proc handler or at boot if kmemcheck=1 is passed
on the command line. Both of these contexts should/can be
!irqs_disabled(), I think.

I may try to implement this idea. Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
