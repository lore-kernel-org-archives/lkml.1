Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbYDNT6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbYDNT6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761074AbYDNT5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:57:06 -0400
Received: from relay1.sgi.com ([192.48.171.29]:40312 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758104AbYDNT5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:57:03 -0400
Date: Mon, 14 Apr 2008 12:57:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: akpm@linux-foundation.org, Nick Piggin <npiggin@suse.de>,
       Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 2 of 9] Core of mmu notifiers
In-Reply-To: <baceb322b45ed4328065.1207669445@duo.random>
Message-ID: <Pine.LNX.4.64.0804141250590.7803@schroedinger.engr.sgi.com>
References: <baceb322b45ed4328065.1207669445@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Andrea Arcangeli wrote:

> +	/*
> +	 * Called when nobody can register any more notifier in the mm
> +	 * and after the "mn" notifier has been disarmed already.
> +	 */
> +	void (*release)(struct mmu_notifier *mn,
> +			struct mm_struct *mm);

Hmmm... The unregister function does not call this. Guess driver calls
unregister function and does release like stuff on its own.

> +	/*
> +	 * invalidate_range_start() and invalidate_range_end() must be
> +	 * paired. Multiple invalidate_range_start/ends may be nested
> +	 * or called concurrently.
> +	 */

How could they be nested or called concurrently?


> +/*
> + * mm_users can't go down to zero while mmu_notifier_unregister()
> + * runs or it can race with ->release. So a mm_users pin must
> + * be taken by the caller (if mm can be different from current->mm).
> + */
> +int mmu_notifier_unregister(struct mmu_notifier *mn, struct mm_struct *mm)
> +{
> +	struct mm_lock_data *data;
> +
> +	BUG_ON(!atomic_read(&mm->mm_users));
> +
> +	data = mm_lock(mm);
> +	if (unlikely(IS_ERR(data)))
> +		return PTR_ERR(data);
> +	hlist_del(&mn->hlist);
> +	mm_unlock(mm, data);
> +	return 0;

Hmmm.. Ok, the user of the notifier does not get notified that it was 
unregistered.

