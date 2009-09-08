Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbZIHLb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbZIHLb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbZIHLb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:31:27 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:62433 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbZIHLb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:31:26 -0400
X-Trace: 259417358/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.8.207/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.8.207
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEANrcpUpQKQjP/2dsb2JhbACBU9hNhBgF
X-IronPort-AV: E=Sophos;i="4.44,352,1249254000"; 
   d="scan'208";a="259417358"
Date: Tue, 8 Sep 2009 12:30:39 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Hiroaki Wakabayashi <primulaelatior@gmail.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/8] mm: munlock use follow_page
In-Reply-To: <20090908115825.edb06814.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0909081227010.25652@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
 <Pine.LNX.4.64.0909072227140.15430@sister.anvils>
 <20090908115825.edb06814.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, KAMEZAWA Hiroyuki wrote:
> On Mon, 7 Sep 2009 22:29:55 +0100 (BST)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> >  void munlock_vma_pages_range(struct vm_area_struct *vma,
> > -			   unsigned long start, unsigned long end)
> > +			     unsigned long start, unsigned long end)
> >  {
> > +	unsigned long addr;
> > +
> > +	lru_add_drain();
> >  	vma->vm_flags &= ~VM_LOCKED;
> > -	__mlock_vma_pages_range(vma, start, end, 0);
> > +
> > +	for (addr = start; addr < end; addr += PAGE_SIZE) {
> > +		struct page *page = follow_page(vma, addr, FOLL_GET);
> > +		if (page) {
> > +			lock_page(page);
> > +			if (page->mapping)
> > +				munlock_vma_page(page);
> 
> Could you add "please see __mlock_vma_pages_range() to see why" or some here ?

Why the test on page->mapping?
Right, I'll add some such comment on that.
Waiting a day or two to see what else comes up.

Thanks,
Hugh
