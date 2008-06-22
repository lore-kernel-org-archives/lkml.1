Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYFVR0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYFVR0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 13:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYFVR02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 13:26:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657AbYFVR01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 13:26:27 -0400
Date: Sun, 22 Jun 2008 10:26:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: ecollins@vmware.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       support@vmware.com
Subject: Re: Linux 2.6.26-rc7
In-Reply-To: <alpine.LFD.1.10.0806220926150.2926@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806221003360.2926@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0806201626140.3167@woody.linux-foundation.org> <b6a2187b0806220012t118d85ffp671abf715c14ea94@mail.gmail.com> <alpine.LFD.1.10.0806220926150.2926@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Jun 2008, Linus Torvalds wrote:
> 
> Hmm. Can you see which part of it broke? Was it the "fix XIP" part ot the 
> ZERO_PAGE part? The easiest way to test is to apply this patch, and see 
> (it just disables the XIP part of fix)

Side note: considering what the patch fixes, I don't actually think we can 
undo it. But there's a possibility that we've actually uncovered an old 
bug that just was very unusual before, because the FOLL_ANON code was much 
harder to trigger before that patch (it only triggered if you didn't have 
a page table fully set up - now it triggers for even just a single missing 
page rather than a whole page table).

And I do see something pretty iffy in the logic for whether it can use 
FOLL_ANON or not - it had a nonsensical test for VM_LOCKED (which makes no 
sense at all), and it had never been taught about the ->nopfn() way of 
filling page tables.

So assuming it's not the XIP fix, you could try this patch instead. It 
replaces the (insane) use of VM_LOCKED with VM_SHARED (which is a lot more 
meaningful for the case of ZERO_PAGE, but strictly speaking probably 
doesn't matter either), and it teaches it about the fact that 
non-anonymous pages can be populated not just with the "->fault" handler, 
but with "->nopfn" too.

I really don't think it's due to this (nobody sane really uses '->nopfn'), 
but if the XIP disabling patch doesn't make a difference, give it a try.

(Most of the patch is obviously the fact that I moved the conditionals 
into a helper inline function to make the dang thing more readable). The 
actual change is trivial.

		Linus

---
 mm/memory.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9aefaae..8c5675f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1045,6 +1045,15 @@ no_page_table:
 	return page;
 }
 
+/* Can we do the FOLL_ANON optimization? */
+static inline int use_zero_page(struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_SHARED)
+		return 0;
+	return !vma->vm_ops ||
+		(!vma->vm_ops->fault && !vma->vm_ops->nopfn);
+}
+
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned long start, int len, int write, int force,
 		struct page **pages, struct vm_area_struct **vmas)
@@ -1119,8 +1128,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		foll_flags = FOLL_TOUCH;
 		if (pages)
 			foll_flags |= FOLL_GET;
-		if (!write && !(vma->vm_flags & VM_LOCKED) &&
-		    (!vma->vm_ops || !vma->vm_ops->fault))
+		if (!write && use_zero_page(vma))
 			foll_flags |= FOLL_ANON;
 
 		do {
