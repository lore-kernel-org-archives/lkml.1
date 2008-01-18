Return-Path: <linux-kernel-owner+w=401wt.eu-S932490AbYARWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbYARWFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760875AbYARWEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:04:52 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:41395 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbYARWEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:04:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V5MMjVfSeziyoEBNmDtw7m+ScBdojzlXmC7rfetm95G51lQYfDzvr7kdUXba25WyTNuUyyZdGuc1PyW4wrl3PuoGp1FhegwUxPfeS1dP1BTJRllE3rCWx3HT0I9+19j8BzVLbJ08ZgrV+7kwdefcyNJbiYkZr0FIHF4dAM7AlnU=
Message-ID: <4df4ef0c0801181404m186bb847sd556e031e908b0b6@mail.gmail.com>
Date: Sat, 19 Jan 2008 01:04:50 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped files
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, peterz@infradead.org,
       linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-Reply-To: <alpine.LFD.1.00.0801181325510.2957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12006091182260-git-send-email-salikhmetov@gmail.com>
	 <alpine.LFD.1.00.0801181033580.2957@woody.linux-foundation.org>
	 <E1JFwOz-00019k-Uo@pomaz-ex.szeredi.hu>
	 <alpine.LFD.1.00.0801181106340.2957@woody.linux-foundation.org>
	 <E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu>
	 <alpine.LFD.1.00.0801181127000.2957@woody.linux-foundation.org>
	 <4df4ef0c0801181158s3f783beaqead3d7049d4d3fa7@mail.gmail.com>
	 <alpine.LFD.1.00.0801181214440.2957@woody.linux-foundation.org>
	 <4df4ef0c0801181303o6656832g8b63d2a119a86a9c@mail.gmail.com>
	 <alpine.LFD.1.00.0801181325510.2957@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/19, Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Sat, 19 Jan 2008, Anton Salikhmetov wrote:
> >
> > Before using pte_wrprotect() the vma_wrprotect() routine uses the
> > pte_offset_map_lock() macro to get the PTE and to acquire the ptl
> > spinlock. Why did you say that this code was not SMP-safe? It should
> > be atomic, I think.
>
> It's atomic WITH RESPECT TO OTHER PEOPLE WHO GET THE LOCK.
>
> Guess how much another x86 CPU cares when it sets the accessed bit in
> hardware?

Thank you very much for taking part in this discussion. Personally,
it's very important to me.  But I'm not sure that I understand which
bit can be lost.

Please let me explain.

The logic for my vma_wrprotect() routine was taken from the
page_check_address() function in mm/rmap.c. Here is a code snippet of
the latter function:

        pgd = pgd_offset(mm, address);
        if (!pgd_present(*pgd))
                return NULL;

        pud = pud_offset(pgd, address);
        if (!pud_present(*pud))
                return NULL;

        pmd = pmd_offset(pud, address);
        if (!pmd_present(*pmd))
                return NULL;

        pte = pte_offset_map(pmd, address);
        /* Make a quick check before getting the lock */
        if (!pte_present(*pte)) {
                pte_unmap(pte);
                return NULL;
        }

        ptl = pte_lockptr(mm, pmd);
        spin_lock(ptl);
        if (pte_present(*pte) && page_to_pfn(page) == pte_pfn(*pte)) {
                *ptlp = ptl;
                return pte;
        }
        pte_unmap_unlock(pte, ptl);

The page_check_address() function is called from the
page_mkclean_one() routine as follows:

        pte = page_check_address(page, mm, address, &ptl);
        if (!pte)
                goto out;

        if (pte_dirty(*pte) || pte_write(*pte)) {
                pte_t entry;

                flush_cache_page(vma, address, pte_pfn(*pte));
                entry = ptep_clear_flush(vma, address, pte);
                entry = pte_wrprotect(entry);
                entry = pte_mkclean(entry);
                set_pte_at(mm, address, pte, entry);
                ret = 1;
        }

        pte_unmap_unlock(pte, ptl);

The write-protection of the PTE is done using the pte_wrprotect()
entity. I intended to do the same during msync() with MS_ASYNC. I
understand that I'm taking a risk of looking a complete idiot now,
however I don't see any difference between the two situations.

I presumed that the code in mm/rmap.c was absolutely correct, that's
why I basically reused the design.

>
> > The POSIX standard requires the ctime and mtime stamps to be updated
> > not later than at the second call to msync() with the MS_ASYNC flag.
>
> .. and that is no excuse for bad code.
>
>                         Linus
>
