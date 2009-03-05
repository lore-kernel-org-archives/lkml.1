Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZCEQlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZCEQlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZCEQj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:39:27 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:59678 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbZCEQjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:39:25 -0500
Subject: [RFC][PATCH 08/11] expose file checkpointability and reasoning in /proc
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 05 Mar 2009 08:39:09 -0800
References: <20090305163857.0C18F3FD@kernel>
In-Reply-To: <20090305163857.0C18F3FD@kernel>
Message-Id: <20090305163909.4204C711@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the first in a set of things that checked to
ensure that a process or entire container is
able to be checkpointed.


Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/proc/base.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/proc/base.c~proc-part-of-f_op-conversion fs/proc/base.c
--- linux-2.6.git/fs/proc/base.c~proc-part-of-f_op-conversion	2009-03-05 08:37:03.000000000 -0800
+++ linux-2.6.git-dave/fs/proc/base.c	2009-03-05 08:37:03.000000000 -0800
@@ -80,6 +80,7 @@
 #include <linux/oom.h>
 #include <linux/elf.h>
 #include <linux/pid_namespace.h>
+#include <linux/checkpoint.h>
 #include "internal.h"
 
 /* NOTE:
@@ -1645,6 +1646,7 @@ out:
 
 static void proc_fd_write_info(struct file *file, char *info)
 {
+	int checkpointable = 0;
 	int max = PROC_FDINFO_MAX;
 	int p = 0;
 	if (!info)
@@ -1652,6 +1654,12 @@ static void proc_fd_write_info(struct fi
 
 	p += scnprintf(info+p, max-p, "pos:\t%lli\n", (long long) file->f_pos);
 	p += scnprintf(info+p, max-p, "flags:\t0%o\n", file->f_flags);
+
+	if (file->f_op->checkpoint)
+		checkpointable = 1;
+	p += scnprintf(info+p, max-p, "checkpointable:\t%d", checkpointable);
+	if (!checkpointable)
+		p += cr_explain_file(file, info+p, max-p);
 }
 
 static int proc_fd_info(struct inode *inode, struct path *path, char *info)
_
