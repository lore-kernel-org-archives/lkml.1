Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbXJZMcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbXJZMcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbXJZMcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:32:16 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:53645 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbXJZMcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:32:15 -0400
Date: Fri, 26 Oct 2007 13:30:42 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jiri Kosina <jikos@jikos.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Sami Farin <safari-kernel@safari.iki.fi>,
       Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] [RFC] brk randomization: compute RLIMIT_DATA properly
 (was Re: x86: randomize brk() and RLIMIT_DATA)
In-Reply-To: <Pine.LNX.4.64.0710261414030.18815@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0710261329450.27706@blonde.wat.veritas.com>
References: <20071025134124.wc44gdud7ixghfxv@m.safari.iki.fi>
 <20071025071324.2eac21d6@laptopd505.fenrus.org> <Pine.LNX.4.64.0710251644460.12935@jikos.suse.cz>
 <20071025171942.pjff7jbpempfcuri@m.safari.iki.fi>
 <Pine.LNX.4.64.0710261235270.18815@twin.jikos.cz>
 <Pine.LNX.4.64.0710261247520.24322@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0710261414030.18815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Jiri Kosina wrote:
> On Fri, 26 Oct 2007, Hugh Dickins wrote:
> 
> > > -	if (rlim < RLIM_INFINITY && brk - mm->start_data > rlim)
> > > +	if (rlim < RLIM_INFINITY && brk - mm->start_data -
> > > +			(mm->start_brk - mm->end_data) > rlim)
> > I find the order in that test mysterious.
> 
> I agree that the order you proposed is easier to understand on the first 
> sight.
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

Acked-by: Hugh Dickins <hugh@veritas.com>

> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index facc1a7..673ac7d 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -251,7 +251,8 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
>  	 * not page aligned -Ram Gupta
>  	 */
>  	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
> -	if (rlim < RLIM_INFINITY && brk - mm->start_data > rlim)
> +	if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
> +			(mm->end_data - mm->start_data) > rlim)
>  		goto out;
>  
>  	newbrk = PAGE_ALIGN(brk);
