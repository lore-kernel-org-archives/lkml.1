Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZLKFfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZLKFfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbZLKFfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:35:44 -0500
Received: from kroah.org ([198.145.64.141]:53473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbZLKF3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:29:46 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:45 2009
Message-Id: <20091211052544.890897126@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Akira Fujita <a-fujita@rs.jp.nec.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [09/34] ext4: fix possible recursive locking warning in EXT4_IOC_MOVE_EXT
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0005-ext4-fix-possible-recursive-locking-warning-in-EXT4_.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit 49bd22bc4d603a2a4fc2a6a60e156cbea52eb494)

If CONFIG_PROVE_LOCKING is enabled, the double_down_write_data_sem()
will trigger a false-positive warning of a recursive lock.  Since we
take i_data_sem for the two inodes ordered by their inode numbers,
this isn't a problem.  Use of down_write_nested() will notify the lock
dependency checker machinery that there is no problem here.

This problem was reported by Brian Rogers:

	http://marc.info/?l=linux-ext4&m=125115356928011&w=1

Reported-by: Brian Rogers <brian@xyzw.org>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/move_extent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -189,7 +189,7 @@ double_down_write_data_sem(struct inode
 	}
 
 	down_write(&EXT4_I(first)->i_data_sem);
-	down_write(&EXT4_I(second)->i_data_sem);
+	down_write_nested(&EXT4_I(second)->i_data_sem, SINGLE_DEPTH_NESTING);
 }
 
 /**


