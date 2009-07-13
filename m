Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZGMGtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZGMGtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbZGMGts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:49:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:39617 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbZGMGtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:49:47 -0400
Date: Mon, 13 Jul 2009 06:49:00 GMT
From: tip-bot for Daniel Qarras <dqarras@yahoo.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dqarras@yahoo.com, hpa@zytor.com,
       mingo@redhat.com, eranian@googlemail.com, a.p.zijlstra@chello.nl,
       vince@deater.net, tglx@linutronix.de, mingo@elte.hu
Reply-To: vince@deater.net, mingo@redhat.com, hpa@zytor.com, dqarras@yahoo.com,
       linux-kernel@vger.kernel.org, eranian@googlemail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter, x86: Extend perf_counter Pentium M support
Message-ID: <tip-f1c6a58121f9846ac665b0fbd3cbab90ce8bcbac@git.kernel.org>
Git-Commit-ID: f1c6a58121f9846ac665b0fbd3cbab90ce8bcbac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Jul 2009 06:49:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1c6a58121f9846ac665b0fbd3cbab90ce8bcbac
Gitweb:     http://git.kernel.org/tip/f1c6a58121f9846ac665b0fbd3cbab90ce8bcbac
Author:     Daniel Qarras <dqarras@yahoo.com>
AuthorDate: Sun, 12 Jul 2009 04:32:40 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Jul 2009 08:46:51 +0200

perf_counter, x86: Extend perf_counter Pentium M support

I've attached a patch to remove the Pentium M special casing of
EMON and as noticed at least with my Pentium M the hardware PMU
now works:

 Performance counter stats for '/bin/ls /var/tmp':

       1.809988  task-clock-msecs         #      0.125 CPUs
              1  context-switches         #      0.001 M/sec
              0  CPU-migrations           #	 0.000 M/sec
            224  page-faults              #	 0.124 M/sec
        1425648  cycles                   #    787.656 M/sec
         912755  instructions             #	 0.640 IPC

Vince suggested that this code was trying to address erratum
Y17 in Pentium-M's:

  http://download.intel.com/support/processors/mobile/pm/sb/25266532.pdf

But that erratum (related to IA32_MISC_ENABLES.7) does not
affect perfcounters as we dont use this toggle to disable RDPMC
and WRMSR/RDMSR access to performance counters. We keep cr4's
bit 8 (X86_CR4_PCE) clear so unprivileged RDPMC access is not
allowed anyway.

Cc: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@googlemail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index bed1c4c..7e346d4 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1583,10 +1583,8 @@ static int p6_pmu_init(void)
 		break;
 	case 9:
 	case 13:
-		/* for Pentium M, we need to check if PMU exist */
-		rdmsr(MSR_IA32_MISC_ENABLE, low, high);
-		if (low & MSR_IA32_MISC_ENABLE_EMON)
-			break;
+		/* Pentium M */
+		break;
 	default:
 		pr_cont("unsupported p6 CPU model %d ",
 			boot_cpu_data.x86_model);
