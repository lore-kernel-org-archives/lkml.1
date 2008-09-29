Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYI2SYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYI2SYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbYI2SXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:23:55 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:57087 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbYI2SXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:23:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=S7dMVvXwzFp4ev9GK5fY4tdZkNjMbEiwkDCRrs41F66kLkQY3wmkQJXLwAOlWIuxlG
         2yhClfrzXJ/Q/NCmFd/XyBuq15oJt6/VcHyk7dUB8eZAY1HtXwJRt6GP1+XTfXpXKOUj
         7rd9gi3Y5KIJbXFdMceM3Oy9JPJGarkHShKhY=
Message-ID: <48E11D34.4000702@gmail.com>
Date: Mon, 29 Sep 2008 20:23:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org, pq@iki.fi, rostedt@goodmis.org
Subject: [PATCH -tip 2/4] Tracing/ftrace: Fix pipe breaking
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Paalanen <pq@iki.fi>

This patch fixes a bug which break the pipe when the seq is empty.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 61f33da..ed10a68 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2610,7 +2610,6 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
 	if (sret != -EBUSY)
 		return sret;
-	sret = 0;
 
 	trace_seq_reset(&iter->seq);
 
@@ -2621,6 +2620,8 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 			goto out;
 	}
 
+waitagain:
+	sret = 0;
 	while (trace_empty(iter)) {
 
 		if ((filp->f_flags & O_NONBLOCK)) {
@@ -2754,8 +2755,13 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
 	if (iter->seq.readpos >= iter->seq.len)
 		trace_seq_reset(&iter->seq);
+
+	/*
+	 * If there was nothing to send to user, inspite of consuming trace
+	 * entries, go back to wait for more entries.
+	 */
 	if (sret == -EBUSY)
-		sret = 0;
+		goto waitagain;
 
 out:
 	mutex_unlock(&trace_types_lock);
