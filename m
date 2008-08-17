Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbYHQBGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbYHQBGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 21:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbYHQBGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 21:06:39 -0400
Received: from saeurebad.de ([85.214.36.134]:34306 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479AbYHQBGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 21:06:38 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] mm: make unmap_vmas() handle non-page-aligned boundary addresses
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
	<sNRO-BDDjQL.A.spE.VazpIB@albercik>
	<Pine.LNX.4.64.0808170036400.25704@blonde.site>
Date: Sun, 17 Aug 2008 03:06:12 +0200
In-Reply-To: <Pine.LNX.4.64.0808170036400.25704@blonde.site> (Hugh Dickins's
	message of "Sun, 17 Aug 2008 00:38:35 +0100 (BST)")
Message-ID: <87fxp4pi0r.fsf_-_@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zap_pte_range() overruns the page tables if the distance between the
start and end is not a multiple of the pagesize.  Because then,
`start' will never be equal to `end' and we will keep looping.

To fix this, round the boundary addresses to exclude partial pages from
the range completely, we must not unmap them anyway.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

Hugh Dickins <hugh@veritas.com> writes:

> On Sat, 16 Aug 2008, Rafael J. Wysocki wrote:
>> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11335
>> Subject		: 2.6.27-rc2-git5 BUG: unable to handle kernel paging request
>> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
>> Date		: 2008-08-12 4:18 (5 days old)
>> References	: http://marc.info/?l=linux-kernel&m=121851477201960&w=4
>> Handled-By	: Hugh Dickins <hugh@veritas.com>
>
> This should still be listed for now, it's interesting,
> but I doubt we'll make any progress unless it can be reproduced.

I think this patch fixes it.  exit_mmap() even calls unmap_vmas() with
an ending address of -1UL which is not page-aligned in my book and on my
architecture :)

It is a similar problem to what we had with gup some weeks ago.

diff --git a/mm/memory.c b/mm/memory.c
index 1002f47..483c5d0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -896,11 +896,17 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
 	long zap_work = ZAP_BLOCK_SIZE;
 	unsigned long tlb_start = 0;	/* For tlb_finish_mmu */
 	int tlb_start_valid = 0;
-	unsigned long start = start_addr;
+	unsigned long start;
 	spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
 	int fullmm = (*tlbp)->fullmm;
 	struct mm_struct *mm = vma->vm_mm;
 
+	/* Preserve partial pages */
+	start_addr = PAGE_ALIGN(start_addr);
+	end_addr &= PAGE_MASK;
+
+	start = start_addr;
+
 	mmu_notifier_invalidate_range_start(mm, start_addr, end_addr);
 	for ( ; vma && vma->vm_start < end_addr; vma = vma->vm_next) {
 		unsigned long end;
