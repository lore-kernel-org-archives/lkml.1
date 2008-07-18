Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbYGRUPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbYGRUPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYGRUPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:15:08 -0400
Received: from smtp.net4india.com ([202.71.129.73]:49990 "EHLO
	smtp.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbYGRUPG (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:15:06 -0400
X-Greylist: delayed 65688 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2008 16:15:05 EDT
Subject: Re: Patch [1/1] minor bugfix in 2.6.26/arch/x86/mm/pat.c - caused
	problems in mmap() of /dev/mem character file
From: "V.Radhakrishnan" <rk@atr-labs.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <Linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20080717223940.GA8206@elte.hu>
References: <1216315516.2324.10.camel@atlas>
	 <alpine.LFD.1.10.0807171025110.2959@woody.linux-foundation.org>
	 <20080717223940.GA8206@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 07:34:17 +0530
Message-Id: <1216346657.2170.11.camel@atlas>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The idea behind this check is to add a second layer of checks to mmap()s 
> - which is absolutely necessary in the case of PAT and not optional. If 
> non-promisc /dev/mem is used then this check is not needed. (because the 
> higher level API already restricts us)
> 
> But this duplication is ugly and confusing - we should have just a 
> single check function, defined once and unconditionally, and utilized by 
> both places (with the devmem check being optional).
> 
> Venki, Arjan, agreed?

In fact, I spent some time thinking that the bug was actually at the
higher level API instead of in the arch specific layer, and I was amazed
that in spite of the config level option being turned off, it was NOT
being reflected in the code !!

This being my first submission to the kernel, I sent it to the mailing
list cc to Linus, as mentioned in the SubmittingPatches file WITHOUT
first subscribing to the mailing list ! Perhaps this is why the thread
did not appear ! ( 'Bug' in the SubmittingPatches file ?? )

Anyway, this is the original patch submitted, after verifying with the
perl script.

--- arch/x86/mm/pat.c.orig	2008-07-17 22:04:18.000000000 +0530
+++ arch/x86/mm/pat.c	2008-07-17 22:43:39.000000000 +0530
@@ -5,7 +5,11 @@
  *          Suresh B Siddha <suresh.b.siddha@intel.com>
  *
  * Loosely based on earlier PAT patchset from Eric Biederman and Andi
Kleen.
- */
+ *
+ * Bug fixed - V. Radhakrishnan <rk@atr-labs.com> on 17-07-2008
+		#ifdef CONFIG_NONPROMISC_DEVMEM changed to
+		#ifndef CONFIG_NONPROMISC_DEVMEM
+*/
 
 #include <linux/mm.h>
 #include <linux/kernel.h>
@@ -471,7 +475,7 @@ pgprot_t phys_mem_access_prot(struct fil
 	return vma_prot;
 }
 
-#ifdef CONFIG_NONPROMISC_DEVMEM
+#ifndef CONFIG_NONPROMISC_DEVMEM
 /* This check is done in drivers/char/mem.c in case of
NONPROMISC_DEVMEM*/
 static inline int range_is_allowed(unsigned long pfn, unsigned long
size)
 {
@@ -586,4 +590,3 @@ void unmap_devmem(unsigned long pfn, uns
 
 	free_memtype(addr, addr + size);
 }
-
Signed-off-by: Radhakrishnan <rk@atr-labs.com>
---




On Fri, 2008-07-18 at 00:39 +0200, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, 17 Jul 2008, V.Radhakrishnan wrote:
> > > 
> > > The above #ifdef must be actually #ifndef and not #ifdef The bug 
> > > does not allow a valid user (root) from accessing /dev/mem even 
> > > though the CONFIG_PROMISC_DEVMEM is NOT selected.
> > 
> > The real bug is that we shouldn't have "double negatives", and 
> > certainly not negative config options. Making that "promiscuous 
> > /dev/mem" option a negated thing as a config option was bad.
> > 
> > Ingo, over to you..
> 
> (hm, i dont find the original thread anywhere.)
> 
> this change:
> 
> > > --- arch/x86/mm/pat.c.orig	2008-07-17 22:04:18.000000000 +0530
> > > +++ arch/x86/mm/pat.c	2008-07-17 22:43:39.000000000 +0530
> > > @@ -471,7 +475,7 @@ pgprot_t phys_mem_access_prot(struct fil
> > >  	return vma_prot;
> > >  }
> > >  
> > > -#ifdef CONFIG_NONPROMISC_DEVMEM
> > > +#ifndef CONFIG_NONPROMISC_DEVMEM
> > >  /* This check is done in drivers/char/mem.c in case of NONPROMISC_DEVMEM*/
> > >  static inline int range_is_allowed(unsigned long pfn, unsigned long size)
> > >  {
> 
> ... would add a crasher cache aliasing bug in case of 
> CONFIG_NONPROMISC_DEVMEM=n (or CONFIG_PROMISC_DEVMEM).
> 
> The idea behind this check is to add a second layer of checks to mmap()s 
> - which is absolutely necessary in the case of PAT and not optional. If 
> non-promisc /dev/mem is used then this check is not needed. (because the 
> higher level API already restricts us)
> 
> But this duplication is ugly and confusing - we should have just a 
> single check function, defined once and unconditionally, and utilized by 
> both places (with the devmem check being optional).
> 
> Venki, Arjan, agreed?
> 
> Also, Linus's observation about the illogical naming of the config 
> symbol is spot on as well, below is the rename commit i've just added to 
> tip/x86/urgent.
> 
> 	Ingo
> 
> ------------------->
> commit 64d206d896ff70b828138577d5ff39deda5f1c4d
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Jul 18 00:26:59 2008 +0200
> 
>     x86: rename CONFIG_NONPROMISC_DEVMEM to CONFIG_PROMISC_DEVMEM
>     
>     Linus observed:
>     
>     > The real bug is that we shouldn't have "double negatives", and
>     > certainly not negative config options. Making that "promiscuous
>     > /dev/mem" option a negated thing as a config option was bad.
>     
>     right ... lets rename this option. There should never be a negation
>     in config options.
>     
>     [ that reminds me of CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER, but that
>       is for another commit ;-) ]
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/Kconfig.debug |    7 ++++---
>  arch/x86/mm/pat.c      |    6 +++---
>  drivers/char/mem.c     |    2 +-
>  3 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index ae36bfa..f0cf5d9 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -5,10 +5,11 @@ config TRACE_IRQFLAGS_SUPPORT
>  
>  source "lib/Kconfig.debug"
>  
> -config NONPROMISC_DEVMEM
> -	bool "Filter access to /dev/mem"
> +config PROMISC_DEVMEM
> +	bool "Allow unlimited access to /dev/mem"
> +	default y
>  	help
> -	  If this option is left off, you allow userspace access to all
> +	  If this option is left on, you allow userspace (root) access to all
>  	  of memory, including kernel and userspace memory. Accidental
>  	  access to this is obviously disastrous, but specific access can
>  	  be used by people debugging the kernel.
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index d458507..c34dc48 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -373,8 +373,8 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
>  	return vma_prot;
>  }
>  
> -#ifdef CONFIG_NONPROMISC_DEVMEM
> -/* This check is done in drivers/char/mem.c in case of NONPROMISC_DEVMEM*/
> +#ifndef CONFIG_PROMISC_DEVMEM
> +/* This check is done in drivers/char/mem.c in case of !PROMISC_DEVMEM*/
>  static inline int range_is_allowed(unsigned long pfn, unsigned long size)
>  {
>  	return 1;
> @@ -398,7 +398,7 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
>  	}
>  	return 1;
>  }
> -#endif /* CONFIG_NONPROMISC_DEVMEM */
> +#endif /* CONFIG_PROMISC_DEVMEM */
>  
>  int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
>  				unsigned long size, pgprot_t *vma_prot)
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 070e22e..de05775 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -80,7 +80,7 @@ static inline int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
>  }
>  #endif
>  
> -#ifdef CONFIG_NONPROMISC_DEVMEM
> +#ifndef CONFIG_PROMISC_DEVMEM
>  static inline int range_is_allowed(unsigned long pfn, unsigned long size)
>  {
>  	u64 from = ((u64)pfn) << PAGE_SHIFT;

