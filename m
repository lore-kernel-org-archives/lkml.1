Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZA2Mfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZA2Mfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 07:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZA2Mfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 07:35:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:44300 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbZA2Mfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 07:35:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EaYATIdVA5BBX65reFoy+p0eZKompqUyY7QkvBtPIb1bCp5r2DLKa6LWvap6Rn4B7d
         UKpyu7VWqwR/hGWtz43odpchYzlO9F9uQvSg25GlrtQ93oRWgfCftB2AnHvPFiZL+1Cu
         ESVeIJ/prKYEN//337+OZF2xYmY0pYPmYfG6E=
MIME-Version: 1.0
In-Reply-To: <1233193736.8760.199.camel@lts-notebook>
References: <20090128102841.GA24924@barrios-desktop>
	 <1233156832.8760.85.camel@lts-notebook>
	 <20090128235514.GB24924@barrios-desktop>
	 <1233193736.8760.199.camel@lts-notebook>
Date: Thu, 29 Jan 2009 21:35:36 +0900
X-Google-Sender-Auth: 8dfbbac65e934dff
Message-ID: <2f11576a0901290435p1bdb41b3o7171384250b93c08@mail.gmail.com>
Subject: Re: [BUG] mlocked page counter mismatch
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: MinChan Kim <minchan.kim@gmail.com>, linux mm <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> I think I see it.  In try_to_unmap_anon(), called from try_to_munlock(),
> we have:
>
>         list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
>                if (MLOCK_PAGES && unlikely(unlock)) {
>                        if (!((vma->vm_flags & VM_LOCKED) &&
> !!! should be '||' ?                                      ^^
>                              page_mapped_in_vma(page, vma)))
>                                continue;  /* must visit all unlocked vmas */
>                        ret = SWAP_MLOCK;  /* saw at least one mlocked vma */
>                } else {
>                        ret = try_to_unmap_one(page, vma, migration);
>                        if (ret == SWAP_FAIL || !page_mapped(page))
>                                break;
>                }
>                if (ret == SWAP_MLOCK) {
>                        mlocked = try_to_mlock_page(page, vma);
>                        if (mlocked)
>                                break;  /* stop if actually mlocked page */
>                }
>        }
>
> or that clause [under if (MLOCK_PAGES && unlikely(unlock))]
> might be clearer as:
>
>               if ((vma->vm_flags & VM_LOCKED) && page_mapped_in_vma(page, vma))
>                      ret = SWAP_MLOCK;  /* saw at least one mlocked vma */
>               else
>                      continue;  /* must visit all unlocked vmas */
>
> Do you agree?

Hmmm.
I don't think so.

>                        if (!((vma->vm_flags & VM_LOCKED) &&
>                              page_mapped_in_vma(page, vma)))
>                                continue;  /* must visit all unlocked vmas */

is already equivalent to

>               if ((vma->vm_flags & VM_LOCKED) && page_mapped_in_vma(page, vma))
>                      ret = SWAP_MLOCK;  /* saw at least one mlocked vma */
>               else
>                      continue;  /* must visit all unlocked vmas */


> And, I wonder if we need a similar check for
> page_mapped_in_vma(page, vma) up in try_to_unmap_one()?

because page_mapped_in_vma() can return 0 if vma is anon vma only.

In the other word,
struct adress_space (for file) gurantee that unrelated vma doesn't chained.
but struct anon_vma (for anon) doesn't gurantee that unrelated vma
doesn't chained.
