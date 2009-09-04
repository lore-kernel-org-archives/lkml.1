Return-Path: <linux-kernel-owner+w=401wt.eu-S933276AbZIDH7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbZIDH7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933249AbZIDH7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:59:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:33522 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933023AbZIDH7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:59:37 -0400
Date: Fri, 4 Sep 2009 07:58:44 GMT
From: "tip-bot for markus.t.metzger@intel.com" <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, a.p.zjilstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, a.p.zjilstra@chello.nl,
       mingo@elte.hu
In-Reply-To: <20090902140616.901253000@intel.com>
References: <20090902140616.901253000@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] x86, perf_counter, bts: Do not allow kernel BTS tracing for now
Message-ID: <tip-1653192f510bd8114b7b133d7289e6e5c3e95046@git.kernel.org>
Git-Commit-ID: 1653192f510bd8114b7b133d7289e6e5c3e95046
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 07:58:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1653192f510bd8114b7b133d7289e6e5c3e95046
Gitweb:     http://git.kernel.org/tip/1653192f510bd8114b7b133d7289e6e5c3e95046
Author:     markus.t.metzger@intel.com <markus.t.metzger@intel.com>
AuthorDate: Wed, 2 Sep 2009 16:04:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 09:26:40 +0200

x86, perf_counter, bts: Do not allow kernel BTS tracing for now

Kernel BTS tracing generates too much data too fast for us to
handle, causing the kernel to hang.

Fail for BTS requests for kernel code.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Acked-by: Peter Zijlstra <a.p.zjilstra@chello.nl>
LKML-Reference: <20090902140616.901253000@intel.com>
[ This is really a workaround - but we want BTS tracing in .32
  so make sure we dont regress. The lockup should be fixed
  ASAP. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 3776b0b..f9cd084 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -984,8 +984,15 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	 * Branch tracing:
 	 */
 	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
-	    (hwc->sample_period == 1) && !bts_available())
-		return -EOPNOTSUPP;
+	    (hwc->sample_period == 1)) {
+		/* BTS is not supported by this architecture. */
+		if (!bts_available())
+			return -EOPNOTSUPP;
+
+		/* BTS is currently only allowed for user-mode. */
+		if (hwc->config & ARCH_PERFMON_EVENTSEL_OS)
+			return -EOPNOTSUPP;
+	}
 
 	hwc->config |= config;
 
