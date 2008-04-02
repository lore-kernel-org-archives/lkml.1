Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYDBKPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYDBKPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYDBKPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:15:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42156 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYDBKPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:15:42 -0400
Date: Wed, 2 Apr 2008 11:15:38 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Paul Mundt <lethal@linux-sh.org>,
       Nish Aravamudan <nish.aravamudan@gmail.com>,
       Adrian Bunk <bunk@kernel.org>, wli@holomorphy.com,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: HugeTLB vs. SH3 cpu
Message-ID: <20080402101538.GA18564@csn.ul.ie>
References: <20080401225809.GC32269@cs181133002.pp.htv.fi> <29495f1d0804011626n2399d69aj7566df7f78953458@mail.gmail.com> <20080402080448.GA4171@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080402080448.GA4171@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (02/04/08 17:04), Paul Mundt didst pronounce:
> On Tue, Apr 01, 2008 at 04:26:14PM -0700, Nish Aravamudan wrote:
> > On 4/1/08, Adrian Bunk <bunk@kernel.org> wrote:
> > > fs/Kconfig says:
> > >
> > >  config HUGETLBFS
> > >         bool "HugeTLB file system support"
> > >         depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || BROKEN
> > >
> > >
> > >  arch/sh/mm/Kconfig says:
> > >
> > >  choice
> > >         prompt "HugeTLB page size"
> > >         depends on HUGETLB_PAGE && (CPU_SH4 || CPU_SH5) && MMU
> > 
> > So the problem is that SH3 is allowed to enable
> > HUGETLB_PAGE/HUGETLBFS, but only SH4/5 define the HPAGE_SHIFT macro,
> > due to some #ifdeffery on the hugepage size. So either the choice
> > needs to be extended to include CPU_SH3 (which builds here, when
> > changed) or the HUGETLBFS conditional needs to depend more
> > specifically on SH4/5 and not just SUPERH. I think the arch maintainer
> > has to make that call, as I don't know the hardware to say if SH3
> > actually supports multiple hugepage sizes.
> > 
> The problem is that the hugetlb Kconfig stuff is a complete mess. There's
> a semi-decoupling between HUGETLBFS and HUGETLB_PAGE, though they both
> depend on each other.
> 

I believe the original intention was that HUGETLB_PAGE would build the
hugepage pool and the arch-specific code and HUGETLBFS would be the userspace
interface but not necessarily the only one. Whatever the original intention,
it's no longer the case as they have become inter-dependant. Fixing it is
not straight-forward but I don't think we want to collapse HUGETLB_PAGE and
HUGETLBFS just yet either.

> Sorting out the mess noted by Adrian is pretty trivial with a
> HAVE_HUGETLB_PAGE. How about this?
> 

While I am loathe to add yet more hugetlb-related Kconfig options, this
does seem to be the common way of dealing with features that depend on the
architecture (e.g. HAVE_OPROFILE, HAVE_IDE, HAVE_KPROBES etc.).

> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 

It appears to be doing the right thing making defconfig across the different
architectures.

Acked-by: Mel Gorman <mel@csn.ul.ie>

> ---
> 
>  arch/ia64/Kconfig                      |    1 +
>  arch/powerpc/platforms/Kconfig.cputype |    1 +
>  arch/sh/Kconfig                        |    2 ++
>  arch/sparc64/Kconfig                   |    1 +
>  arch/x86/Kconfig                       |    1 +
>  fs/Kconfig                             |    3 ++-
>  mm/Kconfig                             |    3 +++
>  7 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> index 8fa3faf..bb1e02b 100644
> --- a/arch/ia64/Kconfig
> +++ b/arch/ia64/Kconfig
> @@ -19,6 +19,7 @@ config IA64
>  	select HAVE_OPROFILE
>  	select HAVE_KPROBES
>  	select HAVE_KRETPROBES
> +	select HAVE_HUGETLB_PAGE
>  	default y
>  	help
>  	  The Itanium Processor Family is Intel's 64-bit successor to
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index 0c3face..7c937ad 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -1,5 +1,6 @@
>  config PPC64
>  	bool "64-bit kernel"
> +	select HAVE_HUGETLB_PAGE
>  	default n
>  	help
>  	  This option selects whether a 32-bit or a 64-bit kernel

hmm... This is what Kconfig is currently doing but by rights, it should be
set on a per-processor basis. I guess it's outside the scope of this patch as
there isn't an obvious way to tell what processor versions support huge pages.

> diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
> index df2e2f9..c48f629 100644
> --- a/arch/sh/Kconfig
> +++ b/arch/sh/Kconfig
> @@ -114,6 +114,7 @@ config CPU_SH3
>  
>  config CPU_SH4
>  	bool
> +	select HAVE_HUGETLB_PAGE
>  	select CPU_HAS_INTEVT
>  	select CPU_HAS_SR_RB
>  	select CPU_HAS_PTEA if !CPU_SH4A || CPU_SHX2
> @@ -130,6 +131,7 @@ config CPU_SH4AL_DSP
>  
>  config CPU_SH5
>  	bool
> +	select HAVE_HUGETLB_PAGE
>  	select CPU_HAS_FPU
>  
>  config CPU_SHX2
> diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
> index 463d1be..3045673 100644
> --- a/arch/sparc64/Kconfig
> +++ b/arch/sparc64/Kconfig
> @@ -16,6 +16,7 @@ config SPARC64
>  	bool
>  	default y
>  	select HAVE_IDE
> +	select HAVE_HUGETLB_PAGE
>  	help
>  	  SPARC is a family of RISC microprocessors designed and marketed by
>  	  Sun Microsystems, incorporated.  This port covers the newer 64-bit
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 6c70fed..d91e7b7 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -22,6 +22,7 @@ config X86
>  	select HAVE_OPROFILE
>  	select HAVE_KPROBES
>  	select HAVE_KRETPROBES
> +	select HAVE_HUGETLB_PAGE
>  	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
>  
>  
> diff --git a/fs/Kconfig b/fs/Kconfig
> index d731282..f886ae2 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -978,7 +978,7 @@ config TMPFS_POSIX_ACL
>  
>  config HUGETLBFS
>  	bool "HugeTLB file system support"
> -	depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || BROKEN
> +	depends on HAVE_HUGETLB_PAGE || BROKEN
>  	help
>  	  hugetlbfs is a filesystem backing for HugeTLB pages, based on
>  	  ramfs. For architectures that support it, say Y here and read
> @@ -987,6 +987,7 @@ config HUGETLBFS
>  	  If unsure, say N.
>  
>  config HUGETLB_PAGE
> +	depends on MMU
>  	def_bool HUGETLBFS
>  
>  config CONFIGFS_FS
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0016ebd..3113374 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -90,6 +90,9 @@ config HAVE_MEMORY_PRESENT
>  	def_bool y
>  	depends on ARCH_HAVE_MEMORY_PRESENT || SPARSEMEM
>  
> +config HAVE_HUGETLB_PAGE
> +	def_bool n
> +
>  #
>  # SPARSEMEM_EXTREME (which is the default) does some bootmem
>  # allocations when memory_present() is called.  If this cannot

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
