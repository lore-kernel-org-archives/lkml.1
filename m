Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbZKZIpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbZKZIpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760069AbZKZIpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:45:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:58854 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760039AbZKZIpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:45:49 -0500
Date: Thu, 26 Nov 2009 08:44:56 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <1259210142-5714-2-git-send-regression-fweisbec@gmail.com>
References: <1259210142-5714-2-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw-breakpoints: Improve in-kernel event creation error granularity
Message-ID: <tip-c6567f642e20bcc79abed030f44be5b0d6da2ded@git.kernel.org>
Git-Commit-ID: c6567f642e20bcc79abed030f44be5b0d6da2ded
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6567f642e20bcc79abed030f44be5b0d6da2ded
Gitweb:     http://git.kernel.org/tip/c6567f642e20bcc79abed030f44be5b0d6da2ded
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 26 Nov 2009 05:35:41 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:29:21 +0100

hw-breakpoints: Improve in-kernel event creation error granularity

In fail case, perf_event_create_kernel_counter() returns NULL
instead of an error, which doesn't help us to inform the user
about the origin of the problem from the outer most callers.
Often we can just return -EINVAL, which doesn't help anyone when
it's eventually about a memory allocation failure.

Then, this patch makes perf_event_create_kernel_counter() always
return a detailed error code.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <1259210142-5714-2-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 35df94e..34a1b9d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4780,14 +4780,17 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 */
 
 	ctx = find_get_context(pid, cpu);
-	if (IS_ERR(ctx))
-		return NULL;
+	if (IS_ERR(ctx)) {
+		err = PTR_ERR(ctx);
+		goto err_exit;
+	}
 
 	event = perf_event_alloc(attr, cpu, ctx, NULL,
 				     NULL, callback, GFP_KERNEL);
-	err = PTR_ERR(event);
-	if (IS_ERR(event))
+	if (IS_ERR(event)) {
+		err = PTR_ERR(event);
 		goto err_put_context;
+	}
 
 	event->filp = NULL;
 	WARN_ON_ONCE(ctx->parent_ctx);
@@ -4804,11 +4807,10 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 
 	return event;
 
-err_put_context:
-	if (err < 0)
-		put_ctx(ctx);
-
-	return NULL;
+ err_put_context:
+	put_ctx(ctx);
+ err_exit:
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
 
