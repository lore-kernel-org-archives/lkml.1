Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYJ1PZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYJ1PZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYJ1PZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:25:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38840 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbYJ1PZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:25:20 -0400
Date: Tue, 28 Oct 2008 10:44:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linux Kernel <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ftrace: fix current_tracer error return
In-Reply-To: <c62985530810280202r694a23e8l5233d892b3aa4330@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810281039130.29482@gandalf.stny.rr.com>
References: <c62985530810271618n11a8b674w5a60deaa335fdcc2@mail.gmail.com>  <alpine.DEB.1.10.0810271935320.20039@gandalf.stny.rr.com>  <c62985530810271644y1df6a13xbcd9d89b7a17ad75@mail.gmail.com> <c62985530810280202r694a23e8l5233d892b3aa4330@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The commit (in linux-tip) c2931e05ec5965597cbfb79ad332d4a29aeceb23
 ( ftrace: return an error when setting a nonexistent tracer )
added useful code that would error when a bad tracer was written into
the current_tracer file.

But this had a bug if the amount written was more than the amount read by 
that code. The first iteration would set the tracer correctly, but since
it did not consume the rest of what was written (usually whitespace), the 
userspace utility would continue to write what was not consumed. This 
second iteration would fail to find a tracer and return -EINVAL. Funny 
thing is that the tracer would have already been set.

This patch just consumes all the data that is written to the file.


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-10-28 10:23:41.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-10-28 10:25:58.000000000 -0400
@@ -2399,9 +2399,10 @@ tracing_set_trace_write(struct file *fil
 	int i;
 	size_t ret;
 
+	ret = cnt;
+
 	if (cnt > max_tracer_type_len)
 		cnt = max_tracer_type_len;
-	ret = cnt;
 
 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
@@ -2434,8 +2435,8 @@ tracing_set_trace_write(struct file *fil
  out:
 	mutex_unlock(&trace_types_lock);
 
-	if (ret == cnt)
-		filp->f_pos += cnt;
+	if (ret > 0)
+		filp->f_pos += ret;
 
 	return ret;
 }


