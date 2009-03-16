Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbZCPRn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbZCPRn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbZCPRnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:43:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45408 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017AbZCPRnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:43:17 -0400
Subject: Re: [PATCH] ftrace: protect executing nmi
From: Steven Rostedt <srostedt@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49BE4BF7.6050407@cn.fujitsu.com>
References: <49BE4BF7.6050407@cn.fujitsu.com>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 16 Mar 2009 13:42:52 -0400
Message-Id: <1237225372.3624.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-03-16 at 20:54 +0800, Lai Jiangshan wrote:
> When I review the sensitive code ftrace_nmi_enter(), I found
> the atomic variable nmi_running does protect NMI VS do_ftrace_mod_code(),
> but it can not protects NMI(entered nmi) VS NMI(ftrace_nmi_enter()).
> 
> cpu#1                   | cpu#2                 | cpu#3
> ftrace_nmi_enter()      | do_ftrace_mod_code()  |
>   not modify            |                       |
> ------------------------|-----------------------|--
> executing               | set mod_code_write = 1|
> executing             --|-----------------------|--------------------
> executing               |                       | ftrace_nmi_enter()
> executing               |                       |    do modify
> ------------------------|-----------------------|-----------------
> ftrace_nmi_exit()       |                       |

Very good review!

This race is possible, although very unlikely, but must be fixed
regardless.

> 
> cpu#3 may be being modified the code which is still being executed on cpu#1,
> it will have undefined results and possibly take a GPF, this patch
> prevents it occurred.

Unfortunately your patch does not solve the problem. It only makes the
race window smaller.

> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 1d0d7f4..e016f5e 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -87,7 +87,8 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
>   *
>   * If an NMI is executed, the first thing it does is to call
>   * "ftrace_nmi_enter". This will check if the flag is set to write
> - * and if it is, it will write what is in the IP and "code" buffers.
> + * and if it is, and there is no executing nmi, it will write
> + * what is in the IP and "code" buffers.
>   *
>   * The trick is, it does not matter if everyone is writing the same
>   * content to the code location. Also, if a CPU is executing code
> @@ -96,6 +97,7 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
>   */
>  
>  static atomic_t nmi_running = ATOMIC_INIT(0);
> +static atomic_t nmi_executing = ATOMIC_INIT(0);
>  static int mod_code_status;		/* holds return value of text write */
>  static int mod_code_write;		/* set when NMI should do the write */
>  static void *mod_code_ip;		/* holds the IP to write to */
> @@ -135,14 +137,18 @@ void ftrace_nmi_enter(void)
>  	atomic_inc(&nmi_running);
>  	/* Must have nmi_running seen before reading write flag */
>  	smp_mb();
> -	if (mod_code_write) {
> +	if (!atomic_read(&nmi_executing) && mod_code_write) {
>  		ftrace_mod_code();
>  		atomic_inc(&nmi_update_count);
>  	}

Here we have another race window. If cpu#1 has that NMI and right here
we get a SMI (something to make the race window bigger). cpu#2 could
have set the mod_code_write and cpu#3 could have another NMI that sees
it but does not see the nmi_executing flag. Now we are in the same
scenario as you nicely described up above.

> +	atomic_inc(&nmi_executing);
> +	smp_mb();
>  }
>  
>  void ftrace_nmi_exit(void)
>  {
> +	smp_mb();
> +	atomic_dec(&nmi_executing);
>  	/* Finish all executions before clearing nmi_running */
>  	smp_wmb();
>  	atomic_dec(&nmi_running);
> 


The solution is to connect the mod_code_write with the nmi_enter and
nmi_exit. Make mod_code_write an atomic.

void ftrace_nmi_enter(void)
{	
	if (atomic_inc_return(&mod_code_write) > 10000) {
		ftrace_mod_code();
		atomic_inc(&nmi_update_count);
	}
	smp_mb();
}

void ftrace_nmi_exit(void)
{
	smp_mb();
	atomic_dec(&mod_code_write);
}

Then in do_ftrace_mod_code ...


	while (atomic_cmpxchg(&mod_code_write, 0, 10001) != 0)
		;

	[...]


	while (atomic_cmpxchg(&mode_code_write, 10001, 0) != 10001)
		;


Does this look like it would solve the issue?

-- Steve


