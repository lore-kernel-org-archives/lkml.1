Return-Path: <linux-kernel-owner+w=401wt.eu-S933969AbZKYIcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969AbZKYIcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933858AbZKYIcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:32:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59973 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZKYIct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:32:49 -0500
Message-ID: <4B0CEB95.2060107@cn.fujitsu.com>
Date: Wed, 25 Nov 2009 16:32:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] trace_kprobes: fix memory leak
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


tp->nr_args is not set before we "goto error",
it causes memory leak for free_trace_probe() use tp->nr_args
to free memory of args.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 79ce6a2..82e8583 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -704,10 +704,12 @@ static int create_trace_probe(int argc, char **argv)
 		ret = parse_probe_arg(arg, &tp->args[i].fetch, is_return);
 		if (ret) {
 			pr_info("Parse error at argument%d. (%d)\n", i, ret);
+			kfree(tp->args[i].name);
 			goto error;
 		}
+
+		tp->nr_args++;
 	}
-	tp->nr_args = i;
 
 	ret = register_trace_probe(tp);
 	if (ret)


