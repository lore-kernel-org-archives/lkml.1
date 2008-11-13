Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYKMMWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYKMMWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 07:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYKMMWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 07:22:25 -0500
Received: from ns1.suse.de ([195.135.220.2]:49716 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbYKMMWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 07:22:24 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Make /proc/sys/vm/drop_caches write only
Date: Thu, 13 Nov 2008 17:54:11 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811131754.11863.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 /proc/sys/vm/drop_caches is used only to trigger dropping caches. It does not 
disable the cache. The ability to read the value written to this file long 
back gives wrong impression.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 3e5637f..9892e1b 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -66,11 +66,9 @@ int drop_caches_sysctl_handler(ctl_table *table, int write,
 	struct file *file, void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec_minmax(table, write, file, buffer, length, ppos);
-	if (write) {
-		if (sysctl_drop_caches & 1)
-			drop_pagecache();
-		if (sysctl_drop_caches & 2)
-			drop_slab();
-	}
+	if (sysctl_drop_caches & 1)
+		drop_pagecache();
+	if (sysctl_drop_caches & 2)
+		drop_slab();
 	return 0;
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9d048fa..dff3c13 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1015,7 +1015,7 @@ static struct ctl_table vm_table[] = {
 		.procname	= "drop_caches",
 		.data		= &sysctl_drop_caches,
 		.maxlen		= sizeof(int),
-		.mode		= 0644,
+		.mode		= 0200,
 		.proc_handler	= drop_caches_sysctl_handler,
 		.strategy	= &sysctl_intvec,
 	},

