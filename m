Return-Path: <linux-kernel-owner+w=401wt.eu-S1762423AbZLKExf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762423AbZLKExf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759330AbZLKExa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:53:30 -0500
Received: from kroah.org ([198.145.64.141]:36863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759254AbZLKEgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:06 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:54 2009
Message-Id: <20091211042753.567755833@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [38/90] ext4: Fix the alloc on close after a truncate hueristic
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0038-ext4-Fix-the-alloc-on-close-after-a-truncate-huerist.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 5534fb5bb35a62a94e0bd1fa2421f7fb6e894f10)

In an attempt to avoid doing an unneeded flush after opening a
(previously non-existent) file with O_CREAT|O_TRUNC, the code only
triggered the hueristic if ei->disksize was non-zero.  Turns out that
the VFS doesn't call ->truncate() if the file doesn't exist, and
ei->disksize is always zero even if the file previously existed.  So
remove the test, since it isn't necessary and in fact disabled the
hueristic.

Thanks to Clemens Eisserer that he was seeing problems with files
written using kwrite and eclipse after sudden crashes caused by a
buggy Intel video driver.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3983,8 +3983,7 @@ void ext4_truncate(struct inode *inode)
 	if (!ext4_can_truncate(inode))
 		return;
 
-	if (ei->i_disksize && inode->i_size == 0 &&
-	    !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
+	if (inode->i_size == 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
 		ei->i_state |= EXT4_STATE_DA_ALLOC_CLOSE;
 
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {


