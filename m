Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbZFHVPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbZFHVPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZFHVP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:15:27 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:38114 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZFHVP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:15:26 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for VIA/Centaur CPUs
Date: Mon, 8 Jun 2009 16:15:22 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090608102754.GP4106@prithivi.gnumonks.org> <200906081503.30488.lkml@morethan.org>
In-Reply-To: <200906081503.30488.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081615.25973.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon June 8 2009, Michael S. Zick wrote:
> On Mon June 8 2009, Harald Welte wrote:
> > The VIA/Centaur C7, C7-M and Nano CPU's all support ACPI based cpu p-states
> > using a MSR interface.  The Linux driver just never made use of it, since in
> > addition to the check for the EST flag it also checked if the vendor is Intel.
> > 
> > Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
> > ---
> >  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > index 208ecf6..ee03585 100644
> > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > @@ -90,7 +90,8 @@ static int check_est_cpu(unsigned int cpuid)
> >  {
> >  	struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
> >  
> > -	if (cpu->x86_vendor != X86_VENDOR_INTEL ||
> > +	if ((cpu->x86_vendor != X86_VENDOR_INTEL &&
> > +	     cpu->x86_vendor != X86_VENDOR_CENTAUR) ||
> >  	    !cpu_has(cpu, X86_FEATURE_EST))
> >  		return 0;
> >  
> 
> For my own internal testing, based on subsequent posts, I simplified
> that to:
> 
> static int check_est_cpu(unsigned int cpuid)
> {
>         struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
> 
>         if (!cpu_has(cpu, X86_FEATURE_EST))
>                 return 0;
> 
>         return 1;
> }
> 
> Have not done anything (yet) to deal with the adaptive controller,
> **which is safe to (not) do on my test system because I know it isn't enabled**
> 
> Note: This machine is known to run common, proprietary operating systems,
> so I am also assuming its BIOS ACPI is complete enough.
> 
> Note 2: Don't try this unless you have a machine to waste.  ;)
>

Phooey, close but no cigar - - -

root@cb01:/sys/devices/system/cpu/cpu0/cpufreq# cat scaling_available_frequencies
1200000 1000000 800000 600000 400000
root@cb01:/sys/devices/system/cpu/cpu0/cpufreq# cat stats/time_in_state
1200000 3281
1000000 120
800000 130
600000 234
400000 52980
root@cb01:/sys/devices/system/cpu/cpu0/cpufreq

It loads, it appears to work, but that lowest 400Mhz has ACPI entries
even though this is a 600Mhz..1200Mhz chip.

Should be fixable -
The code looks like it is "asking" the BIOS for the table ranges -
It needs to sanity check against the limits etched in the silicon for
this particular [mask/process run].

I am thinking, maybe put the min/max GSF into cpu_boot_data.
Will probably need it there to fix e_powersaver anyway.

Mike 
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


