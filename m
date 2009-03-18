Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbZCRDdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbZCRDdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbZCRDcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:32:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbZCRDcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:32:51 -0400
Message-Id: <20090318033249.451020891@goodmis.org>
References: <20090318031423.981603258@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Mar 2009 23:14:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] tracing: optimization of branch tracer
Content-Disposition: inline; filename=0003-tracing-optimization-of-branch-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>

Impact: better performance for if branch tracer

Use an array to count the hit and misses of a conditional instead
of using another conditional. This cuts down on saturation of branch
predictions and increases performance of modern pipelined architectures.

Signed-off-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/compiler.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d95da10..6faa7e5 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -68,6 +68,7 @@ struct ftrace_branch_data {
 			unsigned long miss;
 			unsigned long hit;
 		};
+		unsigned long miss_hit[2];
 	};
 };
 
@@ -125,10 +126,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 				.line = __LINE__,			\
 			};						\
 		______r = !!(cond);					\
-		if (______r)						\
-			______f.hit++;					\
-		else							\
-			______f.miss++;					\
+		______f.miss_hit[______r]++;					\
 		______r;						\
 	}))
 #endif /* CONFIG_PROFILE_ALL_BRANCHES */
-- 
1.6.2

-- 
