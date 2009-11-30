Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbZK3Mi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbZK3Mi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZK3Mi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:38:27 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:12741 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbZK3Mi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:38:27 -0500
X-Trace: 295769746/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogBABZLE0tPRTgw/2dsb2JhbAAI1TOEMQQ
X-IronPort-AV: E=Sophos;i="4.47,314,1257120000"; 
   d="scan'208";a="295769746"
Date: Mon, 30 Nov 2009 12:38:33 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
In-Reply-To: <20091130180452.5BF6.A69D9226@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0911301227530.24660@sister.anvils>
References: <Pine.LNX.4.64.0911241640590.25288@sister.anvils>
 <20091130094616.8f3d94a7.kamezawa.hiroyu@jp.fujitsu.com>
 <20091130180452.5BF6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, KOSAKI Motohiro wrote:
> > After this patch, the number of shared swappable page will be unlimited.
> 
> Probably, it doesn't matter. I mean
> 
>   - KSM sharing and Shmem sharing are almost same performance characteristics.
>   - if memroy pressure is low, SplitLRU VM doesn't scan anon list so much.
> 
> if ksm swap is too costly, we need to improve anon list scanning generically.

Yes, we're in agreement that this issue is not new with KSM swapping.

> btw, I'm not sure why bellow kmem_cache_zalloc() is necessary. Why can't we
> use stack?

Well, I didn't use stack: partly because I'm so ashamed of the pseudo-vmas
on the stack in mm/shmem.c, which have put shmem_getpage() into reports
of high stack users (I've unfinished patches to deal with that); and
partly because page_referenced_ksm() and try_to_unmap_ksm() are on
the page reclaim path, maybe way down deep on a very deep stack.

But it's not something you or I should be worrying about: as the comment
says, this is just a temporary hack, to present a patch which gets KSM
swapping working in an understandable way, while leaving some corrections
and refinements to subsequent patches.  This pseudo-vma is removed in the
very next patch.

Hugh

> 
> ----------------------------
> +	/*
> +	 * Temporary hack: really we need anon_vma in rmap_item, to
> +	 * provide the correct vma, and to find recently forked instances.
> +	 * Use zalloc to avoid weirdness if any other fields are involved.
> +	 */
> +	vma = kmem_cache_zalloc(vm_area_cachep, GFP_ATOMIC);
> +	if (!vma) {
> +		spin_lock(&ksm_fallback_vma_lock);
> +		vma = &ksm_fallback_vma;
> +	}
