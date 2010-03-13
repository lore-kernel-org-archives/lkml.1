Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab0CMQWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 11:22:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:56616 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab0CMQWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 11:22:22 -0500
Date: Sat, 13 Mar 2010 16:21:37 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, peterz@infradead.org, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, peterz@infradead.org, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100313081116.GA5179@lenovo>
References: <20100313081116.GA5179@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: Unmask LVTPC only if we have APIC supported
Message-ID: <tip-8576e1971663ffdb6139041de97cdd2e1d4791cc@git.kernel.org>
Git-Commit-ID: 8576e1971663ffdb6139041de97cdd2e1d4791cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Mar 2010 16:21:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8576e1971663ffdb6139041de97cdd2e1d4791cc
Gitweb:     http://git.kernel.org/tip/8576e1971663ffdb6139041de97cdd2e1d4791cc
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sat, 13 Mar 2010 11:11:16 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 13 Mar 2010 13:32:27 +0100

x86, perf: Unmask LVTPC only if we have APIC supported

Ingo reported:

 |
 | There's a build failure on -tip with the P4 driver, on UP 32-bit, if
 | PERF_EVENTS is enabled but UP_APIC is disabled:
 |
 | arch/x86/built-in.o: In function `p4_pmu_handle_irq':
 | perf_event.c:(.text+0xa756): undefined reference to `apic'
 | perf_event.c:(.text+0xa76e): undefined reference to `apic'
 |

So we have to unmask LVTPC only if we're configured to have one.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100313081116.GA5179@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 381f593..ef861da 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -365,8 +365,10 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 	}
 
 	if (handled) {
+#ifdef CONFIG_X86_LOCAL_APIC
 		/* p4 quirk: unmask it again */
 		apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
+#endif
 		inc_irq_stat(apic_perf_irqs);
 	}
 
