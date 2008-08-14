Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbYHNMtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbYHNMtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 08:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbYHNMtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 08:49:08 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:62372 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753622AbYHNMtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 08:49:07 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [rfc][patch] mm: dirty page accounting race fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808141210200.4398@blonde.site>
References: <20080814094537.GA741@wotan.suse.de>
	 <Pine.LNX.4.64.0808141210200.4398@blonde.site>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 14:49:09 +0200
Message-Id: <1218718149.10800.224.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 12:55 +0100, Hugh Dickins wrote:

> Am I confused, or is your "do_wp_page calls ptep_clear_flush_notify"
> example a very bad one?  The page it's dealing with there doesn't
> go back into the page table (its COW does), and the dirty_accounting
> case doesn't even get down there, it's dealt with in the reuse case
> above, which uses ptep_set_access_flags. 

Also, the new page is only added to the rmap _after_ it has been
installed. So page_mkclean() will never get to it to see the empty pte.

>  Now, I think that one may
> well behave as you suggest on some arches (though it's extending
> permissions not restricting them, so maybe not); but please check
> that out and improve your example.

Another case I just looked at is if ptep_clear_flush_young() actually
does the clear bit. But the few arches (x86_64, ppc64) that I looked at
don't seem to do so.

If someone would, you could hit this race.

/me continues searching for a convincing candidate..

> Even if it does, it's not clear to me that your fix is the answer.
> That may well be because the whole of dirty page accounting grew too
> subtle for me! 

    CPU1                      CPU2

    lock(pte_lock)
    ptep_clear_flush(ptep)
                            page_mkclean()
                              page_check_address()
                                !pte_present(ptep)
                                   return NULL
    ptep_set(ptep, new_pte);
    unlock(pte_lock)

Now, if page_check_address() doesn't return prematurely, but is forced
to take the pte_lock, we won't see that hole and will not skip the page.

> But holding the page table lock on one pte of the
> page doesn't guarantee much about the integrity of the whole dance:
> do_wp_page does its set_page_dirty_balance for this case, you'd
> need to spell out the bad sequence more to convince me.
 
Now you're confusing me... are you saying ptes can be changed from under
your feet even while holding the pte_lock?


