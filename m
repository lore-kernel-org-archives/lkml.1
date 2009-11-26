Return-Path: <linux-kernel-owner+w=401wt.eu-S932816AbZKZEfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbZKZEfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 23:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbZKZEfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 23:35:42 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61251 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbZKZEfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 23:35:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LQdc6xQlhbLp4CBIbrOEnFRcAsuUT0VD7JAJtOBLCRNhaVYjtqXGDSMg4sB+wRGbRb
         fo8w9A2eElat1O4RjzDqVc7zSI1yJPWYAIhFVqxkSE+ZJyrAtae9Ld5FTdIV3PAOKjw7
         +WaksD9m1jnwlg/LiwZtBB9hNnCBdtXPGVmLI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 2/3] hw-breakpoints: Improve in-kernel event creation error granularity
Date: Thu, 26 Nov 2009 05:35:41 +0100
Message-Id: <1259210142-5714-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1259210142-5714-1-git-send-regression-fweisbec@gmail.com>
References: <1259210142-5714-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fail case, perf_event_create_kernel_counter() returns NULL instead
of an error, which doesn't help us to inform the user about the origin
of the problem from the outer most callers. Often we can just return
-EINVAL, which doesn't help anyone when it's eventually about a memory
allocation failure.

Then, this patch makes perf_event_create_kernel_counter() always
returning a detailed error code.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
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
 
-- 
1.6.2.3

