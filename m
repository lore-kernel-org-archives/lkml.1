Return-Path: <linux-kernel-owner+w=401wt.eu-S934038AbYDQB3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbYDQB3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762183AbYDQBJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:09:54 -0400
Received: from sous-sol.org ([216.99.217.87]:59024 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762161AbYDQBJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:09:53 -0400
Message-Id: <20080417010355.701490709@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:14 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Roman Zippel <zippel@linux-m68k.org>
Subject: HFS+: fix unlink of links
Content-Disposition: inline; filename=hfs-fix-unlink-of-links.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Roman Zippel <zippel@linux-m68k.org>

upstream commit: 76b0c26af2736b7e5b87e6ed7ab63901483d5736

Some time ago while attempting to handle invalid link counts, I botched 
the unlink of links itself, so this patch fixes this now correctly, so 
that only the link count of nodes that don't point to links is ignored.
Thanks to Vlado Plaga <rechner@vlado-do.de> to notify me of this 
problem.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/hfsplus/dir.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
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
 

-- 
