Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZIYHqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZIYHqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZIYHqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:46:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbZIYHqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:46:21 -0400
Date: Fri, 25 Sep 2009 03:37:14 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>,
       Amerigo Wang <amwang@redhat.com>
Message-Id: <20090925073948.4147.839.sendpatchset@localhost.localdomain>
Subject: [Patch] vfs: use {set,get}_max_files()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the wrapper functions, {get,set}_max_files().

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>

---
diff --git a/fs/file_table.c b/fs/file_table.c
index 8eb4404..840f71d 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -70,6 +70,11 @@ int get_max_files(void)
 }
 EXPORT_SYMBOL_GPL(get_max_files);
 
+static void set_max_files(int new_value)
+{
+	files_stat.max_files = new_value;
+}
+
 /*
  * Handle nr_files sysctl
  */
@@ -107,12 +112,12 @@ struct file *get_empty_filp(void)
 	/*
 	 * Privileged users can go above max_files
 	 */
-	if (get_nr_files() >= files_stat.max_files && !capable(CAP_SYS_ADMIN)) {
+	if (get_nr_files() >= get_max_files() && !capable(CAP_SYS_ADMIN)) {
 		/*
 		 * percpu_counters are inaccurate.  Do an expensive check before
 		 * we go and fail.
 		 */
-		if (percpu_counter_sum_positive(&nr_files) >= files_stat.max_files)
+		if (percpu_counter_sum_positive(&nr_files) >= get_max_files())
 			goto over;
 	}
 
@@ -450,9 +455,9 @@ void __init files_init(unsigned long mempages)
 	 */ 
 
 	n = (mempages * (PAGE_SIZE / 1024)) / 10;
-	files_stat.max_files = n; 
-	if (files_stat.max_files < NR_FILE)
-		files_stat.max_files = NR_FILE;
+	set_max_files(n);
+	if (get_max_files() < NR_FILE)
+		set_max_files(NR_FILE);
 	files_defer_init();
 	percpu_counter_init(&nr_files, 0);
 } 
