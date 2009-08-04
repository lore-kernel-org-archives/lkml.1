Return-Path: <linux-kernel-owner+w=401wt.eu-S932689AbZHDK2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbZHDK2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932483AbZHDK2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:28:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40959 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465AbZHDK2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:28:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] oom: fix oom_adjust_write() input sanity check.
Cc: kosaki.motohiro@jp.fujitsu.com, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
References: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
Message-Id: <20090804192721.6A49.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  4 Aug 2009 19:28:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] oom: fix oom_adjust_write() input sanity check.

Andrew Morton pointed out oom_adjust_write() has very strange EIO
and new line handling. this patch fixes it.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>,
Cc: Andrew Morton <akpm@linux-foundation.org>,
---
 fs/proc/base.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: b/fs/proc/base.c
===================================================================
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1033,12 +1033,15 @@ static ssize_t oom_adjust_write(struct f
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
+
+	strstrip(buffer);
 	oom_adjust = simple_strtol(buffer, &end, 0);
+	if (*end)
+		return -EINVAL;
 	if ((oom_adjust < OOM_ADJUST_MIN || oom_adjust > OOM_ADJUST_MAX) &&
 	     oom_adjust != OOM_DISABLE)
 		return -EINVAL;
-	if (*end == '\n')
-		end++;
+
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
@@ -1057,9 +1060,8 @@ static ssize_t oom_adjust_write(struct f
 	task->signal->oom_adj = oom_adjust;
 	unlock_task_sighand(task, &flags);
 	put_task_struct(task);
-	if (end - buffer == 0)
-		return -EIO;
-	return end - buffer;
+
+	return count;
 }
 
 static const struct file_operations proc_oom_adjust_operations = {


