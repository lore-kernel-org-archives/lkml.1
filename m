Return-Path: <linux-kernel-owner+w=401wt.eu-S1762812AbZFIKgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762812AbZFIKgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbZFIKV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:21:59 -0400
Received: from kroah.org ([198.145.64.141]:55563 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760874AbZFIKV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:21:56 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:10 2009
Message-Id: <20090609094110.456250714@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:40:05 -0700
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
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 77/87] ext4: Fix discard of inode prealloc space with delayed allocation.
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=ext4-fix-discard-of-inode-prealloc-space-with-delayed-allocation.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit d6014301b5599fba395c42a1e96a7fe86f7d0b2d)

With delayed allocation we should not/cannot discard inode prealloc
space during file close. We would still have dirty pages for which we
haven't allocated blocks yet. With this fix after each get_blocks
request we check whether we have zero reserved blocks and if yes and
we don't have any writers on the file we discard inode prealloc space.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/file.c  |    3 ++-
 fs/ext4/inode.c |    9 ++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -39,7 +39,8 @@ static int ext4_release_file(struct inod
 	}
 	/* if we are the last writer on the inode, drop the block reservation */
 	if ((filp->f_mode & FMODE_WRITE) &&
-			(atomic_read(&inode->i_writecount) == 1))
+			(atomic_read(&inode->i_writecount) == 1) &&
+		        !EXT4_I(inode)->i_reserved_data_blocks)
 	{
 		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_discard_preallocations(inode);
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1036,8 +1036,15 @@ static void ext4_da_update_reserve_space
 	/* update per-inode reservations */
 	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
 	EXT4_I(inode)->i_reserved_data_blocks -= used;
-
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+
+	/*
+	 * If we have done all the pending block allocations and if
+	 * there aren't any writers on the inode, we can discard the
+	 * inode's preallocations.
+	 */
+	if (!total && (atomic_read(&inode->i_writecount) == 0))
+		ext4_discard_preallocations(inode);
 }
 
 /*


