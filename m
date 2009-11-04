Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZKDPtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZKDPtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbZKDPtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:49:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43228 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686AbZKDPtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:49:49 -0500
Date: Wed, 4 Nov 2009 16:49:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20091104154946.GA29885@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
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
Lai Jiangshan (1):
      ring-buffer: Synchronize resizing buffer with reader lock

Li Zefan (1):
      ftrace: Fix unmatched locking in ftrace_regex_write()


 kernel/trace/ftrace.c      |    6 +++---
 kernel/trace/ring_buffer.c |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9c451a1..6dc4e5e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2222,15 +2222,15 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 		ret = ftrace_process_regex(parser->buffer,
 					   parser->idx, enable);
 		if (ret)
-			goto out;
+			goto out_unlock;
 
 		trace_parser_clear(parser);
 	}
 
 	ret = read;
-
+out_unlock:
 	mutex_unlock(&ftrace_regex_lock);
-out:
+
 	return ret;
 }
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3ffa502..5dd017f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1193,6 +1193,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	atomic_inc(&cpu_buffer->record_disabled);
 	synchronize_sched();
 
+	spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1207,6 +1208,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 		return;
 
 	rb_reset_cpu(cpu_buffer);
+	spin_unlock_irq(&cpu_buffer->reader_lock);
 
 	rb_check_pages(cpu_buffer);
 
