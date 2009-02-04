Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbZBDE6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbZBDE6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 23:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZBDE6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 23:58:08 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:14562 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZBDE6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 23:58:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LP1CDCFlzOijVCrXjOMnd4FlqUO3Lx9ca6eux5oBmQfhflBNfD01qlDj8CTUpsjOnS
         GG/hBd/WYSsNeNLRFuYqF1pXwuthMd6CoR46NkrhdXVJu6g+xa0KG/mKxk7VMw/HZ41T
         DA5MZisjNo904+tb5WdrrpmmrA8Q9tfuMLscw=
Date: Wed, 4 Feb 2009 13:57:45 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux mm <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2] fix mlocked page counter mistmatch
Message-ID: <20090204045745.GC6212@barrios-desktop>
References: <20090204103648.ECAF.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090204024447.GB6212@barrios-desktop> <20090204115047.ECB5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204115047.ECB5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 11:51:43AM +0900, KOSAKI Motohiro wrote:
> > > Could you please teach me why this issue doesn't happend on munlockall()?
> > > your scenario seems to don't depend on exit_mmap().
> > 
> > 
> > Good question.
> > It's a different issue.
> > It is related to mmap_sem locking issue. 
> > 
> > Actually, I am about to make a patch.
> > But, I can't understand that Why try_do_mlock_page should downgrade mm_sem ?
> > Is it necessary ? 
> > 
> > In munlockall path, mmap_sem already is holding in write-mode of mmap_sem.
> > so, try_to_mlock_page always fail to downgrade mmap_sem.
> > It's why it looks like working well about mlocked counter. 
> 
> lastest linus tree don't have downgrade mmap_sem.
> (recently it was removed)

Thnaks for information.

what is 'latest linus tree' ?
You mean '29-rc3-git5'?


With '29-rc3-git5', I found,

static int try_to_mlock_page(struct page *page, struct vm_area_struct *vma)
{
  int mlocked = 0; 

  if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
    if (vma->vm_flags & VM_LOCKED) {
      mlock_vma_page(page);
      mlocked++;  /* really mlocked the page */
    }    
    up_read(&vma->vm_mm->mmap_sem);
  }
  return mlocked;
}

It still try to downgrade mmap_sem.
Do I miss something ?

> 
> please see it.
> 

-- 
Kinds Regards
MinChan Kim

