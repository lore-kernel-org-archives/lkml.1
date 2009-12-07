Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbZLGS6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbZLGS6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758424AbZLGS62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:58:28 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:13107 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758119AbZLGS61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:58:27 -0500
X-Trace: 303009791/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.111.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.111.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlABAGPfHEtQKW/F/2dsb2JhbAAI2j2EMwSBZw
X-IronPort-AV: E=Sophos;i="4.47,356,1257120000"; 
   d="scan'208";a="303009791"
Date: Mon, 7 Dec 2009 18:58:25 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Al Viro <viro@ftp.linux.org.uk>, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
In-Reply-To: <20091207035857.GF14381@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0912071710540.14445@sister.anvils>
References: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk> <20091207035857.GF14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Al Viro wrote:
> 	Updated series posted, with fixes merged.  It should also cover
> the shm bug caught by dwg - in case of hugepage shm we ended up with
> oopsen due to b0rken ->get_unmapped_area().

I've now gone over these, is it okay for me to comment all in one?
I do like the way complex conditions have evaporated, though sometimes
I had to spend a long time looking to see how it was justified.
I've given no more thought to that nasty PITA you raise, since
Linus reminded me of the pushf emulation issue (and what I proposed
would also have needed more to handle the exec args case).

[PATCH 1/19] untangling do_mremap(), part 1
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

[PATCH 2/19] do_mremap() untangling, part 2
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

[PATCH 3/19] do_mremap() untangling, part 3
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

[PATCH 4/19] fix checks for expand-in-place mremap

A couple of points on vma_expandable() in 4/19:
+	if (arch_mmap_check(vma->vm_start, end - vma->vm_start, MAP_FIXED))
+		return 0;
+	if (get_unmapped_area(NULL, vma->vm_start, end - vma->vm_start,
+			      0, MAP_FIXED) & ~PAGE_MASK)
 		return 0;

I wondered why you don't pass the appropriate filp and pgoff here?
Maybe it doesn't matter for anything at present (given that you're
expanding an existing mmap), but even if that's the case, I do think
it would be more robust to pass the correct filp and pgoff.

And that arch_mmap_check(,, MAP_FIXED) there: no problem with that,
but it does become a problem later on (mainly in 9 and 11 and 16):
one idiocy you haven't yet noticed, is that (a) nothing has been
using the flags arg to arch_mmap_check(), and (b) do_mmap_pgoff()
and do_brk() disagree on whether they're MAP_ flags or VM_ flags
(and MAP_FIXED == VM_MAYREAD).

You're going for MAP_ flags, fine, but then do_brk() will need
changing once you take notice of those flags (in 9 and 11).

[PATCH 5/19] fix the arch checks in MREMAP_FIXED case
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

[PATCH 6/19] fix pgoff in "have to relocate" case of mremap()
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

but that get_unmapped_area() ought to be accompanied by an
arch_mmap_check(), oughtn't it?  Doesn't really matter because
in the end arch_mmap_check() moves into get_unmapped_area()
anyway, so maybe you decided to leave that issue until then,
and just stick to the pgoff fix here for this patch.

[PATCH 7/19] kill useless checks in sparc mremap variants
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

[PATCH 8/19] file ->get_unmapped_area() shouldn't duplicate work of get_unmapped_area()

I kept on finding more interesting things to do than arrive at a
full understanding of file ->get_unmapped_area()s: they confuse me,
and obviously that's not your fault.  But, while I agree with your
principle of apportioning the work appropriately between the different
helpers, I did wonder (a) what actual benefit this patch brings? you
don't mention it, and it looks like a rearrangement which is very
easy to get wrong (which you admit you did), and (b) whether the patch
is complete, since there are lots of driver ->get_unmapped_area()s
which are not doing the current->mm->get_unmapped_area thing.
I think.  Maybe they're all NOMMU, and it doesn't matter there:
I gave up on trying to work it all out and moved on.

[PATCH 9/19] arm: add arch_mmap_check(), get rid of sys_arm_mremap()

You give arm an arch_mmap_check() which tests MAP_FIXED,
so now do_brk() needs fixing.  Or can arm's get_unmapped_area()
handle this, without any arch_mmap_check()?  In the end you move
the arch_mmap_check() call into get_unmapped_area(), but could it be
eliminated completely, in favour of code in arch's get_unmapped_area()?

[PATCH 10/19] Kill ancient crap in s390 compat mmap
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

[PATCH 11/19] arch_mmap_check() on mn10300
Like 9/19, another arch_mmap_check() which tests MAP_FIXED.

[PATCH 12/19] Cut hugetlb case early for 32bit on ia64
Could you explain this one a bit more, please?  I worry because
MAP_HUGETLB is a recently added special, there's plenty of hugetlb
without MAP_HUGETLB, so I wonder if you're really catching early
all that you want to be catching, whatever that is.

[PATCH 13/19] Unify sys_mmap*
Couple of points on this one.
(a) I didn't understand the arch/score part of it, why you said it
should almost certainly shift pgoff too, nor why you left in the
(pgoff & (~PAGE_MASK >> 12)) part, which looked redundant to me.

And (b) I thought you were being perverse in putting sys_mmap_pgoff()
in mm/util.c, that's never where I'd look for it, we have a file
mm/mmap.c which is just the place for it, after do_mmap_pgoff().
Ah, you're trying to avoid duplicating it in mm/nommu.c?  Hmm,
well, I'd much rather you do duplicate it.  Particularly once
14/19 complicates it with the MAP_HUGETLB fix, which we should
keep in in mm/mmap.c, and shouldn't be needed in mm/nommu.c.

[PATCH 14/19] fix a struct file leak in do_mmap_pgoff()
Good catch, but please transfer to mm/mmap.c.

[PATCH 15/19] Take arch_mmap_check() into get_unmapped_area()
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

[PATCH 16/19] switch do_brk() to get_unmapped_area()
Here we see do_brk()'s confusion over arch_mmap_check()'s flags.

[PATCH 17/19] sparc_brk() is not needed anymore
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

[PATCH 18/19] Get rid of open-coding in ia64_brk()
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

[PATCH 19/19] fix broken aliasing checks for MAP_FIXED on sparc32, mips, arm and sh
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Thanks,
Hugh
