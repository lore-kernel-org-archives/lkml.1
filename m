Return-Path: <linux-kernel-owner+w=401wt.eu-S1763200AbZEACqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763200AbZEACqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757874AbZEACok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:44:40 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:65426 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbZEACof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:44:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PSnP3TVyPTBMn0e461clymcrpcIa/NmXW5xJX4j5kd2T6wcio/oFnAEevmmvRfNHOW
         6CHpevmqLvw248dyTAxxEFPnGuk402o1W6ys8MXtJAmvRcFuojR9BJimYS7K17IStOww
         OGErLQ7LAmqHBJ2JaS82plRyqS4yYeka33fF8=
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
Subject: [PATCH 6/6] kill-the-BKL/reiserfs: release the write lock on flush_commit_list()
Date: Fri,  1 May 2009 04:44:22 +0200
Message-Id: <1241145862-21700-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_commit_list() uses ll_rw_block() to commit the pending log blocks.
ll_rw_block() might sleep, and the bkl was released at this point. Then
we can also relax the write lock at this point.

[ Impact: release the reiserfs write lock when it is not needed ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/journal.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 373d080..b1ebd5a 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -1120,8 +1120,11 @@ static int flush_commit_list(struct super_block *s,
 		    SB_ONDISK_JOURNAL_SIZE(s);
 		tbh = journal_find_get_block(s, bn);
 		if (tbh) {
-			if (buffer_dirty(tbh))
-			    ll_rw_block(WRITE, 1, &tbh) ;
+			if (buffer_dirty(tbh)) {
+		            reiserfs_write_unlock(s);
+			    ll_rw_block(WRITE, 1, &tbh);
+			    reiserfs_write_lock(s);
+			}
 			put_bh(tbh) ;
 		}
 	}
-- 
1.6.2.3

