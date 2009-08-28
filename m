Return-Path: <linux-kernel-owner+w=401wt.eu-S1751410AbZH1CqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbZH1CqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 22:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZH1CqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 22:46:13 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:36926 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZH1CqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 22:46:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CYeLX/0TsnnqC4UgGdvfwmC7FuJoiCbBykk6cIgjhtnAMae2Myk2yfvJYe18ChZO5f
         a/BibOsUPxs1QZiKWahozIwciF7yF9lNSDFuDtszNEa2xK6eaTCvYOJEMoLS50mppUnh
         8XrrmFJzmljr1oBkMTILGUa4KaBsOLOeixXQQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2] perf tool: Fix missing string field printing in perf trace
Date: Fri, 28 Aug 2009 04:46:07 +0200
Message-Id: <1251427567-10551-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251427567-10551-1-git-send-email-fweisbec@gmail.com>
References: <1251427567-10551-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some string fields are not printed because of a missing printf
in the post-processing.

Before:
	    perf-10070 [000]     0.000000: sched_switch: task :10070 [120] (R) ==> :5720 [120]
           geany-5720  [000]     0.000000: sched_switch: task :5720 [120] (S) ==> :10070 [120]
            perf-10070 [000]     0.000000: sched_switch: task :10070 [120] (R) ==> :5720 [120]
           geany-5720  [000]     0.000000: sched_switch: task :5720 [120] (S) ==> :10070 [120]
          <idle>-0     [000]     0.000000: sched_switch: task :0 [140] (R) ==> :361 [115]

After:
	    perf-10070 [000]     0.000000: sched_switch: task perf:10070 [120] (R) ==> geany:5720 [120]
           geany-5720  [000]     0.000000: sched_switch: task geany:5720 [120] (S) ==> perf:10070 [120]
            perf-10070 [000]     0.000000: sched_switch: task perf:10070 [120] (R) ==> geany:5720 [120]
           geany-5720  [000]     0.000000: sched_switch: task geany:5720 [120] (S) ==> perf:10070 [120]
          <idle>-0     [000]     0.000000: sched_switch: task swapper:0 [140] (R) ==> kondemand/1:361 [115]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/trace-event-parse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index a2de650..769c405 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1990,6 +1990,7 @@ static void print_str_arg(void *data, int size,
 		memcpy(str, data + arg->field.field->offset,
 		       arg->field.field->size);
 		str[arg->field.field->size] = 0;
+		printf("%s", str);
 		free(str);
 		break;
 	case PRINT_FLAGS:
-- 
1.6.2.3

