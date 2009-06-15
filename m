Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbZFOC5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbZFOC5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZFOC5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:57:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51231 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbZFOC5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:57:09 -0400
Message-ID: <4A35B8DF.60400@cn.fujitsu.com>
Date: Mon, 15 Jun 2009 10:58:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] tracing/filters: operand can be negative
References: <4A35B84B.40904@cn.fujitsu.com>
In-Reply-To: <4A35B84B.40904@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be a bug:

 # cat format
 name: foo_bar
 ID: 71
 format:
	 ...
         field:int bar;  offset:24;      size:4;
 # echo 'bar < 0' > filter
 # echo 'bar < -1' > filter
 bash: echo: write error: Invalid argument

[ Impact: fix to allow negative operand in filer expr ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index db6e54b..1d81923 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -546,6 +546,7 @@ static int filter_add_pred(struct filter_parse_state *ps,
 	filter_pred_fn_t fn;
 	unsigned long long val;
 	int string_type;
+	int ret;
 
 	pred->fn = filter_pred_none;
 
@@ -581,7 +582,11 @@ static int filter_add_pred(struct filter_parse_state *ps,
 			pred->not = 1;
 		return filter_add_pred_fn(ps, call, pred, fn);
 	} else {
-		if (strict_strtoull(pred->str_val, 0, &val)) {
+		if (field->is_signed)
+			ret = strict_strtoll(pred->str_val, 0, &val);
+		else
+			ret = strict_strtoull(pred->str_val, 0, &val);
+		if (ret) {
 			parse_error(ps, FILT_ERR_ILLEGAL_INTVAL, 0);
 			return -EINVAL;
 		}
-- 
1.5.4.rc3


