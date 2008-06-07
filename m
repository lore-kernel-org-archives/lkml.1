Return-Path: <linux-kernel-owner+w=401wt.eu-S1762998AbYFGBTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762998AbYFGBTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbYFGBJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:24 -0400
Received: from sous-sol.org ([216.99.217.87]:42493 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759592AbYFGBJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:20 -0400
Message-Id: <20080607010632.546163901@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:58 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Tuttle <ttuttle@google.com>, Matt Mackall <mpm@selenic.com>
Subject: [patch 43/50] pagemap: fix bug in add_to_pagemap, require aligned-length reads of /proc/pid/pagemap
Content-Disposition: inline; filename=pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Thomas Tuttle <ttuttle@google.com>

upstream commit: aae8679b0ebcaa92f99c1c3cb0cd651594a43915

Fix a bug in add_to_pagemap.  Previously, since pm->out was a char *,
put_user was only copying 1 byte of every PFN, resulting in the top 7
bytes of each PFN not being copied.  By requiring that reads be a multiple
of 8 bytes, I can make pm->out and pm->end u64*s instead of char*s, which
makes put_user work properly, and also simplifies the logic in
add_to_pagemap a bit.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Thomas Tuttle <ttuttle@google.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/proc/task_mmu.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -524,7 +524,7 @@ const struct file_operations proc_clear_
 };
 
 struct pagemapread {
-	char __user *out, *end;
+	u64 __user *out, *end;
 };
 
 #define PM_ENTRY_BYTES      sizeof(u64)
@@ -547,21 +547,11 @@ struct pagemapread {
 static int add_to_pagemap(unsigned long addr, u64 pfn,
 			  struct pagemapread *pm)
 {
-	/*
-	 * Make sure there's room in the buffer for an
-	 * entire entry.  Otherwise, only copy part of
-	 * the pfn.
-	 */
-	if (pm->out + PM_ENTRY_BYTES >= pm->end) {
-		if (copy_to_user(pm->out, &pfn, pm->end - pm->out))
-			return -EFAULT;
-		pm->out = pm->end;
-		return PM_END_OF_BUFFER;
-	}
-
 	if (put_user(pfn, pm->out))
 		return -EFAULT;
-	pm->out += PM_ENTRY_BYTES;
+	pm->out++;
+	if (pm->out >= pm->end)
+		return PM_END_OF_BUFFER;
 	return 0;
 }
 
@@ -662,7 +652,7 @@ static ssize_t pagemap_read(struct file 
 
 	ret = -EINVAL;
 	/* file position must be aligned */
-	if (*ppos % PM_ENTRY_BYTES)
+	if ((*ppos % PM_ENTRY_BYTES) || (count % PM_ENTRY_BYTES))
 		goto out_task;
 
 	ret = 0;
@@ -692,8 +682,8 @@ static ssize_t pagemap_read(struct file 
 		goto out_pages;
 	}
 
-	pm.out = buf;
-	pm.end = buf + count;
+	pm.out = (u64 *)buf;
+	pm.end = (u64 *)(buf + count);
 
 	if (!ptrace_may_attach(task)) {
 		ret = -EIO;
@@ -718,9 +708,9 @@ static ssize_t pagemap_read(struct file 
 		if (ret == PM_END_OF_BUFFER)
 			ret = 0;
 		/* don't need mmap_sem for these, but this looks cleaner */
-		*ppos += pm.out - buf;
+		*ppos += (char *)pm.out - buf;
 		if (!ret)
-			ret = pm.out - buf;
+			ret = (char *)pm.out - buf;
 	}
 
 out_pages:

-- 
