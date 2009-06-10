Return-Path: <linux-kernel-owner+w=401wt.eu-S932164AbZFJJne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbZFJJne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758837AbZFJJih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40338 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757910AbZFJJiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:21 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 21/24] GFS2: smbd proccess hangs with flock() call.
Date: Wed, 10 Jun 2009 09:31:02 +0100
Message-Id: <1244622665-7470-22-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-21-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-12-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-13-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-14-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-15-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-16-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-17-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-18-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-19-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-20-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-21-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

GFS2 currently does not support mandatory flocks. An flock() call with
LOCK_MAND triggers unexpected behavior because gfs2 is not checking for
this lock type. This patch corrects that.

Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 73b6f55..841ddc9 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -698,8 +698,8 @@ static int gfs2_flock(struct file *file, int cmd, struct file_lock *fl)
 
 	if (!(fl->fl_flags & FL_FLOCK))
 		return -ENOLCK;
-	if (__mandatory_lock(&ip->i_inode))
-		return -ENOLCK;
+	if (fl->fl_type & LOCK_MAND)
+		return -EOPNOTSUPP;
 
 	if (fl->fl_type == F_UNLCK) {
 		do_unflock(file, fl);
-- 
1.6.0.6

