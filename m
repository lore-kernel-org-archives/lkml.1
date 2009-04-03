Return-Path: <linux-kernel-owner+w=401wt.eu-S1764124AbZDCMz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764124AbZDCMz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbZDCMzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:55:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:40789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbZDCMzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:55:44 -0400
Date: Fri, 3 Apr 2009 12:51:30 GMT
From: Carl Henrik Lunde <chlunde@ping.uio.no>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, alan.brunelle@hp.com,
       chlunde@ping.uio.no, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, alan.brunelle@hp.com,
       chlunde@ping.uio.no, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090403122714.GT5178@kernel.dk>
References: <20090403122714.GT5178@kernel.dk>
Subject: [tip:tracing/blktrace-v2] blktrace: NUL-terminate user space messages
Message-ID: <tip-a4b3ada83d06554d307dd54abdc62b2e5648264a@git.kernel.org>
Git-Commit-ID: a4b3ada83d06554d307dd54abdc62b2e5648264a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 12:51:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4b3ada83d06554d307dd54abdc62b2e5648264a
Gitweb:     http://git.kernel.org/tip/a4b3ada83d06554d307dd54abdc62b2e5648264a
Author:     Carl Henrik Lunde <chlunde@ping.uio.no>
AuthorDate: Fri, 3 Apr 2009 14:27:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 14:46:22 +0200

blktrace: NUL-terminate user space messages

Impact: fix corrupted blkparse output

Make sure messages from user space are NUL-terminated strings,
otherwise we could dump random memory to the block trace file.

Additionally, I've limited the message to BLK_TN_MAX_MSG-1
characters, because the last character would be stripped by
vscnprintf anyway.

Signed-off-by: Carl Henrik Lunde <chlunde@ping.uio.no>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "Alan D. Brunelle" <alan.brunelle@hp.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090403122714.GT5178@kernel.dk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 947c5b3..a400b86 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -327,10 +327,10 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
 	char *msg;
 	struct blk_trace *bt;
 
-	if (count > BLK_TN_MAX_MSG)
+	if (count > BLK_TN_MAX_MSG - 1)
 		return -EINVAL;
 
-	msg = kmalloc(count, GFP_KERNEL);
+	msg = kmalloc(count + 1, GFP_KERNEL);
 	if (msg == NULL)
 		return -ENOMEM;
 
@@ -339,6 +339,7 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
 		return -EFAULT;
 	}
 
+	msg[count] = '\0';
 	bt = filp->private_data;
 	__trace_note_message(bt, "%s", msg);
 	kfree(msg);
