Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbZA2EaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbZA2EaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbZA2E3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:29:54 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:39998 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbZA2E3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:29:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=afjhrMbMsAGzv7jDbzzeYdnsCzrx+E/2J+oD44A9zS3cG2gU6iKOXIALE/lO76XWy3
         2R+u5xqHLMpzX9EZPvq+ZiukaLVTDf0m3LMdiyGhU3Zxc8oSXwk1TlbBpkjLnunQbnO6
         5Xd8jGyfL63+RkYVhvuuTDjo+134l7VIwN9T4=
Date: Thu, 29 Jan 2009 13:29:26 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux mm <linux-mm@kvack.org>, linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [BUG] mlocked page counter mismatch
Message-ID: <20090129042926.GC24924@barrios-desktop>
References: <20090128102841.GA24924@barrios-desktop> <1233156832.8760.85.camel@lts-notebook> <20090128235514.GB24924@barrios-desktop> <1233193736.8760.199.camel@lts-notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233193736.8760.199.camel@lts-notebook>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late response. 

> Looks at code again....
> 
> I think I see it.  In try_to_unmap_anon(), called from try_to_munlock(),
> we have:
> 
>          list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
>                 if (MLOCK_PAGES && unlikely(unlock)) {
>                         if (!((vma->vm_flags & VM_LOCKED) &&
> !!! should be '||' ?                                      ^^
>                               page_mapped_in_vma(page, vma)))
>                                 continue;  /* must visit all unlocked vmas */
>                         ret = SWAP_MLOCK;  /* saw at least one mlocked vma */
>                 } else {
>                         ret = try_to_unmap_one(page, vma, migration);
>                         if (ret == SWAP_FAIL || !page_mapped(page))
>                                 break;
>                 }
>                 if (ret == SWAP_MLOCK) {
>                         mlocked = try_to_mlock_page(page, vma);
>                         if (mlocked)
>                                 break;  /* stop if actually mlocked page */
>                 }
>         }
> 
> or that clause [under if (MLOCK_PAGES && unlikely(unlock))]
> might be clearer as:
> 
>                if ((vma->vm_flags & VM_LOCKED) && page_mapped_in_vma(page, vma))
>                       ret = SWAP_MLOCK;  /* saw at least one mlocked vma */
>                else
>                       continue;  /* must visit all unlocked vmas */
> 
> 
> Do you agree?

I agree this. 
This is more clear. we have to check another process's vma which is linked 
by anon_vma. 
We also have to check it in try_to_unmap_file. 


