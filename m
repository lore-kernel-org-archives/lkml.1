Return-Path: <linux-kernel-owner+w=401wt.eu-S1030319AbXEAKFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030319AbXEAKFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031646AbXEAKFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:05:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030319AbXEAKFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:05:36 -0400
Subject: [GFS2] Fix bz 231380, unlock page before dequeing glocks in
	gfs2_commit_write [4/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Josef Whiter <jwhiter@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:01:03 +0100
Message-Id: <1178013663.5462.135.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1de913909263ba7f7054debeda1b79771a7233db Mon Sep 17 00:00:00 2001
From: Josef Whiter <jwhiter@redhat.com>
Date: Mon, 12 Mar 2007 16:55:07 -0500
Subject: [PATCH] [GFS2] Fix bz 231380, unlock page before dequeing glocks in gfs2_commit_write

If we are writing a file, and in the middle of writing the file
another node attempts to get a shared lock on that file (by doing a du for
example) the process doing the writing will hang waiting on lock_page.  The
reason for this is because when we have waiters on a exclusive glock, we will go
through and flush out all dirty pages associated with that inode and release the
lock.  The problem is that when we flush the dirty pages, we could hit a page
that we have locked durring the generic_file_buffered_write part of this
operation.  This patch unlocks the page before we go to dequeue the lock and
locks it immediatly afterwards, since generic_file_buffered_write needs the page
locked when the commit_write is completed.  This patch resolves the problem,
however if somebody sees a better way to do this please don't hesistate to yell.

Signed-off-by: Josef Whiter <jwhiter@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index b3b7e84..90c2879 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -507,7 +507,9 @@ static int gfs2_commit_write(struct file *file, struct page *page,
 		gfs2_quota_unlock(ip);
 		gfs2_alloc_put(ip);
 	}
+	unlock_page(page);
 	gfs2_glock_dq_m(1, &ip->i_gh);
+	lock_page(page);
 	gfs2_holder_uninit(&ip->i_gh);
 	return 0;
 
@@ -520,7 +522,9 @@ fail_endtrans:
 		gfs2_quota_unlock(ip);
 		gfs2_alloc_put(ip);
 	}
+	unlock_page(page);
 	gfs2_glock_dq_m(1, &ip->i_gh);
+	lock_page(page);
 	gfs2_holder_uninit(&ip->i_gh);
 fail_nounlock:
 	ClearPageUptodate(page);
-- 
1.5.1.2



