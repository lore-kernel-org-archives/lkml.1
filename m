Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbZBET7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbZBET7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZBET66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:58:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35719 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbZBET65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:58:57 -0500
Date: Thu, 5 Feb 2009 20:58:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Greear <greearb@candelatech.com>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, len.brown@intel.com
Subject: Re: PATCH:  Allow over-ride of smp_found_cfg with kernel cmd-line
	option.
Message-ID: <20090205195832.GD3129@elte.hu>
References: <498B421D.9090609@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B421D.9090609@candelatech.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ben Greear <greearb@candelatech.com> wrote:

> Allow user to keep smp_found_cfg set to 1 even if MADT
> cannot be parsed.  This works around funky BIOS on FWA-7304
> (VIA CN700 chipset) system, and possibly other systems as well.
> Without this override, performance drops by around 15% on
> network throughput tests on this system.
>
> This is based on 2.6.29-rc3
>
> Signed-Off-By:  Ben Greear <greearb@candelatech.com>
>
>
> Thanks,
> Ben
>
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>

> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index d37593c..e96bf19 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -87,6 +87,7 @@ u8 acpi_sci_flags __initdata;
>  int acpi_sci_override_gsi __initdata;
>  int acpi_skip_timer_override __initdata;
>  int acpi_use_timer_override __initdata;
> +int force_smp_found_cfg __initdata;
>  
>  #ifdef CONFIG_X86_LOCAL_APIC
>  static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
> @@ -1335,6 +1336,14 @@ static void __init early_acpi_process_madt(void)
>  #endif
>  }
>  
> +static int __init parse_force_smp_found_cfg(char *arg)
> +{
> +	force_smp_found_cfg = 1;
> +	return 0;
> +}
> +early_param("force_smp_found_cfg", parse_force_smp_found_cfg);
> +
> +
>  static void __init acpi_process_madt(void)
>  {
>  #ifdef CONFIG_X86_LOCAL_APIC
> @@ -1381,9 +1390,14 @@ static void __init acpi_process_madt(void)
>   		 * Boot with "acpi=off" to use MPS on such a system.
>   		 */
>  		if (smp_found_config) {
> -			printk(KERN_WARNING PREFIX
> -				"No APIC-table, disabling MPS\n");
> -			smp_found_config = 0;
> +			if (force_smp_found_cfg)
> +				printk(KERN_WARNING PREFIX
> +				       "No APIC-table, wanted to disable MPS, but will not\n  due to force_smp_found_cfg=1\n");
> +			else {
> +				printk(KERN_WARNING PREFIX
> +				       "No APIC-table, disabling MPS.  Use force_smp_found_cfg=1 to override\n");
> +				smp_found_config = 0;
> +			}
>  		}
>  	}
>  

I'd _much_ rather have a warning message printed and have a default, 
unconditional fallback to mptable parsing in this case.

I.e. same end result just no ugly and inconvenient force_smp_found_cfg.

The mptable works fine in most such cases to enumerate apic details. (as it 
does in your case, evidently)

And if both the ACPI and the MPTABLE is hosed on a box, it cannot be of much 
use on other OSs either, right?

So please do a patch that removes the 'smp_found_config' and which changes 
the warning message to warn about no ACPI table in the MADT table. Ok?

	Ingo
