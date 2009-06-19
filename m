Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbZFSHUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbZFSHUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZFSHU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:20:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44623 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbZFSHU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:20:26 -0400
Date: Fri, 19 Jun 2009 03:19:57 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>
Message-Id: <20090619072212.6519.10915.sendpatchset@localhost.localdomain>
Subject: [Patch] sysctl: forbid too long numbers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For some file under /proc/sys/kernel, the valid values for them
are < ULONG_MAX if they don't have they own max value defined. Thus,
numbers longer than are invalid.

So use strict_strtoul() instead of simple_strtoul(), and
make strict_strtoul() more strict.

[I don't know whom I should Cc...]
Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ab462b9..bc27e00 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2331,7 +2331,8 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 			if (*p < '0' || *p > '9')
 				break;
 
-			lval = simple_strtoul(p, &p, 0);
+			if (strict_strtoul(p, 0, &lval))
+				return -EINVAL;
 
 			len = p-buf;
 			if ((len < left) && *p && !isspace(*p))
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 756ccaf..ff2ca5c 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -163,11 +163,14 @@ int strict_strtoul(const char *cp, unsigned int base, unsigned long *res)
 	char *tail;
 	unsigned long val;
 	size_t len;
+	char tmp[32];
 
 	*res = 0;
 	len = strlen(cp);
 	if (len == 0)
 		return -EINVAL;
+	if (len > snprintf(tmp, "%ld", ULONG_MAX))
+		return -EINVAL;
 
 	val = simple_strtoul(cp, &tail, base);
 	if (tail == cp)
