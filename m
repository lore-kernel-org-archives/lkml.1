Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbZA2Oor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbZA2Oor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZA2Ooj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:44:39 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:47950 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZA2Ooi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:44:38 -0500
Subject: Re: [BUG] mlocked page counter mismatch
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: MinChan Kim <minchan.kim@gmail.com>, linux mm <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <2f11576a0901290435p1bdb41b3o7171384250b93c08@mail.gmail.com>
References: <20090128102841.GA24924@barrios-desktop>
	 <1233156832.8760.85.camel@lts-notebook>
	 <20090128235514.GB24924@barrios-desktop>
	 <1233193736.8760.199.camel@lts-notebook>
	 <2f11576a0901290435p1bdb41b3o7171384250b93c08@mail.gmail.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 29 Jan 2009 09:44:36 -0500
Message-Id: <1233240276.2315.41.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 21:35 +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > I think I see it.  In try_to_unmap_anon(), called from try_to_munlock(),
> > we have:
> >
> >         list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
> >                if (MLOCK_PAGES && unlikely(unlock)) {
> >                        if (!((vma->vm_flags & VM_LOCKED) &&
> > !!! should be '||' ?                                      ^^
> >                              page_mapped_in_vma(page, vma)))
> >                                continue;  /* must visit all unlocked vmas */
> >                        ret = SWAP_MLOCK;  /* saw at least one mlocked vma */
> >                } else {
> >                        ret = try_to_unmap_one(page, vma, migration);
> >                        if (ret == SWAP_FAIL || !page_mapped(page))
> >                                break;
> >                }
> >                if (ret == SWAP_MLOCK) {
> >                        mlocked = try_to_mlock_page(page, vma);
> >                        if (mlocked)
> >                                break;  /* stop if actually mlocked page */
> >                }
> >        }
> >
> > or that clause [under if (MLOCK_PAGES && unlikely(unlock))]
> > might be clearer as:
> >
> >               if ((vma->vm_flags & VM_LOCKED) && page_mapped_in_vma(page, vma))
> >                      ret = SWAP_MLOCK;  /* saw at least one mlocked vma */
> >               else
> >                      continue;  /* must visit all unlocked vmas */
> >
> > Do you agree?
> 
> Hmmm.
> I don't think so.
> 
> >                        if (!((vma->vm_flags & VM_LOCKED) &&
> >                              page_mapped_in_vma(page, vma)))
> >                                continue;  /* must visit all unlocked vmas */
> 
> is already equivalent to
> 
> >               if ((vma->vm_flags & VM_LOCKED) && page_mapped_in_vma(page, vma))
> >                      ret = SWAP_MLOCK;  /* saw at least one mlocked vma */
> >               else
> >   
>                    continue;  /* must visit all unlocked vmas */

Hmmm, I should know not to try to read code when I'm that sleepy.  Had
myself convinced that the condition was wrong...

> 
> 
> > And, I wonder if we need a similar check for
> > page_mapped_in_vma(page, vma) up in try_to_unmap_one()?
> 
> because page_mapped_in_vma() can return 0 if vma is anon vma only.

by "vma is anon vma only", do you mean that the vma being tested--e.g.,
that we found to be VM_LOCKED--no longer has the page mapped in it's
page tables?  That is it's purpose--to detect this condition.  IIRC, Rik
added it during testing of the mlock patches when we discovered we were
mlocking pages because 

> 
> In the other word,
> struct adress_space (for file) gurantee that unrelated vma doesn't chained.

right.  that's why we don't have the page_mapped_in_vma() check in
try_to_unmap_file().

> but struct anon_vma (for anon) doesn't gurantee that unrelated vma
> doesn't chained.

Well, they're not exactly "unrelated"--vmas attached to an anon_vma are
from the same "family".  Any pages that haven't been COWed will still be
mapped into multiple mm's.

My question last night about try_to_unmap_one() wasn't really related to
the mlock statistics glitch.  Sorry I wasn't more clear about this.  I
was wondering about the case where shrink_page_list was trying to unmap
a page whose vma was on an anon_vma list with other VM_LOCKED vmas that
didn't actually map the page.  However, in the early morning light, I
see that the call to page_check_address() handles this.

----------
Anyway, our original responses to this report crossed in the mail.  You
said you'd handle it.  So, in the meantime, I'm looking at the
mmap()/vm_merge()/mlock_vma_pages_range() issue reported yesterday.

Regards,
Lee

