Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZBRVqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZBRVqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbZBRVgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:36:16 -0500
Received: from kroah.org ([198.145.64.141]:56388 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757272AbZBRVf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:35:59 -0500
Date: Wed, 18 Feb 2009 13:33:16 -0800
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
       alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [patch 33/39] ext4: Fix s_dirty_blocks_counter if block allocation
	failed with nodelalloc
Message-ID: <20090218213316.GH19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ext4-fix-s_dirty_blocks_counter-if-block-allocation-failed-with-nodelalloc.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit 0087d9fb3f29f59e8d42c8b058376d80e5adde4c)

With nodelalloc option we need to update the dirty block counter on
block allocation failure. This is needed because we increment the
dirty block counter early in the block allocation phase. Without
the patch s_dirty_blocks_counter goes wrong so that filesystem's
free blocks decreases incorrectly.

Tested-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4538,7 +4538,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 	}
 	if (ar->len == 0) {
 		*errp = -EDQUOT;
-		return 0;
+		goto out3;
 	}
 	inquota = ar->len;
 
@@ -4611,6 +4611,13 @@ out2:
 out1:
 	if (ar->len < inquota)
 		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
+out3:
+	if (!ar->len) {
+		if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag)
+			/* release all the reserved blocks if non delalloc */
+			percpu_counter_sub(&sbi->s_dirtyblocks_counter,
+						reserv_blks);
+	}
 
 	return block;
 }

