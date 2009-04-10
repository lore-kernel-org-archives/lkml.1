Return-Path: <linux-kernel-owner+w=401wt.eu-S935207AbZDJLJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935207AbZDJLJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934047AbZDJLJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:09:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:45294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932737AbZDJLJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:09:04 -0400
Date: Fri, 10 Apr 2009 11:07:24 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49D46674.9030804@cn.fujitsu.com>
References: <49D46674.9030804@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing: fix splice return too large
Message-ID: <tip-93cfb3c9fd83d877a8f1ffad9ff862b617b32828@git.kernel.org>
Git-Commit-ID: 93cfb3c9fd83d877a8f1ffad9ff862b617b32828
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 11:07:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93cfb3c9fd83d877a8f1ffad9ff862b617b32828
Gitweb:     http://git.kernel.org/tip/93cfb3c9fd83d877a8f1ffad9ff862b617b32828
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Thu, 2 Apr 2009 15:17:08 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 12:44:46 +0200

tracing: fix splice return too large

I got these from strace:

 splice(0x3, 0, 0x5, 0, 0x1000, 0x1) = 12288
 splice(0x3, 0, 0x5, 0, 0x1000, 0x1) = 12288
 splice(0x3, 0, 0x5, 0, 0x1000, 0x1) = 12288
 splice(0x3, 0, 0x5, 0, 0x1000, 0x1) = 16384
 splice(0x3, 0, 0x5, 0, 0x1000, 0x1) = 8192
 splice(0x3, 0, 0x5, 0, 0x1000, 0x1) = 8192
 splice(0x3, 0, 0x5, 0, 0x1000, 0x1) = 8192

I wanted to splice_read 4096 bytes, but it returns 8192 or larger.

It is because the return value of tracing_buffers_splice_read()
does not include "zero out any left over data" bytes.

But tracing_buffers_read() includes these bytes, we make them
consistent.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <49D46674.9030804@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9462976..1ce5dc6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3428,7 +3428,19 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 	int size, i;
 	size_t ret;
 
-	for (i = 0; i < PIPE_BUFFERS && len; i++, len -= size) {
+	if (*ppos & (PAGE_SIZE - 1)) {
+		WARN_ONCE(1, "Ftrace: previous read must page-align\n");
+		return -EINVAL;
+	}
+
+	if (len & (PAGE_SIZE - 1)) {
+		WARN_ONCE(1, "Ftrace: splice_read should page-align\n");
+		if (len < PAGE_SIZE)
+			return -EINVAL;
+		len &= PAGE_MASK;
+	}
+
+	for (i = 0; i < PIPE_BUFFERS && len; i++, len -= PAGE_SIZE) {
 		struct page *page;
 		int r;
 
@@ -3467,7 +3479,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		spd.partial[i].offset = 0;
 		spd.partial[i].private = (unsigned long)ref;
 		spd.nr_pages++;
-		*ppos += size;
+		*ppos += PAGE_SIZE;
 	}
 
 	spd.nr_pages = i;
