Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbYEGWhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbYEGWhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932901AbYEGWgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:36:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:1389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425AbYEGWgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:36:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,450,1204531200"; 
   d="scan'208";a="278987141"
Date: Wed, 7 May 2008 15:36:46 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Frans Pop <elendil@planet.nl>, Jesse Barnes <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org,
       "Packard, Keith" <keith.packard@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, suresh.b.siddha@intel.com
Subject: Re: [git head] X86_PAT & mprotect
Message-ID: <20080507223646.GA10757@linux-os.sc.intel.com>
References: <200805022122.03576.elendil@planet.nl> <200805040910.57088.elendil@planet.nl> <200805050857.57661.jesse.barnes@intel.com> <200805051932.41827.elendil@planet.nl> <20080506224240.GA18706@linux-os.sc.intel.com> <20080507070217.GD32195@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507070217.GD32195@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 09:02:17AM +0200, Ingo Molnar wrote:
> 
> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
> > There is a hole in mprotect, which lets the user to change the page 
> > cache type bits by-passing the kernel reserve_memtype and free_memtype 
> > wrappers. Fix the hole by not letting mprotect change the PAT bits.
> > 
> > Some versions of X used the mprotect hole to change caching type from 
> > UC to WB, so that it can then use mtrr to program WC for that region 
> > [1]. Change the mmap of pci space through /sys or /proc interfaces 
> > from UC to UC_MINUS. With this change, X will not need to use mprotect 
> > hole to get WC type.
> > 
> > [1] lkml.org/lkml/2008/4/16/369
> > 
> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > 
> > ---
> >  arch/x86/pci/i386.c       |    4 +---
> >  include/asm-x86/pgtable.h |    5 ++++-
> >  include/linux/mm.h        |    1 +
> >  mm/mmap.c                 |   13 +++++++++++++
> >  mm/mprotect.c             |    4 +++-
> >  5 files changed, 22 insertions(+), 5 deletions(-)
> 
> hm, that's one dangerous looking patch. (Cc:-ed more MM folks. I've 
> attached the patch below for reference.)
> 
> the purpose of the fix itself seems to make some sense - we dont want 
> mprotect() change the PAT bits in the pte from what they got populated 
> with at fault or mmap time.
> 
> the pte_modify() change looks correct at first sight.
> 
> The _PAGE_PROT_PRESERVE_BITS solution looks a bit ugly (although we do 
> have a couple of other similar #ifndefs in the MM already).
> 
> at minimum we should add vm_get_page_prot_preserve() as an inline 
> function to mm.h if _PAGE_PROT_PRESERVE_BITS is not defined, and make it 
> call vm_get_page_prot(). Also, vm_get_page_prot() in mm/mmap.c should 
> probably be marked inline so that we'll have only a single function call 
> [vm_get_page_prot() is trivial].

I did check that with _PAGE_PROT_PRESERVE_BITS defined to zero,
compiler optimizes vm_get_page_prot_preserve to generate same code as
vm_get_page_prot with no function call (on x86 64). So, things should be OK
from overhead perspective. But, from the code cleanliness aspect,
PRESERVE_BITS looks unclean and needs some cleanup. The reason I posted the
patch as is, was to get the confirmation on the original thread, whether this
indeed fixes those PAT related error messages.
 
> but i'm wondering why similar issues never came up on other 
> architectures - i thought it would be rather common to have immutable 
> pte details. So maybe i'm missing something here ...

Probably other architectures does not depend on preserving things in
vma->vm_page_prot once ptes are set correctly. With PAT, we use
vm_page_prot to keep track of PAT attributes for vmas from parent to
child across fork.

pte_modify() part will be required in all archs that wants to preserve
some bits in pte in a mprotect call.

Thanks,
Venki

