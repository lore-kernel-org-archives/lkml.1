Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbZHHQEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbZHHQEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 12:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZHHQEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 12:04:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:40469 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZHHQE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 12:04:28 -0400
Date: Sat, 8 Aug 2009 16:04:01 GMT
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
In-Reply-To: <1249746576.6453.30.camel@tropicana>
References: <1249746576.6453.30.camel@tropicana>
Subject: [tip:tracing/core] tracing/filters: Don't use pred on alloc failure
Message-ID: <tip-fb82ad719831db58e9baa4c67015aae3fe27e7e3@git.kernel.org>
Git-Commit-ID: fb82ad719831db58e9baa4c67015aae3fe27e7e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 16:04:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb82ad719831db58e9baa4c67015aae3fe27e7e3
Gitweb:     http://git.kernel.org/tip/fb82ad719831db58e9baa4c67015aae3fe27e7e3
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Sat, 8 Aug 2009 10:49:36 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 17:58:07 +0200

tracing/filters: Don't use pred on alloc failure

Dan Carpenter sent me a fix to prevent pred from being used if
it couldn't be allocated.  This updates his patch for the same
problem in the tracing tree (which has changed this code quite
substantially).

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <1249746576.6453.30.camel@tropicana>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
The original report:

create_logical_pred() could sometimes return NULL.

It's a static checker complaining rather than problems at runtime...


---
 kernel/trace/trace_events_filter.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 27c2dbe..490337a 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1050,6 +1050,8 @@ static int replace_preds(struct event_subsystem *system,
 
 		pred = create_pred(elt->op, operand1, operand2);
 add_pred:
+		if (!pred)
+			return -ENOMEM;
 		if (call)
 			err = filter_add_pred(ps, call, pred, false);
 		else
