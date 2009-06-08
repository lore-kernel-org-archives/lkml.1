Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbZFHOZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbZFHOZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbZFHOZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:25:14 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:58730 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbZFHOZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:25:12 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for VIA/Centaur CPUs
Date: Mon, 8 Jun 2009 09:25:09 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906060856.15016.lkml@morethan.org> <20090608102754.GP4106@prithivi.gnumonks.org>
In-Reply-To: <20090608102754.GP4106@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906080925.12460.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon June 8 2009, Harald Welte wrote:
> The VIA/Centaur C7, C7-M and Nano CPU's all support ACPI based cpu p-states
> using a MSR interface.  The Linux driver just never made use of it, since in
> addition to the check for the EST flag it also checked if the vendor is Intel.
>

It looks like we should modify (conditional on ...MVIAC7 at build, model='d' runtime)
the acpi-cpufreq controls to deal properly with the Model-D adaptive controller.

What probably needs to be done is test if it has been set-up and turn it off
before handing control over to the ACPI - -
The information I have from VIA Tech. says not to use external controls while
the adaptive controller is enabled.

Perhaps the same sort of thing in the 'resume' path - some BIOS may be
enabling the adaptive controller.

Mike 
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
>  		return 0;
>  


