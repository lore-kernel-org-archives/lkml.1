Return-Path: <linux-kernel-owner+w=401wt.eu-S935468AbZDJLKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935468AbZDJLKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933915AbZDJLJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:09:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:45299 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118AbZDJLJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:09:11 -0400
Date: Fri, 10 Apr 2009 11:07:13 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49D46670.4010503@cn.fujitsu.com>
References: <49D46670.4010503@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing: update file->f_pos when splice(2) it
Message-ID: <tip-c7625a555f55d7ae49236cde551786c88f5a5ce1@git.kernel.org>
Git-Commit-ID: c7625a555f55d7ae49236cde551786c88f5a5ce1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 11:07:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7625a555f55d7ae49236cde551786c88f5a5ce1
Gitweb:     http://git.kernel.org/tip/c7625a555f55d7ae49236cde551786c88f5a5ce1
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Thu, 2 Apr 2009 15:17:04 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 12:44:44 +0200

tracing: update file->f_pos when splice(2) it

Impact: Cleanup

These two lines:

	if (unlikely(*ppos))
		return -ESPIPE;

in tracing_buffers_splice_read() are not needed, VFS layer
has disabled seek(2).

We remove these two lines, and then we can update file->f_pos.

And tracing_buffers_read() updates file->f_pos, this fix
make tracing_buffers_splice_read() updates file->f_pos too.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <49D46670.4010503@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8e189ff..9462976 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3428,13 +3428,6 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 	int size, i;
 	size_t ret;
 
-	/*
-	 * We can't seek on a buffer input
-	 */
-	if (unlikely(*ppos))
-		return -ESPIPE;
-
-
 	for (i = 0; i < PIPE_BUFFERS && len; i++, len -= size) {
 		struct page *page;
 		int r;
@@ -3474,6 +3467,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		spd.partial[i].offset = 0;
 		spd.partial[i].private = (unsigned long)ref;
 		spd.nr_pages++;
+		*ppos += size;
 	}
 
 	spd.nr_pages = i;
