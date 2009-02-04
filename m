Return-Path: <linux-kernel-owner+w=401wt.eu-S1760073AbZBDVYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073AbZBDVYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbZBDVXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:23:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbZBDVXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:23:52 -0500
Date: Wed, 4 Feb 2009 13:23:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: benh@kernel.crashing.org, eli@mellanox.co.il, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: FW: [PATCH] powerpc/mm: Export HPAGE_SHIFT
Message-Id: <20090204132313.e3047e2f.akpm@linux-foundation.org>
In-Reply-To: <adad4dym2zp.fsf@cisco.com>
References: <20090203164930.GA10101@mtls03>
	<ada8wonnh3t.fsf@cisco.com>
	<1233712248.16867.131.camel@pasglop>
	<20090203211329.d6190a08.akpm@linux-foundation.org>
	<aday6wmn2vr.fsf@cisco.com>
	<20090203222601.747ca8b7.akpm@linux-foundation.org>
	<adad4dym2zp.fsf@cisco.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Feb 2009 11:11:22 -0800
Roland Dreier <rdreier@cisco.com> wrote:

>  > >  > 	huge_page_size(page_hstate(page))
> 
>  > > That would suit.  I assume the intention is for that to be usable by
>  > > driver modules on any architecture?
> 
>  > erm, you overestimate the amount of planning and forethought which goes
>  > into these things ;)
> 
>  > The lack of any EXPORT_SYMBOL(size_to_hstate) is a broadish hint.
> 
> Heh.  Looking into the implementation, it seems that I could actually do
> 
> 	PAGE_SIZE << compound_order(page)
> 
> directly (since there's no reason to go from size to hstate and back to
> size.  I don't know all the details of these VM internals, but that
> seems to only work on the first (small) page of a giant page?  Which
> causes problems for what we're trying to do here...
> 
> To summarize the goal, we are mapping user memory to a device that has
> its own page tables, where the device's page tables can also use
> multiple page sizes.  Using big pages on the device leads to similar
> efficiencies as hugetlb pages do on the CPU, and in fact if a user has
> used hugetlb pages for the memory they're giving to the device, that's a
> very strong hint that the device should use big pages too.
> 
> But one valid situation we have to handle in the driver is if, say,
> userspace has a hugetlb mapped at virtual address 0x200000, and wants to
> map 0x80000 bytes at 0x280000 to the device.  In that case, we're going
> to do essentially
> 
> 	get_user_pages(..., 0x280000, 0x80000 / PAGE_SIZE, ...)
> 
> and get_user_pages() is going to give us a bunch of normal PAGE_SIZE
> pages starting at offset 0x800000 within the compound page that makes up
> the huge page mapped at 0x200000.
> 
> get_user_pages() also gives us the vma back, and we can see from
> is_vm_hugetlb_page() (-- BTW can I just say that a function
> is_xxx_page() that operates on vmas is horribly misnamed --) that these
> pages all come from a hugetlb mapping, but figuring out the size of that
> mapping is I guess a challenge.

compound_head() will convert any page* inside a hugepage into a pointer
to the head page.  It should work OK for regular pages as well as
CONFIG_HUGETLB=n.

So..

	PAGE_SIZE << compound_order(compound_head(page))

?
