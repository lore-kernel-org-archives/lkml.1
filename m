Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbZFONK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbZFONK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbZFONKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:10:16 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:33552 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZFONKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:10:15 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: TSC features, was: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for VIA/Centaur CPUs
Date: Mon, 15 Jun 2009 08:10:13 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090608102754.GP4106@prithivi.gnumonks.org> <alpine.LFD.2.01.0906081128410.6847@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906081128410.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906150810.15799.lkml@morethan.org>
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

Following that same logic, shouldn't this chunk be based on CPU features also?
(Spotted while tracking down why the non-stop TSC wasn't being used on VIA):

#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
static void tsc_check_state(int state)
{
        switch (boot_cpu_data.x86_vendor) {
        case X86_VENDOR_AMD:
        case X86_VENDOR_INTEL:
                /*
                 * AMD Fam10h TSC will tick in all
                 * C/P/S0/S1 states when this bit is set.
                 */
                if (boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
                        return;

                /*FALL THROUGH*/
        default:
                /* TSC could halt in idle, so notify users */
                if (state > ACPI_STATE_C1)
                        mark_tsc_unstable("TSC halts in idle");
        }
}
#else
static void tsc_check_state(int state) { return; }
#endif

Mike
