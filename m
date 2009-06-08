Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZFHVc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZFHVc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbZFHVcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:32:21 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:39997 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbZFHVcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:32:21 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for VIA/Centaur CPUs
Date: Mon, 8 Jun 2009 16:32:18 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090608102754.GP4106@prithivi.gnumonks.org> <alpine.LFD.2.01.0906081128410.6847@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906081128410.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081632.20869.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon June 8 2009, Linus Torvalds wrote:
> 
> On Mon, 8 Jun 2009, Harald Welte wrote:
> >
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
> 
> Hmm. This all really should be just
> 
> 	static int check_est_cpu(unsigned int cpuid)
> 	{
> 		struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
> 		return cpu_has(cpu, X86_FEATURE_EST);
> 	}
> 
> I suspect, with no vendor tests. That's the whole _point_ of CPU features, 
> after all.
> 
> If some vendor claims EST but doesn't actually support the EST interfaces, 
> we should just have fixups to clear the bit in the per-vendor cpuinfo 
> code, not in some random driver.
> 

Sounds like a plan to me - -

Shall we define a kernel 'cpu-feature' for the internal, adaptive
thermal/power/freq controller?

There are at least two cpufreq drivers that need to be able to check
for the feature 
_and_
perhaps the clock/timing routines would need to know if it was there/enabled -

Since it is internal, on-chip, it will not be sending any notifications as
it adapts the core clock speed.  (so much for 'loops/xSec').

Knowing that it is present and enabled would let the timing routines
establish non-loop counting measurements.

Mike
> The only thing that makes me nervous about this is how close to 2.6.30 we 
> are. I'd be happier if this was resolved by doing this as a patch 
> post-2.6.30, and then adding 'stable@kernel.org' as a Cc: tag, and 
> backporting it to 2.6.30.1 if no problems appear. 
> 
> It's not like this is a regression, I think.
> 
> Does that sound like a reasonable plan?
> 
> 		Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


