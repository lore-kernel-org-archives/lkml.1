Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYBQN5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYBQN5A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758281AbYBQN4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:56:47 -0500
Received: from www.tglx.de ([62.245.132.106]:50003 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758242AbYBQN4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:56:46 -0500
Date: Sun, 17 Feb 2008 14:56:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix compile warning building without
 CONFIG_SYSCTL
In-Reply-To: <47A56FEE.9000900@cn.fujitsu.com>
Message-ID: <alpine.LFD.1.00.0802171456070.7583@apollo.tec.linutronix.de>
References: <47A55CA4.9090804@cn.fujitsu.com> <20080203071251.GB19020@elte.hu> <47A56DDA.9000907@cn.fujitsu.com> <47A56FEE.9000900@cn.fujitsu.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Feb 2008, Li Zefan wrote:

> building without CONFIG_SYSCTL:
> 
> arch/x86/kernel/nmi_64.c:50: warning: 'unknown_nmi_panic_callback' declared 'static' but never defined
> 
> This patch also fixes nmi_32.c
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Applied. Thanks,

	 tglx

> ---
>  arch/x86/kernel/nmi_32.c |   21 +++++++++------------
>  arch/x86/kernel/nmi_64.c |   21 +++++++++------------
>  2 files changed, 18 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
> index edd4136..6a0aa70 100644
> --- a/arch/x86/kernel/nmi_32.c
> +++ b/arch/x86/kernel/nmi_32.c
> @@ -46,9 +46,6 @@ static unsigned int nmi_hz = HZ;
>  
>  static DEFINE_PER_CPU(short, wd_enabled);
>  
> -/* local prototypes */
> -static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
> -
>  static int endflag __initdata = 0;
>  
>  #ifdef CONFIG_SMP
> @@ -391,15 +388,6 @@ __kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
>  	return rc;
>  }
>  
> -int do_nmi_callback(struct pt_regs * regs, int cpu)
> -{
> -#ifdef CONFIG_SYSCTL
> -	if (unknown_nmi_panic)
> -		return unknown_nmi_panic_callback(regs, cpu);
> -#endif
> -	return 0;
> -}
> -
>  #ifdef CONFIG_SYSCTL
>  
>  static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
> @@ -453,6 +441,15 @@ int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
>  
>  #endif
>  
> +int do_nmi_callback(struct pt_regs *regs, int cpu)
> +{
> +#ifdef CONFIG_SYSCTL
> +	if (unknown_nmi_panic)
> +		return unknown_nmi_panic_callback(regs, cpu);
> +#endif
> +	return 0;
> +}
> +
>  void __trigger_all_cpu_backtrace(void)
>  {
>  	int i;
> diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
> index fb99484..9a4fde7 100644
> --- a/arch/x86/kernel/nmi_64.c
> +++ b/arch/x86/kernel/nmi_64.c
> @@ -46,9 +46,6 @@ static unsigned int nmi_hz = HZ;
>  
>  static DEFINE_PER_CPU(short, wd_enabled);
>  
> -/* local prototypes */
> -static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
> -
>  /* Run after command line and cpu_init init, but before all other checks */
>  void nmi_watchdog_default(void)
>  {
> @@ -394,15 +391,6 @@ asmlinkage __kprobes void do_nmi(struct pt_regs * regs, long error_code)
>  	nmi_exit();
>  }
>  
> -int do_nmi_callback(struct pt_regs * regs, int cpu)
> -{
> -#ifdef CONFIG_SYSCTL
> -	if (unknown_nmi_panic)
> -		return unknown_nmi_panic_callback(regs, cpu);
> -#endif
> -	return 0;
> -}
> -
>  void stop_nmi(void)
>  {
>  	acpi_nmi_disable();
> @@ -464,6 +452,15 @@ int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
>  
>  #endif
>  
> +int do_nmi_callback(struct pt_regs *regs, int cpu)
> +{
> +#ifdef CONFIG_SYSCTL
> +	if (unknown_nmi_panic)
> +		return unknown_nmi_panic_callback(regs, cpu);
> +#endif
> +	return 0;
> +}
> +
>  void __trigger_all_cpu_backtrace(void)
>  {
>  	int i;
> -- 
> 1.5.4.rc3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
