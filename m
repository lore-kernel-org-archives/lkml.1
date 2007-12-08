Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbXLHAdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbXLHAdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 19:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXLHAc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 19:32:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56090 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050AbXLHAcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 19:32:55 -0500
Date: Fri, 7 Dec 2007 16:31:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: npiggin@suse.de
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [patch 07/18] v4l: nopage
Message-Id: <20071207163142.4e77f9c3.akpm@linux-foundation.org>
In-Reply-To: <20071205071627.469118000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
	<20071205071627.469118000@nick.local0.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Dec 2007 18:15:54 +1100
npiggin@suse.de wrote:

> +static int
> +videobuf_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
>  	struct page *page;
>  
> -	dprintk(3,"nopage: fault @ %08lx [vma %08lx-%08lx]\n",
> -		vaddr,vma->vm_start,vma->vm_end);
> -	if (vaddr > vma->vm_end)
> -		return NOPAGE_SIGBUS;
> +	dprintk(3,"fault: fault @ %08lx [vma %08lx-%08lx]\n",
> +		(unsigned long)vmf->virtual_address,vma->vm_start,vma->vm_end);
>  	page = alloc_page(GFP_USER | __GFP_DMA32);
>  	if (!page)
> -		return NOPAGE_OOM;
> +		return VM_FAULT_OOM;
>  	clear_user_page(page_address(page), vaddr, page);

This didn't compile on sparc64 because `vaddr' is undefined.


Let us see why:

#define clear_user_page(page, vaddr, pg)	clear_page(page)
#define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)

#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)

root cause: lack of argument checking on x86 due to stupid macros.


Could someone *please* start a little project of extirpating this utter
brain damage?  Convert those macros to typechecked static inlines on x86
(at least) so this sort of thing (which happens again and again and again)
is lessened?


macros are such miserable things.  I wonder if we could get checkpatch to
help out here?  
