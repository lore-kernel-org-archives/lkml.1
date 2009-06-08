Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZFHSgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZFHSgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZFHSgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:36:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbZFHSgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:36:02 -0400
Date: Mon, 8 Jun 2009 11:35:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harald Welte <HaraldWelte@viatech.com>
cc: "Michael S. Zick" <lkml@morethan.org>, Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for VIA/Centaur
 CPUs
In-Reply-To: <20090608102754.GP4106@prithivi.gnumonks.org>
Message-ID: <alpine.LFD.2.01.0906081128410.6847@localhost.localdomain>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090606132847.GB14088@prithivi.gnumonks.org> <200906060846.36303.lkml@morethan.org> <200906060856.15016.lkml@morethan.org> <20090608102754.GP4106@prithivi.gnumonks.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Jun 2009, Harald Welte wrote:
>
> The VIA/Centaur C7, C7-M and Nano CPU's all support ACPI based cpu p-states
> using a MSR interface.  The Linux driver just never made use of it, since in
> addition to the check for the EST flag it also checked if the vendor is Intel.
> 
> Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
> ---
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> index 208ecf6..ee03585 100644
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -90,7 +90,8 @@ static int check_est_cpu(unsigned int cpuid)
>  {
>  	struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
>  
> -	if (cpu->x86_vendor != X86_VENDOR_INTEL ||
> +	if ((cpu->x86_vendor != X86_VENDOR_INTEL &&
> +	     cpu->x86_vendor != X86_VENDOR_CENTAUR) ||
>  	    !cpu_has(cpu, X86_FEATURE_EST))

Hmm. This all really should be just

	static int check_est_cpu(unsigned int cpuid)
	{
		struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
		return cpu_has(cpu, X86_FEATURE_EST);
	}

I suspect, with no vendor tests. That's the whole _point_ of CPU features, 
after all.

If some vendor claims EST but doesn't actually support the EST interfaces, 
we should just have fixups to clear the bit in the per-vendor cpuinfo 
code, not in some random driver.

The only thing that makes me nervous about this is how close to 2.6.30 we 
are. I'd be happier if this was resolved by doing this as a patch 
post-2.6.30, and then adding 'stable@kernel.org' as a Cc: tag, and 
backporting it to 2.6.30.1 if no problems appear. 

It's not like this is a regression, I think.

Does that sound like a reasonable plan?

		Linus
