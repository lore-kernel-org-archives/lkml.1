Return-Path: <linux-kernel-owner+w=401wt.eu-S1765003AbZCaXdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765003AbZCaXdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763782AbZCaXVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:21:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:30207 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763793AbZCaXVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:21:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,304,1235980800"; 
   d="scan'208";a="677644353"
Date: Tue, 31 Mar 2009 16:21:09 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 git master and PAT problems
Message-ID: <20090331232109.GA11980@linux-os.sc.intel.com>
References: <200903302317.04515.a.miskiewicz@gmail.com> <200903310125.12120.a.miskiewicz@gmail.com> <20090331002100.GA10490@linux-os.sc.intel.com> <200903310944.32883.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903310944.32883.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 12:44:32AM -0700, Arkadiusz Miskiewicz wrote:
> On Tuesday 31 of March 2009, Pallipadi, Venkatesh wrote:
> > On Mon, Mar 30, 2009 at 04:25:11PM -0700, Arkadiusz Miskiewicz wrote:
> > > On Tuesday 31 of March 2009, Arkadiusz Miskiewicz wrote:
> > > > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
> > > >
> > > > More info follows. Now I've switched to
> > > > e1c502482853f84606928f5a2f2eb6da1993cda1 which contains latest drm
> > > > fixes and now I get much lower numbers of PAT errors but still.
> > >
> > > Also when I switch t400 into discrete mode (radeon hd 3400 instead
> > > of integrated intel GM45) I get such errors (probably unrelated
> > > to these seen when using intel):
> > >
> > > [  419.187657] X:10550 conflicting memory types cfff0000-d0000000
> > > uncached<->uncached-minus [  419.187670] reserve_memtype failed
> > > 0xcfff0000-0xd0000000, track uncached, req write-back [  419.553914]
> > > X:10550 conflicting memory types cfff0000-d0000000
> > > uncached<->uncached-minus [  419.553923] reserve_memtype failed
> > > 0xcfff0000-0xd0000000, track uncached, req write-back [  419.813592]
> > > X:10550 conflicting memory types cfff0000-d0000000
> > > uncached<->uncached-minus [  419.813601] reserve_memtype failed
> > > 0xcfff0000-0xd0000000, track uncached, req write-back [  420.100102]
> > > X:10550 conflicting memory types cfff0000-d0000000
> > > uncached<->uncached-minus [  420.100111] reserve_memtype failed
> > > 0xcfff0000-0xd0000000, track uncached, req write-back
> >
> > Yes. This is a different problem than the freeing invalid type one. Are
> > these errors also with latest git kernel? Can you try the patch below
> > (which is a part of a bigger cleanup patch I have lined up).
> 
> It's a latest git kernel as of today morning
> (latest commit is 15f7176eb1cccec0a332541285ee752b935c1c85)
> + your patch. Problem persists:
> 
> [   74.696353] [drm] Setting GART location based on new memory map
> [   74.711520] [drm] Loading RV620 CP Microcode
> [   74.711792] [drm] Loading RV620 PFP Microcode
> [   74.726719] [drm] Resetting GPU
> [   74.726776] [drm] writeback test succeeded in 1 usecs
> [   75.256034] X:5366 conflicting memory types d0000000-e0000000 uncached-minus<->write-combining
> [   75.256043] reserve_memtype failed 0xd0000000-0xe0000000, track uncached-minus, req write-back
> [   75.849951] X:5366 conflicting memory types d0000000-e0000000 uncached-minus<->write-combining
> [   75.849960] reserve_memtype failed 0xd0000000-0xe0000000, track uncached-minus, req write-back
> [   76.054374] X:5366 conflicting memory types d0000000-e0000000 uncached-minus<->write-combining
> [   76.054377] reserve_memtype failed 0xd0000000-0xe0000000, track uncached-minus, req write-back
> [   76.074481] X:5378 freeing invalid memtype d0000000-e0000000
> [   76.176881] X:5366 conflicting memory types d0000000-e0000000 uncached-minus<->write-combining
> [   76.176885] reserve_memtype failed 0xd0000000-0xe0000000, track uncached-minus, req write-back
> [   76.207734] X:5380 freeing invalid memtype d0000000-e0000000

OK. We now have a theory on what is going wrong here.

The problem seems to be pci mmap uses vm_page_prot flag to remember the
memtype for this region. Looks like that memtype is somehow getting cleared
in this case. We still don't know where it is getting cleared. But, with debug
patch below we can be sure that it is indeed getting cleared, which is
causing problems on fork() as child wont know the memtype that parent got.

Can you please try the below debug patch over upstream git and check whether
you indeed hit the warnon.

Thanks,
Venki


diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 640339e..1294194 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -182,10 +182,10 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 		u8 mtrr_type;
 
 		mtrr_type = mtrr_type_lookup(start, end);
-		if (mtrr_type == MTRR_TYPE_UNCACHABLE)
-			return _PAGE_CACHE_UC;
-		if (mtrr_type == MTRR_TYPE_WRCOMB)
-			return _PAGE_CACHE_WC;
+		if (mtrr_type != MTRR_TYPE_WRBACK)
+			return _PAGE_CACHE_UC_MINUS;
+
+		return _PAGE_CACHE_WB;
 	}
 
 	return req_type;
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index f234a37..4618b71 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -270,6 +270,7 @@ static void pci_track_mmap_page_range(struct vm_area_struct *vma)
 	unsigned long flags = pgprot_val(vma->vm_page_prot)
 						& _PAGE_CACHE_MASK;
 
+	WARN_ON_ONCE(!flags);
 	reserve_memtype(addr, addr + vma->vm_end - vma->vm_start, flags, NULL);
 }
 
@@ -338,6 +339,7 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		return -EAGAIN;
 
 	vma->vm_ops = &pci_mmap_ops;
+	WARN_ON_ONCE(!(pgprot_val(vma->vm_page_prot) & _PAGE_CACHE_MASK));
 
 	return 0;
 }
