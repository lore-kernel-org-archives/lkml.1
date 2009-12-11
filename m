Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbZLKFfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbZLKFfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZLKFfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:35:00 -0500
Received: from kroah.org ([198.145.64.141]:53490 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbZLKF3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:29:50 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:47 2009
Message-Id: <20091211052547.065677730@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [13/34] ext4: journal all modifications in ext4_xattr_set_handle
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0009-ext4-journal-all-modifications-in-ext4_xattr_set_han.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit 86ebfd08a1930ccedb8eac0aeb1ed4b8b6a41dbc)

ext4_xattr_set_handle() was zeroing out an inode outside
of journaling constraints; this is one of the accesses that
was causing the crc errors in journal replay as seen in
kernel.org bugzilla #14354.

Reviewed-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/xattr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -988,6 +988,10 @@ ext4_xattr_set_handle(handle_t *handle,
 	if (error)
 		goto cleanup;
 
+	error = ext4_journal_get_write_access(handle, is.iloc.bh);
+	if (error)
+		goto cleanup;
+
 	if (EXT4_I(inode)->i_state & EXT4_STATE_NEW) {
 		struct ext4_inode *raw_inode = ext4_raw_inode(&is.iloc);
 		memset(raw_inode, 0, EXT4_SB(inode->i_sb)->s_inode_size);
@@ -1013,9 +1017,6 @@ ext4_xattr_set_handle(handle_t *handle,
 		if (flags & XATTR_CREATE)
 			goto cleanup;
 	}
-	error = ext4_journal_get_write_access(handle, is.iloc.bh);
-	if (error)
-		goto cleanup;
 	if (!value) {
 		if (!is.s.not_found)
 			error = ext4_xattr_ibody_set(handle, inode, &i, &is);


