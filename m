Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab0CJNVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:21:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:57541 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab0CJNVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:21:45 -0500
Date: Wed, 10 Mar 2010 13:20:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100305154128.813452402@chello.nl>
References: <20100305154128.813452402@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf, x86: Fix silly bug in data store buffer allocation
Message-ID: <tip-3adaebd69557615c1bf0365ce5e32d93ac7d82af@git.kernel.org>
Git-Commit-ID: 3adaebd69557615c1bf0365ce5e32d93ac7d82af
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:20:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3adaebd69557615c1bf0365ce5e32d93ac7d82af
Gitweb:     http://git.kernel.org/tip/3adaebd69557615c1bf0365ce5e32d93ac7d82af
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 5 Mar 2010 12:09:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:34 +0100

perf, x86: Fix silly bug in data store buffer allocation

Fix up the ds allocation error path, where we could free @buffer before
we used it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <20100305154128.813452402@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 72453ac..a67fff1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -127,10 +127,8 @@ static int reserve_ds_buffers(void)
 
 		err = -ENOMEM;
 		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
-		if (unlikely(!ds)) {
-			kfree(buffer);
+		if (unlikely(!ds))
 			break;
-		}
 		per_cpu(cpu_hw_events, cpu).ds = ds;
 
 		if (x86_pmu.bts) {
