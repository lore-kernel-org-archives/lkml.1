Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbZEFM0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbZEFM0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZEFMZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:25:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48116 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbZEFMZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:25:48 -0400
Date: Wed, 6 May 2009 14:25:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][git-pull -tip] x86: cpu_debug and cpufeature patches
Message-ID: <20090506122530.GV25203@elte.hu>
References: <1240191359.3106.93.camel@ht.satnam> <1240217428.3083.2.camel@ht.satnam> <20090420111619.GE6670@elte.hu> <1240933437.3074.4.camel@ht.satnam> <20090428172828.GA15392@elte.hu> <1240977176.3028.0.camel@ht.satnam> <20090429105021.GG2373@elte.hu> <1241007294.3061.12.camel@ht.satnam> <20090503090908.GA23183@elte.hu> <1241603841.3322.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241603841.3322.3.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Sun, 2009-05-03 at 11:09 +0200, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > We can use cpu_has tests for unknown processors but 'cpu model' is 
> > > accurate and cover all range.
> > > 
> > > cpu_has does not cover following registers:
> > > 1. platform
> > > 2. poweron
> > > 3. control
> > > 4. bios
> > > 5. freq
> > > 6. cache
> > > 7. misc
> > > 8. base
> > > 9. ver
> > > 10. conf
> > 
> > Firstly these should be added to cpufeatures.h.
> > 
> > Then add cpu_has_xxx() accessors need to be added for them and 
> > during CPU init they have to be properly set, via two methods:
> > 
> >  - via CPUID (where this is possible+specified in docs)
> >  - or via "later than CPU version X" checks
> > 
> > Your cpu-model table is equivalent to an explicitly enumerated CPU 
> > version check, but this breaks every time a new CPU comes out. 
> > 
> > "Later than" or CPUID based feature bits are a lot more future-proof 
> > - we only have to add support for new _features_ (and quirks, 
> > occasionally), and dont have to maintain that full table of specific 
> > models to specific features mapping tables.
> > 
> 
> I add some cpufeatures for review, I am still adding rest of them.
> 
> The following changes since commit c861b6f8ea9b39699f4a35bbf7dc06eb937a34de:
>   Ingo Molnar (1):
>         Merge branch 'irq/urgent'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master
> 
> Jaswinder Singh Rajput (6):
>       x86: cpu_debug.c avoid storing cpu_descriptors locally
>       x86: cpu_debug update Kconfig entry
>       x86: cpu_debug.c remove unwanted header files
>       x86: Add cpufeature for Processor Name
>       x86: Add cpufeatures for Advanced Power Management
>       x86: Add cpufeature for Microcode update
> 
>  arch/x86/Kconfig                  |   11 ++++++++-
>  arch/x86/include/asm/cpufeature.h |   21 ++++++++++++++----
>  arch/x86/include/asm/processor.h  |    1 -
>  arch/x86/kernel/cpu/Makefile      |    2 +-
>  arch/x86/kernel/cpu/amd.c         |    9 --------
>  arch/x86/kernel/cpu/common.c      |   16 +++++++++++++-
>  arch/x86/kernel/cpu/cpu_debug.c   |   42 +++++++++++++++++-------------------
>  arch/x86/kernel/cpu/intel.c       |   14 ------------
>  arch/x86/kernel/cpu/powerflags.c  |   20 -----------------
>  arch/x86/kernel/cpu/proc.c        |   14 ------------
>  arch/x86/kernel/microcode_amd.c   |    3 ++
>  arch/x86/kernel/microcode_intel.c |    3 ++
>  12 files changed, 68 insertions(+), 88 deletions(-)
>  delete mode 100644 arch/x86/kernel/cpu/powerflags.c
> 
> Complete diff:
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 4395f4f..213cbca 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -951,7 +951,16 @@ config X86_CPU_DEBUG
>  	tristate "/sys/kernel/debug/x86/cpu/* - CPU Debug support"
>  	---help---
>  	  If you select this option, this will provide various x86 CPUs
> -	  information through debugfs.
> +	  information through debugfs. Any user can read these file but writing
> +	  needs root privilege.
> +
> +	  Note: 1. If you compile cpu_debug as a module, it will _not_ be loaded
> +	  automatically (like usual drivers). You will need to load it manually
> +	  (or add it to list of modules loaded during boot).
> +
> +	  2. You need debugfs, if you want to mount debugfs automatically
> +	  append this line in /etc/fstab:
> +	  debugfs	/sys/kernel/debug	debugfs	defaults	0 0
>  
>  choice
>  	prompt "High Memory Support"
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index bb83b1c..64aebdd 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -6,7 +6,7 @@
>  
>  #include <asm/required-features.h>
>  
> -#define NCAPINTS	9	/* N 32-bit words worth of info */
> +#define NCAPINTS	10	/* N 32-bit words worth of info */
>  
>  /*
>   * Note: If the comment begins with a quoted string, that string is used
> @@ -76,7 +76,6 @@
>  #define X86_FEATURE_K7		(3*32+ 5) /* "" Athlon */
>  #define X86_FEATURE_P3		(3*32+ 6) /* "" P3 */
>  #define X86_FEATURE_P4		(3*32+ 7) /* "" P4 */
> -#define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate */
>  #define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
>  #define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
>  #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
> @@ -153,8 +152,10 @@
>   * Auxiliary flags: Linux defined - For features scattered in various
>   * CPUID levels like 0x6, 0xA etc
>   */
> -#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
> -#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
> +#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration	*/
> +#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer	*/
> +#define X86_FEATURE_PNAME	(7*32+ 2) /* Processor Name		*/
> +#define X86_FEATURE_MICROCODE	(7*32+ 3) /* Microcode update		*/
>  
>  /* Virtualization flags: Linux defined */
>  #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
> @@ -163,12 +164,22 @@
>  #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
>  #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
>  
> +/* Advanced Power Management (Function 8000_0007h), edx */
> +#define X86_FEATURE_TS		(9*32+ 0) /* Temperatue sensor		*/
> +#define X86_FEATURE_FID		(9*32+ 1) /* Frequency ID control	*/
> +#define X86_FEATURE_VID		(9*32+ 2) /* Voltage ID control		*/
> +#define X86_FEATURE_TTP		(9*32+ 3) /* Thermal trip		*/
> +#define X86_FEATURE_HTC		(9*32+ 4) /* Hardware thermal control	*/
> +#define X86_FEATURE_STC		(9*32+ 5) /* Software thermal control	*/
> +#define X86_FEATURE_100MHZSTEPS	(9*32+ 6) /* 100 MHz multiplier control	*/
> +#define X86_FEATURE_HWPSTATE	(9*32+ 7) /* Hardware P-State control	*/
> +#define X86_FEATURE_CONSTANT_TSC (9*32+ 8) /* Constant rate TSC ticks	*/
> +

Yes, this general approach looks pretty good! Note how it reduces 
the line count in fact.

I havent looked deeply yet, but noticed that above you changed 
X86_FEATURE_CONSTANT_TSC - why was that done?

	Ingo
