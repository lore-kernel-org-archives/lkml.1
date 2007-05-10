Return-Path: <linux-kernel-owner+w=401wt.eu-S1759267AbXEJUab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267AbXEJUab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbXEJUaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:30:24 -0400
Received: from holomorphy.com ([66.93.40.71]:54492 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbXEJUaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:30:23 -0400
Date: Thu, 10 May 2007 13:31:02 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
Message-ID: <20070510203102.GO19966@holomorphy.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 09:03:39PM +0100, Hugh Dickins wrote:
> Just want to report that I've been running SLUB on i386, both in -mm
> and with slub-i386-support.patch applied to 2.6.21-git, and observed
> no problems with it.  I'm anxious that it (or an equivalent) go into
> 2.6.22-rc1, i386 being now the last ARCH_USES_SLAB_PAGE_STRUCT holdout.
> In the frenzy over PowerPC, maybe Linus overlooked that i386
> was still not supporting SLUB; and I fear that once people get
> "# CONFIG_SLUB is not set" into their .config, they're less likely to
> switch over to testing CONFIG_SLUB=y - I remain anxious that it see
> as much testing as possible (but under EXPERIMENTAL for 2.6.22, yes).
> Though when I look at the patchset (copied below), I do wonder why
> it puts a quicklist_trim() into i386's cpu_idle() and flush_tlb_mm():
> neither is where I'd expect us to be secretly freeing pages.  Ah,
> several arches do it in cpu_idle(): how odd, oh well.

I need to fix this up a bit. I'll point out the issues in the sequel.

So now quicklist semantics vs. TLB flushing are the motive behind the
odd flush_tlb_mm() affair. The real trick with it is that flushing
must never occur until the TLB flush. Any change to the core quicklist
code that retires pages back to the page allocator earlier (e.g. based
on some limit) will break things badly.


On Thu, May 10, 2007 at 09:03:39PM +0100, Hugh Dickins wrote:
>> -struct kmem_cache *pgd_cache;
>>  struct kmem_cache *pmd_cache;
>>  
>>  void __init pgtable_cache_init(void)
>> @@ -776,12 +775,6 @@ void __init pgtable_cache_init(void)
>>  			pgd_size = PAGE_SIZE;
>>  		}
>>  	}
>> -	pgd_cache = kmem_cache_create("pgd",
>> -				pgd_size,
>> -				pgd_size,
>> -				SLAB_PANIC,
>> -				pgd_ctor,
>> -				(!SHARED_KERNEL_PMD) ? pgd_dtor : NULL);
>>  }

This is wrong; pgd's are smaller than PAGE_SIZE on PAE. Burning lowmem
like this is very, very bad for such systems. pmd_cache is rather
trivial to convert to quicklists, since all it does is zero pages. I
still don't approve of even the !SHARED_KERNEL_PMD case using PAGE_SIZE
-sized pgd's. Xen should really be fixed to avoid requiring guests to
have recursive pagetables or whatever it's doing.


>> @@ -205,8 +206,6 @@ void pmd_ctor(void *pmd, struct kmem_cac
>>   * against pageattr.c; it is the unique case in which a valid change
>>   * of kernel pagetables can't be lazily synchronized by vmalloc faults.
>>   * vmalloc faults work because attached pagetables are never freed.
>> - * The locking scheme was chosen on the basis of manfred's
>> - * recommendations and having no core impact whatsoever.
>>   * -- wli
>>   */
>>  DEFINE_SPINLOCK(pgd_lock);

This comment deletion is bogus, as the locking scheme has not changed.


-- wli
