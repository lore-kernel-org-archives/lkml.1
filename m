Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbZBSSWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbZBSSWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZBSSUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:20:23 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:41407 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbZBSSUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:20:18 -0500
Subject: [RFC][PATCH 5/5] add c/r info to fdinfo
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 19 Feb 2009 10:20:13 -0800
References: <20090219182007.B4B47C1F@kernel>
In-Reply-To: <20090219182007.B4B47C1F@kernel>
Message-Id: <20090219182013.28FF8F42@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the new checkpoint/restart file functions to query
and report on each fd in the /proc/$$/fdinfo/X file.

This should provide an easy way to examine processes
at runtime to see what exactly is causing their inability
to checkpoint.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/proc/base.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/proc/base.c~add-cr-part-to-fdinfo fs/proc/base.c
--- linux-2.6.git/fs/proc/base.c~add-cr-part-to-fdinfo	2009-02-19 10:17:26.000000000 -0800
+++ linux-2.6.git-dave/fs/proc/base.c	2009-02-19 10:17:26.000000000 -0800
@@ -79,6 +79,7 @@
 #include <linux/oom.h>
 #include <linux/elf.h>
 #include <linux/pid_namespace.h>
+#include <linux/checkpoint.h>
 #include "internal.h"
 
 /* NOTE:
@@ -1601,6 +1602,7 @@ out:
 
 static void proc_fd_write_info(struct file *file, char *info)
 {
+	int checkpointable;
 	int max = PROC_FDINFO_MAX;
 	int p = 0;
 	if (!info)
@@ -1608,6 +1610,12 @@ static void proc_fd_write_info(struct fi
 
 	p += snprintf(info+p, max-p, "pos:\t%lli\n", (long long) file->f_pos);
 	p += snprintf(info+p, max-p, "flags:\t0%o\n", file->f_flags);
+
+	checkpointable = cr_file_supported(file);
+	p += snprintf(info+p, max-p, "checkpointable:\t%d", checkpointable);
+	if (!checkpointable)
+		p += cr_explain_file(file, info+p, max-p);
+	p += snprintf(info+p, max-p, "\n");
 }
 
 static int proc_fd_info(struct inode *inode, struct path *path, char *info)
_
