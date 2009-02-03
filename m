Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZBCLdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZBCLdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZBCLde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:33:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51674 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZBCLdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:33:33 -0500
Date: Tue, 3 Feb 2009 12:33:19 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: /proc/sys/vm/drop_caches: add error handling
Message-ID: <20090203113319.GA2022@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Document that drop_caches is unsafe, and add error checking so that it
bails out on invalid inputs. [Note that this was triggered by Android
trying to use it in production, and incidentally writing invalid
value...]

Signed-off-by: Pavel Machek <pavel@suse.cz> 

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 3197fc8..b90f050 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -132,6 +132,10 @@ To free pagecache, dentries and inodes:
 As this is a non-destructive operation and dirty objects are not freeable, the
 user should run `sync' first.
 
+Note that calling this causes some serious latencies, and that this is
+a debug feature; it should not be used for production as it does not
+contain neccessary locking to guarantee safe operation.
+
 ==============================================================
 
 hugepages_treat_as_movable
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 3e5637f..765dec3 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -9,8 +9,9 @@
 #include <linux/sysctl.h>
 #include <linux/gfp.h>
 
-/* A global variable is a bit ugly, but it keeps the code simple */
-int sysctl_drop_caches;
+/* A global variable is a bit ugly, and has locking problems,
+   but it keeps the code simple */
+unsigned int sysctl_drop_caches;
 
 static void drop_pagecache_sb(struct super_block *sb)
 {
@@ -65,12 +66,17 @@ static void drop_slab(void)
 int drop_caches_sysctl_handler(ctl_table *table, int write,
 	struct file *file, void __user *buffer, size_t *length, loff_t *ppos)
 {
-	proc_dointvec_minmax(table, write, file, buffer, length, ppos);
-	if (write) {
-		if (sysctl_drop_caches & 1)
-			drop_pagecache();
-		if (sysctl_drop_caches & 2)
-			drop_slab();
-	}
-	return 0;
+	int res;
+	res = proc_dointvec_minmax(table, write, file, buffer, length, ppos);
+	if (res)
+		return res;
+	if (!write)
+		return res;
+	if (sysctl_drop_caches & ~3)
+		return -EINVAL;
+	if (sysctl_drop_caches & 1)
+		drop_pagecache();
+	if (sysctl_drop_caches & 2)
+		drop_slab();
+	return res;
 }



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
