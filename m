Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbYBATPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbYBATPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbYBATOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:14:20 -0500
Received: from relay2.sgi.com ([192.48.171.30]:33102 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754723AbYBATOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:14:17 -0500
Date: Fri, 1 Feb 2008 11:14:16 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/4] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080201104959.GJ26420@sgi.com>
Message-ID: <Pine.LNX.4.64.0802011113390.18163@schroedinger.engr.sgi.com>
References: <20080201050439.009441434@sgi.com> <20080201050623.344041545@sgi.com>
 <20080201104959.GJ26420@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh. Did not see this soon enougn. Maybe this one is better since it 
avoids the additional unlocks?

On Fri, 1 Feb 2008, Robin Holt wrote:

> do_wp_page can reach the _end callout without passing the _begin
> callout.  This prevents making the _end unles the _begin has also
> been made.
> 
> Index: mmu_notifiers-cl-v5/mm/memory.c
> ===================================================================
> --- mmu_notifiers-cl-v5.orig/mm/memory.c	2008-02-01 04:44:03.000000000 -0600
> +++ mmu_notifiers-cl-v5/mm/memory.c	2008-02-01 04:46:18.000000000 -0600
> @@ -1564,7 +1564,7 @@ static int do_wp_page(struct mm_struct *
>  {
>  	struct page *old_page, *new_page;
>  	pte_t entry;
> -	int reuse = 0, ret = 0;
> +	int reuse = 0, ret = 0, invalidate_started = 0;
>  	int page_mkwrite = 0;
>  	struct page *dirty_page = NULL;
>  
> @@ -1649,6 +1649,8 @@ gotten:
>  
>  	mmu_notifier(invalidate_range_begin, mm, address,
>  				address + PAGE_SIZE, 0);
> +	invalidate_started = 1;
> +
>  	/*
>  	 * Re-check the pte - we dropped the lock
>  	 */
> @@ -1687,7 +1689,8 @@ gotten:
>  		page_cache_release(old_page);
>  unlock:
>  	pte_unmap_unlock(page_table, ptl);
> -	mmu_notifier(invalidate_range_end, mm,
> +	if (invalidate_started)
> +		mmu_notifier(invalidate_range_end, mm,
>  				address, address + PAGE_SIZE, 0);
>  	if (dirty_page) {
>  		if (vma->vm_file)
> 
