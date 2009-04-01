Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197AbZDAN2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbZDAN2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZDAN2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:28:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36960 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbZDAN2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:28:05 -0400
Message-ID: <49D36B4E.7000702@redhat.com>
Date: Wed, 01 Apr 2009 09:25:34 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, frankeh@watson.ibm.com, akpm@osdl.org,
       nickpiggin@yahoo.com.au, hugh@veritas.com
Subject: Re: [patch 4/6] Guest page hinting: writable page table entries.
References: <20090327150905.819861420@de.ibm.com> <20090327151012.398894143@de.ibm.com>
In-Reply-To: <20090327151012.398894143@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:

This code has me stumped.  Does it mean that if a page already
has the PageWritable bit set (and count_ok stays 0), we will
always mark the page as volatile?

How does that work out on !s390?

>  /**
> + * __page_check_writable() - check page state for new writable pte
> + *
> + * @page: the page the new writable pte refers to
> + * @pte: the new writable pte
> + */
> +void __page_check_writable(struct page *page, pte_t pte, unsigned int offset)
> +{
> +	int count_ok = 0;
> +
> +	preempt_disable();
> +	while (page_test_set_state_change(page))
> +		cpu_relax();
> +
> +	if (!TestSetPageWritable(page)) {
> +		count_ok = check_counts(page, offset);
> +		if (check_bits(page) && count_ok)
> +			page_set_volatile(page, 1);
> +		else
> +			/*
> +			 * If two processes create a write mapping at the
> +			 * same time check_counts will return false or if
> +			 * the page is currently isolated from the LRU
> +			 * check_bits will return false but the page might
> +			 * be in volatile state.
> +			 * We have to take care about the dirty bit so the
> +			 * only option left is to make the page stable but
> +			 * we can try to make it volatile a bit later.
> +			 */
> +			page_set_stable_if_present(page);
> +	}
> +	page_clear_state_change(page);
> +	if (!count_ok)
> +		page_make_volatile(page, 1);
> +	preempt_enable();
> +}
> +EXPORT_SYMBOL(__page_check_writable);


-- 
All rights reversed.
