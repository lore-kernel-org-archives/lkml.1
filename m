Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0BSIpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 03:45:32 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:55665 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab0BSIpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 03:45:30 -0500
Date: Fri, 19 Feb 2010 14:15:23 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Michael Stefaniuc <mstefani@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] hw-breakpoint: Keep track of dr7 local enable bits
Message-ID: <20100219084523.GA3525@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <4B7881AC.5070209@redhat.com> <1266516001-7753-3-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266516001-7753-3-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 07:00:01PM +0100, Frederic Weisbecker wrote:
> When the user enables breakpoints through dr7, he can choose
> between "local" or "global" enable bits but given how linux is
> implemented, both have the same effect.
> 
> That said we don't keep track how the user enabled the breakpoints
> so when the user requests the dr7 value, we only translate the
> "enabled" status using the global enabled bits. It means that if
> the user enabled a breakpoint using the local enabled bit, reading
> back dr7 will set the global bit and clear the local one.
> 
> Apps like Wine expect a full dr7 POKEUSER/PEEKUSER match for emulated
> softwares that implement old reverse engineering protection schemes.
> 
> We fix that by keeping track of the whole dr7 value given by the user
> in the thread structure to drop this bug. We'll think about
> something more proper later.
> 
> This fixes a 2.6.32 - 2.6.33-x ptrace regression.
> 
> Reported-by: Michael Stefaniuc <mstefani@redhat.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: K.Prasad <prasad@linux.vnet.ibm.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Maneesh Soni <maneesh@linux.vnet.ibm.com>
> Cc: Alexandre Julliard <julliard@winehq.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
> ---
>  arch/x86/include/asm/processor.h |    2 ++
>  arch/x86/kernel/ptrace.c         |    7 +++++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index fc801ba..b753ea5 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -450,6 +450,8 @@ struct thread_struct {
>  	struct perf_event	*ptrace_bps[HBP_NUM];
>  	/* Debug status used for traps, single steps, etc... */
>  	unsigned long           debugreg6;
> +	/* Keep track of the exact dr7 value set by the user */
> +	unsigned long           ptrace_dr7;
>  	/* Fault info: */
>  	unsigned long		cr2;
>  	unsigned long		trap_no;
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index 017d937..0c1033d 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -702,7 +702,7 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
>  	} else if (n == 6) {
>  		val = thread->debugreg6;
>  	 } else if (n == 7) {
> -		val = ptrace_get_dr7(thread->ptrace_bps);
> +		val = thread->ptrace_dr7;
>  	}
>  	return val;
>  }
> @@ -778,8 +778,11 @@ int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
>  			return rc;
>  	}
>  	/* All that's left is DR7 */
> -	if (n == 7)
> +	if (n == 7) {
>  		rc = ptrace_write_dr7(tsk, val);
> +		if (!rc)
> +			thread->ptrace_dr7 = val;
> +	}
> 
>  ret_path:
>  	return rc;


So, the thread's copy of DR7 (in thread->ptrace_dr7) stores the
requested data even if the 'write' onto DR7 i.e. ptrace_write_dr7()
failed. This can be the other way round i.e. populate the thread's copy
of DR7 only if the write was successful.

I think it will be in consonance with the v2.6.32 behaviour as well. For
instance, in the code snippet from ptrace_set_debugreg() in v2.6.32
below:
                for (i = 0; i < 4; i++)
                        if ((DR7_MASK >> ((data >> (16 + 4*i)) & 0xf)) & 1)
                                return -EIO;
                child->thread.debugreg7 = data;

The thread's copy of DR7 is populated only if the incoming data is
found to be valid.

Thanks,
K.Prasad




