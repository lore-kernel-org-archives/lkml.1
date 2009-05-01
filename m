Return-Path: <linux-kernel-owner+w=401wt.eu-S1761415AbZEAN2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761415AbZEAN2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761251AbZEAN2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:28:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:58480 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760835AbZEAN2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:28:19 -0400
Date: Fri, 1 May 2009 13:27:46 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090501102533.109867793@chello.nl>
References: <20090501102533.109867793@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: fix nmi-watchdog interaction
Message-ID: <tip-63a809a2dc53b91268dd915bbcbd425063893676@git.kernel.org>
Git-Commit-ID: 63a809a2dc53b91268dd915bbcbd425063893676
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 13:27:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63a809a2dc53b91268dd915bbcbd425063893676
Gitweb:     http://git.kernel.org/tip/63a809a2dc53b91268dd915bbcbd425063893676
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 1 May 2009 12:23:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 May 2009 13:23:44 +0200

perf_counter: fix nmi-watchdog interaction

When we don't have any perf-counters active, don't act like we know
what the NMI is for.

[ Impact: fix hard hang with nmi_watchdog=2 ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090501102533.109867793@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index fc06f4d..d4c0cc9 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -871,6 +871,9 @@ perf_counter_nmi_handler(struct notifier_block *self,
 	struct pt_regs *regs;
 	int ret;
 
+	if (!atomic_read(&num_counters))
+		return NOTIFY_DONE;
+
 	switch (cmd) {
 	case DIE_NMI:
 	case DIE_NMI_IPI:
