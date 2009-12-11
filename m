Return-Path: <linux-kernel-owner+w=401wt.eu-S933162AbZLKEkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162AbZLKEkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762337AbZLKEhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:37:10 -0500
Received: from kroah.org ([198.145.64.141]:36949 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757578AbZLKEgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:18 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:01 2009
Message-Id: <20091211042801.408749880@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [52/90] ext4: discard preallocation when restarting a transaction during truncate
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0052-ext4-discard-preallocation-when-restarting-a-transac.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit fa5d11133b07053270e18fa9c18560e66e79217e)

When restart a transaction during a truncate operation, we drop and
reacquire i_data_sem.  After reacquiring i_data_sem, we need to
discard any inode-based preallocation that might have been grabbed
while we released i_data_sem (for example, if pdflush is allocating
blocks and racing against the truncate).

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -193,7 +193,7 @@ static int try_to_extend_transaction(han
  * so before we call here everything must be consistently dirtied against
  * this transaction.
  */
- int ext4_truncate_restart_trans(handle_t *handle, struct inode *inode,
+int ext4_truncate_restart_trans(handle_t *handle, struct inode *inode,
 				 int nblocks)
 {
 	int ret;
@@ -209,6 +209,7 @@ static int try_to_extend_transaction(han
 	up_write(&EXT4_I(inode)->i_data_sem);
 	ret = ext4_journal_restart(handle, blocks_for_truncate(inode));
 	down_write(&EXT4_I(inode)->i_data_sem);
+	ext4_discard_preallocations(inode);
 
 	return ret;
 }


