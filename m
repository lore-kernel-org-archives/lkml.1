Return-Path: <linux-kernel-owner+w=401wt.eu-S933354AbZLKEod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbZLKEod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762271AbZLKEgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:42 -0500
Received: from kroah.org ([198.145.64.141]:36787 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760515AbZLKEf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:56 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:46 2009
Message-Id: <20091211042745.672220552@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [27/90] ext4: Dont update superblock write time when filesystem is read-only
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0027-ext4-Don-t-update-superblock-write-time-when-filesys.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 71290b368ad5e1e0b0b300c9d5638490a9fd1a2d)

This avoids updating the superblock write time when we are mounting
the root file system read/only but we need to replay the journal; at
that point, for people who are east of GMT and who make their clock
tick in localtime for Windows bug-for-bug compatibility, and this will
cause e2fsck to complain and force a full file system check.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/super.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3230,7 +3230,18 @@ static int ext4_commit_super(struct supe
 		clear_buffer_write_io_error(sbh);
 		set_buffer_uptodate(sbh);
 	}
-	es->s_wtime = cpu_to_le32(get_seconds());
+	/*
+	 * If the file system is mounted read-only, don't update the
+	 * superblock write time.  This avoids updating the superblock
+	 * write time when we are mounting the root file system
+	 * read/only but we need to replay the journal; at that point,
+	 * for people who are east of GMT and who make their clock
+	 * tick in localtime for Windows bug-for-bug compatibility,
+	 * the clock is set in the future, and this will cause e2fsck
+	 * to complain and force a full file system check.
+	 */
+	if (!(sb->s_flags & MS_RDONLY))
+		es->s_wtime = cpu_to_le32(get_seconds());
 	es->s_kbytes_written =
 		cpu_to_le64(EXT4_SB(sb)->s_kbytes_written + 
 			    ((part_stat_read(sb->s_bdev->bd_part, sectors[1]) -


