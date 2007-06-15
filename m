Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbXFOVqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbXFOVqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758397AbXFOVqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:46:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:28293 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347AbXFOVqI (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qT4x8cVZ9jj+6YRC6triRJyBwygBPRDKjhqshKkMwMBA06AAOCJIQ3Pb1Y9op7JV1DwoHs8hGzJF6UX+hZMvmL9XpF49UxC0saoFnoM2FL8b+sBk0UrG4LvXQsxPL60aTPGGEVXKEDQJYyg2qtMHCCNP3uaCDhry+P42zOIlRqM=
Message-ID: <6934efce0706151446o44526edbn9e2ef993e2c1d3be@mail.gmail.com>
Date: Fri, 15 Jun 2007 14:46:07 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: carsteno@de.ibm.com
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
In-Reply-To: <467299F5.3070704@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
	 <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au>
	 <467299F5.3070704@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, Carsten Otte <cotte@de.ibm.com> wrote:
> Nick Piggin wrote:
> > Carsten Otte wrote:
> >> The current xip stack relies on having struct page behind the memory
> >> segment. This causes few impact on memory management, but occupies
> >> some more memory. The cramfs patch chose to modify copy on write in
> >> order to deal with vmas that don't have struct page behind.
> >> So far, Hugh and Linus have shown strong opposition against copy on
> >> write with no struct page behind. If this implementation is acceptable
> >> to the them, it seems preferable to me over wasting memory. The xip
> >> stack should be modified to use this vma flag in that case.
> >
> > I would rather not :P
> >
> > We can copy on write without a struct page behind the source today, no?
> > What is insufficient for the XIP code with the current COW?
>
> I've looked at the -mm version of mm/memory.c today, with intend to
> try out VM_PFNMAP for our xip mappings and replace nopage() with fault().
> The thing is, I believe it does'nt work for us:
>   * The way we recognize those mappings is through the rules set up
>   * by "remap_pfn_range()": the vma will have the VM_PFNMAP bit set,
>   * and the vm_pgoff will point to the first PFN mapped: thus every
>   * page that is a raw mapping will always honor the rule
>   *
>   *      pfn_of_page == vma->vm_pgoff + ((addr - vma->vm_start) >>
> PAGE_SHIFT)
>
> This is, as far as I can tell, not true for our xip mappings. Ext2 may
> spread the physical pages behind a given file all over its media. That
> means, that the pfns of the pages that form a vma may be more or less
> random rather than contiguous. The common memory management code
> cannot tell whether or not a given page has been COW'ed.
> Did I miss something?

I agree, the conditions imposed by the remap_pfn_range() don't work.
