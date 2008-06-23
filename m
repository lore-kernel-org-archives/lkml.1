Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbYFWRak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbYFWRak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbYFWRad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:30:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754879AbYFWRac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:30:32 -0400
Date: Mon, 23 Jun 2008 10:27:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Hugh Dickins <hugh@veritas.com>, Greg KH <gregkh@suse.de>,
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
In-Reply-To: <b6a2187b0806231005x44b69918q111e865938c55e7@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0806231022300.2926@woody.linux-foundation.org>
References: <20080622185327.348377223@mini.kroah.org>  <20080622190140.GD20141@suse.de>  <alpine.LFD.1.10.0806221220530.2926@woody.linux-foundation.org>  <20080622202950.GB20800@suse.de>  <b6a2187b0806230832j10e8be28vc0b05fea233437fa@mail.gmail.com> 
 <Pine.LNX.4.64.0806231650190.13651@blonde.site>  <alpine.LFD.1.10.0806230928140.2926@woody.linux-foundation.org> <b6a2187b0806231005x44b69918q111e865938c55e7@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jun 2008, Jeff Chua wrote:
> On Tue, Jun 24, 2008 at 12:39 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Jeff, does this still work with vmware?
> 
> 
> No, this breaks vmware. Does this trace help?

Not really. I have no idea what vmware does, so any traces from vmware are 
pretty useless.

On the other hand, if you add a trace to the "use_zero_page()" function to 
print out the vm_flags and other details, that probably would help.

That said, since the previous patch _did_ work, I bet that one that does 
both VM_LOCKED and VM_SHARED works too. There was a reason I wanted to do 
that VM_SHARED test. I think the VM_SHARED test is sane, unlike the 
VM_LOCKED test (that is a fairly dubious hack for mlock).

So here's the final version. I bet it works.

		Linus
---
 mm/memory.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9aefaae..423e0e7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1045,6 +1045,26 @@ no_page_table:
 	return page;
 }
 
+/* Can we do the FOLL_ANON optimization? */
+static inline int use_zero_page(struct vm_area_struct *vma)
+{
+	/*
+	 * We don't want to optimize FOLL_ANON for make_pages_present()
+	 * when it tries to page in a VM_LOCKED region. As to VM_SHARED,
+	 * we want to get the page from the page tables to make sure
+	 * that we serialize and update with any other user of that
+	 * mapping.
+	 */
+	if (vma->vm_flags & (VM_LOCKED | VM_SHARED))
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
@@ -1119,8 +1139,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		foll_flags = FOLL_TOUCH;
 		if (pages)
 			foll_flags |= FOLL_GET;
-		if (!write && !(vma->vm_flags & VM_LOCKED) &&
-		    (!vma->vm_ops || !vma->vm_ops->fault))
+		if (!write && use_zero_page(vma))
 			foll_flags |= FOLL_ANON;
 
 		do {
