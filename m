Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbZBVRvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbZBVRvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbZBVRvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:51:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51657 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZBVRvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:51:37 -0500
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for conversions
From: Andi Kleen <andi@firstfloor.org>
References: <20090220011316.379904625@goodmis.org>
	<20090220011521.003556651@goodmis.org>
Date: Sun, 22 Feb 2009 18:50:00 +0100
In-Reply-To: <20090220011521.003556651@goodmis.org> (Steven Rostedt's message of "Thu, 19 Feb 2009 20:13:20 -0500")
Message-ID: <87y6vyuzsn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> From: Steven Rostedt <srostedt@redhat.com>
>
> Impact: keep kernel text read only
>
> Because dynamic ftrace converts the calls to mcount into and out of
> nops at run time, we needed to always keep the kernel text writable.
>
> But this defeats the point of CONFIG_DEBUG_RODATA. This patch converts
> the kernel code to writable before ftrace modifies the text, and converts
> it back to read only afterward.
>
> The conversion is done via stop_machine and no IPIs may be executed
> at that time. The kernel text is set to write just before calling
> stop_machine and set to read only again right afterward.

The very old text poke code I had for this just used a dynamic
mapping elsewhere instead to modify the code. That's much less
intrusive than changing the complete mappings. Any reason you can't use 
that too?

-Andi

>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/x86/include/asm/ftrace.h |   10 ++++++++++
>  arch/x86/kernel/ftrace.c      |   20 ++++++++++++++++++++
>  arch/x86/mm/init_32.c         |   27 ++++++++++++++++++++++++---
>  arch/x86/mm/init_64.c         |   29 ++++++++++++++++++++++++-----
>  4 files changed, 78 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index b55b4a7..5564cf3 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -80,4 +80,14 @@ extern void return_to_handler(void);
>  #endif /* __ASSEMBLY__ */
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>  
> +#ifndef __ASSEMBLY__
> +#ifdef CONFIG_DEBUG_RODATA
> +void set_kernel_text_rw(void);
> +void set_kernel_text_ro(void);
> +#else
> +static inline void set_kernel_text_rw(void) { }
> +static inline void set_kernel_text_ro(void) { }
> +#endif
> +#endif /* __ASSEMBLY__ */
> +

-- 
ak@linux.intel.com -- Speaking for myself only.
