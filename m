Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbZLPUst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbZLPUst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 15:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZLPUss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 15:48:48 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:2212 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbZLPUsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 15:48:46 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAA7XKEurR7Hu/2dsb2JhbAC/U5cMhCsE
X-IronPort-AV: E=Sophos;i="4.47,408,1257120000"; 
   d="scan'208";a="450840439"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: alloc_file(): simplify handling of mnt_clone_write() errors
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Dec 2009 12:48:44 -0800
Message-ID: <ada7hsm8x1v.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Dec 2009 20:48:45.0000 (UTC) FILETIME=[2899B480:01CA7E91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When alloc_file() and init_file() were combined, the error handling of
mnt_clone_write() was taken into alloc_file() in a somewhat obfuscated
way.  Since we don't use the error code for anything except warning,
we might as well warn directly without an extra variable.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 fs/file_table.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 17a55b8..25fe294 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -186,10 +186,8 @@ struct file *alloc_file(struct path *path, fmode_t mode,
 	 * that we can do debugging checks at __fput()
 	 */
 	if ((mode & FMODE_WRITE) && !special_file(path->dentry->d_inode->i_mode)) {
-		int error = 0;
 		file_take_write(file);
-		error = mnt_clone_write(path->mnt);
-		WARN_ON(error);
+		WARN_ON(mnt_clone_write(path->mnt));
 	}
 	ima_counts_get(file);
 	return file;
