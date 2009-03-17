Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbZCQWAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbZCQWAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbZCQV7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:59:50 -0400
Received: from ns.suse.de ([195.135.220.2]:57644 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbZCQV7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:59:49 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 12/32] ocfs2: re-order ocfs2_empty_dir checks
Date: Tue, 17 Mar 2009 13:01:02 -0700
Message-Id: <1237320082-12921-13-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ocfs2_empty_dir() is far more expensive than checking link count. Since both
need to be checked at the same time, we can improve performance by checking
link count first.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/namei.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 67113cf..58c318d 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -834,10 +834,7 @@ static int ocfs2_unlink(struct inode *dir,
 	child_locked = 1;
 
 	if (S_ISDIR(inode->i_mode)) {
-	       	if (!ocfs2_empty_dir(inode)) {
-			status = -ENOTEMPTY;
-			goto leave;
-		} else if (inode->i_nlink != 2) {
+		if (inode->i_nlink != 2 || !ocfs2_empty_dir(inode)) {
 			status = -ENOTEMPTY;
 			goto leave;
 		}
@@ -1280,8 +1277,8 @@ static int ocfs2_rename(struct inode *old_dir,
 
 	if (target_exists) {
 		if (S_ISDIR(new_inode->i_mode)) {
-			if (!ocfs2_empty_dir(new_inode) ||
-			    new_inode->i_nlink != 2) {
+			if (new_inode->i_nlink != 2 ||
+			    !ocfs2_empty_dir(new_inode)) {
 				status = -ENOTEMPTY;
 				goto bail;
 			}
-- 
1.5.6

