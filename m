Return-Path: <linux-kernel-owner+w=401wt.eu-S1762537AbZEACqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762537AbZEACqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759030AbZEACog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:44:36 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47259 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbZEACod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:44:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vtShLf0ZwVKFy+q+CqKQM7/ysL4Jc8fYIRzGmNtdyVQemDXFzGQsLN5nK3NSfGXq8Z
         qdEZVq/QY4gOoZKfvVPCLSyHQFUjYFZ83SMOPxibr/1609JdgTDKFHGOY2IDUDwEKNFe
         R7yoRnrN8F+1AhikS2GFlySzcnKPwThFjd5Po=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5/6] kill-the-BKL/reiserfs: release the write lock inside reiserfs_read_bitmap_block()
Date: Fri,  1 May 2009 04:44:21 +0200
Message-Id: <1241145862-21700-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_read_bitmap_block() uses sb_bread() to read the bitmap block. This
helper might sleep.

Then, when the bkl was used, it was released at this point. We can then
relax the write lock too here.

[ Impact: release the reiserfs write lock when it is not needed ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/bitmap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index 1470334..6854957 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -1249,7 +1249,9 @@ struct buffer_head *reiserfs_read_bitmap_block(struct super_block *sb,
 	else if (bitmap == 0)
 		block = (REISERFS_DISK_OFFSET_IN_BYTES >> sb->s_blocksize_bits) + 1;
 
+	reiserfs_write_unlock(sb);
 	bh = sb_bread(sb, block);
+	reiserfs_write_lock(sb);
 	if (bh == NULL)
 		reiserfs_warning(sb, "sh-2029: %s: bitmap block (#%u) "
 		                 "reading failed", __func__, block);
-- 
1.6.2.3

