Return-Path: <linux-kernel-owner+w=401wt.eu-S2993207AbXECVpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993207AbXECVpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993204AbXECVpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:45:36 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2885 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993207AbXECVpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:45:35 -0400
Date: Thu, 3 May 2007 23:45:32 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/2] rename thread_info to stack
In-Reply-To: <20070503141951.d67d0289.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705032338450.1479@scrub.home>
References: <Pine.LNX.4.64.0705010210010.1479@scrub.home>
 <20070503141951.d67d0289.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 3 May 2007, Andrew Morton wrote:

> > This finally renames the thread_info field in task structure to stack,
> > so that the assumptions about this field are gone and archs have more
> > freedom about placing the thread_info structure.
> 
> It needed this build fix:
> 
> --- a/include/asm-x86_64/system.h~rename-thread_info-to-stack-fix
> +++ a/include/asm-x86_64/system.h
> @@ -39,7 +39,7 @@
>  		       [threadrsp] "i" (offsetof(struct task_struct, thread.rsp)), \
>  		       [ti_flags] "i" (offsetof(struct thread_info, flags)),\
>  		       [tif_fork] "i" (TIF_FORK),			  \
> -		       [thread_info] "i" (offsetof(struct task_struct, thread_info)), \
> +		       [thread_info] "i" (offsetof(struct task_struct, stack)), \
>  		       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))   \
>  		     : "memory", "cc" __EXTRA_CLOBBER)
>      
> _
> 
> 
> It is unpleasing that this code is forced to implicitly assume that the
> thing pointed to by task_struct.stack has type `struct thread_info'.
> 
> Are we sure this patch is a good thing?

Assembler code is difficult to wrap, there are more places where assembler 
code assumes that the thread_info is at the start of the stack.
Anyway, in this case it looks a little weird that TIF_FORK needs to be 
cleared at every context switch, other archs setup a different return 
address (usually ret_from_fork) and then finish scheduling by calling 
schedule_tail().

bye, Roman
