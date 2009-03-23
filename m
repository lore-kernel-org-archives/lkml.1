Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbZCWIen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbZCWIen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757115AbZCWIeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:34:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:51718 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144AbZCWIeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:34:01 -0400
Date: Mon, 23 Mar 2009 08:33:26 GMT
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237796802.7527.39.camel@charm-linux>
References: <1237796802.7527.39.camel@charm-linux>
Subject: [tip:tracing/filters] tracing/filters: fix bug in copy_pred()
Message-ID: <tip-ee6cdabc820a29bd607f38d9cb335c3ceddc673b@git.kernel.org>
Git-Commit-ID: ee6cdabc820a29bd607f38d9cb335c3ceddc673b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 08:33:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee6cdabc820a29bd607f38d9cb335c3ceddc673b
Gitweb:     http://git.kernel.org/tip/ee6cdabc820a29bd607f38d9cb335c3ceddc673b
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Mon, 23 Mar 2009 03:26:42 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 09:30:36 +0100

tracing/filters: fix bug in copy_pred()

Impact: fix potential crash on subsystem filter expression freeing

When making a copy of the predicate, pred->field_name needs to be
duplicated in the copy as well, otherwise bad things can happen due to
later multiple frees of the same string.

This affects only per-subsystem event filtering.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237796802.7527.39.camel@charm-linux>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events_filter.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index c4a413b..fd01d80 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -276,11 +276,19 @@ static struct filter_pred *copy_pred(struct filter_pred *pred)
 		return NULL;
 
 	memcpy(new_pred, pred, sizeof(*pred));
+
+	if (pred->field_name) {
+		new_pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
+		if (!new_pred->field_name) {
+			kfree(new_pred);
+			return NULL;
+		}
+	}
+
 	if (pred->str_val) {
 		new_pred->str_val = kstrdup(pred->str_val, GFP_KERNEL);
-		new_pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
 		if (!new_pred->str_val) {
-			kfree(new_pred);
+			filter_free_pred(new_pred);
 			return NULL;
 		}
 	}
