Return-Path: <linux-kernel-owner+w=401wt.eu-S1030185AbXCGOZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030185AbXCGOZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030307AbXCGOZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:25:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030185AbXCGOZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:25:45 -0500
Subject: [GFS2] fix hangup when multiple processes are trying to write to
	the same file [4/12]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: Josef Whiter <jwhiter@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1173277501.11001.752.camel@quoit.chygwyn.com>
References: <1173277501.11001.752.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Mar 2007 14:28:49 +0000
Message-Id: <1173277729.11001.760.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From a13cbe375303585fec1425135ed54adb62be41fc Mon Sep 17 00:00:00 2001
From: Josef Whiter <jwhiter@redhat.com>
Date: Fri, 23 Feb 2007 12:49:51 -0500
Subject: [PATCH] [GFS2] fix hangup when multiple processes are trying to write to the same file

This fixes a problem I encountered while running bonnie++.  When you have one
thread that opens a file and starts to write to it, and then another thread that
tries to open and write to the same file, the second thread will loop forever
trying to grab the inode lock for that inode.  Basically we come in through
generic_buffered_file_write, which calls gfs2_prepare_write, which then attempts
to grab the glock.  Because we don't own the lock, gfs2_prepare_write gets
GLR_TRYFAILED, which returns AOP_TRUNCATED_PAGE to generic_buffered_file_write.
At this point generic_buffered_file_write loops around again and immediately
retries the prepare_write.  This means that the second process never gets off of
the processor in order to allow the process that holds the lock to finish its
work and let go of the lock.  This patch makes gfs2_glock_nq schedule() if it
gets back a GLR_TRYFAILED, which resolves this problem.

Signed-off-by: Josef Whiter <jwhiter@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 56e3359..b3b7e84 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -266,9 +266,11 @@ skip_lock:
 out:
 	return error;
 out_unlock:
-	if (error == GLR_TRYFAILED)
-		error = AOP_TRUNCATED_PAGE;
 	unlock_page(page);
+	if (error == GLR_TRYFAILED) {
+		error = AOP_TRUNCATED_PAGE;
+		yield();
+	}
 	if (do_unlock)
 		gfs2_holder_uninit(&gh);
 	goto out;
@@ -364,6 +366,7 @@ static int gfs2_prepare_write(struct file *file, struct page *page,
 		if (error == GLR_TRYFAILED) {
 			unlock_page(page);
 			error = AOP_TRUNCATED_PAGE;
+			yield();
 		}
 		goto out_uninit;
 	}
-- 
1.4.4.2



