Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbXGCHYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbXGCHYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbXGCHY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:24:27 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:42719 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbXGCHY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:24:27 -0400
Subject: Re: [patch 3/5] remove ptep_test_and_clear_dirty and
	ptep_clear_flush_dirty.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Zachary Amsden <zach@vmware.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <4689A691.9090908@vmware.com>
References: <20070629135530.912094590@de.ibm.com>
	 <20070629141528.060235678@de.ibm.com>  <4689A691.9090908@vmware.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 03 Jul 2007 09:26:38 +0200
Message-Id: <1183447598.9766.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-02 at 18:29 -0700, Zachary Amsden wrote:
> > -static inline int
> > -ptep_test_and_clear_dirty (struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
> > -{
> > -#ifdef CONFIG_SMP
> > -	if (!pte_dirty(*ptep))
> > -		return 0;
> > -	return test_and_clear_bit(_PAGE_D_BIT, ptep);
> > -#else
> > -	pte_t pte = *ptep;
> > -	if (!pte_dirty(pte))
> > -		return 0;
> > -	set_pte_at(vma->vm_mm, addr, ptep, pte_mkclean(pte));
> > -	return 1;
> > -#endif
> > -}
> 
> I've not followed all the changes lately - what is the current protocol 
> for clearing dirty bit?  Is it simply pte_clear followed by set or is it 
> not done at all?  At least for i386 and virtualization, we had several 
> optimizations to the test_and_clear path that are not possible with a 
> pte_clear / set_pte approach.

Imho with a sequence of ptep_get_and_clear, pte_wrprotect, set_pte_at.
One of the reasons why ptep_test_and_clear_dirty doesn't make sense
anymore is the shared dirty page tracking. You never just test and clear
the dirty bit, the latest code always sets the write protect bit as
well.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


