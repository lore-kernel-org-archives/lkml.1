Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbZFXQrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbZFXQrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759788AbZFXQrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:47:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759297AbZFXQrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:47:16 -0400
Date: Wed, 24 Jun 2009 09:46:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-Id: <20090624094622.d0b0fd82.akpm@linux-foundation.org>
In-Reply-To: <20090624080753.4f677847@infradead.org>
References: <20090624080753.4f677847@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 08:07:53 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> Hi,
> 
> a new item is coming up fast in the kerneloops.org stats, and it's new
> in 2.6.31-rc;
> 
> http://www.kerneloops.org/searchweek.php?search=get_page_from_freelist
> 
> it's this warning in mm/page_alloc.c:
> 
>                         * __GFP_NOFAIL is not to be used in new code.
>                          *
>                          * All __GFP_NOFAIL callers should be fixed so that they
>                          * properly detect and handle allocation failures.
>                          *
>                          * We most definitely don't want callers attempting to
>                          * allocate greater than single-page units with
>                          * __GFP_NOFAIL.
>                          */
>                         WARN_ON_ONCE(order > 0);
>   
> 
> typical backtraces look like
> 
> get_page_from_freelist
> __alloc_pages_nodemask
> alloc_pages_current
> alloc_slab_page
> new_slab
> __slab_alloc
> kmem_cache_alloc_notrace
> start_this_handle
> jbd2_journal_start
> 
> and
> 
> get_page_from_freelist
> __alloc_pages_nodemask
> alloc_pages_current
> alloc_slab_page
> new_slab
> __slab_alloc
> kmem_cache_alloc_notrace
> start_this_handle
> journal_start
> ext3_journal_start_sb
> ext3_journal_start
> ext3_dirty_inode
> 
> but there are some other ones as well at the url above.
> 
> 
> git blame shows that 
> 
> commit dab48dab37d2770824420d1e01730a107fade1aa
> Author: Andrew Morton <akpm@linux-foundation.org>
> Date:   Tue Jun 16 15:32:37 2009 -0700
> 
> introduced this WARN_ON.....

Well yes.  Using GFP_NOFAIL on a higher-order allocation is bad.  This
patch is there to find, name, shame, blame and hopefully fix callers.

A fix for cxgb3 is in the works.  slub's design is a big problem.

But we'll probably have to revert it for 2.6.31 :(
