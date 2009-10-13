Return-Path: <linux-kernel-owner+w=401wt.eu-S934006AbZJMSRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006AbZJMSRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760881AbZJMSRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:17:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51464 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760880AbZJMSRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:17:54 -0400
Date: Tue, 13 Oct 2009 20:17:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20091013181707.GA10512@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Li Zefan (1):
      tracing/filters: Fix memory leak when setting a filter

Steven Rostedt (1):
      tracing: fix trace_vprintk call


 kernel/trace/trace.c               |    2 +-
 kernel/trace/trace_events_filter.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4506826..c820b03 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1393,7 +1393,7 @@ int trace_array_vprintk(struct trace_array *tr,
 
 int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 {
-	return trace_array_printk(&global_trace, ip, fmt, args);
+	return trace_array_vprintk(&global_trace, ip, fmt, args);
 }
 EXPORT_SYMBOL_GPL(trace_vprintk);
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 2324578..98a6cc5 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -933,8 +933,9 @@ static void postfix_clear(struct filter_parse_state *ps)
 
 	while (!list_empty(&ps->postfix)) {
 		elt = list_first_entry(&ps->postfix, struct postfix_elt, list);
-		kfree(elt->operand);
 		list_del(&elt->list);
+		kfree(elt->operand);
+		kfree(elt);
 	}
 }
 