> 
> And, I wonder if we need a similar check for 
> page_mapped_in_vma(page, vma) up in try_to_unmap_one()?
> 
> > 
> > > 
> > > > 
> > > > But, After I called munlockall intentionally, the counter work well. 
> > > > In case of munlockall, we already had a mmap_sem about write. 
> > > > Such a case, try_to_mlock_page can't call mlock_vma_page.
> > > > so, mlocked counter didn't increased. 
> > > > As a result, the counter seems to be work well but I think 
> > > > it also have a problem.
> > > 
> > > I THINK this is a artifact of the way stats are accumulated in per cpu
> > > differential counters and pushed to the zone state accumulators when a
> > > threshold is reached.  I've seen this condition before, but it
> > > eventually clears itself as the stats get pushed to the zone state.
> > > Still, it bears more investigation, as it's been a while since I worked
> > > on this and some subsequent fixes could have broken it:
> > 
> > Hmm... My test result is as follow. 
> > 
> > 1) without munlockall
> > before:
> > 
> > root@barrios-target-linux:~# tail -8 /proc/vmstat 
> > unevictable_pgs_culled 0
> > unevictable_pgs_scanned 0
> > unevictable_pgs_rescued 0
> > unevictable_pgs_mlocked 0
> > unevictable_pgs_munlocked 0
> > unevictable_pgs_cleared 0
> > unevictable_pgs_stranded 0
> > unevictable_pgs_mlockfreed 0
> > 
> > root@barrios-target-linux:~# cat /proc/meminfo | egrep 'Mlo|Unev'
> > Unevictable:           0 kB
> > Mlocked:               0 kB
> > 
> > after:
> > root@barrios-target-linux:~# tail -8 /proc/vmstat 
> > unevictable_pgs_culled 369
> > unevictable_pgs_scanned 0
> > unevictable_pgs_rescued 388
> > unevictable_pgs_mlocked 392
> > unevictable_pgs_munlocked 387
> > unevictable_pgs_cleared 1
> 
> this looks like either some task forked and COWed an anon page--perhaps
> a stack page--or truncated a mlocked, mmaped file.  
> 
> > unevictable_pgs_stranded 0
> > unevictable_pgs_mlockfreed 0
> > 
> > root@barrios-target-linux:~# cat /proc/meminfo | egrep 'Mlo|Unev'
> > Unevictable:           8 kB
> > Mlocked:               8 kB
> > 
> > after dropping cache
> > 
> > root@barrios-target-linux:~# cat /proc/meminfo | egrep 'Mlo|Unev'
> > Unevictable:           4 kB
> > Mlocked:               4 kB
> 
> Same effect I was seeing.  Two extra mlock counts until we drop cache.
> Then only 1.  Interesting.
> 
> > 
> > 
> > 2) with munlockall 
> > 
> > barrios-target@barrios-target-linux:~$ tail -8 /proc/vmstat
> > unevictable_pgs_culled 0
> > unevictable_pgs_scanned 0
> > unevictable_pgs_rescued 0
> > unevictable_pgs_mlocked 0
> > unevictable_pgs_munlocked 0
> > unevictable_pgs_cleared 0
> > unevictable_pgs_stranded 0
> > unevictable_pgs_mlockfreed 0
> > 
> > barrios-target@barrios-target-linux:~$ cat /proc/meminfo | egrep 'Mlo|Unev'
> > Unevictable:           0 kB
> > Mlocked:               0 kB
> > 
> > after
> > 
> > 
> > root@barrios-target-linux:~# tail -8 /proc/vmstat
> > unevictable_pgs_culled 369
> > unevictable_pgs_scanned 0
> > unevictable_pgs_rescued 389
> > unevictable_pgs_mlocked 389
> > unevictable_pgs_munlocked 389
> > unevictable_pgs_cleared 0
> > unevictable_pgs_stranded 0
> > unevictable_pgs_mlockfreed 0
> > 
> > root@barrios-target-linux:~# cat /proc/meminfo | egrep 'Mlo|Unev'
> > Unevictable:           0 kB
> > Mlocked:               0 kB
> > 
> > Both tests have to show same result. 
> > But is didn't. 
> > 
> > I think it's not per-cpu problem. 
> > 
> > When I digged in the source, I found that. 
> > In case of test without munlockall, try_to_unmap_file calls try_to_mlock_page 
> 
> This I don't understand.  exit_mmap() calls munlock_vma_pages_all() for
> all VM_LOCKED vmas.  This should have the same effect as calling
> mlock_fixup() without VM_LOCKED flags, which munlockall() does.

I said early. The difference is write of mmap_sem. 
In case of exit_mmap, it have readlock of mmap_sem. 
but In case of munlockall, it have writelock of mmap_sem. 
so try_to_mlock_page will fail down_read_trylock. 

> 
> 
> > since some pages are mapped several vmas(I don't know why that pages is shared 
> > other vma in same process. 
> 
> Isn't necessarily in the same task.  We're traversing the list of vma's
> associated with a single anon_vma.  This includes all ancestors and
> descendants that haven't exec'd.  Of course, I don't see a fork() in
> either of your test programs, so I don't know what's happening.

I agree. we have to traverse list of vma's. 
In my case, my test program's image's first page is mapped two vma.
one is code vma. the other is data vma. I don't know why code and data vmas
include program's first page.
 
> 
> > One of page which i have seen is test program's 
> > first code page[page->index : 0 vma->vm_pgoff : 0]. It was mapped by data vma, too). 
> > Other vma have VM_LOCKED.
> > So try_to_unmap_file calls try_to_mlock_page. Then, After calling 
> > successful down_read_try_lock call, mlock_vma_page increased mlocked
> > counter again. 
> > 
> > In case of test with munlockall, try_to_mlock_page's down_read_trylock 
> > couldn't be sucessful. That's because munlockall called down_write.
> > At result, try_to_mlock_page cannot call try_to_mlock_page. so, mlocked counter 
> > don't increased. I think it's not right. 
> > But fortunately Mlocked number is right. :(
> 
> 
> I'll try with your 2nd test program [sent via separate mail] and try the
> fix above.  I also want to understand the difference between exit_mmap()
> for a task that called mlockall() and the munlockall() case.
> 

Thanks for having an interest in this problem. :)

> Regards,
> Lee

-- 
Kinds Regards
MinChan Kim
