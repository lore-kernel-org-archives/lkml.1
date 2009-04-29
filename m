Return-Path: <linux-kernel-owner+w=401wt.eu-S1761707AbZD2Wi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761707AbZD2Wi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759966AbZD2WVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:50 -0400
Received: from kroah.org ([198.145.64.141]:40674 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760061AbZD2WVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:29 2009
Message-Id: <20090429220929.694765675@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Johannes Weiner <hannes@cmpxchg.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>
Subject: [patch 45/58] mm: check for no mmaps in exit_mmap()
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=mm-check-for-no-mmaps-in-exit_mmap.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit dcd4a049b9751828c516c59709f3fdf50436df85 upstream.

When dup_mmap() ooms we can end up with mm->mmap == NULL.  The error
path does mmput() and unmap_vmas() gets a NULL vma which it
dereferences.

In exit_mmap() there is nothing to do at all for this case, we can
cancel the callpath right there.

[akpm@linux-foundation.org: add sorely-needed comment]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Kir Kolyshkin <kir@openvz.org>
Tested-by: Kir Kolyshkin <kir@openvz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mmap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2068,6 +2068,9 @@ void exit_mmap(struct mm_struct *mm)
 	arch_exit_mmap(mm);
 	mmu_notifier_release(mm);
 
+	if (!mm->mmap)	/* Can happen if dup_mmap() received an OOM */
+		return;
+
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);


