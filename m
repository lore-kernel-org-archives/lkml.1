Return-Path: <linux-kernel-owner+w=401wt.eu-S1763931AbZFNVtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763931AbZFNVtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 17:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761086AbZFNVtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 17:49:00 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:49192 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761821AbZFNVs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 17:48:59 -0400
Subject: Re: apic: native_apic_write_dummy warning
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20090614200620.GB24604@lenovo>
References: <1245006351.5912.174.camel@odie.local>
	 <20090614192220.GB4851@lenovo> <20090614194017.GA24604@lenovo>
	 <20090614200620.GB24604@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Jun 2009 23:50:16 +0200
Message-Id: <1245016216.5890.10.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

man, 15 06 2009 kl. 00:06 +0400, skrev Cyrill Gorcunov:
> [Cyrill Gorcunov - Sun, Jun 14, 2009 at 11:40:17PM +0400]
> ... 
> | Neither thermal interrupts nor mce will be functional if apic
> | is not properly set up (even having kernel compiled that way
> | it support both). So you may try to pass "lapic" boot option
> | and check if we're lucky in attempt to enable apic via force
> | push. Anyway this warn show that the code is to be fixed
> | (and native_apic_write_dummy done its work great catching
> |  useless apic->write operation). I'll handle it but a bit later.
> | 
> | Andi CC'ed since he is involved in MCE handling just for the
> | record.
> | 
> | 	-- Cyrill
> 
> Simon here is a patch I would appreciate if you test.

That was quick work :) No warning with the patch (or lapic).

> ---
> [PATCH -tip] x86: mce intel -- don't touch THERMAL_APIC_VECTOR if no active APIC
> 
> If APIC was disabled for some reason and not even mapped
> we should not try to enable thermal interrupts at all.
> 
> Reported-by: Simon Holm Thøgersen <odie@cs.aau.dk>

Tested-by: Simon Holm Thøgersen <odie@cs.aau.dk>

> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_intel.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/cpu/mcheck/mce_intel.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/mcheck/mce_intel.c
> @@ -21,9 +21,15 @@ void intel_init_thermal(struct cpuinfo_x
>  	int tm2 = 0;
>  	u32 l, h;
>  
> -	/* Thermal monitoring depends on ACPI and clock modulation*/
> -	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
> +	/*
> +	 * Thermal monitoring depends on ACPI, clock modulation
> +	 * and APIC as well
> +	 */
> +	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC) ||
> +		!cpu_has(c, X86_FEATURE_APIC)) {
> +		pr_debug("Thermal monitoring disabled\n");
>  		return;
> +	}
>  
>  	/*
>  	 * First check if its enabled already, in which case there might
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

