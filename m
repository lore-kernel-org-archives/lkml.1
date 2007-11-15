Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbXKOGMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbXKOGMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbXKOGKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:10:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36503 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807AbXKOGKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:10:41 -0500
Date: Wed, 14 Nov 2007 22:09:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliv?r Pint?r <oliver.pntr@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Willy Tarreau <w@1wt.eu>, Christoph Lameter <clameter@sgi.com>
Subject: [patch 06/13] SLUB: Fix memory leak by not reusing cpu_slab
Message-ID: <20071115060934.GG7602@kroah.com>
References: <20071115042610.731859958@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="slub-fix-memory-leak-by-not-reusing-cpu_slab.patch"
In-Reply-To: <20071115060544.GA7602@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Christoph Lameter <clameter@sgi.com>

patch 05aa345034de6ae9c77fb93f6a796013641d57d5 in mainline.

SLUB: Fix memory leak by not reusing cpu_slab

Fix the memory leak that may occur when we attempt to reuse a cpu_slab
that was allocated while we reenabled interrupts in order to be able to
grow a slab cache. The per cpu freelist may contain objects and in that
situation we may overwrite the per cpu freelist pointer loosing objects.
This only occurs if we find that the concurrently allocated slab fits
our allocation needs.

If we simply always deactivate the slab then the freelist will be properly
reintegrated and the memory leak will go away.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/slub.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1501,28 +1501,8 @@ new_slab:
 	page = new_slab(s, gfpflags, node);
 	if (page) {
 		cpu = smp_processor_id();
-		if (s->cpu_slab[cpu]) {
-			/*
-			 * Someone else populated the cpu_slab while we
-			 * enabled interrupts, or we have gotten scheduled
-			 * on another cpu. The page may not be on the
-			 * requested node even if __GFP_THISNODE was
-			 * specified. So we need to recheck.
-			 */
-			if (node == -1 ||
-				page_to_nid(s->cpu_slab[cpu]) == node) {
-				/*
-				 * Current cpuslab is acceptable and we
-				 * want the current one since its cache hot
-				 */
-				discard_slab(s, page);
-				page = s->cpu_slab[cpu];
-				slab_lock(page);
-				goto load_freelist;
-			}
-			/* New slab does not fit our expectations */
+		if (s->cpu_slab[cpu])
 			flush_slab(s, s->cpu_slab[cpu], cpu);
-		}
 		slab_lock(page);
 		SetSlabFrozen(page);
 		s->cpu_slab[cpu] = page;

-- 
