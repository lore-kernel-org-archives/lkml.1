Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab0CDQWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:22:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab0CDQWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:22:01 -0500
Message-ID: <4B8FDE16.3050403@redhat.com>
Date: Thu, 04 Mar 2010 11:21:42 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 09/14] perf, x86: use LBR for PEBS IP+1 fixup
References: <20100304140046.596569763@chello.nl> <20100304140100.619375431@chello.nl>
In-Reply-To: <20100304140100.619375431@chello.nl>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> PEBS always reports the IP+1, that is the instruction after the one
> that got sampled, cure this by using the LBR to reliably rewind the
> instruction stream.
> 
> CC: Masami Hiramatsu <mhiramat@redhat.com>
> CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---
>  arch/x86/include/asm/perf_event.h         |   19 ++++++
>  arch/x86/kernel/cpu/perf_event.c          |   70 ++++++++++++-------------
>  arch/x86/kernel/cpu/perf_event_intel.c    |    4 -
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |   84 +++++++++++++++++++++++++++++-
>  include/linux/perf_event.h                |    6 ++
>  5 files changed, 144 insertions(+), 39 deletions(-)
> 
[...]
> Index: linux-2.6/arch/x86/include/asm/perf_event.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/perf_event.h
> +++ linux-2.6/arch/x86/include/asm/perf_event.h
> @@ -136,6 +136,25 @@ extern void perf_events_lapic_init(void)
>  
>  #define PERF_EVENT_INDEX_OFFSET			0
>  
> +/*
> + * Abuse bit 3 of the cpu eflags register to indicate proper PEBS IP fixups.
> + * This flag is otherwise unused and ABI specified to be 0, so nobody should
> + * care what we do with it.
> + */
> +#define PERF_EFLAGS_EXACT	(1UL << 3)
 > +
> +#define perf_misc_flags(regs)				\
> +({	int misc = 0;					\
> +	if (user_mode(regs))				\
> +		misc |= PERF_RECORD_MISC_USER;		\
> +	else						\
> +		misc |= PERF_RECORD_MISC_KERNEL;	\
> +	if (regs->flags & PERF_EFLAGS_EXACT)		\
> +		misc |= PERF_RECORD_MISC_EXACT;		\
> +	misc; })
> +
> +#define perf_instruction_pointer(regs)	((regs)->ip)

Hmm, why don't you use instruction_pointer() defined in asm/ptrace.h?
And I couldn't find any user of this macro in this patch...

Others looks good to me :)

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
