Return-Path: <linux-kernel-owner+w=401wt.eu-S1767169AbXEBSgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767169AbXEBSgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767172AbXEBSgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:36:33 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:38118 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767169AbXEBSgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:36:31 -0400
Date: Wed, 2 May 2007 19:36:10 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, haveblue@ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <Pine.LNX.4.64.0705021017270.32635@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0705021924200.24456@blonde.wat.veritas.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705021017270.32635@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 02 May 2007 18:36:27.0951 (UTC) FILETIME=[CB99E3F0:01C78CE8]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBjbGFtZXRlckBzZ2kuY29tAGxpbnV4LW1tQGt2YWNrLm9yZwBoYXZlYmx1ZUBpYm0uY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Christoph Lameter wrote:
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

I'm astonished and impressed, both with Kconfig and your use of it:
that does seem to work.  Though I don't dare go so far as to give
the patch an ack, and don't like this way out at all.  It needs a
proper (quicklist) solution, and by the time that solution comes
along, all the powerpc people will have CONFIG_SLAB=y in their
.config, and "make oldconfig" will just perpetuate that status quo,
instead of the switching over to CONFIG_SLUB=y.  I think.  Unless
we keep changing the config option names, or go through a phase
with no option.

I'd much rather be testing a quicklist patch:
I'd better give that a try.

Hugh

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
>  config DEFAULT_UIMAGE
>  	bool
>  	help
