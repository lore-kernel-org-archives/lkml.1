Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYEIUFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYEIUFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYEIUFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:05:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:42223 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYEIUFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:05:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,462,1204531200"; 
   d="scan'208";a="244608880"
Date: Fri, 9 May 2008 13:05:19 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Hugh Dickins <hugh@veritas.com>, Frans Pop <elendil@planet.nl>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Packard, Keith" <keith.packard@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git head] X86_PAT & mprotect
Message-ID: <20080509200519.GA10897@linux-os.sc.intel.com>
References: <200805022122.03576.elendil@planet.nl> <200805040910.57088.elendil@planet.nl> <200805050857.57661.jesse.barnes@intel.com> <200805051932.41827.elendil@planet.nl> <20080506224240.GA18706@linux-os.sc.intel.com> <20080507070217.GD32195@elte.hu> <Pine.LNX.4.64.0805071941140.18916@blonde.site> <20080507232326.GB10757@linux-os.sc.intel.com> <20080509100818.GD19617@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509100818.GD19617@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 12:08:18PM +0200, Ingo Molnar wrote:
> 
> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
> > > I've tried doing it slightly differently below, don't know whether 
> > > you'll consider it an improvement or not.
> > 
> > Hugh: Thanks for looking into this. Yes. I like your modified patch. 
> > Simpler and smaller.
> 
> i have stuck your original patch into testing and nothing blew up so 
> far. Due to the mm/ bits this is not for the scope of x86.git, but 
> obviously it all looks good and is .26-worthy to me:
> 
>  Acked-by: Ingo Molnar <mingo@elte.hu>
>  Tested-by: Ingo Molnar <mingo@elte.hu>
> 
> Venki, could you please send a full patch against -git that has 
> everything from Hugh included, with an updated changelog, for 
> Linus/Andrew to ack/apply?
> 

Ingo,

Split up the patch into two parts as the pci part was unrelated to mprotect
problem in a sense.

Here is the first patch.

Thanks,
Venki


Some versions of X used the mprotect workaround to change caching type from
UC to WB, so that it can then use mtrr to program WC for that region [1].
Change the mmap of pci space through /sys or /proc interfaces from UC to
UC_MINUS. With this change, X will not need to use mprotect
workaround to get WC type.
Also the bug with mprotect which lets caller to change PAT bits is fixed in
the follow on patch. So, this X workaround will stop working as well.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/pci/i386.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c	2008-05-06 15:45:47.000000000 -0700
+++ linux-2.6/arch/x86/pci/i386.c	2008-05-09 10:05:45.000000000 -0700
@@ -301,15 +301,13 @@ int pci_mmap_page_range(struct pci_dev *
 	prot = pgprot_val(vma->vm_page_prot);
 	if (pat_wc_enabled && write_combine)
 		prot |= _PAGE_CACHE_WC;
-	else if (pat_wc_enabled)
+	else if (pat_wc_enabled || boot_cpu_data.x86 > 3)
 		/*
 		 * ioremap() and ioremap_nocache() defaults to UC MINUS for now.
 		 * To avoid attribute conflicts, request UC MINUS here
 		 * aswell.
 		 */
 		prot |= _PAGE_CACHE_UC_MINUS;
-	else if (boot_cpu_data.x86 > 3)
-		prot |= _PAGE_CACHE_UC;
 
 	vma->vm_page_prot = __pgprot(prot);
 
