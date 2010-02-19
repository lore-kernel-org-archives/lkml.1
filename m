Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab0BSIv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 03:51:57 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:56526 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab0BSIvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 03:51:55 -0500
Date: Fri, 19 Feb 2010 14:21:50 +0530
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
Subject: Re: [PATCH 1/2] hw-breakpoints: Accept breakpoints on NULL address
Message-ID: <20100219085150.GB3525@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <4B7881AC.5070209@redhat.com> <1266516001-7753-2-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266516001-7753-2-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 07:00:00PM +0100, Frederic Weisbecker wrote:
> Before we had a generic breakpoint API, ptrace was accepting
> breakpoints on NULL address in x86. The new API refuse them,
> without given strong reasons. We need to follow the previous
> behaviour as some userspace apps like Wine need such NULL
> breakpoints to ensure old emulated software protections
> are still working.
> 
> This fixes a 2.6.32 - 2.6.33-x ptrace regression.
> 
> Reported-by: Michael Stefaniuc <mstefani@redhat.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: K.Prasad <prasad@linux.vnet.ibm.com>

Acked-by: K.Prasad <prasad@linux.vnet.ibm.com>

> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Maneesh Soni <maneesh@linux.vnet.ibm.com>
> Cc: Alexandre Julliard <julliard@winehq.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
> ---
>  arch/x86/kernel/hw_breakpoint.c |   30 +++++++-----------------------
>  1 files changed, 7 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> index 05d5fec..bb6006e 100644
> --- a/arch/x86/kernel/hw_breakpoint.c
> +++ b/arch/x86/kernel/hw_breakpoint.c
> @@ -212,25 +212,6 @@ static int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
>  	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
>  }
> 
> -/*
> - * Store a breakpoint's encoded address, length, and type.
> - */
> -static int arch_store_info(struct perf_event *bp)
> -{
> -	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> -	/*
> -	 * For kernel-addresses, either the address or symbol name can be
> -	 * specified.
> -	 */
> -	if (info->name)
> -		info->address = (unsigned long)
> -				kallsyms_lookup_name(info->name);
> -	if (info->address)
> -		return 0;
> -
> -	return -EINVAL;
> -}
> -
>  int arch_bp_generic_fields(int x86_len, int x86_type,
>  			   int *gen_len, int *gen_type)
>  {
> @@ -362,10 +343,13 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp,
>  		return ret;
>  	}
> 
> -	ret = arch_store_info(bp);
> -
> -	if (ret < 0)
> -		return ret;
> +	/*
> +	 * For kernel-addresses, either the address or symbol name can be
> +	 * specified.
> +	 */
> +	if (info->name)
> +		info->address = (unsigned long)
> +				kallsyms_lookup_name(info->name);
>  	/*
>  	 * Check that the low-order bits of the address are appropriate
>  	 * for the alignment implied by len.
> -- 
> 1.6.2.3
> 
