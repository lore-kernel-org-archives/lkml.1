Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbYDIQZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbYDIQZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627AbYDIQXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:23:05 -0400
Received: from linux-m68k.xs4all.nl ([82.95.193.92]:41895 "EHLO
	scrub.xs4all.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757608AbYDIQXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:23:04 -0400
X-Greylist: delayed 2319 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2008 12:23:03 EDT
Date: Wed, 9 Apr 2008 17:44:07 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH/HFS+] fix unlink of links
Message-ID: <Pine.LNX.4.64.0804091727200.8547@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some time ago while attempting to handle invalid link counts, I botched 
the unlink of links itself, so this patch fixes this now correctly, so 
that only the link count of nodes that don't point to links is ignored.
Thanks to Vlado Plaga <rechner@vlado-do.de> to notify me of this 
problem.

bye, Roman

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

Index: linux-2.6/fs/hfsplus/dir.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/dir.c	2008-04-07 14:25:42.000000000 +0200
+++ linux-2.6/fs/hfsplus/dir.c	2008-04-07 15:59:45.000000000 +0200
@@ -340,16 +340,23 @@ static int hfsplus_unlink(struct inode *
 
 	if (inode->i_nlink > 0)
 		drop_nlink(inode);
-	hfsplus_delete_inode(inode);
-	if (inode->i_ino != cnid && !inode->i_nlink) {
-		if (!atomic_read(&HFSPLUS_I(inode).opencnt)) {
-			res = hfsplus_delete_cat(inode->i_ino, HFSPLUS_SB(sb).hidden_dir, NULL);
-			if (!res)
-				hfsplus_delete_inode(inode);
+	if (inode->i_ino == cnid)
+		clear_nlink(inode);
+	if (!inode->i_nlink) {
+		if (inode->i_ino != cnid) {
+			HFSPLUS_SB(sb).file_count--;
+			if (!atomic_read(&HFSPLUS_I(inode).opencnt)) {
+				res = hfsplus_delete_cat(inode->i_ino,
+							 HFSPLUS_SB(sb).hidden_dir,
+							 NULL);
+				if (!res)
+					hfsplus_delete_inode(inode);
+			} else
+				inode->i_flags |= S_DEAD;
 		} else
-			inode->i_flags |= S_DEAD;
+			hfsplus_delete_inode(inode);
 	} else
-		clear_nlink(inode);
+		HFSPLUS_SB(sb).file_count--;
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 
