Return-Path: <linux-kernel-owner+w=401wt.eu-S1761030AbYAKJjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761030AbYAKJjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbYAKJjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:39:44 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:47601 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbYAKJjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:39:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GhXEpnVNNyZ9YriHM7B1t7hjCYELdEDIU3aQ4SoosuWS/2FQWy79YsMsti8fMolQLOlutEDQzPrZCwkAddoXruFczXWRP1Mu82bDY1U2SsvtoSuUe6KU4lIcogq9hm42QZSNxiPIWqAg/IX05452XFpMKbfnC3/YfmvQIWvQ2tY=
Message-ID: <47873959.3000102@gmail.com>
Date: Fri, 11 Jan 2008 10:39:37 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adjust/fix LDT handling for Xen
References: <4787436E.76E4.0078.0@novell.com>
In-Reply-To: <4787436E.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2008 10:22 AM, Jan Beulich wrote:
> Don't rely on kmalloc(PAGE_SIZE) returning PAGE_SIZE aligned memory
> (Xen requires GDT *and* LDT to be page-aligned). Using the page
> allocator interface also removes the (albeit small) slab allocator
> overhead. The same change being done for 64-bits for consistency.
> 
> Further, the Xen hypercall interface expects the LDT address to be
> virtual, not machine.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> 
> ---
>  arch/x86/kernel/ldt_32.c |    7 +++----
>  arch/x86/kernel/ldt_64.c |    7 +++----
>  arch/x86/xen/enlighten.c |    9 +--------
>  3 files changed, 7 insertions(+), 16 deletions(-)
> 
> --- linux-2.6.24-rc7/arch/x86/kernel/ldt_32.c	2008-01-10 16:53:54.000000000 +0100
> +++ 2.6.24-rc7-x86-xen-ldt/arch/x86/kernel/ldt_32.c	2008-01-09 13:59:50.000000000 +0100
[...]
> @@ -73,7 +72,7 @@ static int alloc_ldt(mm_context_t *pc, u
>  		if (oldsize*LDT_ENTRY_SIZE > PAGE_SIZE)
>  			vfree(oldldt);
>  		else
> -			kfree(oldldt);
> +			put_page(virt_to_page(oldldt));
>  	}
>  	return 0;
>  }
> @@ -117,7 +116,7 @@ void destroy_context(struct mm_struct *m
>  		if ((unsigned)mm->context.size*LDT_ENTRY_SIZE > PAGE_SIZE)
>  			vfree(mm->context.ldt);
>  		else
> -			kfree(mm->context.ldt);
> +			put_page(virt_to_page(mm->context.ldt));

why not free_page() with all those checks if it is correct virt address which it 
brings?

regards,
-- 
Jiri Slaby
Faculty of Informatics, Masaryk University
Suse Labs
