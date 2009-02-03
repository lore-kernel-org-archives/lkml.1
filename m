Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbZBCXoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbZBCXoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZBCXo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:44:26 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:49231 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZBCXoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:44:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hwpeeJBDbjtDBG2A8YXzULvU9xuzYuo9gNpJ7yuHtjSyQt6vckr89KY2RyO7xUFhPY
         Ot3lBP76DE4dKPJ9C9m8078IWmvLjqqwLq5nz+Y0xRHosbrvrpOCLMFZPyr8qmop2y7h
         pUkg2c+a0HHGprrW9KZenyKkB3ugrSsSf2u5s=
Date: Wed, 4 Feb 2009 08:44:08 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux mm <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2] fix mlocked page counter mistmatch
Message-ID: <20090203234408.GA6212@barrios-desktop>
References: <20090203042405.GB16179@barrios-desktop> <2f11576a0902030844l64c25496sa5f2892bbb04e47c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0902030844l64c25496sa5f2892bbb04e47c@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 01:44:52AM +0900, KOSAKI Motohiro wrote:
> Hi MinChan,
> 
> I'm confusing now.
> Can you teach me?

No problem. :)

> 
> > When I tested following program, I found that mlocked counter
> > is strange.
> > It couldn't free some mlocked pages of test program.
> > It is caused that try_to_unmap_file don't check real
> > page mapping in vmas.
> 
> What meanining is "real" page mapping?

What I mean is that if the page is mapped at the vma,
I call it's "real" page mapping.
I explain it more detaily below.

> 
> 
> > That's because goal of address_space for file is to find all processes
> > into which the file's specific interval is mapped.
> > What I mean is that it's not related page but file's interval.
> 
> hmmm. No.
> I ran your reproduce program.
> 
> two vma pointing the same page cause this leaking.

I don't think so. 

> 
> iow, any library have .text and .data segment. then the tail of .text
> and the head of .data vma point the same page.
> its page was leaked.
> 
> 
> > Even if the page isn't really mapping at the vma, it returns
> > SWAP_MLOCK since the vma have VM_LOCKED, then calls
> > try_to_mlock_page. After all, mlocked counter is increased again.
> >
> > COWed anon page in a file-backed vma could be a such case.
> > This patch resolves it.
> 
> What meaning is "anon page in a file-backed"?
> As far as I know, if cow happend on private mapping page, new page is
> treated truth anon.
> 

vm_area_struct's annotation can explain about your question. 

struct vm_area_struct {
  struct mm_struct * vm_mm; /* The address space we belong to. */
  ....
  ....
  /*  
   * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
   * list, after a COW of one of the file pages.  A MAP_SHARED vma
   * can only be in the i_mmap tree.  An anonymous MAP_PRIVATE, stack
   * or brk vma (with NULL file) can only be in an anon_vma list.
   */
  struct list_head anon_vma_node; /* Serialized by anon_vma->lock */
  struct anon_vma *anon_vma;  /* Serialized by page_table_lock */
  ....
  ....
}

Let us call it anon page in a file-backed. 
In this case, the new page is mapped at the vma. 
the vma don't include old page any more but i_mmap tree still have 
the vma. 

So, the i_mmap tree can have the vma which don't include
the page if the one is anon page in a file-backed. 

This problem is caused by that. 
Is it enough ?

> 
> So, I don't reach to your conclusion yet. please teach me.


-- 
Kinds Regards
MinChan Kim

