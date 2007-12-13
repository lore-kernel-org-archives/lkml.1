Return-Path: <linux-kernel-owner+w=401wt.eu-S1760527AbXLMGj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527AbXLMGj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758304AbXLMGhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:37:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56237 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251AbXLMGg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:36:59 -0500
Date: Wed, 12 Dec 2007 22:34:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Adrian Bunk <bunk@kernel.org>,
       Willy Tarreau <wtarreau@hera.kernel.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: [patch 06/36] tmpfs: restore missing clear_highpage
Message-ID: <20071213063417.GG25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tmpfs-restore-missing-clear_highpage.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Hugh Dickins <hugh@veritas.com>

patch e84e2e132c9c66d8498e7710d4ea532d1feaaac5 in mainline

tmpfs was misconverted to __GFP_ZERO in 2.6.11.  There's an unusual case in
which shmem_getpage receives the page from its caller instead of allocating.
We must cover this case by clear_highpage before SetPageUptodate, as before.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/shmem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1066,7 +1066,7 @@ shmem_alloc_page(gfp_t gfp, struct shmem
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, idx);
 	pvma.vm_pgoff = idx;
 	pvma.vm_end = PAGE_SIZE;
-	page = alloc_page_vma(gfp | __GFP_ZERO, &pvma, 0);
+	page = alloc_page_vma(gfp, &pvma, 0);
 	mpol_free(pvma.vm_policy);
 	return page;
 }
@@ -1086,7 +1086,7 @@ shmem_swapin(struct shmem_inode_info *in
 static inline struct page *
 shmem_alloc_page(gfp_t gfp,struct shmem_inode_info *info, unsigned long idx)
 {
-	return alloc_page(gfp | __GFP_ZERO);
+	return alloc_page(gfp);
 }
 #endif
 
@@ -1295,6 +1295,7 @@ repeat:
 
 		info->alloced++;
 		spin_unlock(&info->lock);
+		clear_highpage(filepage);
 		flush_dcache_page(filepage);
 		SetPageUptodate(filepage);
 	}

-- 
