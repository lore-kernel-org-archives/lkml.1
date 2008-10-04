Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYJDUFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYJDUFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYJDUE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:04:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:17323 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbYJDUEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:04:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=uepXskw9hqyQHz9/+Og7LH8N6maDuLWmuf0342ziUwIPkHIqn56tRTw8jpMKsQMaDH
         7xKPYr/Mca4wahSY8OOw8Z5FUyYUwrAE7bInsursCaoBD2Qy+kD2JlFXxoeKYfT9eVDd
         70vQdG9tLZnCIH4zoYV3xbcq1hRIHr0tmM1Yk=
Message-ID: <48E7CC5C.7080306@gmail.com>
Date: Sat, 04 Oct 2008 22:04:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: [PATCH -tip] Return an error when setting a nonexistent tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When one try to set a nonexistent tracer, no error is returned
as if the name of the tracer was correct.
We should return -EINVAL.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1cd2e81..9b30473 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2384,9 +2384,11 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 	struct tracer *t;
 	char buf[max_tracer_type_len+1];
 	int i;
+	size_t ret;
 
 	if (cnt > max_tracer_type_len)
 		cnt = max_tracer_type_len;
+	ret = cnt;
 
 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
@@ -2402,7 +2404,11 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 		if (strcmp(t->name, buf) == 0)
 			break;
 	}
-	if (!t || t == current_trace)
+	if (!t) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (t == current_trace)
 		goto out;
 
 	if (current_trace && current_trace->reset)
@@ -2415,9 +2421,10 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
  out:
 	mutex_unlock(&trace_types_lock);
 
-	filp->f_pos += cnt;
+	if (ret == cnt)
+		filp->f_pos += cnt;
 
-	return cnt;
+	return ret;
 }
 
 static ssize_t
