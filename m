Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZFDE0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZFDE0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 00:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZFDE0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 00:26:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:54640 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZFDE0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 00:26:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,302,1241420400"; 
   d="scan'208";a="150463167"
Date: Thu, 4 Jun 2009 12:26:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [6/16] HWPOISON: Add various poison checks in
	mm/memory.c
Message-ID: <20090604042603.GA15682@localhost>
References: <20090603846.816684333@firstfloor.org> <20090603184639.1933B1D028F@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603184639.1933B1D028F@basil.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 02:46:38AM +0800, Andi Kleen wrote:
> 
> Bail out early when hardware poisoned pages are found in page fault handling.

I suspect this patch is also not absolutely necessary: the poisoned
page will normally have been isolated already.

> Since they are poisoned they should not be mapped freshly into processes,
> because that would cause another (potentially deadly) machine check
> 
> This is generally handled in the same way as OOM, just a different
> error code is returned to the architecture code.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  mm/memory.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux/mm/memory.c
> ===================================================================
> --- linux.orig/mm/memory.c	2009-06-03 19:36:23.000000000 +0200
> +++ linux/mm/memory.c	2009-06-03 19:36:23.000000000 +0200
> @@ -2797,6 +2797,9 @@
>  	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
>  		return ret;
>  
> +	if (unlikely(PageHWPoison(vmf.page)))
> +		return VM_FAULT_HWPOISON;
> +

Direct return with locked page could lockup someone later.
Either drop this patch or fix it with this check?

Thanks,
Fengguang
---

--- linux.orig/mm/memory.c
+++ linux/mm/memory.c
@@ -2658,8 +2658,11 @@ static int __do_fault(struct mm_struct *
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
 		return ret;
 
-	if (unlikely(PageHWPoison(vmf.page)))
+	if (unlikely(PageHWPoison(vmf.page))) {
+		if (ret & VM_FAULT_LOCKED)
+			unlock_page(vmf.page);
 		return VM_FAULT_HWPOISON;
+	}
 
 	/*
 	 * For consistency in subsequent calls, make the faulted page always
