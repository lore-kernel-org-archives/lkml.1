Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbZDGTi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbZDGTi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZDGTiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:38:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35030 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZDGTiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:38:20 -0400
Date: Tue, 7 Apr 2009 21:40:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>, hugh@veritas.com, npiggin@suse.de,
       riel@redhat.com, lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [13/16] POISON: The high level memory error handler in the VM
Message-ID: <20090407194034.GW17934@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407151010.E72A91D0471@basil.firstfloor.org> <20090407185146.GA3818@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407185146.GA3818@cmpxchg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 08:51:46PM +0200, Johannes Weiner wrote:
> > +
> > +	if (av == NULL)	/* Not actually mapped anymore */
> > +		goto out;
> > +
> > +	read_lock(&tasklist_lock);
> > +	for_each_process (tsk) {
> > +		if (!tsk->mm)
> > +			continue;
> > +		list_for_each_entry (vma, &av->head, anon_vma_node) {
> > +			if (vma->vm_mm == tsk->mm)
> > +				add_to_kill(tsk, page, vma, to_kill, tkc);
> > +		}
> > +	}
> > +	read_unlock(&tasklist_lock);
> > +out:
> > +	page_unlock_anon_vma(av);
> 
> If !av, this doesn't need an unlock and in fact crashes due to
> dereferencing NULL.

Good point. Fixed. Thanks.
> 
> > +static int poison_page_prepare(struct page *p, unsigned long pfn, int trapno)
> > +{
> > +	if (PagePoison(p)) {
> > +		printk(KERN_ERR
> > +		       "MCE: Error for already poisoned page at %lx\n", pfn);
> > +		return -1;
> > +	}
> > +	SetPagePoison(p);
> 
> TestSetPagePoison()?

It doesn't matter in this case because it doesn't need to be atomic.
The normal reason for TestSet is atomicity requirements. If someone
feels strongly about it I can add it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
