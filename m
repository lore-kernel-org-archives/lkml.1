Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYG2AvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYG2AvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYG2Au5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:50:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:62768 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbYG2Au4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:50:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b5eZ9qQpjr/WG2dUW+1dr1EpO/vX6p+gmssQTEmh06MD4+mCS5MMRJyruaPyVoWkSn
         sNaLuiinRWYEH+HmFgFbGIsdtho+teVrBmWdVT58juBvtzZ9xew+XLDxIXkiZEU1xSNt
         kc/UU/reb+g3KVr7XL/ns2hsLkCBIqzbB250s=
Date: Tue, 29 Jul 2008 04:51:05 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@saeurebad.de>, akpm@linuxfoundation.org,
       torvalds@linuxfoundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: do not overrun page table ranges in gup
Message-ID: <20080729005105.GA15046@martell.zuzino.mipt.ru>
References: <20080728184947.GA5041@martell.zuzino.mipt.ru> <20080728185316.GA19479@martell.zuzino.mipt.ru> <87y73l5zlj.fsf_-_@saeurebad.de> <87tze95yrk.fsf@saeurebad.de> <alpine.LFD.1.10.0807281721200.3486@nehalem.linux-foundation.org> <alpine.LFD.1.10.0807281737480.3486@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807281737480.3486@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 05:39:18PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 28 Jul 2008, Linus Torvalds wrote:
> > 
> > So no, the right fix would be to align 'start' first, which means that 
> > everything else (including 'end') will be page-aligned. Aligning just one 
> > or the other is very very wrong.
> 
> Does this work?
> 
> Not pretty, but it stands _some_ chance of being correct.

vmsplice01 doesn't crash now.

> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -223,14 +223,17 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  			struct page **pages)
>  {
>  	struct mm_struct *mm = current->mm;
> -	unsigned long end = start + (nr_pages << PAGE_SHIFT);
> -	unsigned long addr = start;
> +	unsigned long addr, len, end;
>  	unsigned long next;
>  	pgd_t *pgdp;
>  	int nr = 0;
>  
> +	start &= PAGE_MASK;
> +	addr = start;
> +	len = (unsigned long) nr_pages << PAGE_SHIFT;
> +	end = start + len;
>  	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
> -					start, nr_pages*PAGE_SIZE)))
> +					start, len)))
>  		goto slow_irqon;
>  
>  	/*

