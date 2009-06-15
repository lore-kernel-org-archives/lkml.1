Return-Path: <linux-kernel-owner+w=401wt.eu-S1763394AbZFOPpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763394AbZFOPpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759750AbZFOPoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:44:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38283 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbZFOPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:44:09 -0400
Message-Id: <20090615154411.371584730@goodmis.org>
References: <20090615154226.058101204@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Jun 2009 11:42:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 5/7] tracing/filters: operand can be negative
Content-Disposition: inline; filename=0005-tracing-filters-operand-can-be-negative.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

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

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A35B8DF.60400@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
1.6.3.1

-- 
