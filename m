Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbZFXQza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbZFXQza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbZFXQzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:55:23 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35174 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZFXQzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nR6czT9MuBOqKbAjzqamXwyjeY7b7Ter5LiDmv6vQF+yf9UkvRzLTyOVakryjVOPQo
         qgjF9zXa6+uHx3ouG2U5tWqEFqzET0iItqunJJeSvjIzWHjSY1tyAAGbMWiVii2O77AU
         ktjfjfZOsI0fItePen8uvzhE++ErSt7zYdLG4=
MIME-Version: 1.0
In-Reply-To: <20090624094622.d0b0fd82.akpm@linux-foundation.org>
References: <20090624080753.4f677847@infradead.org>
	 <20090624094622.d0b0fd82.akpm@linux-foundation.org>
Date: Wed, 24 Jun 2009 19:55:24 +0300
X-Google-Sender-Auth: 2c60b86d9630a3f1
Message-ID: <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com>
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

Hi Andrew,

On Wed, 24 Jun 2009 08:07:53 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
>> a new item is coming up fast in the kerneloops.org stats, and it's new
>> in 2.6.31-rc;
>>
>> http://www.kerneloops.org/searchweek.php?search=get_page_from_freelist
>>
>> it's this warning in mm/page_alloc.c:
>>
>>                         * __GFP_NOFAIL is not to be used in new code.
>>                          *
>>                          * All __GFP_NOFAIL callers should be fixed so that they
>>                          * properly detect and handle allocation failures.
>>                          *
>>                          * We most definitely don't want callers attempting to
>>                          * allocate greater than single-page units with
>>                          * __GFP_NOFAIL.
>>                          */
>>                         WARN_ON_ONCE(order > 0);
>>
>>
>> typical backtraces look like
>>
>> get_page_from_freelist
>> __alloc_pages_nodemask
>> alloc_pages_current
>> alloc_slab_page
>> new_slab
>> __slab_alloc
>> kmem_cache_alloc_notrace
>> start_this_handle
>> jbd2_journal_start
>>
>> and
>>
>> get_page_from_freelist
>> __alloc_pages_nodemask
>> alloc_pages_current
>> alloc_slab_page
>> new_slab
>> __slab_alloc
>> kmem_cache_alloc_notrace
>> start_this_handle
>> journal_start
>> ext3_journal_start_sb
>> ext3_journal_start
>> ext3_dirty_inode
>>
>> but there are some other ones as well at the url above.
>>
>>
>> git blame shows that
>>
>> commit dab48dab37d2770824420d1e01730a107fade1aa
>> Author: Andrew Morton <akpm@linux-foundation.org>
>> Date:   Tue Jun 16 15:32:37 2009 -0700
>>
>> introduced this WARN_ON.....

On Wed, Jun 24, 2009 at 7:46 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> Well yes.  Using GFP_NOFAIL on a higher-order allocation is bad.  This
> patch is there to find, name, shame, blame and hopefully fix callers.
>
> A fix for cxgb3 is in the works.  slub's design is a big problem.
>
> But we'll probably have to revert it for 2.6.31 :(

How is SLUB's design a problem here? Can't we just clear GFP_NOFAIL
from the higher order allocation and thus force GFP_NOFAIL allocations
to use the minimum required order?

                              Pekka
