Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab0CKRdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:33:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933411Ab0CKRc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:32:58 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Sachin Prabhu <sprabhu@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/3] GFS2: Skip check for mandatory locks when unlocking
Date: Thu, 11 Mar 2010 17:22:01 +0000
Message-Id: <1268328121-10797-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1268328121-10797-3-git-send-email-swhiteho@redhat.com>
References: <1268328121-10797-1-git-send-email-swhiteho@redhat.com>
 <1268328121-10797-2-git-send-email-swhiteho@redhat.com>
 <1268328121-10797-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Prabhu <sprabhu@redhat.com>

gfs2_lock() will skip locks on file which have mode set to 02666. This is a problem in cases where the mode of the file is changed after a process has obtained a lock on the file. Such a lock will be skipped and will result in a BUG in locks_remove_flock().

gfs2_lock() should skip the check for mandatory locks when unlocking a file.

Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index a6abbae..e6dd2ae 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -640,7 +640,7 @@ static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
 
 	if (!(fl->fl_flags & FL_POSIX))
 		return -ENOLCK;
-	if (__mandatory_lock(&ip->i_inode))
+	if (__mandatory_lock(&ip->i_inode) && fl->fl_type != F_UNLCK)
 		return -ENOLCK;
 
 	if (cmd == F_CANCELLK) {
-- 
1.6.2.5

