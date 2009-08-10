Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZHJJ2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZHJJ2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZHJJ2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:28:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57868 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbZHJJ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:28:01 -0400
Subject: [PATCH 5/3] perf_counter: Require CAP_SYS_ADMIN for raw tracepoint
 data
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1249698400-5441-2-git-send-email-fweisbec@gmail.com>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
	 <1249698400-5441-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Aug 2009 11:27:32 +0200
Message-Id: <1249896452.17467.75.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: perf_counter: Require CAP_SYS_ADMIN for raw tracepoint data
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Aug 10 11:20:12 CEST 2009

Raw tracepoint data is a severe data leak, restrict this to root only.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -3788,6 +3788,14 @@ static void tp_perf_counter_destroy(stru
 
 static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 {
+	/*
+	 * Raw tracepoint data is a severe data leak, only allow root to
+	 * have these.
+	 */
+	if ((counter->attr.sample_type & PERF_SAMPLE_RAW) &&
+			!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
 	if (ftrace_profile_enable(counter->attr.config))
 		return NULL;
 

