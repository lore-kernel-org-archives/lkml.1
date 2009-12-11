Return-Path: <linux-kernel-owner+w=401wt.eu-S1762612AbZLKEw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762612AbZLKEw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762598AbZLKEwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:52:50 -0500
Received: from kroah.org ([198.145.64.141]:36871 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760694AbZLKEgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:07 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:54 2009
Message-Id: <20091211042754.189709948@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [39/90] ext4: Fix hueristic which avoids group preallocation for closed files
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0039-ext4-Fix-hueristic-which-avoids-group-preallocation-.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 71780577306fd1e76c7a92e3b308db624d03adb9)

The hueristic was designed to avoid using locality group preallocation
when writing the last segment of a closed file.  Fix it by move
setting size to the maximum of size and isize until after we check
whether size == isize.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4162,7 +4162,6 @@ static void ext4_mb_group_or_file(struct
 	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
 	isize = (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - 1)
 		>> bsbits;
-	size = max(size, isize);
 
 	if ((size == isize) &&
 	    !ext4_fs_is_busy(sbi) &&
@@ -4172,6 +4171,7 @@ static void ext4_mb_group_or_file(struct
 	}
 
 	/* don't use group allocation for large files */
+	size = max(size, isize);
 	if (size >= sbi->s_mb_stream_request) {
 		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
 		return;


