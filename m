Return-Path: <linux-kernel-owner+w=401wt.eu-S1757752AbZEQBYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbZEQBYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 21:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbZEQBYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 21:24:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:54534 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbZEQBYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 21:24:33 -0400
Message-ID: <4A0F672A.3000309@kernel.org>
Date: Sun, 17 May 2009 10:23:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: suresh.b.siddha@intel.com
CC: "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org>	 <1242436626.27006.8623.camel@localhost.localdomain>	 <4A0ED8D8.2010303@kernel.org> <1242500964.27006.8636.camel@localhost.localdomain>
In-Reply-To: <1242500964.27006.8636.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 17 May 2009 01:23:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Suresh.

Suresh Siddha wrote:
> On Sat, 2009-05-16 at 08:16 -0700, Tejun Heo wrote:
>> Hello, Suresh.
>>
>> Suresh Siddha wrote:
>>> Tejun, Can you please educate me why we need to map this first
>>> percpu chunk (which is pre-allocated during boot and is physically
>>> contiguous) into vmalloc area?
>> To make areas for each cpu congruent such that the address offset of a
>> percpu symbol for CPU N is always the same from the address for CPU 0.
> 
> But for the first percpu chunk, isn't it the case that the physical
> address allocations for a particular cpu is contiguous (as you are using
> one bootmem allocation for whole PMD_SIZE for any given cpu)? So both
> the kernel direct mapping aswell as the vmalloc mappings are contiguous
> for the first chunk, on any given cpu. Right?

Hmmm... okay.  Percpu areas are composed of multiple chunks.  A single
chunk is composed of multiple units, one unit for each CPU.  Units in
a single chunk should be contiguous and of the same size such that
unit_addr_for_cpu_N == chunk_addr + N * unit_size whereas chunks don't
need to have any special address relation to other chunks.  Combined,
this results in percpu addresses for CPU N are always offset by N *
unit_size from the percpu adresses for CPU 0 which can be efficiently
determined using some extra resource in the processor (segment
register on x86 for example).

For remap first chunk allocator, each unit for each CPU is allocated
separately using the bootmem allocator.  Each unit is continuous but
they still need to be assembed into a single contiguous area to be
used as the first chunk, which is where the remapping comes in.  So,
the extra requirement is that units in the same chunk need to be
contiguous and NUMA allocation means units will be spread according to
NUMA configuration, so they need to be put together by remapping them.

>>> Perhaps even for the other dynamically allocated secondary chunks?
>>> (as far as I can see, all the chunk allocations seems to be
>>> physically contiguous and later mapped into vmalloc area)..
>>>
>>> That should simplify these things quite a bit(atleast for first
>>> percpu chunk).  I am missing something obvious I guess.
>> Hmm... Sorry I don't really follow.  Can you please elaborate the
>> question?
> 
> For the first percpu chunk, we can use the kernel direct mapping and
> avoid the vmalloc mapping of PMD_SIZE. And avoid the vmap address
> aliasing problem (wrt to free pages that we have given back to -mm) that
> we are trying to avoid with this patchset (as the existing cpa code
> already takes care of the kernel direct mappings).

Hmmm.... If you can show me how to use the linear mapping directly,
I'll be happy as a clam.

Thanks.

-- 
tejun
