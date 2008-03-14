Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYCNQpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYCNQpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 12:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYCNQow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:44:52 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:63499 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYCNQov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hH5iUk5RBjCF3hRjVNJlvDgKql4vFJqIPKzhHjOWEBHhGEBNDWARCfcMs0vI+nsQDcyXP1vC2gOfBdovoCLyyihqfqSns1jxum+HllQkQsKzFiklCDZwOEdePG4Q/r2bp+yw5MntgfJEFKng2ykx6cf9u06or3n8iqVdhclneBE=
Message-ID: <86802c440803140944p302b300fy7515fb758221932b@mail.gmail.com>
Date: Fri, 14 Mar 2008 09:44:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] mm: fix boundary checking in free_bootmem_core
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <87iqzp5xfv.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com>
	 <86802c440803121811i262b21bdrfb07df52fd27aaae@mail.gmail.com>
	 <20080312182240.db32c858.akpm@linux-foundation.org>
	 <200803132259.47063.ak@suse.de>
	 <86802c440803131522t3d038d39gbe8eb0d38ddcb634@mail.gmail.com>
	 <87iqzp5xfv.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Mar 2008 12:58:44 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>  >
>  > then i tried to reserve 64M or 128M RAM before that, and free that
>  > before gart/switotble try to allloc_bootmem under 4g.
>
>  Sounds like an incredible hack. There are far better ways to do that
>  for bootmem allocations. e.g. you can just specify a high enough "goal"
>  That is how swiotlb solves a similar problem (at least before my
>  mask allocator rewrite)

I don't think so.

anyway, otherway to workaround it is
change
                return __earlyonly_bootmem_alloc(node, size, size,
                                __pa(MAX_DMA_ADDRESS));
in vmemmap_alloc_block to
                return __earlyonly_bootmem_alloc(node, size, size,
                                __pa(MAX_DMA_ADDRESS + (1<<27)));
to make room for gart. but that is global change. and may affect other
platform. and don't make sure gart will get it.

also i assume swiotlb need that range is less than 4g.

>
>
>  > >  with your improved free_bootmem()
>  >
>  > using phys_to_nid()? it seems we only have that on x86_64.
>
>  pfn/page_to_nid() is generic afaik.

still in bootmem stage? page->flags is ready at that time?

YH
