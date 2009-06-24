Return-Path: <linux-kernel-owner+w=401wt.eu-S1759801AbZFXRAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801AbZFXRAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbZFXRAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:00:05 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:63411 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbZFXRAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:00:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BysQirOve/5b1gqQozjk0dK6e4SLspqpQPiT4DjO3Tka2/X32TvrRbXA4D8Fq1kntz
         puMhYP4ostOYeLLPCa+xRNDtt7gkLeGTxtehU84/1hHuvEKFofJsSRyPMhEvkSkHZH7O
         okQd0SAyHVB+tHb+KBvnlKioNE8JOttpnFE0U=
MIME-Version: 1.0
In-Reply-To: <84144f020906240956x1f96abbax5eef3667828b66cd@mail.gmail.com>
References: <20090624080753.4f677847@infradead.org>
	 <20090624094622.d0b0fd82.akpm@linux-foundation.org>
	 <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com>
	 <84144f020906240956x1f96abbax5eef3667828b66cd@mail.gmail.com>
Date: Wed, 24 Jun 2009 20:00:04 +0300
X-Google-Sender-Auth: d6b49c213e1e22ff
Message-ID: <84144f020906241000l5870771fp262444cbc1840653@mail.gmail.com>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 7:56 PM, Pekka Enberg<penberg@cs.helsinki.fi> wrote:
> On Wed, Jun 24, 2009 at 7:55 PM, Pekka Enberg<penberg@cs.helsinki.fi> wrote:
>> Hi Andrew,
>>
>> On Wed, 24 Jun 2009 08:07:53 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
>>>> a new item is coming up fast in the kerneloops.org stats, and it's new
>>>> in 2.6.31-rc;
>>>>
>>>> http://www.kerneloops.org/searchweek.php?search=get_page_from_freelist
>>>>
>>>> it's this warning in mm/page_alloc.c:
>>>>
>>>>                         * __GFP_NOFAIL is not to be used in new code.
>>>>                          *
>>>>                          * All __GFP_NOFAIL callers should be fixed so that they
>>>>                          * properly detect and handle allocation failures.
>>>>                          *
>>>>                          * We most definitely don't want callers attempting to
>>>>                          * allocate greater than single-page units with
>>>>                          * __GFP_NOFAIL.
>>>>                          */
>>>>                         WARN_ON_ONCE(order > 0);
>>>>
>>>>
>>>> typical backtraces look like
>>>>
>>>> get_page_from_freelist
>>>> __alloc_pages_nodemask
>>>> alloc_pages_current
>>>> alloc_slab_page
>>>> new_slab
>>>> __slab_alloc
>>>> kmem_cache_alloc_notrace
>>>> start_this_handle
>>>> jbd2_journal_start
>>>>
>>>> and
>>>>
>>>> get_page_from_freelist
>>>> __alloc_pages_nodemask
>>>> alloc_pages_current
>>>> alloc_slab_page
>>>> new_slab
>>>> __slab_alloc
>>>> kmem_cache_alloc_notrace
>>>> start_this_handle
>>>> journal_start
>>>> ext3_journal_start_sb
>>>> ext3_journal_start
>>>> ext3_dirty_inode
>>>>
>>>> but there are some other ones as well at the url above.
>>>>
>>>>
>>>> git blame shows that
>>>>
>>>> commit dab48dab37d2770824420d1e01730a107fade1aa
>>>> Author: Andrew Morton <akpm@linux-foundation.org>
>>>> Date:   Tue Jun 16 15:32:37 2009 -0700
>>>>
>>>> introduced this WARN_ON.....
>>
>> On Wed, Jun 24, 2009 at 7:46 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>>> Well yes.  Using GFP_NOFAIL on a higher-order allocation is bad.  This
>>> patch is there to find, name, shame, blame and hopefully fix callers.
>>>
>>> A fix for cxgb3 is in the works.  slub's design is a big problem.
>>>
>>> But we'll probably have to revert it for 2.6.31 :(
>>
>> How is SLUB's design a problem here? Can't we just clear GFP_NOFAIL
>> from the higher order allocation and thus force GFP_NOFAIL allocations
>> to use the minimum required order?
>
> Small correction: force GFP_NOFAIL allocations to use minimum order
> _if_ the higher order allocation fails.

And here's a badly linewrapped, untested patch to do that (sorry I
don't have my laptop here). Christoph, does this look ok to you?

diff --git a/mm/slub.c b/mm/slub.c
index ce62b77..8aaf0fa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1088,8 +1088,7 @@ static struct page *allocate_slab(struct
kmem_cache *s, gfp_t flags, int node)

        flags |= s->allocflags;

-       page = alloc_slab_page(flags | __GFP_NOWARN | __GFP_NORETRY, node,
-                                                                       oo);
+       page = alloc_slab_page(flags & ~__GFP_NOFAIL | __GFP_NOWARN |
__GFP_NORETRY, node, oo);
        if (unlikely(!page)) {
                oo = s->min;
                /*
