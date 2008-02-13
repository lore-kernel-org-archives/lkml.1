Return-Path: <linux-kernel-owner+w=401wt.eu-S1761736AbYBMCkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761736AbYBMCkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYBMCkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:40:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbYBMCkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:40:46 -0500
Date: Wed, 13 Feb 2008 10:40:20 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       corbet@lwn.net
Subject: Re: [PATCH 2/2 resend] mm: various cleanups in get_user_pages()
Message-ID: <20080213024020.GA4002@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20080212112919.GB3481@kernel.sg> <20080212114024.GA4440@kernel.sg> <20080212131030.GA3332@kernel.sg> <200802131213.04902.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802131213.04902.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Thanks for the review.

<quote sender="Nick Piggin">
> On Wednesday 13 February 2008 00:10, Eugene Teo wrote:
[...]
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 54f951b..c7e0610 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -1003,7 +1003,9 @@ int get_user_pages(struct task_struct *tsk, struct
> > mm_struct *mm, unsigned int foll_flags;
> >
> >  		vma = find_extend_vma(mm, start);
> > -		if (!vma && in_gate_area(tsk, start)) {
> > +		if (!vma)
> > +			goto finish_or_fault;
> > +		if (in_gate_area(tsk, start)) {
> >  			unsigned long pg = start & PAGE_MASK;
> >  			struct vm_area_struct *gate_vma = get_gate_vma(tsk);
> >  			pgd_t *pgd;
> 
> Doesn't this break the logic?
> 
> If you don't have a vma, but you are in the gate area, then you
> should use the gate vma. With your patch, gate area will fault.

Yes, you are right. I also relooked at the patch, and actually vma is
validated after if (... in_gate_area(tsk, start)) { ... }, so my patch
is not correct.

> > @@ -1011,7 +1013,7 @@ int get_user_pages(struct task_struct *tsk, struct
> > mm_struct *mm, pmd_t *pmd;
> >  			pte_t *pte;
> >  			if (write) /* user gate pages are read-only */
> > -				return i ? : -EFAULT;
> > +				goto finish_or_fault;
> 
> I don't know if this is exactly a cleanup or not... I guess gcc
> probably isn't smart enough to fold them all together, so it should
> use a little less code in the unlikely branches. Does it?

Agree.

Eugene
