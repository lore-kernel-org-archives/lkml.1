Return-Path: <linux-kernel-owner+w=401wt.eu-S1765978AbZGABSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765978AbZGABSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761543AbZGAAgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:36:00 -0400
Received: from kroah.org ([198.145.64.141]:60758 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761613AbZGAAfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:45 2009
Message-Id: <20090701002444.956184017@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sunil Mushran <sunil.mushran@oracle.com>,
       Joel Becker <joel.becker@oracle.com>
Subject: [patch 105/108] ocfs2: Fix ocfs2_osb_dump()
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ocfs2-fix-ocfs2_osb_dump.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sunil Mushran <sunil.mushran@oracle.com>

commit c3d38840abaa45c1c5a5fabbb8ffc9a0d1a764d1 upstream.

Skip printing information that is not valid for local mounts.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/super.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -232,20 +232,24 @@ static int ocfs2_osb_dump(struct ocfs2_s
 			"%10s => Opts: 0x%lX  AtimeQuanta: %u\n", "Mount",
 			osb->s_mount_opt, osb->s_atime_quantum);
 
-	out += snprintf(buf + out, len - out,
-			"%10s => Stack: %s  Name: %*s  Version: %d.%d\n",
-			"Cluster",
-			(*osb->osb_cluster_stack == '\0' ?
-			 "o2cb" : osb->osb_cluster_stack),
-			cconn->cc_namelen, cconn->cc_name,
-			cconn->cc_version.pv_major, cconn->cc_version.pv_minor);
+	if (cconn) {
+		out += snprintf(buf + out, len - out,
+				"%10s => Stack: %s  Name: %*s  "
+				"Version: %d.%d\n", "Cluster",
+				(*osb->osb_cluster_stack == '\0' ?
+				 "o2cb" : osb->osb_cluster_stack),
+				cconn->cc_namelen, cconn->cc_name,
+				cconn->cc_version.pv_major,
+				cconn->cc_version.pv_minor);
+	}
 
 	spin_lock(&osb->dc_task_lock);
 	out += snprintf(buf + out, len - out,
 			"%10s => Pid: %d  Count: %lu  WakeSeq: %lu  "
 			"WorkSeq: %lu\n", "DownCnvt",
-			task_pid_nr(osb->dc_task), osb->blocked_lock_count,
-			osb->dc_wake_sequence, osb->dc_work_sequence);
+			(osb->dc_task ?  task_pid_nr(osb->dc_task) : -1),
+			osb->blocked_lock_count, osb->dc_wake_sequence,
+			osb->dc_work_sequence);
 	spin_unlock(&osb->dc_task_lock);
 
 	spin_lock(&osb->osb_lock);
@@ -265,14 +269,15 @@ static int ocfs2_osb_dump(struct ocfs2_s
 
 	out += snprintf(buf + out, len - out,
 			"%10s => Pid: %d  Interval: %lu  Needs: %d\n", "Commit",
-			task_pid_nr(osb->commit_task), osb->osb_commit_interval,
+			(osb->commit_task ? task_pid_nr(osb->commit_task) : -1),
+			osb->osb_commit_interval,
 			atomic_read(&osb->needs_checkpoint));
 
 	out += snprintf(buf + out, len - out,
-			"%10s => State: %d  NumTxns: %d  TxnId: %lu\n",
+			"%10s => State: %d  TxnId: %lu  NumTxns: %d\n",
 			"Journal", osb->journal->j_state,
-			atomic_read(&osb->journal->j_num_trans),
-			osb->journal->j_trans_id);
+			osb->journal->j_trans_id,
+			atomic_read(&osb->journal->j_num_trans));
 
 	out += snprintf(buf + out, len - out,
 			"%10s => GlobalAllocs: %d  LocalAllocs: %d  "
@@ -300,7 +305,6 @@ static int ocfs2_osb_dump(struct ocfs2_s
 
 	out += snprintf(buf + out, len - out, "%10s => %3s  %10s\n",
 			"Slots", "Num", "RecoGen");
-
 	for (i = 0; i < osb->max_slots; ++i) {
 		out += snprintf(buf + out, len - out,
 				"%10s  %c %3d  %10d\n",


