Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbXHBOy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbXHBOy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbXHBOyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:54:50 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58226 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754862AbXHBOyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:54:49 -0400
Date: Thu, 2 Aug 2007 16:54:29 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Renninger <trenn@suse.de>
Cc: Gabriel C <nix.or.die@googlemail.com>, davej@codemonkey.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [-mm patch] CPUfreq: Only check for transition latency on
	problematic governors
Message-ID: <20070802145429.GW3972@stusta.de>
References: <a44ae5cd0708011631k7f476af2jcd01d2875f4b4b17@mail.gmail.com> <20070801165704.a26961b7.akpm@linux-foundation.org> <46B12516.4090006@googlemail.com> <20070802134838.GV3972@stusta.de> <1186065486.18821.545.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1186065486.18821.545.camel@queen.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 04:38:06PM +0200, Thomas Renninger wrote:
> On Thu, 2007-08-02 at 15:48 +0200, Adrian Bunk wrote:
> > On Thu, Aug 02, 2007 at 02:28:06AM +0200, Gabriel C wrote:
> > > Andrew Morton wrote:
> > > > On Wed, 1 Aug 2007 16:31:46 -0700
> > > > "Miles Lane" <miles.lane@gmail.com> wrote:
> > > > 
> > > >>   LD      .tmp_vmlinux1
> > > >> drivers/built-in.o: In function `__cpufreq_governor':
> > > >> cpufreq.c:(.text+0xaf178): undefined reference to `cpufreq_gov_performance'
> > > >> cpufreq.c:(.text+0xaf18a): undefined reference to `cpufreq_gov_performance'
> > > >> make: *** [.tmp_vmlinux1] Error 1
> > > > 
> > > > One for Thomas, I expect.
> > > 
> > > Is this patch :
> > > 
> > > cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
> > > 
> > > Reverting it here fixes the error.
> > 
> > Possible fix below.
> Or this one.
> Advantage: You can still have cpufreq core without the performance 
>            governor built.
> Disadvantage: The logic whether transition latency checks are
>               needed/done is moved to Kconfig.
>               Means, if you write a governor that has transition
>               latency values above 0, you must let it depend on
>               the performance governor in Kconfig.
> 
> Hope I got all .config possibilities with that one now.
> Attached is also a replacement patch for this one:
> cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
> 
> 
> CPUfreq: Only check for transition latency on problematic governors
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> --
> 
> --- linux-2.6.23-rc1-mm2/include/linux/cpufreq.h	2007-08-02 16:01:36.000000000 +0200
> +++ linux-2.6.23-rc1-mm2_fixed/include/linux/cpufreq.h	2007-08-02 15:21:28.000000000 +0200
> @@ -299,8 +299,10 @@ static inline unsigned int cpufreq_get(u
>    Performance governor is fallback governor if any other gov failed to
>    auto load due latency restrictions
>  */
> +#ifdef CONFIG_CPU_FREQ_GOV_PERFORMANCE
>  extern struct cpufreq_governor cpufreq_gov_performance;
>  #define CPUFREQ_PERFORMANCE_GOVERNOR	(&cpufreq_gov_performance)
> +#endif
>  #ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE
>  #define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_performance)
>  #elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE)
> --- linux-2.6.23-rc1-mm2/drivers/cpufreq/cpufreq.c	2007-08-02 16:01:35.000000000 +0200
> +++ linux-2.6.23-rc1-mm2_fixed/drivers/cpufreq/cpufreq.c	2007-08-02 16:23:09.000000000 +0200
> @@ -1484,17 +1484,30 @@ static int __cpufreq_governor(struct cpu
>  					unsigned int event)
>  {
>  	int ret;
> +
> +	/* Only must be defined when default governor is known to have latency
> +	   restrictions, like e.g. conservative or ondemand.
> +	   That this is the case is already ensured in Kconfig
> +	*/
> +#ifdef CONFIG_CPU_FREQ_GOV_PERFORMANCE
>  	struct cpufreq_governor *gov = CPUFREQ_PERFORMANCE_GOVERNOR;
> +#else
> +	struct cpufreq_governor *gov = NULL;
> +#endif
>...

Looks good, but you could remove CPUFREQ_PERFORMANCE_GOVERNOR and 
directly use cpufreq_gov_performance.
  
cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

