Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbYBPLJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbYBPLJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 06:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYBPLJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 06:09:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53131 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494AbYBPLJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 06:09:34 -0500
Date: Sat, 16 Feb 2008 03:08:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] KVM swapping with MMU Notifiers V7
Message-Id: <20080216030817.965ff1f7.akpm@linux-foundation.org>
In-Reply-To: <20080216104827.GI11732@v2.random>
References: <20080215064859.384203497@sgi.com>
	<20080216104827.GI11732@v2.random>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 11:48:27 +0100 Andrea Arcangeli <andrea@qumranet.com> wrote:

> +void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
> +					   struct mm_struct *mm,
> +					   unsigned long start, unsigned long end,
> +					   int lock)
> +{
> +	for (; start < end; start += PAGE_SIZE)
> +		kvm_mmu_notifier_invalidate_page(mn, mm, start);
> +}
> +
> +static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
> +	.invalidate_page	= kvm_mmu_notifier_invalidate_page,
> +	.age_page		= kvm_mmu_notifier_age_page,
> +	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
> +};

So this doesn't implement ->invalidate_range_start().

By what means does it prevent new mappings from being established in the
range after core mm has tried to call ->invalidate_rande_start()?
mmap_sem, I assume?


> +			/* set userspace_addr atomically for kvm_hva_to_rmapp */
> +			spin_lock(&kvm->mmu_lock);
> +			memslot->userspace_addr = userspace_addr;
> +			spin_unlock(&kvm->mmu_lock);

are you sure?  kvm_unmap_hva() and kvm_age_hva() read ->userspace_addr a
single time and it doesn't immediately look like there's a need to take the
lock here?


