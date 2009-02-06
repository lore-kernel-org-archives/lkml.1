Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZBFGIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZBFGIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZBFGID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:08:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55216 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZBFGIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:08:01 -0500
Date: Fri, 6 Feb 2009 01:07:59 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michael Neuling <mikey@neuling.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] powerpc, ftrace: fix compile error when modules not
 configured
In-Reply-To: <20090206060527.369616736@goodmis.org>
Message-ID: <alpine.DEB.1.10.0902060107350.5262@gandalf.stny.rr.com>
References: <20090206060328.181057235@goodmis.org> <20090206060527.369616736@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ forgot to add linuxppc ]


On Fri, 6 Feb 2009, Steven Rostedt wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Michael Neuling reported a compile bug when dynamic ftrace was
> configured in and modules were not. This was due to the ftrace
> code referencing module specific structures.
> 
> Reported-by: Michael Neuling <mikey@neuling.org>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/powerpc/kernel/ftrace.c |   16 +++++++++++++++-
>  1 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
> index a913f91..88c641d 100644
> --- a/arch/powerpc/kernel/ftrace.c
> +++ b/arch/powerpc/kernel/ftrace.c
> @@ -113,6 +113,8 @@ static int test_24bit_addr(unsigned long ip, unsigned long addr)
>  	return create_branch((unsigned int *)ip, addr, 0);
>  }
>  
> +#ifdef CONFIG_MODULES
> +
>  static int is_bl_op(unsigned int op)
>  {
>  	return (op & 0xfc000003) == 0x48000001;
> @@ -323,6 +325,7 @@ __ftrace_make_nop(struct module *mod,
>  	return 0;
>  }
>  #endif /* PPC64 */
> +#endif /* CONFIG_MODULES */
>  
>  int ftrace_make_nop(struct module *mod,
>  		    struct dyn_ftrace *rec, unsigned long addr)
> @@ -342,6 +345,7 @@ int ftrace_make_nop(struct module *mod,
>  		return ftrace_modify_code(ip, old, new);
>  	}
>  
> +#ifdef CONFIG_MODULES
>  	/*
>  	 * Out of range jumps are called from modules.
>  	 * We should either already have a pointer to the module
> @@ -366,9 +370,13 @@ int ftrace_make_nop(struct module *mod,
>  		mod = rec->arch.mod;
>  
>  	return __ftrace_make_nop(mod, rec, addr);
> -
> +#else
> +	/* We should not get here without modules */
> +	return -EINVAL;
> +#endif /* CONFIG_MODULES */
>  }
>  
> +#ifdef CONFIG_MODULES
>  #ifdef CONFIG_PPC64
>  static int
>  __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
> @@ -457,6 +465,7 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
>  	return 0;
>  }
>  #endif /* CONFIG_PPC64 */
> +#endif /* CONFIG_MODULES */
>  
>  int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
>  {
> @@ -475,6 +484,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
>  		return ftrace_modify_code(ip, old, new);
>  	}
>  
> +#ifdef CONFIG_MODULES
>  	/*
>  	 * Out of range jumps are called from modules.
>  	 * Being that we are converting from nop, it had better
> @@ -486,6 +496,10 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
>  	}
>  
>  	return __ftrace_make_call(rec, addr);
> +#else
> +	/* We should not get here without modules */
> +	return -EINVAL;
> +#endif /* CONFIG_MODULES */
>  }
>  
>  int ftrace_update_ftrace_func(ftrace_func_t func)
> -- 
> 1.5.6.5
> 
> -- 
> 
> 
