Return-Path: <linux-kernel-owner+w=401wt.eu-S935379AbZDBHUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935379AbZDBHUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933046AbZDBHSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:18:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57911 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1765968AbZDBHSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:18:45 -0400
Message-ID: <49D46674.9030804@cn.fujitsu.com>
Date: Thu, 02 Apr 2009 15:17:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] tracing: fix splice return too large
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



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
is not include "zero out any left over data" bytes.
But tracing_buffers_read() include these bytes, we make them
consistent.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d101c12..a7ea047 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3408,7 +3408,19 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
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
 
@@ -3447,7 +3459,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		spd.partial[i].offset = 0;
 		spd.partial[i].private = (unsigned long)ref;
 		spd.nr_pages++;
-		*ppos += size;
+		*ppos += PAGE_SIZE;
 	}
 
 	spd.nr_pages = i;




