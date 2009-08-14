Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbZHNUSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbZHNUSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757129AbZHNUSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:18:40 -0400
Received: from sparc.brc.ubc.ca ([137.82.2.12]:55453 "EHLO sparc.brc.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757127AbZHNUSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:18:40 -0400
From: Vincent Li <macli@brc.ubc.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Vincent Li <macli@brc.ubc.ca>
Subject: [PATCH] fs/proc/base.c: fix proc_fault_inject_write() input sanity check
Date: Fri, 14 Aug 2009 13:18:40 -0700
Message-Id: <1250281120-3308-1-git-send-email-macli@brc.ubc.ca>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove obfuscated zero-length input check and return -EINVAL instead of -EIO error
to make the error message clear to user. Add whitespace stripping. No functionality changes.

The old code:

echo  1  > /proc/pid/make-it-fail (ok)
echo 1foo > /proc/pid/make-it-fail (-bash: echo: write error: Input/output error)

The new code:

echo  1  > /proc/pid/make-it-fail (ok)
echo 1foo > /proc/pid/make-it-fail (-bash: echo: write error: Invalid argument)

This patch is conservative in changes to not breaking existing scripts/applications.
based on v2.6.31-rc6, compiled and tested ok.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
---
 fs/proc/base.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 175db25..ba345d9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1182,17 +1182,16 @@ static ssize_t proc_fault_inject_write(struct file * file,
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	make_it_fail = simple_strtol(buffer, &end, 0);
-	if (*end == '\n')
-		end++;
+	make_it_fail = simple_strtol(strstrip(buffer), &end, 0);
+	if (*end)
+		return -EINVAL;
 	task = get_proc_task(file->f_dentry->d_inode);
 	if (!task)
 		return -ESRCH;
 	task->make_it_fail = make_it_fail;
 	put_task_struct(task);
-	if (end - buffer == 0)
-		return -EIO;
-	return end - buffer;
+
+	return count;
 }
 
 static const struct file_operations proc_fault_inject_operations = {
-- 
1.6.0.4

