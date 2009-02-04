Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZBDCMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZBDCMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZBDCMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:12:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48992 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZBDCMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:12:44 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH v2] fix mlocked page counter mistmatch
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux mm <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090203234408.GA6212@barrios-desktop>
References: <2f11576a0902030844l64c25496sa5f2892bbb04e47c@mail.gmail.com> <20090203234408.GA6212@barrios-desktop>
Message-Id: <20090204103648.ECAF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed,  4 Feb 2009 11:12:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Feb 04, 2009 at 01:44:52AM +0900, KOSAKI Motohiro wrote:
> > Hi MinChan,
> > 
> > I'm confusing now.
> > Can you teach me?
> 
> No problem. :)
> 
> > 
> > > When I tested following program, I found that mlocked counter
> > > is strange.
> > > It couldn't free some mlocked pages of test program.
> > > It is caused that try_to_unmap_file don't check real
> > > page mapping in vmas.
> > 
> > What meanining is "real" page mapping?
> 
> What I mean is that if the page is mapped at the vma,
> I call it's "real" page mapping.
> I explain it more detaily below.
> 
> > 
> > 
> > > That's because goal of address_space for file is to find all processes
> > > into which the file's specific interval is mapped.
> > > What I mean is that it's not related page but file's interval.
> > 
> > hmmm. No.
> > I ran your reproduce program.
> > 
> > two vma pointing the same page cause this leaking.
> 
> I don't think so. 

Please confirm by actual machine and kernel.
I confirmed by printk debugging.


> > iow, any library have .text and .data segment. then the tail of .text
> > and the head of .data vma point the same page.
> > its page was leaked.
> > 
> > 
> > > Even if the page isn't really mapping at the vma, it returns
> > > SWAP_MLOCK since the vma have VM_LOCKED, then calls
> > > try_to_mlock_page. After all, mlocked counter is increased again.
> > >
> > > COWed anon page in a file-backed vma could be a such case.
> > > This patch resolves it.
> > 
> > What meaning is "anon page in a file-backed"?
> > As far as I know, if cow happend on private mapping page, new page is
> > treated truth anon.
> > 
> 
> vm_area_struct's annotation can explain about your question. 
> 
> struct vm_area_struct {
>   struct mm_struct * vm_mm; /* The address space we belong to. */
>   ....
>   ....
>   /*  
>    * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
>    * list, after a COW of one of the file pages.  A MAP_SHARED vma
>    * can only be in the i_mmap tree.  An anonymous MAP_PRIVATE, stack
>    * or brk vma (with NULL file) can only be in an anon_vma list.
>    */
>   struct list_head anon_vma_node; /* Serialized by anon_vma->lock */
>   struct anon_vma *anon_vma;  /* Serialized by page_table_lock */
>   ....
>   ....
> }
> 
> Let us call it anon page in a file-backed. 
> In this case, the new page is mapped at the vma. 
> the vma don't include old page any more but i_mmap tree still have 
> the vma. 

hmhm. thanks. 
my understanding largely improvement.

I agree page_check_address() checking is necessary.

> So, the i_mmap tree can have the vma which don't include
> the page if the one is anon page in a file-backed. 
> 
> This problem is caused by that. 
> Is it enough ?

Could you please teach me why this issue doesn't happend on munlockall()?
your scenario seems to don't depend on exit_mmap().



