Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYG2AhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYG2AhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYG2Ag4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:36:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbYG2Ag4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:36:56 -0400
Date: Mon, 28 Jul 2008 17:33:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@saeurebad.de>
cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linuxfoundation.org,
       torvalds@linuxfoundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: do not overrun page table ranges in gup
In-Reply-To: <87tze95yrk.fsf@saeurebad.de>
Message-ID: <alpine.LFD.1.10.0807281721200.3486@nehalem.linux-foundation.org>
References: <20080728184947.GA5041@martell.zuzino.mipt.ru> <20080728185316.GA19479@martell.zuzino.mipt.ru> <87y73l5zlj.fsf_-_@saeurebad.de> <87tze95yrk.fsf@saeurebad.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Jul 2008, Johannes Weiner wrote:
> 
> Actually, I think the prettier fix would be to just establish that
> garuantee:
>
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -223,7 +223,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  			struct page **pages)
>  {
>  	struct mm_struct *mm = current->mm;
> -	unsigned long end = start + (nr_pages << PAGE_SHIFT);
> +	unsigned long end = PAGE_ALIGN(start + (nr_pages << PAGE_SHIFT));

Umm. 'end' is guaranteed to be page-aligned if 'start' is. 

So if this makes a difference, that implies that _start_ isn't 
page-aligned, and then you when you add PAGE_SIZE to 'addr', you are going 
to miss 'end' again.

So no, the right fix would be to align 'start' first, which means that 
everything else (including 'end') will be page-aligned. Aligning just one 
or the other is very very wrong.

But yeah, this looks like a nasty bug. It's also sad that the code 
that _should_ be architecture-independent, isn't - because every 
architecture defines the _whole_ "get_user_pages_fast()", even though part 
of it is very much arch-independent (the whole alignment/access_ok part).

It also shows a bug in that whole "access_ok()" check. The fact is, that 
thing is broken too - for the same reason. If you want to get a single 
page at the end of the address space, but don't use an aligned address, 
the "access_ok()" will fail.

Nick, how do you want to fix this? I was just about to cut an -rc1, but I 
would really like to see this one not make it into it..

		Linus
