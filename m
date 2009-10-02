Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbZJBMhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbZJBMhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbZJBMhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:37:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45710 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251AbZJBMhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:37:51 -0400
Date: Fri, 2 Oct 2009 14:37:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: [GIT PULL] tracing fixes
Message-ID: <20091002123743.GA19699@elte.hu>
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
	[score: 0.0095]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Matt Fleming (1):
      tracing: Fix infinite recursion in ftrace_update_pid_func()

Paul Mundt (1):
      kmemtrace: Fix up tracer registration


 kernel/trace/ftrace.c    |    4 ++++
 kernel/trace/kmemtrace.c |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 46592fe..3724756 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -225,7 +225,11 @@ static void ftrace_update_pid_func(void)
 	if (ftrace_trace_function == ftrace_stub)
 		return;
 
+#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	func = ftrace_trace_function;
+#else
+	func = __ftrace_trace_function;
+#endif
 
 	if (ftrace_pid_trace) {
 		set_ftrace_pid_function(func);
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 81b1645..a91da69 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -501,7 +501,7 @@ static int __init init_kmem_tracer(void)
 		return 1;
 	}
 
-	if (!register_tracer(&kmem_tracer)) {
+	if (register_tracer(&kmem_tracer) != 0) {
 		pr_warning("Warning: could not register the kmem tracer\n");
 		return 1;
 	}
