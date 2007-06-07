Return-Path: <linux-kernel-owner+w=401wt.eu-S1763534AbXFGPfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763534AbXFGPfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbXFGPfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:35:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252AbXFGPfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:35:30 -0400
Date: Thu, 7 Jun 2007 08:34:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070607083458.a3fc7737.akpm@linux-foundation.org>
In-Reply-To: <20070607214706.3efc5870.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<20070607214706.3efc5870.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 21:47:06 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Question.
> 
> While writing memory unplug, I noticed this code.
> ==
> static int
> fixup_anon_page(pte_t *pte, unsigned long start, unsigned long end, void *priv)
> {
>         struct vm_area_struct *vma = priv;
>         struct page *page = vm_normal_page(vma, start, *pte);
> 
>         if (page && PageAnon(page))
>                 page->index = linear_page_index(vma, start);
> 
>         return 0;
> }
> 
> static int fixup_anon_pages(struct vm_area_struct *vma)
> {
>         struct mm_walk walk = {
>                 .pte_entry = fixup_anon_page,
>         };
> 
>         return walk_page_range(vma->vm_mm,
>                         vma->vm_start, vma->vm_end, &walk, vma);
> }

I assume the above is your code - it's not in the tree?

> 
> I think that 'pte' passed to fixup_anon_page() by walk_page_range()
> is not guaranteed to be 'Present'.

yup - the pagewalker only checks for !pte_none().

> Then, vm_normal_page() will show print_bad_pte().

> If this never occur now, I'll add my own check code for memory migration by kernel here.

Yes, you'll need to perform additional filtering where appropriate.

> (Sorry, I can't find who should be CCed.)

Matt and David did most of the work here.
