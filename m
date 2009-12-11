Return-Path: <linux-kernel-owner+w=401wt.eu-S934423AbZLKErK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934423AbZLKErK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934262AbZLKEqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:46:48 -0500
Received: from kroah.org ([198.145.64.141]:37037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761371AbZLKEgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:32 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:09 2009
Message-Id: <20091211042808.870915761@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [65/90] ext4: journal all modifications in ext4_xattr_set_handle
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0065-ext4-journal-all-modifications-in-ext4_xattr_set_han.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

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


