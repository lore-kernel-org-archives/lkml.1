Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbZCED1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbZCED1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 22:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZCED1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 22:27:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43793 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbZCED1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 22:27:15 -0500
Message-Id: <20090305032712.764688306@goodmis.org>
References: <20090305032532.802709985@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Mar 2009 22:25:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/7] tracing: do not return EFAULT if read copied anything
Content-Disposition: inline; filename=0002-tracing-do-not-return-EFAULT-if-read-copied-anythin.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix trace read to conform to standards

Andrew Morton, Theodore Tso and H. Peter Anvin brought to my attention
that a userspace read should not return -EFAULT if it succeeded in
copying anything. It should only return -EFAULT if it failed to copy
at all.

This patch modifies the check of copy_from_user and updates the return
code appropriately.

I also used H. Peter Anvin's short cut rule to just test ret == count.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ab5cbca..57155dc 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -346,6 +346,9 @@ ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 	int len;
 	int ret;
 
+	if (!cnt)
+		return 0;
+
 	if (s->len <= s->readpos)
 		return -EBUSY;
 
@@ -353,9 +356,11 @@ ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 	if (cnt > len)
 		cnt = len;
 	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
-	if (ret)
+	if (ret == cnt)
 		return -EFAULT;
 
+	cnt -= ret;
+
 	s->readpos += len;
 	return cnt;
 }
@@ -3049,6 +3054,9 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 	ssize_t ret;
 	size_t size;
 
+	if (!count)
+		return 0;
+
 	/* Do we have previous read data to read? */
 	if (info->read < PAGE_SIZE)
 		goto read;
@@ -3073,8 +3081,10 @@ read:
 		size = count;
 
 	ret = copy_to_user(ubuf, info->spare + info->read, size);
-	if (ret)
+	if (ret == size)
 		return -EFAULT;
+	size -= ret;
+
 	*ppos += size;
 	info->read += size;
 
-- 
1.6.1.3

-- 
