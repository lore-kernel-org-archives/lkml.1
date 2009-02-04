Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZBDK2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZBDK2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZBDK2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:28:23 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37777 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZBDK2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:28:22 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH v2] fix mlocked page counter mistmatch
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux mm <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090204045745.GC6212@barrios-desktop>
References: <20090204115047.ECB5.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090204045745.GC6212@barrios-desktop>
Message-Id: <20090204171639.ECCE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed,  4 Feb 2009 19:28:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With '29-rc3-git5', I found,
> 
> static int try_to_mlock_page(struct page *page, struct vm_area_struct *vma)
> {
>   int mlocked = 0; 
> 
>   if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
>     if (vma->vm_flags & VM_LOCKED) {
>       mlock_vma_page(page);
>       mlocked++;  /* really mlocked the page */
>     }    
>     up_read(&vma->vm_mm->mmap_sem);
>   }
>   return mlocked;
> }
> 
> It still try to downgrade mmap_sem.
> Do I miss something ?

sorry, I misunderstood your "downgrade". I said linus removed downgrade_write(&mma_sem).

Now, I understand this issue perfectly. I agree you and lee-san's fix is correct.
	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


and, I think current try_to_mlock_page() is correct. no need change.
Why?

1. Generally, mmap_sem holding is necessary when vma->vm_flags accessed.
   that's vma's basic rule.
2. However, try_to_unmap_one() doesn't held mamp_sem. but that's ok.
   it often get incorrect result. but caller consider incorrect value safe.
3. try_to_mlock_page() need mmap_sem because it obey rule (1).
4. in try_to_mlock_page(), if down_read_trylock() is failure, 
   we can't move the page to unevictable list. but that's ok.
   the page in evictable list is periodically try to reclaim. and
   be called try_to_unmap().
   try_to_unmap() (and its caller) also move the unevictable page to unevictable list.
   Therefore, in long term view, the page leak is not happend.

this explanation is enough?

thanks.


