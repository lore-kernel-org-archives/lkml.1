Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbYIIWxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbYIIWxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 18:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYIIWxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 18:53:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754005AbYIIWxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 18:53:21 -0400
Date: Tue, 9 Sep 2008 15:53:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: alex.nixon@citrix.com, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 2/2] xen: fix pinning when not using split pte locks
Message-Id: <20080909155306.921d453b.akpm@linux-foundation.org>
In-Reply-To: <48C6FC0D.9040009@goop.org>
References: <1220959508-13806-1-git-send-email-alex.nixon@citrix.com>
	<48C6BB00.9040607@goop.org>
	<48C6CCD7.8030800@citrix.com>
	<48C6DE6E.1070804@goop.org>
	<48C6F80E.8010509@citrix.com>
	<48C6FC0D.9040009@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2008 15:43:25 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> We only pin PTE pages when using split PTE locks, so don't do the
> pin/unpin when attaching/detaching pte pages to a pinned pagetable.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/xen/enlighten.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> ===================================================================
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -864,7 +864,7 @@
>  
>  		if (!PageHighMem(page)) {
>  			make_lowmem_page_readonly(__va(PFN_PHYS((unsigned long)pfn)));
> -			if (level == PT_PTE)
> +			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
>  				pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
>  		} else
>  			/* make sure there are no stray mappings of
> @@ -932,7 +932,7 @@
>  
>  	if (PagePinned(page)) {
>  		if (!PageHighMem(page)) {
> -			if (level == PT_PTE)
> +			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
>  				pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
>  			make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
>  		}

What are the effects of the bug which you fixed?

Do you consider this to be 2.6.27 material?  2.6.26.x?  2.6.25.x?
