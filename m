Return-Path: <linux-kernel-owner+w=401wt.eu-S1762863AbZEACqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762863AbZEACqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759148AbZEACoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:44:38 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:65426 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbZEACoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:44:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HrBZJaRMioebTfd+mb0IZBI4iZOQoSmwz0sNIV02YUN8oaL1IG1e30y6o7aIR42gm+
         16SxhSw4P/6T9knH/6PA0OgdwLWGj30wGqezjR7kqD2oogFHU/jI3kMH8OWy/13plj5R
         HMRkQ8rfOTQB2lemzRcDjLkfD8Qx6/4DkAKXk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4/6] kill-the-BKL/reiserfs: release the write lock inside get_neighbors()
Date: Fri,  1 May 2009 04:44:20 +0200
Message-Id: <1241145862-21700-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_neighbors() is used to get the left and/or right blocks
against a given one in order to balance a tree.

sb_bread() is used to read the buffer of these neighors blocks and
while it waits for this operation, it might sleep.

The bkl was released at this point, and then we can also release
the write lock before calling sb_bread().

This is safe because if the filesystem is changed after this
lock release, the function returns REPEAT_SEARCH (aka SCHEDULE_OCCURRED
in the function header comments) in order to repeat the neighbhor
research.

[ Impact: release the reiserfs write lock when it is not needed ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/fix_node.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/fix_node.c b/fs/reiserfs/fix_node.c
index bf5f2cb..3a685e3 100644
--- a/fs/reiserfs/fix_node.c
+++ b/fs/reiserfs/fix_node.c
@@ -1971,7 +1971,9 @@ static int get_neighbors(struct tree_balance *tb, int h)
 		     tb->FL[h]) ? tb->lkey[h] : B_NR_ITEMS(tb->
 								       FL[h]);
 		son_number = B_N_CHILD_NUM(tb->FL[h], child_position);
+		reiserfs_write_unlock(sb);
 		bh = sb_bread(sb, son_number);
+		reiserfs_write_lock(sb);
 		if (!bh)
 			return IO_ERROR;
 		if (FILESYSTEM_CHANGED_TB(tb)) {
@@ -2009,7 +2011,9 @@ static int get_neighbors(struct tree_balance *tb, int h)
 		child_position =
 		    (bh == tb->FR[h]) ? tb->rkey[h] + 1 : 0;
 		son_number = B_N_CHILD_NUM(tb->FR[h], child_position);
+		reiserfs_write_unlock(sb);
 		bh = sb_bread(sb, son_number);
+		reiserfs_write_lock(sb);
 		if (!bh)
 			return IO_ERROR;
 		if (FILESYSTEM_CHANGED_TB(tb)) {
-- 
1.6.2.3

