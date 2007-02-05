Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbXBEOgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbXBEOgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932941AbXBEOgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:36:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932874AbXBEOf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:35:59 -0500
Subject: [GFS2] make lock_dlm drop_count tunable in sysfs [46/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:44:04 +0000
Message-Id: <1170686644.11001.363.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 05acac8420a6e24fc892d0ae88b2f1e7606f8524 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Thu, 25 Jan 2007 14:24:04 -0600
Subject: [PATCH] [GFS2] make lock_dlm drop_count tunable in sysfs

We want to be able to change or disable the default drop_count (number at
which the dlm asks gfs to limit the the number of locks it's holding).
Add it to the collection of sysfs tunables for an fs.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/main.c b/fs/gfs2/locking/dlm/main.c
index 2194b1d..a0e7eda 100644
--- a/fs/gfs2/locking/dlm/main.c
+++ b/fs/gfs2/locking/dlm/main.c
@@ -11,9 +11,6 @@
 
 #include "lock_dlm.h"
 
-extern int gdlm_drop_count;
-extern int gdlm_drop_period;
-
 extern struct lm_lockops gdlm_ops;
 
 static int __init init_lock_dlm(void)
@@ -40,9 +37,6 @@ static int __init init_lock_dlm(void)
 		return error;
 	}
 
-	gdlm_drop_count = GDLM_DROP_COUNT;
-	gdlm_drop_period = GDLM_DROP_PERIOD;
-
 	printk(KERN_INFO
 	       "Lock_DLM (built %s %s) installed\n", __DATE__, __TIME__);
 	return 0;
diff --git a/fs/gfs2/locking/dlm/mount.c b/fs/gfs2/locking/dlm/mount.c
index cdd1694..1d8faa3 100644
--- a/fs/gfs2/locking/dlm/mount.c
+++ b/fs/gfs2/locking/dlm/mount.c
@@ -9,8 +9,6 @@
 
 #include "lock_dlm.h"
 
-int gdlm_drop_count;
-int gdlm_drop_period;
 const struct lm_lockops gdlm_ops;
 
 
@@ -24,8 +22,8 @@ static struct gdlm_ls *init_gdlm(lm_callback_t cb, struct gfs2_sbd *sdp,
 	if (!ls)
 		return NULL;
 
-	ls->drop_locks_count = gdlm_drop_count;
-	ls->drop_locks_period = gdlm_drop_period;
+	ls->drop_locks_count = GDLM_DROP_COUNT;
+	ls->drop_locks_period = GDLM_DROP_PERIOD;
 	ls->fscb = cb;
 	ls->sdp = sdp;
 	ls->fsflags = flags;
diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index 29ae06f..4746b88 100644
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ b/fs/gfs2/locking/dlm/sysfs.c
@@ -116,6 +116,17 @@ static ssize_t recover_status_show(struct gdlm_ls *ls, char *buf)
 	return sprintf(buf, "%d\n", ls->recover_jid_status);
 }
 
+static ssize_t drop_count_show(struct gdlm_ls *ls, char *buf)
+{
+	return sprintf(buf, "%d\n", ls->drop_locks_count);
+}
+
+static ssize_t drop_count_store(struct gdlm_ls *ls, const char *buf, size_t len)
+{
+	ls->drop_locks_count = simple_strtol(buf, NULL, 0);
+	return len;
+}
+
 struct gdlm_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct gdlm_ls *, char *);
@@ -135,6 +146,7 @@ GDLM_ATTR(first_done,     0444, first_done_show,     NULL);
 GDLM_ATTR(recover,        0644, recover_show,        recover_store);
 GDLM_ATTR(recover_done,   0444, recover_done_show,   NULL);
 GDLM_ATTR(recover_status, 0444, recover_status_show, NULL);
+GDLM_ATTR(drop_count,     0644, drop_count_show,     drop_count_store);
 
 static struct attribute *gdlm_attrs[] = {
 	&gdlm_attr_proto_name.attr,
@@ -147,6 +159,7 @@ static struct attribute *gdlm_attrs[] = {
 	&gdlm_attr_recover.attr,
 	&gdlm_attr_recover_done.attr,
 	&gdlm_attr_recover_status.attr,
+	&gdlm_attr_drop_count.attr,
 	NULL,
 };
 
-- 
1.4.4.2



