Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZBDXgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZBDXgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZBDXgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:36:15 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:37082 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbZBDXgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:36:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xq3SLjhSOlXOgVPv2czAGjUWXPaSEAcdT+C5YYsQ4r+nS30ttbfwsdtV4L51z9vy3s
         2FMlK6nhuDKHtDGUX/98FMFvf+2GcI+Sfmhki6VVMSdtOK3DepgIM1DHb49XNX9R5KbD
         KHvDpSTbzCxXO+M+dKcFoLEYYFSYF/w5n4Zv0=
Date: Thu, 5 Feb 2009 08:35:43 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux mm <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2] fix mlocked page counter mistmatch
Message-ID: <20090204233543.GA26159@barrios-desktop>
References: <20090204115047.ECB5.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090204045745.GC6212@barrios-desktop> <20090204171639.ECCE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204171639.ECCE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 07:28:19PM +0900, KOSAKI Motohiro wrote:
> > With '29-rc3-git5', I found,
> > 
> > static int try_to_mlock_page(struct page *page, struct vm_area_struct *vma)
> > {
> >   int mlocked = 0; 
> > 
> >   if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
> >     if (vma->vm_flags & VM_LOCKED) {
> >       mlock_vma_page(page);
> >       mlocked++;  /* really mlocked the page */
> >     }    
> >     up_read(&vma->vm_mm->mmap_sem);
> >   }
> >   return mlocked;
> > }
> > 
> > It still try to downgrade mmap_sem.
> > Do I miss something ?
> 
> sorry, I misunderstood your "downgrade". I said linus removed downgrade_write(&mma_sem).
> 
> Now, I understand this issue perfectly. I agree you and lee-san's fix is correct.
> 	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Good. I will send adrew with your ACK agian.

> 
> 
> and, I think current try_to_mlock_page() is correct. no need change.
> Why?
> 
> 1. Generally, mmap_sem holding is necessary when vma->vm_flags accessed.
>    that's vma's basic rule.
> 2. However, try_to_unmap_one() doesn't held mamp_sem. but that's ok.
>    it often get incorrect result. but caller consider incorrect value safe.
> 3. try_to_mlock_page() need mmap_sem because it obey rule (1).
> 4. in try_to_mlock_page(), if down_read_trylock() is failure, 
>    we can't move the page to unevictable list. but that's ok.
>    the page in evictable list is periodically try to reclaim. and
>    be called try_to_unmap().
>    try_to_unmap() (and its caller) also move the unevictable page to unevictable list.
>    Therefore, in long term view, the page leak is not happend.

Thanks for clarification.
In long term view, you're right.

but My concern is that munlock[all] pathes always hold down of mmap_sem. 
After all, down_read_trylock always wil fail for such cases.

So, current task's mlocked pages only can be reclaimed 
by background or direct reclaim path if the task don't exit.

I think it can increase reclaim overhead unnecessary 
if there are lots of such tasks.

What's your opinion ?

> 
> this explanation is enough?
> 
> thanks.
> 

-- 
Kinds Regards
MinChan Kim

