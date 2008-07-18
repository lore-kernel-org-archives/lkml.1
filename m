Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbYGRDU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbYGRDU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 23:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYGRDUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 23:20:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:43879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbYGRDUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 23:20:11 -0400
From: Thomas Renninger <trenn@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: cpufreq limits avilable frequencies to 800MHz on git kernel
Date: Fri, 18 Jul 2008 04:46:33 +0200
User-Agent: KMail/1.9.9
Cc: arekm@maven.pl, linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk,
       gnorton@novell.com, miguel@novell.com, linux-acpi@vger.kernel.org,
       davej@redhat.com, stable@kernel.org
References: <200805231944.57320.arekm@maven.pl> <200807171548.04584.trenn@suse.de> <20080717144000.5a577985.akpm@linux-foundation.org>
In-Reply-To: <20080717144000.5a577985.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807180446.34297.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2008 11:40:00 pm Andrew Morton wrote:
> On Thu, 17 Jul 2008 15:48:02 +0200
>
> Thomas Renninger <trenn@suse.de> wrote:
> > Hi,
> >
> > maybe I found something..., can someone review/test this.
> >
> > Thanks,
> >
> >          Thomas
> >
> > ------------
> > CPUFREQ ACPI: Only call _PPC after cpufreq ACPI init funcs got called
> > already
> >
> > Ingo Molnar provided a fix to not call _PPC at processor driver
> > initialization time.
> > Git commit #e4233dec749a3519069d9390561b5636a75c7579
> >
> > But it can still happen that _PPC is called at  processor driver
> > initialization time.
> >
> > This patch should make sure that this is not possible anymore.
>
> There is no actual description of what this fixes, is there?  Do
> machines go oops, or what?
ThinkPads get stuck at lowest frequency.
A very nasty bug, reported several times recently.
This seem to show up rarely, not 100% reproducable (after every X boot...).
I do not know whether this one really fixes it. I saw an interesting debug
output on the cpufreq list recently pointing in this direction.
Even if it's not this, only calling _PPC after other initial cpufreq ACPI 
functions like _PDC or _PSS have been called (means cpufreq is really active) 
is a good idea. _PPC functions often have a complex logic. They might depend
on variables initialized in e.g. in _PDC or _PSS...
>
> How do we proceed from here with this patch?  Who should review it, who
> should test it, who should ack it and who should merge it?
I hope that Dave or someone on cpufreq list is having a look at it.
Dave should take it if it's fine.
People seeing this are in CC. After a quick review (patches are short..), I 
can provide an rpm for SUSE people (there is a SUSE and a kernel bug open)
https://bugzilla.novell.com/show_bug.cgi?id=374099

>
> e4233dec749a3519069d9390561b5636a75c7579 was in January so this patch
> is applicable to 2.6.25.x and to 2.6.26.x.  But is it needed there?
Probably should go in through .27 after review/testing.

