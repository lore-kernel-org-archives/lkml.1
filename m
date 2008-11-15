Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbYKOBh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbYKOBh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 20:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYKOBht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 20:37:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:33460 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYKOBhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 20:37:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=GVSQs8Z4tfjRFzvvRdJzWgSTbVLSBzmzW7XvQYbiLmZ7zdirL/edWV9pYtG2cFzi2h
         S5GhTBjYRhjN5kJVgrNsxY6dq+jTrTPUgfHKgN9jPU2M1/stdNJ6fgjb4mwdeWhNFs6x
         9idGv4WJneE+TvvooZVchuyeRh8oCk0u5/+KA=
Message-ID: <491E27E8.7050401@gmail.com>
Date: Sat, 15 Nov 2008 02:37:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] tracing/function-return-tracer: Add a barrier to ensure return
 stack index is incremented in memory
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Fix possible race condition in ftrace function return tracer

This fixes a possible race condition if index incrementation
is not immediately flushed in memory.

Thanks for Andi Kleen and Steven Rostedt for pointing out this issue
and give me this solution.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>
---
 arch/x86/kernel/ftrace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index fe83273..db25236 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -56,6 +56,7 @@ static int push_return_trace(unsigned long ret, unsigned long long time,
 		return -EBUSY;
 
 	index = ++ti->curr_ret_stack;
+	barrier();
 	ti->ret_stack[index].ret = ret;
 	ti->ret_stack[index].func = func;
 	ti->ret_stack[index].calltime = time;
-- 
1.5.2.5
