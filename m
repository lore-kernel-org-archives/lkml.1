Return-Path: <linux-kernel-owner+w=401wt.eu-S1161323AbXEDVce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161323AbXEDVce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161531AbXEDVce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:32:34 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:55103 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161323AbXEDVcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:32:32 -0400
Date: Fri, 4 May 2007 15:32:27 -0600
From: Mike Stroyan <mike.stroyan@hp.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rohit Seth <rohitseth@google.com>, "'Hugh Dickins'" <hugh@veritas.com>,
       "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Luck, Tony'" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
Message-ID: <20070504213227.GA2965@ldl.fc.hp.com>
References: <200704281805.l3SI5JQx030827@smtp.corp.google.com> <463727E1.3090203@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <463727E1.3090203@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 09:43:29PM +1000, Nick Piggin wrote:
> Rohit Seth wrote:
...
> >Caches on Itanium are physical.  So, it doesn't matter what virtual address
> >you use to flush a cache line, cache line containing specific physical
> >memory will be flushed. 
> 
> Really? I was under the vague impression that L1 i/d caches were virtual
> and required this flushing... but I guess so long as the ISA says that
> fc/fc.i flushes all caches corresponding to the physical address of the
> provided virtual address, then that's what matters.

  The L1 caches on Itanium have interesting behavior.  The cache lines
are indexed by virtual address.  But those L1 cache lines are invalidated
whenever their corresponding L1 TLB entry is evicted or replaced.
That means that old L1 icache lines will be invalidated by TLB changes
even before a fc.i instruction flushed those icache lines.  That would
help make old kernels work on pre-montecito processors without correctly
ordered fc.i instructions.  The L1 icache was flushed by TLB inserts
and the L2 icache was unified.

  fc.i is also defined to make an address coherent between data and
instruction caches at all levels of cache.  That handles the update of
L1 icache lines during a st,fc.i,sync.i,srlz.i sequence.

  I see these details in section 6.1.1 of "Intel® Itanium® 2 Processor
Reference Manual".  But I haven't found them in a general Itanium
Architecture reference.

-- 
Mike Stroyan, mike.stroyan@hp.com
