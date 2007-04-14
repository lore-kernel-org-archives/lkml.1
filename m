Return-Path: <linux-kernel-owner+w=401wt.eu-S1751326AbXDNXNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbXDNXNB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 19:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXDNXNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 19:13:01 -0400
Received: from mx2.netapp.com ([216.240.18.37]:38347 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbXDNXNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 19:13:00 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2007 19:13:00 EDT
X-IronPort-AV: i="4.14,411,1170662400"; 
   d="scan'208"; a="51169094:sNHT1182860588"
Subject: NFS: Fix two bugs in the O_DIRECT write code
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       "Mr. Charles Edward Lever" <Chuck.Lever@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Sat, 14 Apr 2007 19:11:52 -0400
Message-Id: <1176592312.6089.29.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 14 Apr 2007 23:11:58.0168 (UTC) FILETIME=[4CF15580:01C77EEA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do not flag an error if the COMMIT call fails and we decide to resend the
writes. Let the resend flag the error if it fails.

If a write has failed, then nfs_direct_write_result should not attempt to
send a commit. It should just exit asap and return the error to the user.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
---

 fs/nfs/direct.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index b1c98ea..2877744 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -432,10 +432,10 @@ static void nfs_direct_commit_result(struct rpc_task *task, void *calldata)
 	if (NFS_PROTO(data->inode)->commit_done(task, data) != 0)
 		return;
 	if (unlikely(task->tk_status < 0)) {
-		dreq->error = task->tk_status;
+		dprintk("NFS: %5u commit failed with error %d.\n",
+				task->tk_pid, task->tk_status);
 		dreq->flags = NFS_ODIRECT_RESCHED_WRITES;
-	}
-	if (memcmp(&dreq->verf, &data->verf, sizeof(data->verf))) {
+	} else if (memcmp(&dreq->verf, &data->verf, sizeof(data->verf))) {
 		dprintk("NFS: %5u commit verify failed\n", task->tk_pid);
 		dreq->flags = NFS_ODIRECT_RESCHED_WRITES;
 	}
@@ -531,9 +531,12 @@ static void nfs_direct_write_result(struct rpc_task *task, void *calldata)
 
 	spin_lock(&dreq->lock);
 
+	if (unlikely(dreq->error != 0))
+		goto out_unlock;
 	if (unlikely(status < 0)) {
+		/* An error has occured, so we should not commit */
+		dreq->flags = 0;
 		dreq->error = status;
-		goto out_unlock;
 	}
 
 	dreq->count += data->res.count;
