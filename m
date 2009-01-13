Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbZAMC3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbZAMC3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 21:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbZAMC3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 21:29:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49914 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZAMC3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 21:29:07 -0500
Date: Tue, 13 Jan 2009 03:43:37 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Frederik Deweerdt <frederik.deweerdt@xprog.eu>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090113024337.GL23848@one.firstfloor.org>
References: <20090112213539.GA10720@gambetta> <20090112215701.GH23848@one.firstfloor.org> <20090112224037.GA16585@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112224037.GA16585@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No distro kernel will build with less than 8 CPUs anyway so this point is 
> moot.

It has nothing to do with what the distro kernel builds with. As I stated
clearly in my review the per cpu data is sized based on the possible map, 
which is discovered from the BIOS at runtime.  So if your system has two cores 
only you will only have two copies of per cpu data. 

With this patch on the other hand you will always have 8 copies
of this data; aka 1K no matter how many CPUs you have.

So the description that it saves memory is flat out 
wrong on any system with less than 8 threads (which
is by far the biggest majority of systems currently
and in the forseeable future) 

> > You would need to cache line pad each entry then, otherwise you risk 
> > false sharing. [...]
> 
> They are already cache line padded.

Yes that's the problem here. 

> 
> > [...] That would make the array 1K on 128 bytes cache line system.
> 
> 512 bytes.

8 * 128 = 1024 

Ok the real waste is a little less because you need at least one copy,
but still considerable. (896 bytes on UP, 768 bytes on 2C)


> 
> > [...]  This means on small systems this would actually waste much more 
> > memory.
> 
> Really small systems will be UP and wont do cross-CPU TLB flushes, so if 
> they are a worry the flush code can be UP optimized. (Nobody bothered so 
> far.)

The SMP flush code shouldn't be called at all on UP because the "other cpu"
mask is always empty.

Just talking about the memory. Sure it's only 1K (or 896 bytes), but if you 
add up a lot of little 896byte wastes you eventually get a lot of waste all over.

Anyways if you wanted to do this without using per cpu data you
could use alloc_percpu(), but that would be much more complicated
code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
