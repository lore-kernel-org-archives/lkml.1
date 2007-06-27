Return-Path: <linux-kernel-owner+w=401wt.eu-S1762805AbXF0Sxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762805AbXF0Sxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758925AbXF0Sxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:53:48 -0400
Received: from web30502.mail.mud.yahoo.com ([68.142.200.115]:22629 "HELO
	web30502.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758834AbXF0Sxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:53:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=YylMILRaLbP66E0hA1asxs2eGWt/go2EHYSv0MNj8vsSvn2TApE0oPGFhRII9pKM2y+2WtobmdTQVnAIm7gGUB3f8GOCRMLXjgmVANq+PbsRzfQLZrTZNclTaAHm9xbp51oX+xH1hMrXtAKl5rNnDcGQMgcwqiayDYoBePP7c/M=;
X-YMail-OSG: 6AxZKk8VM1ktnrutpIeQNqlhV8vElz8Jjafs97Imhsp6enxHxZ8J70ehfVXqYe232czNx7W2kg--
Date: Wed, 27 Jun 2007 11:53:46 -0700 (PDT)
From: Casey Leedom <casey_leedom@yahoo.com>
Subject: Re: ZERO_PAGE() vs. loadable modules in Redhat 4.4 i386 kernels ...
To: linux-kernel@vger.kernel.org
In-Reply-To: <1182969547.2718.0.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <951709.47871.qm@web30502.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Arjan van de Ven <arjan@infradead.org> wrote:

> you forgot to attach your source code or provide a URL to it.....

  Sorry, my bad.  I'm just diving into Linux for the first time and wasn't
aware of the protocols.  Here's the code fragment I'm currently using:

	address = skb_vaddr(skb) & PAGE_MASK;
	end = PAGE_ALIGN(skb_vaddr(skb) + len);

	down_read(&current->mm->mmap_sem);
	vma = find_vma(current->mm, skb_vaddr(skb));

	spin_lock(&current->mm->page_table_lock);
	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++, address += PAGE_SIZE) { 
		pgd_t *pgd;
		pud_t *pud;
		pmd_t *pmd;
		pte_t *ptep;
		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];

		/*
		 * If we're looking at the ZERO_PAGE() then we don't have to
		 * do anything.  It's never going to be modified.  See also
		 * where we avoid the ZERO_PAGE() in skb_dma_complete().
		 */
		if (frag->page == ZERO_PAGE(address))
			continue;

		atomic_inc(&frag->page->_mapcount);

		/*
		 * If we're not dealing with the ZERO_PAGE() then it should
		 * not be possible to end up without a mapping to the page.
		 * But just in case we check here and issue a BUG() if the
		 * mapping is missing ...
		 */
		if (unlikely((pgd = pgd_offset(current->mm, address),
			      pgd_none(*pgd)) ||
			     (pud = pud_offset(pgd, address),
			      pud_none(*pud)) ||
			     (pmd = pmd_offset(pud, address),
			      pmd_none(*pmd)) ||
			     (ptep = pte_offset_map(pmd, address),
			      pte_none(*ptep)))) {
			printk("skb_dma_pending: missing %s page mapping"
			       " for vaddr=%#lx, page=%p\n",
			       pgd_none(*pgd) ? "pgd"
			       : pud_none(*pud) ? "pud"
			       : pmd_none(*pmd) ? "pmd"
			       : "pte",
			       address, frag->page);
			BUG();
		}

		ptep_set_wrprotect(current->mm, address, ptep);
		pte_unmap(ptep);
	}
	spin_unlock(&current->mm->page_table_lock);
	flush_tlb_range(vma, address, end);

I hope that isn't too large but I wanted to provide sufficient context.

Casey
