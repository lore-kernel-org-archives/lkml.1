Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbZB0UhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbZB0UhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759871AbZB0Uel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:34:41 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52283 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759852AbZB0Uej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:34:39 -0500
Subject: [RFC][PATCH 7/8] add c/r info to fdinfo
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 27 Feb 2009 12:34:34 -0800
References: <20090227203425.F3B51176@kernel>
In-Reply-To: <20090227203425.F3B51176@kernel>
Message-Id: <20090227203434.D4729F99@kernel>
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
--- linux-2.6.git/fs/proc/base.c~add-cr-part-to-fdinfo	2009-02-27 12:07:40.000000000 -0800
+++ linux-2.6.git-dave/fs/proc/base.c	2009-02-27 12:07:40.000000000 -0800
@@ -80,6 +80,7 @@
 #include <linux/oom.h>
 #include <linux/elf.h>
 #include <linux/pid_namespace.h>
+#include <linux/checkpoint.h>
 #include "internal.h"
 
 /* NOTE:
@@ -1636,6 +1637,7 @@ out:
 
 static void proc_fd_write_info(struct file *file, char *info)
 {
+	int checkpointable;
 	int max = PROC_FDINFO_MAX;
 	int p = 0;
 	if (!info)
@@ -1643,6 +1645,12 @@ static void proc_fd_write_info(struct fi
 
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
