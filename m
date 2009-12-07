Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbZLGTao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbZLGTao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 14:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbZLGTan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 14:30:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51658 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351AbZLGTan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 14:30:43 -0500
Date: Mon, 7 Dec 2009 19:30:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
Message-ID: <20091207193048.GI14381@ZenIV.linux.org.uk>
References: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk> <20091207035857.GF14381@ZenIV.linux.org.uk> <Pine.LNX.4.64.0912071710540.14445@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912071710540.14445@sister.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 06:58:25PM +0000, Hugh Dickins wrote:

> [PATCH 4/19] fix checks for expand-in-place mremap
> 
> A couple of points on vma_expandable() in 4/19:
> +	if (arch_mmap_check(vma->vm_start, end - vma->vm_start, MAP_FIXED))
> +		return 0;
> +	if (get_unmapped_area(NULL, vma->vm_start, end - vma->vm_start,
> +			      0, MAP_FIXED) & ~PAGE_MASK)
>  		return 0;
> 
> I wondered why you don't pass the appropriate filp and pgoff here?
> Maybe it doesn't matter for anything at present (given that you're
> expanding an existing mmap), but even if that's the case, I do think
> it would be more robust to pass the correct filp and pgoff.

Umm...  Can do, but that's a bit of an extra work - I'd need to check
if we want MAP_SHARED passed if we bother to pass file.

> And that arch_mmap_check(,, MAP_FIXED) there: no problem with that,
> but it does become a problem later on (mainly in 9 and 11 and 16):
> one idiocy you haven't yet noticed, is that (a) nothing has been
> using the flags arg to arch_mmap_check(), and (b) do_mmap_pgoff()
> and do_brk() disagree on whether they're MAP_ flags or VM_ flags
> (and MAP_FIXED == VM_MAYREAD).

*ow*

> You're going for MAP_ flags, fine, but then do_brk() will need
> changing once you take notice of those flags (in 9 and 11).

Point taken, but see below.

> [PATCH 8/19] file ->get_unmapped_area() shouldn't duplicate work of get_unmapped_area()
> 
> I kept on finding more interesting things to do than arrive at a
> full understanding of file ->get_unmapped_area()s: they confuse me,
> and obviously that's not your fault.  But, while I agree with your
> principle of apportioning the work appropriately between the different
> helpers, I did wonder (a) what actual benefit this patch brings? you
> don't mention it, and it looks like a rearrangement which is very
> easy to get wrong (which you admit you did), and (b) whether the patch
> is complete, since there are lots of driver ->get_unmapped_area()s
> which are not doing the current->mm->get_unmapped_area thing.
> I think.  Maybe they're all NOMMU, and it doesn't matter there:
> I gave up on trying to work it all out and moved on.

_That_ is one hell of a mess; most of those suckers are NOMMU (and
!MAP_FIXED, while we are at it).  There are very few exceptions:
	* hugetlb
	* shm on top of hugetlb
	* fb (== pci)
	* spufs
That's *all*.  And frankly, hugetlb/shm/spufs look a lot like candidates
for a single mm method; "is this a hugepage mapping" matters in a lot more
places and I'm not at all sure that spufs is correct.  Oh, and there's
pure cargo-cult thing in bad_inode.c - we are not going to get that
file_operations instance as anything->f_op, so *all* methods except
->open() and ->fsync() (the latter due to nfsd playing silly buggers with
sync of directories) are never going to be called.

The benefit of patch... it's a preparation to the next one - we want to
push arch_mmap_check() down into get_unmapped_area() and the less extra
calls we grow and have to analyse, the better...

> [PATCH 9/19] arm: add arch_mmap_check(), get rid of sys_arm_mremap()
> 
> You give arm an arch_mmap_check() which tests MAP_FIXED,
> so now do_brk() needs fixing.  Or can arm's get_unmapped_area()
> handle this, without any arch_mmap_check()?  In the end you move
> the arch_mmap_check() call into get_unmapped_area(), but could it be
> eliminated completely, in favour of code in arch's get_unmapped_area()?

Point, but take a look at actual check there.  do_brk() won't run afoul
of it anyway with existing callers on arm.  But yes, I agree that flags
need to be fixed there.

> [PATCH 12/19] Cut hugetlb case early for 32bit on ia64
> Could you explain this one a bit more, please?  I worry because
> MAP_HUGETLB is a recently added special, there's plenty of hugetlb
> without MAP_HUGETLB, so I wonder if you're really catching early
> all that you want to be catching, whatever that is.

What I want to catch is "do_mmap_pgoff() would create struct file" case.
And MAP_HUGETLB is *exactly* what I want to catch - existing file will
get through to do_mmap_pgoff() and we'll fail due to unsuitable address
(with MAP_FIXED) or address beyond TASK_SIZE (without MAP_FIXED).  That's
fine.

> [PATCH 13/19] Unify sys_mmap*
> Couple of points on this one.
> (a) I didn't understand the arch/score part of it, why you said it
> should almost certainly shift pgoff too, nor why you left in the
> (pgoff & (~PAGE_MASK >> 12)) part, which looked redundant to me.

Exactly because it's redundant ;-)

If they ever grow PAGE_SHIFT > 12, they'll need to shift; until they do
that the check is simply if (0) and gets compiled away.

That check looks like either a pure cargo-cult thing, or a preparation to
different page sizes.  I'd rather give a benefit of doubt and put a warning
in comment...
 
> And (b) I thought you were being perverse in putting sys_mmap_pgoff()
> in mm/util.c, that's never where I'd look for it, we have a file
> mm/mmap.c which is just the place for it, after do_mmap_pgoff().
> Ah, you're trying to avoid duplicating it in mm/nommu.c?  Hmm,
> well, I'd much rather you do duplicate it.  Particularly once
> 14/19 complicates it with the MAP_HUGETLB fix, which we should
> keep in in mm/mmap.c, and shouldn't be needed in mm/nommu.c.

I'm not too happy with mm/util.c, but I really don't like the mmap vs nommu
duplications.  Hell knows; we can always split and move later on.
