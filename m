Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbXH0Ldi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbXH0Ldi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 07:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbXH0Lcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 07:32:54 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49487 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755048AbXH0Lcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 07:32:52 -0400
Message-ID: <388214369.67692@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070827113249.173435849@mail.ustc.edu.cn>
References: <20070827112152.816663278@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 19:21:54 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@osdl.org>, Jens Axboe <jens.axboe@oracle.com>,
       David Chinner <dgc@sgi.com>, Ken Chen <kenchen@google.com>,
       Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] writeback: introduce dirty_volatile_interval
Content-Disposition: inline; filename=writeback-young_protect_interval.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce dirty_volatile_interval for the minimal dirty time.
Inodes dirtied less than dirty_volatile_interval will not be
considered for syncing by kupdate-style writeback.

This new parameter will be used in clustered writeback.
The old dirty_expire_interval is still(but less) respected.

Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: David Chinner <dgc@sgi.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Andrew Morton <akpm@osdl.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/writeback.h |    1 +
 kernel/sysctl.c           |    7 +++++++
 mm/page-writeback.c       |    5 +++++
 3 files changed, 13 insertions(+)

--- linux-2.6.23-rc3-mm1.orig/include/linux/writeback.h
+++ linux-2.6.23-rc3-mm1/include/linux/writeback.h
@@ -101,6 +101,7 @@ extern int dirty_background_ratio;
 extern int vm_dirty_ratio;
 extern int dirty_writeback_interval;
 extern int dirty_expire_interval;
+extern int dirty_volatile_interval;
 extern int block_dump;
 extern int laptop_mode;
 
--- linux-2.6.23-rc3-mm1.orig/mm/page-writeback.c
+++ linux-2.6.23-rc3-mm1/mm/page-writeback.c
@@ -85,6 +85,11 @@ int dirty_writeback_interval = 5 * HZ;
 int dirty_expire_interval = 30 * HZ;
 
 /*
+ * The shortest number of jiffies for which data should remain dirty
+ */
+int dirty_volatile_interval = 5 * HZ;
+
+/*
  * Flag that makes the machine dump writes/reads and block dirtyings.
  */
 int block_dump;
--- linux-2.6.23-rc3-mm1.orig/kernel/sysctl.c
+++ linux-2.6.23-rc3-mm1/kernel/sysctl.c
@@ -837,6 +837,13 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec_userhz_jiffies,
 	},
 	{
+		.procname	= "dirty_volatile_centisecs",
+		.data		= &dirty_volatile_interval,
+		.maxlen		= sizeof(dirty_volatile_interval),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_userhz_jiffies,
+	},
+	{
 		.ctl_name	= VM_NR_PDFLUSH_THREADS,
 		.procname	= "nr_pdflush_threads",
 		.data		= &nr_pdflush_threads,

-- 
