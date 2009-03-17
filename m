Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbZCQOk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbZCQOk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 10:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbZCQOkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 10:40:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZCQOkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 10:40:00 -0400
Subject: Re: [PATCH 2/2] ftrace: fast path for do_ftrace_mod_code()
From: Steven Rostedt <srostedt@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49BF9E69.80908@cn.fujitsu.com>
References: <49BE4BF7.6050407@cn.fujitsu.com>
	 <1237225372.3624.15.camel@localhost.localdomain>
	 <49BF9D8A.4070200@cn.fujitsu.com>  <49BF9E69.80908@cn.fujitsu.com>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 17 Mar 2009 10:39:37 -0400
Message-Id: <1237300777.3624.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-03-17 at 20:58 +0800, Lai Jiangshan wrote:
> Lai Jiangshan wrote:
> > 
> > Subject: [PATCH 1/2] ftrace: protect running nmi (V2)
> > 
> 
> 
> Subject: [PATCH 2/2] ftrace: fast path for do_ftrace_mod_code()
> 
> commit 90c7ac49aa819feb9433b5310089fca6399881c0
> adds a fast path to prevent NMI lockup.
> 
> But the previous patch "protect executing nmi" changes
> do_ftrace_mod_code()'s implementation, we still need fix to
> prevent NMI lockup by adding a fast path.
> 
> A difference between this fix and 90c7ac49aa819feb9433b5310089fca6399881c0
> is that: We kill any new writers in spite of probe_kernel_write()
> success or fail, not only when probe_kernel_write() fail.
> (When probe_kernel_write() success, new writers do not need to do
> it again.)

I'm a bit nervous about this code. We do not get much benefit from it,
because the NMI case is an anomaly, and is not a fast path anyway. This
code only happens when we are running the stop_machine, and this adds
added complexity for little benefit.

The original patch was to prevent an actual live lock I got in one of my
tests. The problem was that the failure of the write caused a printk
stack dump. But the time it took the print to go out over the serial was
long enough that the next NMI triggered when it finished. The new NMI
hit the same error and did another print. Thus, all I got was a lot of
prints out over the serial, but the system was dead.

I like the first patch. but you remove the protection there. It should
have been in this patch. But it should have still added the
functionality of the previous method.

> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 699a1c0..61cb520 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -98,6 +98,7 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
>  #define MOD_CODE_WRITE_FLAG (1 << 31)	/* set when NMI should do the write */
>  static atomic_t nmi_running = ATOMIC_INIT(0);
>  static int mod_code_status;		/* holds return value of text write */
> +static int mod_code_no_write = 1;	/* set when NMI not need do the write */
>  static void *mod_code_ip;		/* holds the IP to write to */
>  static void *mod_code_newcode;		/* holds the text to write to the IP */
>  
> @@ -124,14 +125,19 @@ static void ftrace_mod_code(void)
>  	 */
>  	mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
>  					     MCOUNT_INSN_SIZE);
> +
> +	smb_wmb();

I still rather have this only set when mod_code_status fails.

> +	mod_code_no_write = 1;
>  }
>  
>  void ftrace_nmi_enter(void)
>  {
>  	if (atomic_inc_return(&nmi_running) & MOD_CODE_WRITE_FLAG) {
>  		smp_rmb();
> -		ftrace_mod_code();
> -		atomic_inc(&nmi_update_count);
> +		if (!mod_code_no_write) {
> +			ftrace_mod_code();
> +			atomic_inc(&nmi_update_count);
> +		}
>  	}
>  	/* Must have previous changes seen before executions */
>  	smp_mb();
> @@ -161,6 +167,7 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
>  {
>  	mod_code_ip = (void *)ip;
>  	mod_code_newcode = new_code;
> +	mod_code_no_write = 0;

Here's another issue, if mod_code_status failed, we do not want to have
mod_code_no_write become zero again. The logic may indeed prevent this,
but I rather have the logic be straight forward, and just set this to
one when we have a failure and forget about it. Yes, it is a bit more
expensive, but it makes the code clearer.

-- Steve

>  
>  	/*
>  	 * The previous variables need to be visible before NMIs sees
> @@ -173,7 +180,8 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
>  	/* Make sure all running NMIs have finished before we write the code */
>  	smp_mb();
>  
> -	ftrace_mod_code();
> +	if (!mod_code_no_write)
> +		ftrace_mod_code();
>  
>  	/* Make sure the write happens before clearing the bit */
>  	smp_mb();
> 
> 
> 

