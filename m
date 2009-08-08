Return-Path: <linux-kernel-owner+w=401wt.eu-S1751472AbZHHQEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbZHHQEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 12:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbZHHQEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 12:04:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:40457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZHHQEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 12:04:08 -0400
Date: Sat, 8 Aug 2009 16:03:36 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       error27@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       error27@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1249746549.6453.29.camel@tropicana>
References: <1249746549.6453.29.camel@tropicana>
Subject: [tip:tracing/core] tracing/filters: Don't use pred on alloc failure
Message-ID: <tip-96b2de313b1e0e02aea80ee47df6a2b5cbdf8e13@git.kernel.org>
Git-Commit-ID: 96b2de313b1e0e02aea80ee47df6a2b5cbdf8e13
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 16:03:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96b2de313b1e0e02aea80ee47df6a2b5cbdf8e13
Gitweb:     http://git.kernel.org/tip/96b2de313b1e0e02aea80ee47df6a2b5cbdf8e13
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Sat, 8 Aug 2009 10:49:09 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 17:55:34 +0200

tracing/filters: Don't use pred on alloc failure

Dan Carpenter sent me a fix to prevent pred from being used if
it couldn't be allocated.  I noticed the same problem also
existed for the create_pred() case and added a fix for that.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <1249746549.6453.29.camel@tropicana>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events_filter.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 936c621..1557148 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1029,6 +1029,8 @@ static int replace_preds(struct event_subsystem *system,
 
 		if (elt->op == OP_AND || elt->op == OP_OR) {
 			pred = create_logical_pred(elt->op);
+			if (!pred)
+				return -ENOMEM;
 			if (call) {
 				err = filter_add_pred(ps, call, pred);
 				filter_free_pred(pred);
@@ -1048,6 +1050,8 @@ static int replace_preds(struct event_subsystem *system,
 		}
 
 		pred = create_pred(elt->op, operand1, operand2);
+		if (!pred)
+			return -ENOMEM;
 		if (call) {
 			err = filter_add_pred(ps, call, pred);
 			filter_free_pred(pred);
