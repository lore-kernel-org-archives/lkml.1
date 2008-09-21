Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbYIUSK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbYIUSK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 14:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbYIUSKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 14:10:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:30269 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYIUSKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 14:10:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=xnayy3P+YkIT4qYcUYofr+MzMeoLC/2wtkuzUnMMV5fZQ8+maoC8wQbjisU4s5vnrm
         jPr8fLqyksrf+vxRLaekB0XyDTwKmk/Loqv3UsLsyKc65F+TBacs5ocjpdSmZUB0mg2K
         nFLPjXWn02GH8zaPLNZqIwkEemn73zLnZIB9M=
Message-ID: <48D68E06.50504@gmail.com>
Date: Sun, 21 Sep 2008 20:10:14 +0200
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>
Subject: [Patch 1/3] Tracing/ftrace: Make nop tracer reset previous entries
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If nop tracer is selected, some old entries from the previous tracer could still be enqueued. Tracing have to be reset.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff -rup linux-2.6-tip (2)/kernel/trace/trace_nop.c linux-2.6-tip/kernel/trace/trace_nop.c
--- linux-2.6-tip (2)/kernel/trace/trace_nop.c	2008-09-19 18:01:26.000000000 +0200
+++ linux-2.6-tip/kernel/trace/trace_nop.c	2008-09-21 00:44:47.000000000 +0200
@@ -25,8 +25,12 @@ static void stop_nop_trace(struct trace_
 }

 

 static void nop_trace_init(struct trace_array *tr)

-{

-	ctx_trace = tr;

+{
+	int cpu;

+	ctx_trace = tr;
+
+	for_each_online_cpu(cpu)

+		tracing_reset(tr->data[cpu]);

 

 	if (tr->ctrl)

 		start_nop_trace(tr);