> Insufficient info.
>
> Ho hum.  I queued it, tagged as needed-in-2.6.25.x and 2.6.26.x.  But I
> am unsure about that.
>
> Please help to clarify these things.
>
> > Signed-off-by: Thomas Renninger <trenn@suse.de>
> > ---
> >  arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c |    6 ++++++
> >  drivers/acpi/processor_perflib.c              |   13 ++++++++++++-
> >  drivers/cpufreq/cpufreq.c                     |    3 +++
> >  include/linux/cpufreq.h                       |    1 +
> >  4 files changed, 22 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
> > b/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
> > index 69288f6..3233fe8 100644
> > --- a/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
> > +++ b/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
> > @@ -96,6 +96,12 @@ static int pmi_notifier(struct notifier_block *nb,
> >  	struct cpufreq_frequency_table *cbe_freqs;
> >  	u8 node;
> >
> > +	/* Should this really be called for CPUFREQ_ADJUST,
> > CPUFREQ_INCOMPATIBLE +	 * and CPUFREQ_NOTIFY policy events?)
> > +	 */
> > +	if (event == CPUFREQ_START)
> > +		return 0;
> > +
> >  	cbe_freqs = cpufreq_frequency_get_table(policy->cpu);
> >  	node = cbe_cpu_to_node(policy->cpu);
> >
> > diff --git a/drivers/acpi/processor_perflib.c
> > b/drivers/acpi/processor_perflib.c
> > index b474996..63ccf80 100644
> > --- a/drivers/acpi/processor_perflib.c
> > +++ b/drivers/acpi/processor_perflib.c
> > @@ -72,7 +72,13 @@ MODULE_PARM_DESC(ignore_ppc, "If the frequency of your
> > machine gets wrongly" \
> >  #define PPC_REGISTERED   1
> >  #define PPC_IN_USE       2
> >
> > -static int acpi_processor_ppc_status = 0;
> > +/* ignore_ppc:
> > + * -1 -> cpufreq low level drivers not initialized -> _PSS, etc. not
> > called yet
>
> I am going to start hanging around in dark alleys in the hope of
> meeting the person who invented wordwrapping.
Sorry about that, I moved to kmail recently, still do not know how this could 
happen...

         Thomas
>
>
> Here it is again, fixed:
>
>
> From: Thomas Renninger <trenn@suse.de>
>
> Ingo Molnar provided a fix to not call _PPC at processor driver
> initialization time.  Git commit #e4233dec749a3519069d9390561b5636a75c7579
>
> But it can still happen that _PPC is called at processor driver
> initialization time.
>
> This patch should make sure that this is not possible anymore.
>
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> Cc: Dave Jones <davej@redhat.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: Chandra Seetharaman <sekharan@us.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Arkadiusz Miskiewicz <arekm@maven.pl>
> Cc: <gnorton@novell.com>
> Cc: <miguel@novell.com>
> Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c |    6 ++++++
>  drivers/acpi/processor_perflib.c              |   13 ++++++++++++-
>  drivers/cpufreq/cpufreq.c                     |    3 +++
>  include/linux/cpufreq.h                       |    1 +
>  4 files changed, 22 insertions(+), 1 deletion(-)
>
> diff -puN
> arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c~cpufreq-acpi-only-call-_ppc-a
>fter-cpufreq-acpi-init-funcs-got-called-already
> arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c ---
> a/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c~cpufreq-acpi-only-call-_ppc
>-after-cpufreq-acpi-init-funcs-got-called-already +++
> a/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
> @@ -96,6 +96,12 @@ static int pmi_notifier(struct notifier_
>  	struct cpufreq_frequency_table *cbe_freqs;
>  	u8 node;
>
> +	/* Should this really be called for CPUFREQ_ADJUST, CPUFREQ_INCOMPATIBLE
> +	 * and CPUFREQ_NOTIFY policy events?)
> +	 */
> +	if (event == CPUFREQ_START)
> +		return 0;
> +
>  	cbe_freqs = cpufreq_frequency_get_table(policy->cpu);
>  	node = cbe_cpu_to_node(policy->cpu);
>
> diff -puN
> drivers/acpi/processor_perflib.c~cpufreq-acpi-only-call-_ppc-after-cpufreq-
>acpi-init-funcs-got-called-already drivers/acpi/processor_perflib.c ---
> a/drivers/acpi/processor_perflib.c~cpufreq-acpi-only-call-_ppc-after-cpufre
>q-acpi-init-funcs-got-called-already +++ a/drivers/acpi/processor_perflib.c
> @@ -72,7 +72,13 @@ MODULE_PARM_DESC(ignore_ppc, "If the fre
>  #define PPC_REGISTERED   1
>  #define PPC_IN_USE       2
>
> -static int acpi_processor_ppc_status = 0;
> +/* ignore_ppc:
> + * -1 -> cpufreq low level drivers not initialized -> _PSS, etc. not
> called yet + *       ignore _PPC
> + *  0 -> cpufreq low level drivers initialized -> consider _PPC values
> + *  1 -> ignore _PPC totally -> forced by user through boot param
> + */
> +static int acpi_processor_ppc_status = -1;
>
>  static int acpi_processor_ppc_notifier(struct notifier_block *nb,
>  				       unsigned long event, void *data)
> @@ -81,6 +87,11 @@ static int acpi_processor_ppc_notifier(s
>  	struct acpi_processor *pr;
>  	unsigned int ppc = 0;
>
> +	if (event == CPUFREQ_START && ignore_ppc <= 0) {
> +		ignore_ppc = 0;
> +		return 0;
> +	}
> +
>  	if (ignore_ppc)
>  		return 0;
>
> diff -puN
> drivers/cpufreq/cpufreq.c~cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-in
>it-funcs-got-called-already drivers/cpufreq/cpufreq.c ---
> a/drivers/cpufreq/cpufreq.c~cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-
>init-funcs-got-called-already +++ a/drivers/cpufreq/cpufreq.c
> @@ -825,6 +825,9 @@ static int cpufreq_add_dev(struct sys_de
>  	policy->user_policy.min = policy->cpuinfo.min_freq;
>  	policy->user_policy.max = policy->cpuinfo.max_freq;
>
> +	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> +				     CPUFREQ_START, policy);
> +
>  #ifdef CONFIG_SMP
>
>  #ifdef CONFIG_HOTPLUG_CPU
> diff -puN
> include/linux/cpufreq.h~cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init
>-funcs-got-called-already include/linux/cpufreq.h ---
> a/include/linux/cpufreq.h~cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-in
>it-funcs-got-called-already +++ a/include/linux/cpufreq.h
> @@ -106,6 +106,7 @@ struct cpufreq_policy {
>  #define CPUFREQ_ADJUST		(0)
>  #define CPUFREQ_INCOMPATIBLE	(1)
>  #define CPUFREQ_NOTIFY		(2)
> +#define CPUFREQ_START		(3)
>
>  #define CPUFREQ_SHARED_TYPE_NONE (0) /* None */
>  #define CPUFREQ_SHARED_TYPE_HW	 (1) /* HW does needed coordination */
> _


