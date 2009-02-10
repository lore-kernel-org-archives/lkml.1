Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbZBJSbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbZBJSbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 13:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbZBJSaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 13:30:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:50891 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbZBJSav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 13:30:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E7Gb9MubwIGbgpJLG7rxyEzzqmfs7/cnqw6scVRcPdHnaEpkRnHIErCiJ1GTmh7IS5
         BG/oQJ0qC177Ip5OeZQax3wbje3QcPraAUH9N1LeT22ESB55Rt6e9oCoMPihWUNpk58H
         RpojH1Dotn4llE+pm8KMo19YViYZF6xorvlxQ=
Date: Tue, 10 Feb 2009 19:30:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: git pull request for tip/tracing/urgent
Message-ID: <20090210183046.GA1342@nowhere>
References: <alpine.DEB.1.10.0902101314440.23505@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902101314440.23505@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 01:19:31PM -0500, Steven Rostedt wrote:
> 
> Ingo,
> 
> The bug that is fixed by this change can affect users. Most likely it will 
> not, since the fault should never happen. But this is a protective 
> mechanism, where if it does, that means there is a bug in the tracer.
> 
> As you have previously told me, a bug in the tracer should never crash the 
> kernel. Since the detection of a fault in the function graph tracer can 
> lead to a kernel crash (without this change) I think this qualifies as 
> something for 29.
> 
> -- Steve
> 
> 
> The following patch is in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/tracing/urgent
> 
> 
> Steven Rostedt (1):
>       tracing, x86: fix fixup section to return to original code
> 
> ----
>  arch/x86/kernel/ftrace.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> ---------------------------
> commit e3944bfac961cd7fc82f3b3143c55dc375748569
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Tue Feb 10 13:07:13 2009 -0500
> 
>     tracing, x86: fix fixup section to return to original code
>     
>     Impact: fix to prevent a kernel crash on fault
>     
>     If for some reason the pointer to the parent function on the
>     stack takes a fault, the fix up code will not return back to
>     the original faulting code. This can lead to unpredictable
>     results and perhaps even a kernel panic.
>     
>     A fault should not happen, but if it does, we should simply
>     disable the tracer, warn, and continue running the kernel.
>     It should not lead to a kernel crash.
>     
>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 1b43086..9d549e4 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -491,13 +491,15 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>  		"1: " _ASM_MOV " (%[parent_old]), %[old]\n"
>  		"2: " _ASM_MOV " %[return_hooker], (%[parent_replaced])\n"
>  		"   movl $0, %[faulted]\n"
> +		"3:\n"
>  
>  		".section .fixup, \"ax\"\n"
> -		"3: movl $1, %[faulted]\n"
> +		"4: movl $1, %[faulted]\n"
> +		"   jmp 3b\n"
>  		".previous\n"


It thought after the fixup section, the code would continue to rest of the C code.
Where would it go without the jmp?

Thanks.


> -		_ASM_EXTABLE(1b, 3b)
> -		_ASM_EXTABLE(2b, 3b)
> +		_ASM_EXTABLE(1b, 4b)
> +		_ASM_EXTABLE(2b, 4b)
>  
>  		: [parent_replaced] "=r" (parent), [old] "=r" (old),
>  		  [faulted] "=r" (faulted)
> 

