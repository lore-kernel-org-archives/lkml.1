Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbZDGSwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbZDGSwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZDGSwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:52:12 -0400
Received: from cmpxchg.org ([85.214.51.133]:43246 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZDGSwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:52:12 -0400
Date: Tue, 7 Apr 2009 20:51:46 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: hugh@veritas.com, npiggin@suse.de, riel@redhat.com,
       lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [13/16] POISON: The high level memory error handler in the VM
Message-ID: <20090407185146.GA3818@cmpxchg.org>
References: <20090407509.382219156@firstfloor.org> <20090407151010.E72A91D0471@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407151010.E72A91D0471@basil.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Tue, Apr 07, 2009 at 05:10:10PM +0200, Andi Kleen wrote:

> +static void collect_procs_anon(struct page *page, struct list_head *to_kill,
> +			      struct to_kill **tkc)
> +{
> +	struct vm_area_struct *vma;
> +	struct task_struct *tsk;
> +	struct anon_vma *av = page_lock_anon_vma(page);
> +
> +	if (av == NULL)	/* Not actually mapped anymore */
> +		goto out;
> +
> +	read_lock(&tasklist_lock);
> +	for_each_process (tsk) {
> +		if (!tsk->mm)
> +			continue;
> +		list_for_each_entry (vma, &av->head, anon_vma_node) {
> +			if (vma->vm_mm == tsk->mm)
> +				add_to_kill(tsk, page, vma, to_kill, tkc);
> +		}
> +	}
> +	read_unlock(&tasklist_lock);
> +out:
> +	page_unlock_anon_vma(av);

If !av, this doesn't need an unlock and in fact crashes due to
dereferencing NULL.

> +static int poison_page_prepare(struct page *p, unsigned long pfn, int trapno)
> +{
> +	if (PagePoison(p)) {
> +		printk(KERN_ERR
> +		       "MCE: Error for already poisoned page at %lx\n", pfn);
> +		return -1;
> +	}
> +	SetPagePoison(p);

TestSetPagePoison()?
