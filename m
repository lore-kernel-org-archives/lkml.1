Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbXLSGu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbXLSGu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 01:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbXLSGuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 01:50:51 -0500
Received: from ns1.suse.de ([195.135.220.2]:40447 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbXLSGuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 01:50:50 -0500
Date: Wed, 19 Dec 2007 07:50:49 +0100
From: Nick Piggin <npiggin@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Rohland <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] tmpfs: radix_tree_preloading
Message-ID: <20071219065049.GA31872@wotan.suse.de>
References: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com> <Pine.LNX.4.64.0712182204210.27165@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712182204210.27165@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 10:05:19PM +0000, Hugh Dickins wrote:
> Nick has observed that shmem.c still uses GFP_ATOMIC when adding to page
> cache or swap cache, without any radix tree preload: so tending to deplete
> emergency reserves of memory.
> 
> GFP_ATOMIC remains appropriate in shmem_writepage's add_to_swap_cache:
> it's being called under memory pressure, so must not wait for more memory
> to become available.  But shmem_unuse_inode now has a window in which it
> can and should preload with GFP_KERNEL, and say GFP_NOWAIT instead of
> GFP_ATOMIC in its add_to_page_cache.
> 
> shmem_getpage is not so straightforward: its filepage/swappage integrity
> relies upon exchanging between caches under spinlock, and it would need a
> lot of restructuring to place the preloads correctly.  Instead, follow
> its pattern of retrying on races: use GFP_NOWAIT instead of GFP_ATOMIC in
> add_to_page_cache, and begin each circuit of the repeat loop with a sleeping
> radix_tree_preload, followed immediately by radix_tree_preload_end - that
> won't guarantee success in the next add_to_page_cache, but doesn't need to.
> 
> And we can then remove that bothersome congestion_wait: when needed,
> it'll automatically get done in the course of the radix_tree_preload.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Looks good to me. Thanks for this!
