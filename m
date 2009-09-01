Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbZIAFc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbZIAFc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 01:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZIAFc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 01:32:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49755 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZIAFcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 01:32:55 -0400
Message-ID: <4A9CB1BA.3060402@cn.fujitsu.com>
Date: Tue, 01 Sep 2009 13:31:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/filters: Defer pred allocation, fix memory leak
References: <4A9B8EA5.6020700@cn.fujitsu.com> <20090831174107.GB6048@nowhere>
In-Reply-To: <20090831174107.GB6048@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check if we have already allocated memory for filter preds.

Spotted-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index c6b2edf..93660fb 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -409,6 +409,9 @@ static int init_preds(struct ftrace_event_call *call)
 	struct filter_pred *pred;
 	int i;
 
+	if (call->filter)
+		return 0;
+
 	filter = call->filter = kzalloc(sizeof(*filter), GFP_KERNEL);
 	if (!call->filter)
 		return -ENOMEM;
@@ -447,11 +450,9 @@ static int init_subsystem_preds(struct event_subsystem *system)
 		if (strcmp(call->system, system->name) != 0)
 			continue;
 
-		if (!call->filter) {
-			err = init_preds(call);
-			if (err)
-				return err;
-		}
+		err = init_preds(call);
+		if (err)
+			return err;
 	}
 
 	return 0;
-- 
1.6.3

