Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484Ab0AZWRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0AZWRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004Ab0AZWRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:17:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab0AZWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:17:15 -0500
X-Authority-Analysis: v=1.0 c=1 a=4RuTwoS-Cn8A:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=OPa1YJ-o9gJhTFxU0ukA:9 a=ZEgAo0MxMsIjphLjBT8A:7 a=rR99mWNiu_PTeS1TkJGAq5sOBbIA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100126221712.447066697@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 17:09:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/5] tracing: Prevent kernel oops with corrupted buffer
References: <20100126220923.534282809@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Prevent-kernel-oops-with-corrupted-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the contents of the ftrace ring buffer gets corrupted and the trace
file is read, it could create a kernel oops (usualy just killing the user
task thread). This is caused by the checking of the pid in the buffer.
If the pid is negative, it still references the cmdline cache array,
which could point to an invalid address.

The simple fix is to test for negative PIDs.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0df1b0f..eac6875 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -951,6 +951,11 @@ void trace_find_cmdline(int pid, char comm[])
 		return;
 	}
 
+	if (WARN_ON_ONCE(pid < 0)) {
+		strcpy(comm, "<XXX>");
+		return;
+	}
+
 	if (pid > PID_MAX_DEFAULT) {
 		strcpy(comm, "<...>");
 		return;
-- 
1.6.5


