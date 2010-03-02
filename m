Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0CBMk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 07:40:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:48584 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab0CBMk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 07:40:26 -0500
Date: Tue, 2 Mar 2010 12:39:34 GMT
From: tip-bot for Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20100301174815.GC8224@sgi.com>
References: <20100301174815.GC8224@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] x86: Fix sched_clock_cpu for systems with unsynchronized TSC
Message-ID: <tip-14be1f7454ea96ee614467a49cf018a1a383b189@git.kernel.org>
Git-Commit-ID: 14be1f7454ea96ee614467a49cf018a1a383b189
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Mar 2010 12:39:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14be1f7454ea96ee614467a49cf018a1a383b189
Gitweb:     http://git.kernel.org/tip/14be1f7454ea96ee614467a49cf018a1a383b189
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Mon, 1 Mar 2010 11:48:15 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Mar 2010 13:36:11 +0100

x86: Fix sched_clock_cpu for systems with unsynchronized TSC

On UV systems, the TSC is not synchronized across blades.  The
sched_clock_cpu() function is returning values that can go
backwards  (I've seen as much as 8 seconds) when switching
between cpus.

As each cpu comes up, early_init_intel() will currently set the
sched_clock_stable flag true.  When mark_tsc_unstable() runs, it
clears the flag, but this only occurs once (the first time a cpu
comes up whose TSC is not synchronized with cpu 0).  After this,
early_init_intel() will set the flag again as the next cpu comes
up.

Only set sched_clock_stable if tsc has not been marked unstable.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100301174815.GC8224@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 879666f..7e1cca1 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -70,7 +70,8 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		sched_clock_stable = 1;
+		if (!check_tsc_unstable())
+			sched_clock_stable = 1;
 	}
 
 	/*
