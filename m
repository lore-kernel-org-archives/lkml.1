Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab0BCJQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:16:07 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57321 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab0BCJOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:14:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N/jKgdsVrg9dMxCyhMEkPRpr0dnZ4zKsUm2dEnNSAnfEcvt43bWAdUuFaKHIzJ2K/q
         C9QUbJaTpjKNh1AjQoUokSP2ApdbaPD45tkc/dOOLM955dPmXqEdje3pK2aLyI7aRVCv
         0AWQwi8ayH6LHwcLR4Li32MOBsGmALRtaHhow=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 07/11] perf: Handle injection iotcl for tracepoints from perf record
Date: Wed,  3 Feb 2010 10:14:31 +0100
Message-Id: <1265188475-23509-8-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call the injection iotcl request for tracepoint events, in case
some of them support it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 tools/perf/builtin-record.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index eea5691..da42519 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -386,6 +386,15 @@ try_again:
 	}
 
 	ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_ENABLE);
+
+	/*
+	 * If a tracepoint has some events he wants us to catchup
+	 * let's inject them. We may have such injectable event
+	 * in several cpus, we want only one injection, so pick the
+	 * first cpu
+	 */
+	if (attr->type == PERF_TYPE_TRACEPOINT && !nr_cpu)
+		ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_INJECT);
 }
 
 static void open_counters(int cpu, pid_t pid)
-- 
1.6.2.3

