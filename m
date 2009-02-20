Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZBTFa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZBTFa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 00:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZBTFaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 00:30:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:36564 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbZBTFaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 00:30:15 -0500
Message-ID: <499E3FBA.50102@kernel.org>
Date: Fri, 20 Feb 2009 14:29:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org>	<1234958676-27618-10-git-send-email-tj@kernel.org>	<20090219021015.aac6ea43.akpm@linux-foundation.org>	<499E16D5.9070106@kernel.org> <20090219190417.c664bff4.akpm@linux-foundation.org>
In-Reply-To: <20090219190417.c664bff4.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Feb 2009 05:29:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

Andrew Morton wrote:
>> Hmmm... Is it customary to dump stack on allocation failure?  AFAICS,
>> kmalloc or vmalloc isn't doing it.
> 
> The page allocator (and hence kmalloc) will do it.
> 
> But a more important question is "is a trace useful".  I'd say "yes". 
> Because being told that something ran out of memory isn't terribly
> useful.  The very first question is "OK, well _what_ ran out of
> memory?".

Then the page allocator will do it for percpu allocator too other than
get_vm_area() failure.  I think the right place to add dump_stack()
would be failure path of get_mv_area().  Right?

>> Because those parameters are initialized during boot but should work
>> as constant once they're set up.  I wanted to make sure that these
>> values don't get assigned to or changed and make that clear by making
>> them look like constants as except for the init code they're constants
>> for all purposes.
> 
> Well, there are an infinite number of ways in which people can later
> introduce bugs.  Why defend against just one?  Particularly in a way
> which muckies up the code?
> 
> If you really want to defend against alterations, access these things
> via function calls rather than via nastycasts which masquerade as
> constants?
> 
> static inline int pcpu_unit_pages_shift(void)
> {
> 	return __pcpu_unit_pages_shift;
> }

It's more a notation to signify the semantics of usage rather than the
mechanics.  I don't really see why this is such a big deal.  Macros
evaluating to rvalue to act as pseudo constant isn't that uncommon.
Anyways, I'll just drop the macros and use the raw variables.

>>> Methinks vmalloc() should have a might_sleep().  Dunno.
>> I can add that but it's an internal utility function which is called
>> from a few well known obvious call sites to replace krealloc, so I
>> don't thinks it's a big deal.  Maybe the correct thing to do is adding
>> might_sleep() to vmalloc?
> 
> I think so.  It perhaps already has one, via indirect means.

Alright, will look into it and add it if it actually is missing.

>>> A designed decision has been made to not permit the caller to specify
>>> the allocation mode?
>> The design decision was inherited from the original percpu allocator.
> 
> That doesn't mean it's right ;)

:-)

> But I don't recall us ever wishing that the gfp_t arg had been
> included.
> 
>>>> +static void free_pcpu_chunk(struct pcpu_chunk *chunk)
>>>> +{
>>>> +	if (!chunk)
>>>> +		return;
>>> afaict this test is unneeded.
>> I think it's better to put NULL test to free functions in general.
>> People expect free functions to take NULL argument and swallow it.
>> Doint it otherwise adds unnecessary danger for subtle bugs later on.
> 
> It's a dumb convention.  In the vast majority of cases the pointer is
> not NULL.  We add a test-n-branch to 99.999999999% of cases just to
> save three seconds of programmer effort a single time.
> 
> A better design would have been to have kfree() and
> kfree_might_be_null().  (We can still do that by adding a new
> kfree_im_not_stupid() which doesn't do the check).
> 
> It's a bad tradeoff to expend billions of cycles on millions of
> machines to save a little programmer effort.
> 
> (And we're not consistent anyway - see pci_free_consistent)

By making free_pcpu_chunk() not accept NULL, we'll only increase the
inconsistency.  The given fact is that we simply can't remove it from
kfree() at this point.  With the most popular free function supporting
that convention, it's silly and unfruitful to do things otherwise.  It
forces callers of any free functions to go look for each function
implementation to check whether it accepts NULL or not and in many
cases to wrongly assume one way or the other.  I don't think the
minute performance gain justifies the programming overhead.  Given the
current situation, what needs fixing is pci_free_consistent().

>>>> +void *__alloc_percpu(size_t size, size_t align)
>>>> +{
>>>> +	void *ptr = NULL;
>>>> +	struct pcpu_chunk *chunk;
>>>> +	int slot, off, err;
>>>> +
>>>> +	if (unlikely(!size))
>>>> +		return NULL;
>>> hm.  Why do we do this?  Perhaps emitting this warning:
>>>
>>>> +	if (unlikely(size > PAGE_SIZE << PCPU_MIN_UNIT_PAGES_SHIFT ||
>>>> +		     align > PAGE_SIZE)) {
>>>> +		printk(KERN_WARNING "illegal size (%zu) or align (%zu) for "
>>>> +		       "percpu allocation\n", size, align);
>>> would be more appropriate.
>> Maybe.  Dunno.  Returning NULL is what malloc/calloc are allowed to do
>> at least.
> 
> Yes, but it is probably a programming error in the caller.  We want to
> report that asap, not hide it.  The buggy caller will probably now
> assume that the memory allocation failed and will bale out altogether,
> leaving everyone all confused.

I kind of agree to this one.  Most alloc functions do allow it but
yeap its usage isn't very prevalent and is much more likely to be
buggy.  Alright, WARN_ON() then.

>>>> +/**
>>>> + * free_percpu - free percpu area
>>>> + * @ptr: pointer to area to free
>>>> + *
>>>> + * Free percpu area @ptr.  Might sleep.
>>>> + */
>>>> +void free_percpu(void *ptr)
>>>> +{
>>>> +	void *addr = __pcpu_ptr_to_addr(ptr);
>>>> +	struct pcpu_chunk *chunk;
>>>> +	int off;
>>>> +
>>>> +	if (!ptr)
>>>> +		return;
>>> Do we ever do this?  Should it be permitted?  Should we warn?
>> Dunno but should be allowed, yes, no.  :-)
> 
> It adds cycles and hides caller bugs.  Zap it!

Heh heh... No! :-) I'm sorry but I think that's the wrong decision.

Thanks.

-- 
tejun
