Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270AbZHVU6I (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 22 Aug 2009 16:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbZHVU6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 16:58:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51048 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690AbZHVU4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 16:56:53 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
   josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip] v3 Use debugfs_remove_recursive() simplify code.
Date: Sat, 22 Aug 2009 13:56:50 -0700
Message-Id: <12509746132173-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090727181401.GA14120@linux.vnet.ibm.com>
References: <20090727181401.GA14120@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Suggested by Josh Triplett.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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
 
 
-- 
1.5.2.5

