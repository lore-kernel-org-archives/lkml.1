Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbZCQGVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbZCQGVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 02:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZCQGVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 02:21:06 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:56675 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZCQGVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 02:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mfy7ko+n+SE0EESKSInSfz8OOFwk+uCPcqnpi2GkKSPRirltHPvYE/NdjYKs+0f+0W
         kbnV+WT4Ca6TyBnvAOczQxCjqFiIn6dhkIe4YeR/l2lXWY/Z6QaOfiftM3JhFrtKL2M5
         4dJpCb7vWcfR5XrejcwEs+BxOCJE2wlcS/gis=
Subject: [PATCH] tracing: fix leak in event_format_read()
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 01:20:59 -0500
Message-Id: <1237270859.8033.141.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If event_format_read() exits early due to nonzero ppos, the previously
kmalloc doesn't get freed - might as well do the check before the
kmalloc and avoid the problem.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace_events.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 238ea95..c88227b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -378,15 +378,15 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	char *buf;
 	int r;
 
+	if (*ppos)
+		return 0;
+
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
 
 	trace_seq_init(s);
 
-	if (*ppos)
-		return 0;
-
 	/* If any of the first writes fail, so will the show_format. */
 
 	trace_seq_printf(s, "name: %s\n", call->name);
-- 
1.5.6.3



