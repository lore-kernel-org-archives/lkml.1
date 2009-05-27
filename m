Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbZE0DRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbZE0DRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbZE0DRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:17:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51438 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbZE0DRm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:17:42 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Determine if mapping is MAP_SHARED using VM_MAYSHARE and not VM_SHARED in hugetlbfs
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       npiggin@suse.de, apw@shadowen.org, agl@us.ibm.com, ebmunson@us.ibm.com,
       andi@firstfloor.org, david@gibson.dropbear.id.au, kenchen@google.com,
       wli@holomorphy.com, akpm@linux-foundation.org, starlight@binnacle.cx,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090527004859.GB6189@csn.ul.ie>
References: <Pine.LNX.4.64.0905262056150.958@sister.anvils> <20090527004859.GB6189@csn.ul.ie>
Message-Id: <20090527111652.688B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 27 May 2009 12:17:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > > follow_hugetlb_page
> > > 	This is checking of the zero page can be shared or not. Crap,
> > > 	this one looks like it should have been converted to VM_MAYSHARE
> > > 	as well.
> > 
> > Now, what makes you say that?
> > 
> > I really am eager to understand, because I don't comprehend
> > that VM_SHARED at all. 
> 
> I think I understand it, but I keep changing my mind on whether
> VM_SHARED is sufficient or not.
> 
> In this specific case, the zeropage must not be used by process A where
> it's possible that process B has populated it with data. when I said "Crap"
> earlier, the scenario I imagined went something like;
> 
> o Process A opens a hugetlbfs file read/write but does not map the file
> o Process B opens the same hugetlbfs read-only and maps it
>   MAP_SHARED. hugetlbfs allows mmaps to files that have not been ftruncate()
>   so it can fault pages without SIGBUS
> o Process A writes the file - currently this is impossible as hugetlbfs
>   does not support write() but lets pretend it was possible
> o Process B calls mlock() which calls into follow_hugetlb_page().
>   VM_SHARED is not set because it's a read-only mapping and it returns
>   the wrong page.
> 
> This last step is where I went wrong. As process 2 had no PTE for that
> location, it would have faulted the page as normal and gotten the correct
> page and never considered the zero page so VM_SHARED was ok after all.
> 
> But this is sufficiently difficult that I'm worried that there is some other
> scenario where Process B uses the zero page when it shouldn't. Testing for
> VM_MAYSHARE would prevent the zero page being used incorrectly whether the
> mapping is read-only or read-write but maybe that's too paranoid.
> 
> Kosaki, can you comment on what impact (if any) testing for VM_MAYSHARE
> would have here with respect to core-dumping?

Thank you for very kindful explanation.

Perhaps, I don't understand this issue yet. Honestly I didn't think this
issue at my patch making time.

following is my current analysis. if I'm misunderstanding anythink, please
correct me.

hugepage mlocking call make_pages_present().
above case, follow_page_page() don't use ZERO_PAGE because vma don't have
VM_SHARED.
but that's ok. make_pages_present's intention is not get struct page,
it is to make page population. in this case, we need follow_hugetlb_page() call
hugetlb_fault(), I think.


In the other hand, when core-dump case

.text segment: open(O_RDONLY) + mmap(MAP_SHARED)
.data segment: open(O_RDONLY) + mmap(MAP_PRIVATE)

it mean .text can't use ZERO_PAGE. but I think no problem. In general
.text is smaller than .data. It doesn't make so slowness.



> > I believe Kosaki-san's 4b2e38ad simply
> > copied it from Linus's 672ca28e to mm/memory.c.  But even back
> > when that change was made, I confessed to having lost the plot
> > on it: so far as I can see, putting a VM_SHARED test in there
> > just happened to prevent some VMware code going the wrong way,
> > but I don't see the actual justification for it.
> > 
> 
> Having no idea how vmware broke exactly, I'm not sure what exactly was
> fixed. Maybe by not checking VM_SHARED, it was possible that a caller of
> get_user_pages() would not see updates made by a parallel writer.
> 
> > So, given that I don't understand it in the first place,
> > I can't really support changing that VM_SHARED to VM_MAYSHARE.
> > 
> 
> Lets see what Kosaki says. If he's happy with VM_SHARED, I'll leave it
> alone.


