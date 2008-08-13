Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYHMCIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYHMCIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 22:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYHMCIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 22:08:32 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:54126 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751858AbYHMCIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 22:08:31 -0400
Date: Wed, 13 Aug 2008 07:37:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       nishimura@mxp.nes.nec.co.jp, xemul@openvz.org, hugh@veritas.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 0/2] Memory rlimit fix crash on fork
Message-ID: <20080813020725.GA5139@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org, skumar@linux.vnet.ibm.com,
	yamamoto@valinux.co.jp, menage@google.com, lizf@cn.fujitsu.com,
	linux-kernel@vger.kernel.org, nishimura@mxp.nes.nec.co.jp,
	xemul@openvz.org, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
References: <20080811100719.26336.98302.sendpatchset@balbir-laptop> <20080812171407.2f468729.akpm@linux-foundation.org> <48A237B8.6060004@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <48A237B8.6060004@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2008-08-13 06:54:08]:

> Andrew Morton wrote:
> > On Mon, 11 Aug 2008 15:37:19 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> --- linux-2.6.27-rc1/mm/memory.c~memrlimit-fix-crash-on-fork	2008-08-11 14:57:48.000000000 +0530
> >> +++ linux-2.6.27-rc1-balbir/mm/memory.c	2008-08-11 14:58:33.000000000 +0530
> >> @@ -901,8 +901,12 @@ unsigned long unmap_vmas(struct mmu_gath
> > 
> > ^^ returns a long.
> > 
> >>  	unsigned long start = start_addr;
> >>  	spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
> >>  	int fullmm = (*tlbp)->fullmm;
> >> -	struct mm_struct *mm = vma->vm_mm;
> >> +	struct mm_struct *mm;
> >> +
> >> +	if (!vma)
> >> +		return;
> > 
> > ^^ mm/memory.c:907: warning: 'return' with no value, in function returning non-void
> > 
> > How does this happen?
> > 
> > I'll drop the patch.  The above mystery change needs a comment, IMO.
> 
> Oops.. I'll send the updated version. I'll comment it as well.
>

Andrew,

I double checked the compiler warnings this time around and tested the
patch. I've changed the core logic to avoid calling into unmap_vmas
and do an early exit. My understanding is that doing an early exit
should be OK, but I would like you get either you or Hugh or folks
from linux-mm to comment on it and explicitly mention if it is OK to do so.


Changelog v2
------------

Remove changes from unmap_vmas(), don't call the remaining operations
in exit_mmap() if mm->mmap is NULL.

This patch fixes a crash that occurs when kernbench is set with memrlimit
set to 500M on my x86_64 box. The root cause for the failure is

1. We don't set mm->mmap to NULL for the process for which fork() failed
2. mmput() dereferences vma (in unmap_vmas, vma->vm_mm).

This patch fixes the problem by

1. Initializing mm->mmap to NULL prior to failing dup_mmap()
2. Check early if mm->mmap is NULL in exit_mmap() and return

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 kernel/fork.c |   19 ++++++++++---------
 mm/mmap.c     |    9 +++++++++
 2 files changed, 19 insertions(+), 9 deletions(-)

diff -puN mm/mmap.c~memrlimit-fix-crash-on-fork mm/mmap.c
--- linux-2.6.27-rc1/mm/mmap.c~memrlimit-fix-crash-on-fork	2008-08-11 14:45:07.000000000 +0530
+++ linux-2.6.27-rc1-balbir/mm/mmap.c	2008-08-13 07:17:34.000000000 +0530
@@ -2118,6 +2118,15 @@ void exit_mmap(struct mm_struct *mm)
 		}
 	}
 	vma = mm->mmap;
+
+	/*
+	 * In the case that dup_mm() failed, mm->mmap is NULL and
+	 * we never really setup the mm. We don't have much to do,
+	 * we might as well return early
+	 */
+	if (!vma)
+		return;
+
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);
diff -puN kernel/fork.c~memrlimit-fix-crash-on-fork kernel/fork.c
--- linux-2.6.27-rc1/kernel/fork.c~memrlimit-fix-crash-on-fork	2008-08-11 14:45:07.000000000 +0530
+++ linux-2.6.27-rc1-balbir/kernel/fork.c	2008-08-11 14:56:04.000000000 +0530
@@ -274,15 +274,6 @@ static int dup_mmap(struct mm_struct *mm
 	 */
 	down_write_nested(&mm->mmap_sem, SINGLE_DEPTH_NESTING);
 
-	/*
-	 * Uncharging as a result of failure is done by mmput()
-	 * in dup_mm()
-	 */
-	if (memrlimit_cgroup_charge_as(oldmm, oldmm->total_vm)) {
-		retval = -ENOMEM;
-		goto out;
-	}
-
 	mm->locked_vm = 0;
 	mm->mmap = NULL;
 	mm->mmap_cache = NULL;
@@ -295,6 +286,16 @@ static int dup_mmap(struct mm_struct *mm
 	rb_parent = NULL;
 	pprev = &mm->mmap;
 
+	/*
+	 * Called after mm->mmap is set to NULL, so that the routines
+	 * following this function understand that fork failed (read
+	 * mmput).
+	 */
+	if (memrlimit_cgroup_charge_as(oldmm, oldmm->total_vm)) {
+		retval = -ENOMEM;
+		goto out;
+	}
+
 	for (mpnt = oldmm->mmap; mpnt; mpnt = mpnt->vm_next) {
 		struct file *file;
 
diff -puN mm/memory.c~memrlimit-fix-crash-on-fork mm/memory.c
_
 
-- 
	Balbir
