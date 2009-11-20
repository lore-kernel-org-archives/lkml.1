Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbZKTLFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbZKTLFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 06:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZKTLFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 06:05:54 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48430 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZKTLFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 06:05:53 -0500
Message-ID: <4B067816.6070304@cs.helsinki.fi>
Date: Fri, 20 Nov 2009 13:05:58 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: paulmck@linux.vnet.ibm.com, linux-mm@kvack.org, cl@linux-foundation.org,
       mpm@selenic.com, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
References: <20091118181202.GA12180@linux.vnet.ibm.com>	 <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>	 <1258709153.11284.429.camel@laptop>	 <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com> <1258714328.11284.522.camel@laptop>
In-Reply-To: <1258714328.11284.522.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra kirjoitti:
> On Fri, 2009-11-20 at 12:38 +0200, Pekka Enberg wrote:
>>
>> On Fri, Nov 20, 2009 at 11:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>  2) propagate the nesting information and user spin_lock_nested(), given
>>> that slab is already a rat's nest, this won't make it any less obvious.
>> spin_lock_nested() doesn't really help us here because there's a
>> _real_ possibility of a recursive spin lock here, right? 
> 
> Well, I was working under the assumption that your analysis of it being
> a false positive was right ;-)
> 
> I briefly tried to verify that, but got lost and gave up, at which point
> I started looking for ways to annotate.

Uh, ok, so apparently I was right after all. There's a comment in 
free_block() above the slab_destroy() call that refers to the comment 
above alloc_slabmgmt() function definition which explains it all.

Long story short: ->slab_cachep never points to the same kmalloc cache 
we're allocating or freeing from. Where do we need to put the 
spin_lock_nested() annotation? Would it be enough to just use it in 
cache_free_alien() for alien->lock or do we need it in 
cache_flusharray() as well?

			Pekka
