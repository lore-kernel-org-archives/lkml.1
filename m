Return-Path: <linux-kernel-owner+w=401wt.eu-S933076AbYA2QVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076AbYA2QVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932749AbYA2QUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:20:16 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:47423
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765983AbYA2QUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:20:14 -0500
Date: Tue, 29 Jan 2008 17:20:04 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080129162004.GL7233@v2.random>
References: <20080128202840.974253868@sgi.com> <20080128202923.849058104@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128202923.849058104@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 12:28:42PM -0800, Christoph Lameter wrote:
> Index: linux-2.6/mm/fremap.c
> ===================================================================
> --- linux-2.6.orig/mm/fremap.c	2008-01-25 19:31:05.000000000 -0800
> +++ linux-2.6/mm/fremap.c	2008-01-25 19:32:49.000000000 -0800
> @@ -15,6 +15,7 @@
>  #include <linux/rmap.h>
>  #include <linux/module.h>
>  #include <linux/syscalls.h>
> +#include <linux/mmu_notifier.h>
>  
>  #include <asm/mmu_context.h>
>  #include <asm/cacheflush.h>
> @@ -211,6 +212,7 @@ asmlinkage long sys_remap_file_pages(uns
>  		spin_unlock(&mapping->i_mmap_lock);
>  	}
>  
> +	mmu_notifier(invalidate_range, mm, start, start + size, 0);
>  	err = populate_range(mm, vma, start, size, pgoff);

How can it be right to invalidate_range _before_ ptep_clear_flush?

> @@ -1634,6 +1639,8 @@ gotten:
>  	/*
>  	 * Re-check the pte - we dropped the lock
>  	 */
> +	mmu_notifier(invalidate_range, mm, address,
> +				address + PAGE_SIZE - 1, 0);
>  	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
>  	if (likely(pte_same(*page_table, orig_pte))) {
>  		if (old_page) {

What's the point of invalidate_range when the size is PAGE_SIZE? And
how can it be right to invalidate_range _before_ ptep_clear_flush?
