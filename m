Return-Path: <linux-kernel-owner+w=401wt.eu-S1761032AbYBADxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761032AbYBADxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 22:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYBADww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 22:52:52 -0500
Received: from relay2.sgi.com ([192.48.171.30]:51371 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753176AbYBADwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 22:52:51 -0500
Date: Thu, 31 Jan 2008 21:52:49 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 1/3] mmu_notifier: Core code
Message-ID: <20080201035249.GE26420@sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.553249048@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131045812.553249048@sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: linux-2.6/include/linux/mmu_notifier.h
...
> +struct mmu_notifier_ops {
...
> +	/*
> +	 * invalidate_range_begin() and invalidate_range_end() must paired.
> +	 * Multiple invalidate_range_begin/ends may be nested or called
> +	 * concurrently. That is legit. However, no new external references
> +	 * may be established as long as any invalidate_xxx is running or
> +	 * any invalidate_range_begin() and has not been completed through a
> +	 * corresponding call to invalidate_range_end().
> +	 *
> +	 * Locking within the notifier needs to serialize events correspondingly.
> +	 *
> +	 * If all invalidate_xx notifier calls take a driver lock then it is possible
> +	 * to run follow_page() under the same lock. The lock can then guarantee
> +	 * that no page is removed. That way we can avoid increasing the refcount
> +	 * of the pages.
> +	 *
> +	 * invalidate_range_begin() must clear all references in the range
> +	 * and stop the establishment of new references.
> +	 *
> +	 * invalidate_range_end() reenables the establishment of references.
> +	 *
> +	 * atomic indicates that the function is called in an atomic context.
> +	 * We can sleep if atomic == 0.
> +	 */
> +	void (*invalidate_range_begin)(struct mmu_notifier *mn,
> +				 struct mm_struct *mm,
> +				 unsigned long start, unsigned long end,
> +				 int atomic);
> +
> +	void (*invalidate_range_end)(struct mmu_notifier *mn,
> +				 struct mm_struct *mm, int atomic);

I think we need to pass in the same start-end here as well.  Without it,
the first invalidate_range would have to block faulting for all addresses
and would need to remain blocked until the last invalidate_range has
completed.  While this would work, (and will probably be how we implement
it for the short term), it is far from ideal.

Thanks,
Robin
