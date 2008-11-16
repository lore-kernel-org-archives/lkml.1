Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYKPExd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYKPExd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYKPExZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:53:25 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:13640 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbYKPExY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:53:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=pi3GYJ2Kgmk5go8v23ENzvrfCQHRHSHoI3Qq+8yZFja4+4AuRHA2ekPs1ZdubBXqrP
         If9NCuEc8W4VYNwFXL/HyINc5K96xSy2Du33eSF/rDgGlqx3qjNw9Dwbr+DG6jn8cnGS
         PKcJQHgs+j8PcA0wqUk5V/0MFNiBsYEI0acl0=
Message-ID: <491FA73F.9080401@gmail.com>
Date: Sun, 16 Nov 2008 05:53:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] tracing/ftrace: Fixes unexpected -EINVAL when longest
 tracer name is set
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Corrects return value from tracing_set_trace_write

The following commit d9e540762f5cdd89f24e518ad1fd31142d0b9726 remade
alive the bug which made the set of a new tracer returning -EINVAL if
this is the longest name of tracer.
This patch corrects it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4a90462..2d5672d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2655,6 +2655,9 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 	char buf[max_tracer_type_len+1];
 	int i;
 	size_t ret;
+	int err;
+
+	ret = cnt;
 
 	if (cnt > max_tracer_type_len)
 		cnt = max_tracer_type_len;
@@ -2668,12 +2671,11 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 	for (i = cnt - 1; i > 0 && isspace(buf[i]); i--)
 		buf[i] = 0;
 
-	ret = tracing_set_tracer(buf);
-	if (!ret)
-		ret = cnt;
+	err = tracing_set_tracer(buf);
+	if (err)
+		return err;
 
-	if (ret > 0)
-		filp->f_pos += ret;
+	filp->f_pos += ret;
 
 	return ret;
 }
-- 
1.5.2.5
