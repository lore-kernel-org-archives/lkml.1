Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbXEMUJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbXEMUJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbXEMUI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:08:58 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:58212 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbXEMUI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:08:57 -0400
Date: Sun, 13 May 2007 23:08:41 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH] make sysctl/kernel/core_pattern and fs/exec.c agree on maximum core filename size
Message-ID: <20070513200841.GA31736@localdomain>
References: <20070513173122.GA31737@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513173122.GA31737@localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sysctl/kernel/core_pattern and fs/exec.c agree on maximum 
core filename size and change it to 128, so that extensive patterns 
such as '/local/cores/%e-%h-%s-%t-%p.core' won't result in 
truncated filename generation.

Signed-off-by: Dan Aloni <da-x@monatomic.org>

diff --git a/fs/exec.c b/fs/exec.c
index 70fa365..0b68588 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -60,7 +60,7 @@
 #endif
 
 int core_uses_pid;
-char core_pattern[128] = "core";
+char core_pattern[CORENAME_MAX_SIZE] = "core";
 int suid_dumpable = 0;
 
 EXPORT_SYMBOL(suid_dumpable);
@@ -1264,8 +1264,6 @@ int set_binfmt(struct linux_binfmt *new)
 
 EXPORT_SYMBOL(set_binfmt);
 
-#define CORENAME_MAX_SIZE 64
-
 /* format_corename will inspect the pattern parameter, and output a
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 2d956cd..e1a7083 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -17,6 +17,8 @@ struct pt_regs;
 
 #ifdef __KERNEL__
 
+#define CORENAME_MAX_SIZE 128
+
 /*
  * This structure is used to hold the arguments that are used when loading binaries.
  */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4073353..30ee462 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -227,7 +227,7 @@ static ctl_table kern_table[] = {
 		.ctl_name	= KERN_CORE_PATTERN,
 		.procname	= "core_pattern",
 		.data		= core_pattern,
-		.maxlen		= 128,
+		.maxlen		= CORENAME_MAX_SIZE,
 		.mode		= 0644,
 		.proc_handler	= &proc_dostring,
 		.strategy	= &sysctl_string,

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
