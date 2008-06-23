Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbYFWQn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbYFWQn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYFWQnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:43:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018AbYFWQnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:43:17 -0400
Date: Mon, 23 Jun 2008 09:39:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Jeff Chua <jeff.chua.linux@gmail.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@tv-sign.ru>, Nick Piggin <npiggin@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Subject: Re: [patch 2/5] Reinstate ZERO_PAGE optimization in get_user_pages()
 and fix XIP
In-Reply-To: <Pine.LNX.4.64.0806231650190.13651@blonde.site>
Message-ID: <alpine.LFD.1.10.0806230928140.2926@woody.linux-foundation.org>
References: <20080622185327.348377223@mini.kroah.org>  <20080622190140.GD20141@suse.de>  <alpine.LFD.1.10.0806221220530.2926@woody.linux-foundation.org>  <20080622202950.GB20800@suse.de> <b6a2187b0806230832j10e8be28vc0b05fea233437fa@mail.gmail.com>
 <Pine.LNX.4.64.0806231650190.13651@blonde.site>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Jun 2008, Hugh Dickins wrote:

> On Mon, 23 Jun 2008, Jeff Chua wrote:
> > 
> > I can confirm that the 2nd patch from Linus fixed the problem.
> > 
> >                http://lkml.org/lkml/2008/6/22/107
> 
> But I'm afraid you've pushed me into taking another look at that
> patch, and I see a problem with it.  To be honest, I've lost the
> plot on this issue, and didn't really get what your problem is,
> nor how Linus expected to be fixing it.

The problem is that the old code said:

 - we can use FOLL_ANON, assuming that the vma has no vm_ops, or has no 
   "fault" callback.

That was funcamentally broken. Because you can have a "nopfn" callback. 
But it's hard to notice, since the whole FOLL_ANON code only _used_ to 
trigger if a whole page table was missing.

The VM_LOCKED test was just crazy, but I doubt it was the cause of the 
bug.

> The problem is that "insane" VM_LOCKED test which he has removed.
> I've remembered now what that's about: it's for make_pages_present.

That's still crazy. make_pages_present() already does:

	write = (vma->vm_flags & VM_WRITE) != 0;

and passes that in to "get_user_pages()". So for a writable mapping, we'll 
elide the FOLL_ANON case anyway, and for a read-only mapping we should 
have used ZERO_PAGE. Damn. Oh, well.

We can certainly re-instate the insane behaviour for mlock(). Not that we 
historically used to - we used to just map in ZERO_PAGE.

> So I think Linus needs to factor that into the final patch,
> whilst at the same time solving whatever is the vmware breakage.

So here's a third patch to test. It removes the VM_SHARED thing just to 
get us closer to the original code (and because do_no_page() didn't do it 
historically, so let's not do it either), and it re-instates the insane 
VM_LOCKED test with a comment.

Jeff, does this still work with vmware?

		Linus

---
 mm/memory.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9aefaae..a2ce28d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1045,6 +1045,23 @@ no_page_table:
 	return page;
 }
 
+/* Can we do the FOLL_ANON optimization? */
+static inline int use_zero_page(struct vm_area_struct *vma)
+{
+	/*
+	 * We don't want to optimize FOLL_ANON for make_pages_present()
+	 * when it tries to page in a VM_LOCKED region.
+	 */
+	if (vma->vm_flags & VM_LOCKED)
+		return 0;
+	/*
+	 * And if we have a fault or a nopfn routine, it's not an
+	 * anonymous region.
+	 */
+	return !vma->vm_ops ||
+		(!vma->vm_ops->fault && !vma->vm_ops->nopfn);
+}
+
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned long start, int len, int write, int force,
 		struct page **pages, struct vm_area_struct **vmas)
@@ -1119,8 +1136,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		foll_flags = FOLL_TOUCH;
 		if (pages)
 			foll_flags |= FOLL_GET;
-		if (!write && !(vma->vm_flags & VM_LOCKED) &&
-		    (!vma->vm_ops || !vma->vm_ops->fault))
+		if (!write && use_zero_page(vma))
 			foll_flags |= FOLL_ANON;
 
 		do {
