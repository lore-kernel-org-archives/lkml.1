Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbZDGX13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbZDGX13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZDGX1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:27:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:38858 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZDGX1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:27:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,340,1235980800"; 
   d="scan'208";a="129009499"
Date: Wed, 8 Apr 2009 07:27:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ying Han <yinghan@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 03/14] mm: remove FAULT_FLAG_RETRY dead code
Message-ID: <20090407232700.GB5607@localhost>
References: <20090407071729.233579162@intel.com> <20090407072133.053995305@intel.com> <604427e00904071303g1d092eabp59fca0713ddacf82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <604427e00904071303g1d092eabp59fca0713ddacf82@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 04:03:36AM +0800, Ying Han wrote:
> On Tue, Apr 7, 2009 at 12:17 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > Cc: Ying Han <yinghan@google.com>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  mm/memory.c |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > --- mm.orig/mm/memory.c
> > +++ mm/mm/memory.c
> > @@ -2766,10 +2766,8 @@ static int do_linear_fault(struct mm_str
> >  {
> >        pgoff_t pgoff = (((address & PAGE_MASK)
> >                        - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> > -       int write = write_access & ~FAULT_FLAG_RETRY;
> > -       unsigned int flags = (write ? FAULT_FLAG_WRITE : 0);
> > +       unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);
> >
> > -       flags |= (write_access & FAULT_FLAG_RETRY);
> >        pte_unmap(page_table);
> >        return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
> >  }
> So, we got rid of FAULT_FLAG_RETRY flag?

Seems yes for the current mm tree, see the following two commits.

I did this patch on seeing 761fe7bc8193b7. But a closer look
indicates that the following two patches disable the filemap
VM_FAULT_RETRY part totally...

Anyway, if these two patches are to be reverted somehow(I guess yes),
this patch shall be _ignored_.

btw, do you have any test case and performance numbers for
FAULT_FLAG_RETRY? And possible overheads for (the worst case)
sparse random mmap reads on a sparse file?  I cannot find any
in your changelogs..

Thanks,
Fengguang


commit 761fe7bc8193b7858b7dc7eb4a026dc66e49fe1f
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Mon Feb 9 21:08:50 2009 +0100

    A shot in the dark :(
    
    Cc: Mike Waychison <mikew@google.com>
    Cc: Ying Han <yinghan@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index bac7d7a..1c6736d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1139,8 +1139,6 @@ good_area:
                return;
        }
 
-       write |= retry_flag;
-
        /*
         * If for any reason at all we couldn't handle the fault,
         * make sure we exit gracefully rather than endlessly redo


commit f01ca7a68c37680a4eee22a8722a713c5102b3bb
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Mon Feb 9 21:08:50 2009 +0100

    Untangle the `write' boolean from the FAULT_FLAG_foo non-boolean field.
    
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Cc: David Rientjes <rientjes@google.com>
    Cc: Hugh Dickins <hugh@veritas.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
    Cc: Mike Waychison <mikew@google.com>
    Cc: Nick Piggin <npiggin@suse.de>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Rohit Seth <rohitseth@google.com>
    Cc: T<F6>r<F6>k Edwin <edwintorok@gmail.com>
    Cc: Valdis.Kletnieks@vt.edu
    Cc: Ying Han <yinghan@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index b2cc88f..bac7d7a 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -978,7 +978,7 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
        struct mm_struct *mm;
        int write;
        int fault;
-       unsigned int retry_flag = FAULT_FLAG_RETRY;
+       int retry_flag = 1;
 
        tsk = current;
        mm = tsk->mm;
@@ -1140,6 +1140,7 @@ good_area:
        }
 
        write |= retry_flag;
+
        /*
         * If for any reason at all we couldn't handle the fault,
         * make sure we exit gracefully rather than endlessly redo
@@ -1159,8 +1160,8 @@ good_area:
         * be removed or changed after the retry.
         */
        if (fault & VM_FAULT_RETRY) {
-               if (write & FAULT_FLAG_RETRY) {
-                       retry_flag &= ~FAULT_FLAG_RETRY;
+               if (retry_flag) {
+                       retry_flag = 0;
                        goto retry;
                }

