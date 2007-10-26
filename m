Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbXJZMEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbXJZMEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbXJZMD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:03:59 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:50632 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbXJZMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:03:58 -0400
Date: Fri, 26 Oct 2007 13:02:57 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jiri Kosina <jikos@jikos.cz>
cc: Sami Farin <safari-kernel@safari.iki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] [RFC] brk randomization: compute RLIMIT_DATA properly
 (was Re: x86: randomize brk() and RLIMIT_DATA)
In-Reply-To: <Pine.LNX.4.64.0710261235270.18815@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0710261247520.24322@blonde.wat.veritas.com>
References: <20071025134124.wc44gdud7ixghfxv@m.safari.iki.fi>
 <20071025071324.2eac21d6@laptopd505.fenrus.org> <Pine.LNX.4.64.0710251644460.12935@jikos.suse.cz>
 <20071025171942.pjff7jbpempfcuri@m.safari.iki.fi>
 <Pine.LNX.4.64.0710261235270.18815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Jiri Kosina wrote:
> On Thu, 25 Oct 2007, Sami Farin wrote:
> > > > > Would be neat if randomized brk and setrlimit(RLIMIT_DATA, ...)
> > > > > worked in a predictable way:
> > > > this isn't a valid case afaics; even on "traditional x86" (before we 
> > > > changed the address space layout, or even today if you have an 
> > > > unlimited stack rlimit) this isn't going to work. applications 
> > > > really shouldn't use (s)brk() but malloc(); you have to be able to 
> > > > fall back to mmap regardless of what you do.
> > > I tend to agree here with Arjan. However it probably would make no 
> > > harm to make at least a little bit consisten behavior of setrlimit(), 
> > > though it has a little use in such cases.
> > > Sami, does the patch below work for you?
> > Thanks, Jiri, now RLIMIT_DATA works as expected. Using only RLIMIT_AS to 
> > limit processes' memory usage is not very easy.  It includes also 
> > libraries mapped read-only, I have to check/modify the limits when I 
> > update/add libraries,...
> 
> This patch is [RFC] as I am not sure whether it is worth it (see Arjan's 
> comment above).

It is worth it.

Arjan's right that RLIMIT_DATA has difficulty making sense, but
you shouldn't be randomizing its breakage further with your patch.

> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> brk randomization: compute RLIMIT_DATA properly
> 
> In cases of heap area placed at randomly-generated offset from 
> mm->end_data (arch_randomize_brk()), we need to subtract the value of the 
> offset for setrlimit(RLIMIT_DATA) to work properly -- otherwise we count 
> the unoccupied memory between mm->end_data and mm->start_brk as occupied.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index facc1a7..c7ade18 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -251,7 +251,8 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
>  	 * not page aligned -Ram Gupta
>  	 */
>  	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
> -	if (rlim < RLIM_INFINITY && brk - mm->start_data > rlim)
> +	if (rlim < RLIM_INFINITY && brk - mm->start_data -
> +			(mm->start_brk - mm->end_data) > rlim)
>  		goto out;
>  
>  	newbrk = PAGE_ALIGN(brk);

I find the order in that test mysterious.  Others might ask you to use
an intermediate variable, I don't care about that, but I would find

if (rlim < RLIM_INFINITY &&
	(brk - mm->start_brk) + (mm->end_data - mm->start_data) > rlim)

much easier to understand.

Hugh
