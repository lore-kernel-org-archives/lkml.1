Return-Path: <linux-kernel-owner+w=401wt.eu-S1750897AbXECIPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897AbXECIPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbXECIPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:15:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbXECIP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:15:29 -0400
Date: Thu, 3 May 2007 01:15:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, haveblue@ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
Message-Id: <20070503011515.0d89082b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705021017270.32635@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
	<20070501125559.9ab42896.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0705021017270.32635@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 10:25:47 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 2 May 2007, Hugh Dickins wrote:
> 
> > I presume the answer is just to extend your quicklist work to
> > powerpc's lowest level of pagetables.  The only other architecture
> > which is using kmem_cache for them is arm26, which has
> > "#error SMP is not supported", so won't be giving this problem.
> 
> In the meantime we would need something like this to disable SLUB in this 
> particular configuration. Note that I have not tested this and the <= for
> the comparision with SPLIT_PTLOCK_CPUS may not work (Never seen such a
> construct in a Kconfig file but it is needed here).
> 
> 
> 
> PowerPC: Disable SLUB for configurations in which slab page structs are modified
> 
> PowerPC uses the slab allocator to manage the lowest level of the page table.
> In high cpu configurations we also use the page struct to split the page
> table lock. Disallow the selection of SLUB for that case.
> 
> [Not tested: I am not familiar with powerpc build procedures etc]
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> Index: linux-2.6.21-rc7-mm2/arch/powerpc/Kconfig
> ===================================================================
> --- linux-2.6.21-rc7-mm2.orig/arch/powerpc/Kconfig	2007-05-02 10:07:34.000000000 -0700
> +++ linux-2.6.21-rc7-mm2/arch/powerpc/Kconfig	2007-05-02 10:13:37.000000000 -0700
> @@ -117,6 +117,19 @@ config GENERIC_BUG
>  	default y
>  	depends on BUG
>  
> +#
> +# Powerpc uses the slab allocator to manage its ptes and the
> +# page structs of ptes are used for splitting the page table
> +# lock for configurations supporting more than SPLIT_PTLOCK_CPUS.
> +#
> +# In that special configuration the page structs of slabs are modified.
> +# This setting disables the selection of SLUB as a slab allocator.
> +#
> +config ARCH_USES_SLAB_PAGE_STRUCT
> +	bool
> +	default y
> +	depends on SPLIT_PTLOCK_CPUS <= NR_CPUS
> +

That all seems to work as intended.

However with NR_CPUS=8 SPLIT_PTLOCK_CPUS=4, enabling SLUB=y crashes the
machine early in boot.  

Too early for netconsole, no serial console.  Wedges up uselessly with
CONFIG_XMON=n, does mysterious repeated uncontrollable exceptions with
CONFIG_XMON=y.  This is all fairly typical for a powerpc/G5 crash :(

However I was able to glimpse some stuff as it flew past.  Crash started in
flush_old_exec and ended in pgtable_free_tlb -> kmem_cache_free.  I don't know
how to do better than that I'm afraid, unless I'm to hunt down a PCIE serial
card, perhaps.

