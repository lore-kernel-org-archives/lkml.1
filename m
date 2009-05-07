Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbZEGJYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbZEGJYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761366AbZEGJXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:23:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:40415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761332AbZEGJXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:23:16 -0400
Date: Thu, 7 May 2009 09:21:28 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090318192700.A6038@sedona.ch.intel.com>
References: <20090318192700.A6038@sedona.ch.intel.com>
Subject: [tip:tracing/core] x86, bts: use atomic memory allocation
Message-ID: <tip-c78a3956b982418186e40978a51636a2b43221bc@git.kernel.org>
Git-Commit-ID: c78a3956b982418186e40978a51636a2b43221bc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:21:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c78a3956b982418186e40978a51636a2b43221bc
Gitweb:     http://git.kernel.org/tip/c78a3956b982418186e40978a51636a2b43221bc
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Wed, 18 Mar 2009 19:27:00 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Mar 2009 14:02:47 +0100

x86, bts: use atomic memory allocation

Ds_request_bts() needs to allocate memory. It uses GFP_KERNEL.

Hw-branch-tracer calls ds_request_bts() within on_each_cpu().

Use atomic memory allocation to allow it to be used in that context.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
LKML-Reference: <20090318192700.A6038@sedona.ch.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 5fd5333..b1d6e1f 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -255,8 +255,13 @@ static inline struct ds_context *ds_get_context(struct task_struct *task)
 	struct ds_context *new_context = NULL;
 	unsigned long irq;
 
-	/* Chances are small that we already have a context. */
-	new_context = kzalloc(sizeof(*new_context), GFP_KERNEL);
+	/*
+	 * Chances are small that we already have a context.
+	 *
+	 * Contexts for per-cpu tracing are allocated using
+	 * smp_call_function(). We must not sleep.
+	 */
+	new_context = kzalloc(sizeof(*new_context), GFP_ATOMIC);
 	if (!new_context)
 		return NULL;
 
@@ -662,8 +667,12 @@ struct bts_tracer *ds_request_bts(struct task_struct *task,
 	if (ovfl)
 		goto out;
 
+	/*
+	 * Per-cpu tracing is typically requested using smp_call_function().
+	 * We must not sleep.
+	 */
 	error = -ENOMEM;
-	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
+	tracer = kzalloc(sizeof(*tracer), GFP_ATOMIC);
 	if (!tracer)
 		goto out;
 	tracer->ovfl = ovfl;
@@ -722,8 +731,12 @@ struct pebs_tracer *ds_request_pebs(struct task_struct *task,
 	if (ovfl)
 		goto out;
 
+	/*
+	 * Per-cpu tracing is typically requested using smp_call_function().
+	 * We must not sleep.
+	 */
 	error = -ENOMEM;
-	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
+	tracer = kzalloc(sizeof(*tracer), GFP_ATOMIC);
 	if (!tracer)
 		goto out;
 	tracer->ovfl = ovfl;
