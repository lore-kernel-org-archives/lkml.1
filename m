Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZERFko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZERFko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 01:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZERFkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 01:40:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:57785 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbZERFkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 01:40:32 -0400
Date: Mon, 18 May 2009 05:39:48 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <18960.56772.869734.304631@drongo.ozlabs.ibm.com>
References: <18960.56772.869734.304631@drongo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: powerpc: initialize cpuhw pointer before use
Message-ID: <tip-c0daaf3f1f672defa3a45ca449b76d0e86c55892@git.kernel.org>
Git-Commit-ID: c0daaf3f1f672defa3a45ca449b76d0e86c55892
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 18 May 2009 05:39:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0daaf3f1f672defa3a45ca449b76d0e86c55892
Gitweb:     http://git.kernel.org/tip/c0daaf3f1f672defa3a45ca449b76d0e86c55892
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 18 May 2009 14:02:12 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 May 2009 07:38:42 +0200

perf_counter: powerpc: initialize cpuhw pointer before use

Commit 9e35ad38 ("perf_counter: Rework the perf counter
disable/enable") added code to the powerpc hw_perf_enable (renamed
from hw_perf_restore) to test cpuhw->disabled and return immediately
if it is not set (i.e. if the PMU is already enabled).

Unfortunately the test got added before cpuhw was initialized,
resulting in an oops the first time hw_perf_enable got called.
This fixes it by moving the initialization of cpuhw to before
cpuhw->disabled is tested.

[ Impact: fix oops-causing bug on powerpc ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <18960.56772.869734.304631@drongo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 6baae5a..fe21b24 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -450,12 +450,11 @@ void hw_perf_enable(void)
 	int idx;
 
 	local_irq_save(flags);
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
 	if (!cpuhw->disabled) {
 		local_irq_restore(flags);
 		return;
 	}
-
-	cpuhw = &__get_cpu_var(cpu_hw_counters);
 	cpuhw->disabled = 0;
 
 	/*
