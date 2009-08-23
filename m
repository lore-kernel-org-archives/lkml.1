Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZHWJDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZHWJDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZHWJDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:03:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:36970 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916AbZHWJDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:03:06 -0400
Date: Sun, 23 Aug 2009 09:02:44 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12509746132173-git-send-email->
References: <12509746132173-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Use debugfs_remove_recursive() simplify code.
Message-ID: <tip-22f00b69f6a7e1e18e821979a23e8307c2de9888@git.kernel.org>
Git-Commit-ID: 22f00b69f6a7e1e18e821979a23e8307c2de9888
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 23 Aug 2009 09:02:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22f00b69f6a7e1e18e821979a23e8307c2de9888
Gitweb:     http://git.kernel.org/tip/22f00b69f6a7e1e18e821979a23e8307c2de9888
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sat, 22 Aug 2009 13:56:50 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 23 Aug 2009 10:32:39 +0200

rcu: Use debugfs_remove_recursive() simplify code.

Suggested by Josh Triplett.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josht@linux.vnet.ibm.com
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
LKML-Reference: <12509746132173-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutree_trace.c |   45 +++++++++++++++------------------------------
 1 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index ea4a474..31af3a0 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -265,62 +265,47 @@ static struct file_operations rcu_pending_fops = {
 };
 
 static struct dentry *rcudir;
-static struct dentry *datadir;
-static struct dentry *datadir_csv;
-static struct dentry *gpdir;
-static struct dentry *hierdir;
-static struct dentry *rcu_pendingdir;
 
 static int __init rcuclassic_trace_init(void)
 {
+	struct dentry *retval;
+
 	rcudir = debugfs_create_dir("rcu", NULL);
 	if (!rcudir)
-		goto out;
+		goto free_out;
 
-	datadir = debugfs_create_file("rcudata", 0444, rcudir,
+	retval = debugfs_create_file("rcudata", 0444, rcudir,
 						NULL, &rcudata_fops);
-	if (!datadir)
+	if (!retval)
 		goto free_out;
 
-	datadir_csv = debugfs_create_file("rcudata.csv", 0444, rcudir,
+	retval = debugfs_create_file("rcudata.csv", 0444, rcudir,
 						NULL, &rcudata_csv_fops);
-	if (!datadir_csv)
+	if (!retval)
 		goto free_out;
 
-	gpdir = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
-	if (!gpdir)
+	retval = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
+	if (!retval)
 		goto free_out;
 
-	hierdir = debugfs_create_file("rcuhier", 0444, rcudir,
+	retval = debugfs_create_file("rcuhier", 0444, rcudir,
 						NULL, &rcuhier_fops);
-	if (!hierdir)
+	if (!retval)
 		goto free_out;
 
-	rcu_pendingdir = debugfs_create_file("rcu_pending", 0444, rcudir,
+	retval = debugfs_create_file("rcu_pending", 0444, rcudir,
 						NULL, &rcu_pending_fops);
-	if (!rcu_pendingdir)
+	if (!retval)
 		goto free_out;
 	return 0;
 free_out:
-	if (datadir)
-		debugfs_remove(datadir);
-	if (datadir_csv)
-		debugfs_remove(datadir_csv);
-	if (gpdir)
-		debugfs_remove(gpdir);
-	debugfs_remove(rcudir);
-out:
+	debugfs_remove_recursive(rcudir);
 	return 1;
 }
 
 static void __exit rcuclassic_trace_cleanup(void)
 {
-	debugfs_remove(datadir);
-	debugfs_remove(datadir_csv);
-	debugfs_remove(gpdir);
-	debugfs_remove(hierdir);
-	debugfs_remove(rcu_pendingdir);
-	debugfs_remove(rcudir);
+	debugfs_remove_recursive(rcudir);
 }
 
 
