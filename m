Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbYJVT3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbYJVT3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYJVT3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:29:32 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39538 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbYJVT3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:29:31 -0400
Message-ID: <48FF7F14.8070007@jeffhansen.com>
Date: Wed, 22 Oct 2008 13:29:24 -0600
From: Jeff Hansen <x@jeffhansen.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081013)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Chris Snook <csnook@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
References: <1224552902.2640.88.camel@alok-dev1>	 <48FD6EDC.5010801@redhat.com> <1224703586.13953.12.camel@alok-dev1>
In-Reply-To: <1224703586.13953.12.camel@alok-dev1>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 68.178.9.66
X-SA-Exim-Rcpt-To: akataria@vmware.com, csnook@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org, dhecht@vmware.com
X-SA-Exim-Mail-From: x@jeffhansen.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;akataria@vmware.com
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0156]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok,

No objections.  Looks good to me.

-Jeff

Alok Kataria wrote:
> Jeff, i have kept your Signed-off-by with this slightly modified patch,
> incase you have any objections to that please let me know.
>
> --
> [X86] Skip verification by the watchdog for TSC clocksource.
>
> From: Alok N Kataria <akataria@vmware.com>
>
> This is achieved by resetting the CLOCKSOURCE_MUST_VERIFY flag.
>
> We add a tsc=reliable commandline option to enable this.
> This enables legacy hardware without HPET, LAPIC, or ACPI timers
> to enter high-resolution timer mode.
>
> Along with that have extended this to be used in virtualization
> environment, just for VMware as yet. This is important since there
> is a wrap-around problem with the acpi_pm timer.
> The acpi_pm counter is just 24bits and this can overflow in 4 seconds.
> With the NO_HZ kernels in virtualized environment, there can be situations
> when the guest is descheduled for longer duration, as a result we may miss
> the wrap of the acpi counter. When TSC is used as a clocksource and acpi_pm
> timer is being used as the watchdog clocksource this error in acpi_pm
> results in TSC being marked as unstable, and essentially results in time
> dropping in chunks of 4 seconds whenever this wrap is missed. Since the
> virtualized TSC is reliable on VMware, we should always use the TSCs
> clocksource on VMware, so we skip the verfication at runtime.
>
> Since we reset the flag for mgeode systems too, i have combined
> the mgeode case with the check for VMware.
>
> Signed-off-by: Jeff Hansen <jhansen@cardaccess-inc.com>
> Signed-off-by: Alok N Kataria <akataria@vmware.com>
> Cc: Chris Snook <csnook@redhat.com>
> ---
>
>  Documentation/kernel-parameters.txt |    7 +++++++
>  arch/x86/kernel/tsc.c               |   33 +++++++++++++++++++++------------
>  2 files changed, 28 insertions(+), 12 deletions(-)
>
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index e82c5bc..c5eb028 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2230,6 +2230,13 @@ and is between 256 and 4096 characters. It is defined in the file
>  			Format:
>  			<io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>
>  
> +	tsc=		Disable clocksource-must-verify flag for TSC.
> +			Format: <string>
> +			[x86] reliable: mark tsc clocksource as reliable, this
> +			disables clocksource verification at runtime.
> +			Used to enable high-resolution timer mode on older
> +			hardware, and in virtualized environment.
> +
>  	turbografx.map[2|3]=	[HW,JOY]
>  			TurboGraFX parallel port interface
>  			Format:
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 4ae207c..24eff09 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -32,6 +32,7 @@ static int tsc_unstable;
>     erroneous rdtsc usage on !cpu_has_tsc processors */
>  static int tsc_disabled = -1;
>  
> +static int tsc_clocksource_reliable;
>  /*
>   * Scheduler clock - returns current time in nanosec units.
>   */
> @@ -99,6 +100,15 @@ int __init notsc_setup(char *str)
>  
>  __setup("notsc", notsc_setup);
>  
> +static int __init tsc_setup(char *str)
> +{
> +	if (!strcmp(str, "reliable"))
> +		tsc_clocksource_reliable = 1;
> +	return 1;
> +}
> +
> +__setup("tsc=", tsc_setup);
> +
>  #define MAX_RETRIES     5
>  #define SMI_TRESHOLD    50000
>  
> @@ -745,24 +755,21 @@ static struct dmi_system_id __initdata bad_tsc_dmi_table[] = {
>  	{}
>  };
>  
> -/*
> - * Geode_LX - the OLPC CPU has a possibly a very reliable TSC
> - */
> +static void __init check_system_tsc_reliable(void)
> +{
>  #ifdef CONFIG_MGEODE_LX
> -/* RTSC counts during suspend */
> +	/* RTSC counts during suspend */
>  #define RTSC_SUSP 0x100
> -
> -static void __init check_geode_tsc_reliable(void)
> -{
>  	unsigned long res_low, res_high;
>  
>  	rdmsr_safe(MSR_GEODE_BUSCONT_CONF0, &res_low, &res_high);
> +	/* Geode_LX - the OLPC CPU has a possibly a very reliable TSC */
>  	if (res_low & RTSC_SUSP)
> -		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
> -}
> -#else
> -static inline void check_geode_tsc_reliable(void) { }
> +		tsc_clocksource_reliable = 1;
>  #endif
> +	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
> +		tsc_clocksource_reliable = 1;
> +}
>  
>  /*
>   * Make an educated guess if the TSC is trustworthy and synchronized
> @@ -797,6 +804,8 @@ static void __init init_tsc_clocksource(void)
>  {
>  	clocksource_tsc.mult = clocksource_khz2mult(tsc_khz,
>  			clocksource_tsc.shift);
> +	if (tsc_clocksource_reliable)
> +		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
>  	/* lower the rating if we already know its unstable: */
>  	if (check_tsc_unstable()) {
>  		clocksource_tsc.rating = 0;
> @@ -857,7 +866,7 @@ void __init tsc_init(void)
>  	if (unsynchronized_tsc())
>  		mark_tsc_unstable("TSCs unsynchronized");
>  
> -	check_geode_tsc_reliable();
> +	check_system_tsc_reliable();
>  	init_tsc_clocksource();
>  }
>  
>
>
>   


-- 
---------------------------------------------------
"If someone's gotta do it, it might as well be me."
                x@jeffhansen.com

