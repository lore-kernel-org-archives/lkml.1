Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbYLCU3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbYLCU3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbYLCT6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:58:23 -0500
Received: from kroah.org ([198.145.64.141]:56851 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751543AbYLCT6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:58:11 -0500
Date: Wed, 3 Dec 2008 11:56:57 -0800
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
       alan@lxorguk.ukuu.org.uk, Mingming Cao <cmm@us.ibm.com>
Subject: [patch 103/104] ext3: fix ext3 block reservation early ENOSPC issue
Message-ID: <20081203195657.GZ8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ext3-fix-ext3-block-reservation-early-enospc-issue.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mingming Cao <cmm@us.ibm.com>

commit 46d01a225e694f1a4343beea44f1e85105aedd7e upstream.

We could run into ENOSPC error on ext3, even when there is free blocks on
the filesystem.

The problem is triggered in the case the goal block group has 0 free
blocks , and the rest block groups are skipped due to the check of
"free_blocks < windowsz/2".  Current code could fall back to non
reservation allocation to prevent early ENOSPC after examing all the block
groups with reservation on , but this code was bypassed if the reservation
window is turned off already, which is true in this case.

This patch fixed two issues:
1) We don't need to turn off block reservation if the goal block group has
0 free blocks left and continue search for the rest of block groups.

Current code the intention is to turn off the block reservation if the
goal allocation group has a few (some) free blocks left (not enough for
make the desired reservation window),to try to allocation in the goal
block group, to get better locality.  But if the goal blocks have 0 free
blocks, it should leave the block reservation on, and continues search for
the next block groups,rather than turn off block reservation completely.

2) we don't need to check the window size if the block reservation is off.

The problem was originally found and fixed in ext4.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext3/balloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1547,6 +1547,7 @@ retry_alloc:
 	 * turn off reservation for this allocation
 	 */
 	if (my_rsv && (free_blocks < windowsz)
+		&& (free_blocks > 0)
 		&& (rsv_is_empty(&my_rsv->rsv_window)))
 		my_rsv = NULL;
 
@@ -1585,7 +1586,7 @@ retry_alloc:
 		 * free blocks is less than half of the reservation
 		 * window size.
 		 */
-		if (free_blocks <= (windowsz/2))
+		if (my_rsv && (free_blocks <= (windowsz/2)))
 			continue;
 
 		brelse(bitmap_bh);

