Return-Path: <linux-kernel-owner+w=401wt.eu-S1762168AbZEACpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762168AbZEACpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbZEACoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:44:32 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47259 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbZEACoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:44:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BMzpS1sJn55UXUJ5scdkdE68Ag0bRtkqupVjDSGS5ZPRY6qfAZISHU7+XWmvDi0M5n
         qsktGqXhWNXG0vjUKBCGoQol2aNL1ZejaDGXHuEl5wzUwJVSm3xkEapKY+ad4tI2XjAz
         uVI2zfBJD5jrnuku2+tVn/2nQ3MdcCQ5CKA7Q=
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
Subject: [PATCH 3/6] kill-the-BKL/reiserfs: release write lock while rescheduling on prepare_for_delete_or_cut()
Date: Fri,  1 May 2009 04:44:19 +0200
Message-Id: <1241145862-21700-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare_for_delete_or_cut() can process several types of items, including
indirect items, ie: items which contain no file data but pointers to
unformatted nodes scattering the datas of a file.

In this case it has to zero out these pointers to block numbers of
unformatted nodes and release the bitmap from these block numbers.

It can take some time, so a rescheduling() is performed between each
block processed. We can safely release the write lock while
rescheduling(), like the bkl did, because the code checks just after
if the item has moved after sleeping.

[ Impact: release the reiserfs write lock when it is not needed ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/stree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 6bd99a9..6ddcecb 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1026,7 +1026,9 @@ static char prepare_for_delete_or_cut(struct reiserfs_transaction_handle *th, st
 			reiserfs_free_block(th, inode, block, 1);
 		    }
 
+		    reiserfs_write_unlock(sb);
 		    cond_resched();
+		    reiserfs_write_lock(sb);
 
 		    if (item_moved (&s_ih, path))  {
 			need_re_search = 1;
-- 
1.6.2.3

