Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZLKFaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZLKFaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZLKFaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:30:08 -0500
Received: from kroah.org ([198.145.64.141]:53591 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbZLKFaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:30:04 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:55 2009
Message-Id: <20091211052555.487338959@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Curt Wohlgemuth <curtw@google.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [28/34] ext4: remove blocks from inode prealloc list on failure
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0024-ext4-remove-blocks-from-inode-prealloc-list-on-failu.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit b844167edc7fcafda9623955c05e4c1b3c32ebc7)

This fixes a leak of blocks in an inode prealloc list if device failures
cause ext4_mb_mark_diskspace_used() to fail.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Acked-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/mballoc.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3011,6 +3011,24 @@ static void ext4_mb_collect_stats(struct
 }
 
 /*
+ * Called on failure; free up any blocks from the inode PA for this
+ * context.  We don't need this for MB_GROUP_PA because we only change
+ * pa_free in ext4_mb_release_context(), but on failure, we've already
+ * zeroed out ac->ac_b_ex.fe_len, so group_pa->pa_free is not changed.
+ */
+static void ext4_discard_allocated_blocks(struct ext4_allocation_context *ac)
+{
+	struct ext4_prealloc_space *pa = ac->ac_pa;
+	int len;
+
+	if (pa && pa->pa_type == MB_INODE_PA) {
+		len = ac->ac_b_ex.fe_len;
+		pa->pa_free += len;
+	}
+
+}
+
+/*
  * use blocks preallocated to inode
  */
 static void ext4_mb_use_inode_pa(struct ext4_allocation_context *ac,
@@ -4295,6 +4313,7 @@ repeat:
 			ac->ac_status = AC_STATUS_CONTINUE;
 			goto repeat;
 		} else if (*errp) {
+			ext4_discard_allocated_blocks(ac);
 			ac->ac_b_ex.fe_len = 0;
 			ar->len = 0;
 			ext4_mb_show_ac(ac);


