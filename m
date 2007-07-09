Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbXGILRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbXGILRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXGILRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:17:05 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:26937 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751835AbXGILRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:17:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=xeYK734h3MH6gv6OsooS+KIxaqaeFRNw+aKfXIZhVVQFzrwF0R/NJHxpyXqMYAWZYF3wGrDyGmGFJfJDBfh0hTdfm1e7FPgqORHRAsMqQKla3O2HJmMtxCcYOvzptogMTpvRxAUX4eBFy9f4CF2tYDppqlCFN2Nd41tXFCvHrwk=  ;
X-YMail-OSG: VhcmCTQVM1lg0UFk5uuAy57J4ssB8wk57mmVjDh8nSY47QYQiq8nBnQs7dGbdgeN2dvUbamWPw--
Message-ID: <46921928.8020900@yahoo.com.au>
Date: Mon, 09 Jul 2007 21:16:56 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, suresh.b.siddha@intel.com,
       corey.d.gough@intel.com, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
References: <20070708034952.022985379@sgi.com>	 <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu>	 <20070708110224.9cd9df5b.akpm@linux-foundation.org>	 <4691A415.6040208@yahoo.com.au> <84144f020707090404l657a62c7x89d7d06b3dd6c34b@mail.gmail.com>
In-Reply-To: <84144f020707090404l657a62c7x89d7d06b3dd6c34b@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Nick,
> 
> On 7/9/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> SLOB contains several significant O(1) and also O(n) memory savings that
>> are so far impossible-by-design for SLUB. They are: slab external
>> fragmentation is significantly reduced; kmalloc internal fragmentation is
>> significantly reduced; order of magnitude smaller kmem_cache data type;
>> order of magnitude less code...
> 
> 
> I assume with "slab external fragmentation" you mean allocating a
> whole page for a slab when there are not enough objects to fill the
> whole thing thus wasting memory?

Yep. Without really analysing it, I guess SLOB's savings here are
O(1) over SLUB and will relatively diminish as the machine size gets
larger, however with the number of slabs even a small kernel creates,
this is likely to be significant on small memory systems.


> We could try to combat that by
> packing multiple variable-sized slabs within a single page. Also,

Yeah, that could help.


> adding some non-power-of-two kmalloc caches might help with internal
> fragmentation.

That too, although of course it will work against the external
fragmentation problem. This is more of an O(n) problem and may not
be responsible for as much waste as the first issue on small memory
machines (I haven't done detailed profiling so I don't know).


> In any case, SLUB needs some serious tuning for smaller machines
> before we can get rid of SLOB.

I would always be happy to see the default allocator become more
space efficient... I think it would be most productive to get
detailed profiles of exactly where the memory is being wasted on
small mem= boots. Although I don't think matching SLOB would be
an easy task at all.

-- 
SUSE Labs, Novell Inc.
