Return-Path: <linux-kernel-owner+w=401wt.eu-S934206AbZDBHTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206AbZDBHTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761566AbZDBHSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:18:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52794 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758610AbZDBHSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:18:41 -0400
Message-ID: <49D46670.4010503@cn.fujitsu.com>
Date: Thu, 02 Apr 2009 15:17:04 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] tracing: update file->f_pos when splice(2) it
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2a81dec..d101c12 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3408,13 +3408,6 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
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
@@ -3454,6 +3447,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		spd.partial[i].offset = 0;
 		spd.partial[i].private = (unsigned long)ref;
 		spd.nr_pages++;
+		*ppos += size;
 	}
 
 	spd.nr_pages = i;







