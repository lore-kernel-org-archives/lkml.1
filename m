Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbZIIB1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbZIIB1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZIIB1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:27:50 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56663 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZIIB1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:27:49 -0400
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <4AA70198.9070500@cn.fujitsu.com> <4AA701B3.704@cn.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 08 Sep 2009 18:27:46 -0700
In-Reply-To: <4AA701B3.704@cn.fujitsu.com> (Li Zefan's message of "Wed\, 09 Sep 2009 09\:15\:31 +0800")
Message-ID: <m1pra0hppp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Li Zefan <lizf@cn.fujitsu.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_Sft_Brands_C00 XM_Sft_Brands_C00
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 2/2] tracing/events: Add kexec tracepoints
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan <lizf@cn.fujitsu.com> writes:

> When panic, save in ring buffer the time when crash happened,
> the panic message, etc. And the data can be retrieved from
> core dump file using flight-recorder, which is going to be a
> module of the crash utility.
>
> Also if we implement flight-recorder in perf tool, those trace
> outputs can be used by perf tool.

Please let's keep dynamic code out of crash_kexec if we can.

If this is just about timestamsp I don't see the point.

Eric



> ---
>  include/trace/events/kexec.h |   51 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/kexec.c               |    4 +++
>  kernel/panic.c               |    4 +++
>  3 files changed, 59 insertions(+), 0 deletions(-)
>  create mode 100644 include/trace/events/kexec.h
>
> diff --git a/include/trace/events/kexec.h b/include/trace/events/kexec.h
> new file mode 100644
> index 0000000..c1d740a
> --- /dev/null
> +++ b/include/trace/events/kexec.h
> @@ -0,0 +1,51 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM kexec
> +
> +#if !defined(_TRACE_KEXEC_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_KEXEC_H
> +
> +#include <linux/kexec.h>
> +#include <linux/tracepoint.h>
> +
> +TRACE_EVENT(panic,
> +
> +	TP_PROTO(const char *msg),
> +
> +	TP_ARGS(msg),
> +
> +	TP_STRUCT__entry(
> +		__string(	msg,	msg	)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(msg, msg);
> +	),
> +
> +	TP_printk("%s", __get_str(msg))
> +);
> +
> +TRACE_EVENT(crash_kexec,
> +
> +	TP_PROTO(struct kimage *image, struct pt_regs *regs),
> +
> +	TP_ARGS(image, regs),
> +
> +	TP_STRUCT__entry(
> +		__field(	void *,	image	)
> +		__field(	void *, ip	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->image	= image;
> +		__entry->ip	= regs ?
> +			(void *)instruction_pointer(regs) : NULL;
> +	),
> +
> +	TP_printk("image=%p, ip=%p", __entry->image, __entry->ip)
> +);
> +
> +#endif /* _TRACE_KEXEC_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> +
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index f336e21..3d7eda7 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -38,6 +38,8 @@
>  #include <asm/system.h>
>  #include <asm/sections.h>
>  
> +#include <trace/events/kexec.h>
> +
>  /* Per cpu memory for storing cpu states in case of system crash. */
>  note_buf_t* crash_notes;
>  
> @@ -1073,6 +1075,8 @@ void crash_kexec(struct pt_regs *regs)
>  	if (mutex_trylock(&kexec_mutex)) {
>  		if (kexec_crash_image) {
>  			struct pt_regs fixed_regs;
> +
> +			trace_crash_kexec(kexec_crash_image, regs);
>  			crash_setup_regs(&fixed_regs, regs);
>  			crash_save_vmcoreinfo();
>  			machine_crash_shutdown(&fixed_regs);
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 22ec502..c3baa23 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -23,6 +23,9 @@
>  #include <linux/nmi.h>
>  #include <linux/dmi.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/kexec.h>
> +
>  int panic_on_oops;
>  static unsigned long tainted_mask;
>  static int pause_on_oops;
> @@ -69,6 +72,7 @@ NORET_TYPE void panic(const char * fmt, ...)
>  	va_start(args, fmt);
>  	vsnprintf(buf, sizeof(buf), fmt, args);
>  	va_end(args);
> +	trace_panic(buf);
>  	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
>  #ifdef CONFIG_DEBUG_BUGVERBOSE
>  	dump_stack();
> -- 
> 1.6.3
