Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbZAVTQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbZAVTQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbZAVTQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:16:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55878 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbZAVTQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:16:13 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
       bfields@fieldses.org, cluster-devel@redhat.com, teigland@redhat.com
Subject: [PATCH 1/2] dlm: initialize file_lock struct in GETLK before copying conflicting lock
Date: Thu, 22 Jan 2009 14:16:03 -0500
Message-Id: <1232651764-10799-2-git-send-email-jlayton@redhat.com>
In-Reply-To: <1232651764-10799-1-git-send-email-jlayton@redhat.com>
References: <1232651764-10799-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dlm_posix_get fills out the relevant fields in the file_lock before
returning when there is a lock conflict, but doesn't clean out any of
the other fields in the file_lock.

When nfsd does a NFSv4 lockt call, it sets the fl_lmops to
nfsd_posix_mng_ops before calling the lower fs. When the lock comes back
after testing a lock on GFS2, it still has that field set. This confuses
nfsd into thinking that the file_lock is a nfsd4 lock.

Fix this by making DLM reinitialize the file_lock before copying the
fields from the conflicting lock.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/dlm/plock.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index eba87ff..ca46f11 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -304,7 +304,9 @@ int dlm_posix_get(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 	if (rv == -ENOENT)
 		rv = 0;
 	else if (rv > 0) {
+		locks_init_lock(fl);
 		fl->fl_type = (op->info.ex) ? F_WRLCK : F_RDLCK;
+		fl->fl_flags = FL_POSIX;
 		fl->fl_pid = op->info.pid;
 		fl->fl_start = op->info.start;
 		fl->fl_end = op->info.end;
-- 
1.5.5.6

