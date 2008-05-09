Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbYEIPFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbYEIPFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYEIPFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:05:06 -0400
Received: from gw.goop.org ([64.81.55.164]:59328 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbYEIPFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:05:05 -0400
Message-ID: <48246815.9070607@goop.org>
Date: Fri, 09 May 2008 16:04:53 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ross Biro <rossb@google.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH 2/2] MM: Make Page Tables Relocatable --relcoation
 code
References: <20080509135107.28D11DCA63@localhost>
In-Reply-To: <20080509135107.28D11DCA63@localhost>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ross Biro wrote:
> +void update_new_page_and_free(struct mm_struct *mm, struct page *old_page)
> +{
> +
> +	int type;
> +
> +	/* Currently we only worry about cpu bits in ptes. */
> +	if (old_page->page_table_type == PAGE_TABLE_PTE) {
> +		struct page *new_page = old_page->migrated_page;
> +		spinlock_t *ptl;
> +		pte_t *old;
> +		pte_t *new;
> +		int i;
> +#ifdef __pte_lockptr
> +		ptl = __pte_lockptr(new_page);
> +#else
> +		ptl = &mm->page_table_lock;
> +#endif
> +		spin_lock(ptl);
> +		old = (pte_t *)kmap_atomic(old_page, KM_PTE0);
> +		new = (pte_t *)kmap_atomic(new_page, KM_PTE1);
> +		for (i = 0; i < PTRS_PER_PTE; i++)
> +			arch_copy_cpu_bits_pte(old, new);
>   

old++, new++?

> +
> +		kunmap_atomic(new_page, KM_PTE1);
> +		kunmap_atomic(old_page, KM_PTE0);
> +		new_page->migrated_page = NULL;
> +		spin_unlock(ptl);
> +	}
> +
> +	old_page->migrated_page = NULL;
> +	type = old_page->page_table_type;
> +	reset_page_mapcount(old_page);
> +
> +	free_page_table_page(mm, old_page, type);
> +}

    J
