Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbYAIXQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbYAIXQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYAIXQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:16:34 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:54799 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYAIXQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:16:33 -0500
Date: Thu, 10 Jan 2008 00:16:21 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, tony.luck@intel.com,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       David Wilder <dwilder@us.ibm.com>, jkenisto@us.ibm.com
Subject: Re: [PATCHv4] kprobes: Introduce kprobe_handle_fault()
Message-ID: <20080109231620.GA9002@osiris.ibm.com>
References: <1199737486.7666.12.camel@brick> <18307.64807.204087.375733@cargo.ozlabs.ibm.com> <1199833324.6424.12.camel@brick> <1199852360.6424.39.camel@brick> <20080109061408.GA9486@osiris.ibm.com> <1199859742.6424.44.camel@brick> <1199916062.6424.60.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199916062.6424.60.camel@brick>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  arch/avr32/mm/fault.c   |   21 +--------------------
>  arch/ia64/mm/fault.c    |   24 +-----------------------
>  arch/powerpc/mm/fault.c |   25 +------------------------
>  arch/s390/mm/fault.c    |   25 +------------------------
>  arch/sparc64/mm/fault.c |   23 +----------------------
>  arch/x86/mm/fault_64.c  |   23 ++---------------------
>  include/linux/kprobes.h |   17 +++++++++++++++++
>  7 files changed, 24 insertions(+), 134 deletions(-)

Somehow I think you missed arch/x86/mm/fault_32.c :)

> This uncovered a possible bug in the s390 version as that purely
> copied the x86 version unconditionally passing 14 as the trapnr
> rather than the error_code parameter.

> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 2456b52..a9033cf 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -51,29 +51,6 @@ extern int sysctl_userprocess_debug;
> 
>  extern void die(const char *,struct pt_regs *,long);
> 
> -#ifdef CONFIG_KPROBES
> -static inline int notify_page_fault(struct pt_regs *regs, long err)
> -{
> -	int ret = 0;
> -
> -	/* kprobe_running() needs smp_processor_id() */
> -	if (!user_mode(regs)) {
> -		preempt_disable();
> -		if (kprobe_running() && kprobe_fault_handler(regs, 14))
> -			ret = 1;
> -		preempt_enable();
> -	}
> -
> -	return ret;
> -}
> -#else
> -static inline int notify_page_fault(struct pt_regs *regs, long err)
> -{
> -	return 0;
> -}
> -#endif
> -
> -
>  /*
>   * Unlock any spinlocks which will prevent us from getting the
>   * message out.
> @@ -309,7 +286,7 @@ do_exception(struct pt_regs *regs, unsigned long error_code, int write)
>  	int si_code;
>  	int fault;
> 
> -	if (notify_page_fault(regs, error_code))
> +	if (kprobe_handle_fault(regs, 14))
>  		return;

Uhm.. yes. 14 is HFP-Significance exception. That doesn't make too much
sense. Passing error_code here would be the right thing to do.
Also I just checked with David Wilder: system tap itself doesn't have any
fault handlers. So it should be safe to change this.
