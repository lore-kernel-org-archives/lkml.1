Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZCXWZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZCXWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZCXWZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:25:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42628 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbZCXWZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:25:43 -0400
Date: Tue, 24 Mar 2009 23:25:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error: freeing invalid memtype
Message-ID: <20090324222516.GA4292@elte.hu>
References: <49C03208.6050603@gmail.com> <1237399938.4529.208.camel@localhost.localdomain> <49C572CC.6090704@gmail.com> <20090323190720.GA16831@linux-os.sc.intel.com> <49C95C66.2050100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C95C66.2050100@gmail.com>
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


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> Pallipadi, Venkatesh wrote:
> > On Sat, Mar 21, 2009 at 04:05:48PM -0700, Kevin Winchester wrote:
> >> Pallipadi, Venkatesh wrote:
> >>> Kevin,
> >>>
> >>> Can you please send me the output of
> >>> # cat /debug/x86/pat_memtype_list
> >>>
> >>> (with debugfs mounted at /debug) as soon as you login into X and also
> >>> when you start seeing these errors with etracer and glxinfo.
> >>>
> >> Here is the output before attempting to run glxinfo:
> >> : :
> >> : :
> >>
> >> Does that help track down the problem?  I am about to try disabling PAT
> >> in my config to see if that fixes things.
> >>
> > 
> > Can you please try the patch below and let me whether it helps.
> > 
> > Thanks,
> > Venki
> > 
> > x86, PAT: Change vma prot in pci_mmap to reflect inherited prot
> >     
> > While looking at the issue in the thread
> > http://marc.info/?l=dri-devel&m=123606627824556&w=2
> > noticed a bug in pci PAT code and memory type setting.
> >     
> > pci mmap code did not set the proper protection in vma, when it
> > inherited protection in reserve_memtype. This bug only affects
> > the case where there exists a WC mapping before X does an mmap
> > with /proc or /sys pci interface. This will cause X userlevel
> > mmap from /proc or /sysfs to fail on fork.
> >     
> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > 
> > diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> > index 5ead808..f234a37 100644
> > --- a/arch/x86/pci/i386.c
> > +++ b/arch/x86/pci/i386.c
> > @@ -319,6 +319,9 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
> >  			return -EINVAL;
> >  		}
> >  		flags = new_flags;
> > +		vma->vm_page_prot = __pgprot(
> > +			(pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK) |
> > +			flags);
> >  	}
> >  
> >  	if (((vma->vm_pgoff < max_low_pfn_mapped) ||
> 
> This patch fixes the problem for me - no more errors in my dmesg.  
> I suppose that I also did update to the latest mainline as well, 
> so it could possibly have been some other patch instead.  If you 
> think there is a big risk of that, let me know and I'll repeat the 
> test and make sure that this patch is the only difference.

No, there was no fix in this area mainline, so it's this patch. I've 
queued up the fix for the .30 merge window with a -stable backport 
tag - so it will show up in .29.1 or .29.2 if it remains 
problem-free.

Thanks a lot for your testing! Below is the final commit.

	Ingo

---------------->
>From 9cdec049389ce2c324fd1ec508a71528a27d4a07 Mon Sep 17 00:00:00 2001
From: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Date: Mon, 23 Mar 2009 12:07:20 -0700
Subject: [PATCH] x86, PAT, PCI: Change vma prot in pci_mmap to reflect inherited prot

While looking at the issue in the thread:

  http://marc.info/?l=dri-devel&m=123606627824556&w=2

noticed a bug in pci PAT code and memory type setting.

PCI mmap code did not set the proper protection in vma, when it
inherited protection in reserve_memtype. This bug only affects
the case where there exists a WC mapping before X does an mmap
with /proc or /sys pci interface. This will cause X userlevel
mmap from /proc or /sysfs to fail on fork.

Reported-by: Kevin Winchester <kjwinchester@gmail.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: <stable@kernel.org>
LKML-Reference: <20090323190720.GA16831@linux-os.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/pci/i386.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5ead808..f234a37 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -319,6 +319,9 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			return -EINVAL;
 		}
 		flags = new_flags;
+		vma->vm_page_prot = __pgprot(
+			(pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK) |
+			flags);
 	}
 
 	if (((vma->vm_pgoff < max_low_pfn_mapped) ||
