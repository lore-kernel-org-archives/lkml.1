Return-Path: <linux-kernel-owner+w=401wt.eu-S933177AbZFOSOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbZFOSOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933635AbZFOSOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:14:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:42664 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933593AbZFOSOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:14:04 -0400
Date: Mon, 15 Jun 2009 18:13:38 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4A35B8DF.60400@cn.fujitsu.com>
References: <4A35B8DF.60400@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing/filters: operand can be negative
Message-ID: <tip-5e4904cb633177046bee5d26946a7ac918e642fc@git.kernel.org>
Git-Commit-ID: 5e4904cb633177046bee5d26946a7ac918e642fc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Jun 2009 18:13:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e4904cb633177046bee5d26946a7ac918e642fc
Gitweb:     http://git.kernel.org/tip/5e4904cb633177046bee5d26946a7ac918e642fc
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 15 Jun 2009 10:58:39 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 15 Jun 2009 11:37:16 -0400

tracing/filters: operand can be negative

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
