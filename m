Return-Path: <linux-kernel-owner+w=401wt.eu-S1764859AbZAPJ0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764859AbZAPJ0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761132AbZAPJ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:26:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33464 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758389AbZAPJ0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:26:03 -0500
Date: Fri, 16 Jan 2009 10:25:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL}: latest tip/cpus4096 changes
Message-ID: <20090116092540.GC4305@elte.hu>
References: <49704DF6.8040205@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49704DF6.8040205@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> 
> Hi Ingo,
> 
> Please pull the following 'fairly lightweight' changes for tip/cpus4096.

> --- a/arch/x86/kernel/apic.c
> +++ b/arch/x86/kernel/apic.c
> @@ -1562,8 +1562,69 @@ void __init init_apic_mappings(void)
>   * This initializes the IO-APIC and APIC hardware if this is
>   * a UP kernel.
>   */
> +
> +#if MAX_APICS < 256
>  int apic_version[MAX_APICS];
>  
> +#else
> +struct apic_version_info {
> +	unsigned int apicid;
> +	int version;
> +};
> +
> +struct apic_version_info _apic_version_info[CONFIG_NR_CPUS] __initdata;
> +struct apic_version_info *apic_version_info __refdata = _apic_version_info;
> +int nr_apic_version_info;
> +
> +/* can be called either during init or cpu hotplug add */
> +int __cpuinit add_apic_version(unsigned int apicid, int version)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_apic_version_info; i++)
> +		if (apicid == apic_version_info[i].apicid) {
> +			apic_version_info[i].version = version;
> +			return 0;
> +		}
> +
> +	if (likely(nr_apic_version_info < nr_cpu_ids)) {
> +		i = nr_apic_version_info++;
> +		apic_version_info[i].apicid = apicid;
> +		apic_version_info[i].version = version;
> +		return 0;
> +	}
> +	return -ENOMEM;
> +}
> +
> +/* lookup version for apic, usually first one (boot cpu) */
> +int get_apic_version(unsigned int apicid)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_apic_version_info; i++)
> +		if (apicid == apic_version_info[i].apicid)
> +			return apic_version_info[i].version;
> +
> +	return 0;
> +}
> +
> +/* allocate permanent apic_version structure */
> +void __init cleanup_apic_version(void)
> +{
> +	size_t size;
> +	int i;
> +
> +	/* allows disabled_cpus to be brought online */
> +	size = nr_cpu_ids * sizeof(*apic_version_info);
> +	apic_version_info = alloc_bootmem(size);
> +
> +	/* copy version info from initial array to permanent array */
> +	for (i = 0; i < nr_apic_version_info; i++)
> +		apic_version_info[i] = _apic_version_info[i];
> +}
> +
> +#endif /* MAX_APICS >= 256 */

this is all but 'lightweight'. A 'lightweight' patch is that which either 
is less than say a dozen lines or one that changes a provably trivial 
aspect of the kernel. This patch goes to the guts of the APIC code and is 
not only complex but also very ugly:

 - it's riddled with #ifdefs

 - it splits the testing space between <256 apics and large system - guess 
   which one will get 99% of the testing?

And why is it all done, a hundred lines of very ugly code in a fragile 
area of the x86 architecture? Because you want to shrink this array:

   int apic_version[MAX_APICS];

which can take 128K of RAM if MAX_APICs is 32K ...

Firstly, if you want to shrink the APIC version array, you might want to 
shrink it the most obvious way: by changing the 'int' to 'char' via a 
oneliner patch. APIC version values tend to be significantly below 256. 
That gives 75% of space savings already.

Secondly, you might even observe the fact that the set of systems with 
assymetric APIC versions approximates that of the nil set. Assymetric SMP 
never took off and probably never will - vendors have hard enough time 
getting the very same type of CPU working across the board.

And _even_ if there existed such systems, we already have a lot of other 
places where symmetry is assumed and _material_ APIC version assymetry to 
the boot CPU's APIC version will very likely not work anyway, on the 
physical signalling level.

So the simplest approach might as well be to turn apic_version into a 
single __read_mostly boot_apic_version variable. Maybe also a 
WARN_ONCE("whee") message if an APIC is seen with a version different from 
that of the boot CPU.

_Please_ think these changes through because these kinds of mindless 
complication patches are not acceptable at all.

	Ingo
