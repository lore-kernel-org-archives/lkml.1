Return-Path: <linux-kernel-owner+w=401wt.eu-S933983AbZLFRW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983AbZLFRW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933962AbZLFRW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:22:57 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:22721 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933959AbZLFRW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:22:56 -0500
X-Trace: 299068010/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.111.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.111.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As0AAAd3G0tQKW/F/2dsb2JhbAAI1Q2EMwQ
X-IronPort-AV: E=Sophos;i="4.47,350,1257120000"; 
   d="scan'208";a="299068010"
Date: Sun, 6 Dec 2009 17:22:54 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
In-Reply-To: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0912061715280.3721@sister.anvils>
References: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Dec 2009, Al Viro wrote:
> 
> Series below should deal with those, mostly by switching to consistent
> use of get_unmapped_area() and sanitizing mmap/mremap code in general.

Sorry, I've not got through them all yet.

> 
> There is one case where we still have a serious PITA and I'm not sure
> how to deal with that; it's expand_stack().  We can trigger that by
> creating a VM_GROWS{UP,DOWN} mapping and either hitting a pagefault
> on address {below,above} it or doing PTRACE_POKEDATA on such address.
> As it is, we only check that range we are expanding into is not a
> hugetlb-only one.  The thing is, we *can't* just do the normal checks
> as-is there.

It's been noticed in the past that the wrong rlimits are checked too.
I toyed with this patch nearly five years ago: does anyone know why
we need access_process_vm() to be able to expand another's stack?


[PATCH] mm: forbid expand_stack on another mm

In a very few cases, get_user_pages() is used on another process's address
space: by access_process_vm() (ptrace, /proc/<pid>/mem and a few others),
perhaps arch/arm/mach-bcmring/dma.c, perhaps drivers/gpu/drm/ttm/ttm_tt.c.

But expand_stack() can get into trouble when used on another process:
the wrong rlimits are applied, and the stack could be expanded into an
area forbidden to that kind of process - mm doesn't contain all the info.

I've never found out why we need access_process_vm() to expand a stack:
shall we see what breaks if we just forbid expand_stack() on another mm?

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/mmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- 2.6.32/mm/mmap.c	2009-12-03 03:51:21.000000000 +0000
+++ linux/mm/mmap.c	2009-12-06 16:49:01.000000000 +0000
@@ -1717,7 +1717,7 @@ find_extend_vma(struct mm_struct *mm, un
 	vma = find_vma_prev(mm, addr, &prev);
 	if (vma && (vma->vm_start <= addr))
 		return vma;
-	if (!prev || expand_stack(prev, addr))
+	if (!prev || mm != current->mm || expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED) {
 		if (mlock_vma_pages_range(prev, addr, prev->vm_end) < 0)
@@ -1745,6 +1745,8 @@ find_extend_vma(struct mm_struct * mm, u
 		return vma;
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		return NULL;
+	if (mm != current->mm)
+		return NULL;
 	start = vma->vm_start;
 	if (expand_stack(vma, addr))
 		return NULL;
