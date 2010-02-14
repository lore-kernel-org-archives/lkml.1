Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab0BNJOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 04:14:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:33585 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab0BNJNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 04:13:53 -0500
Date: Sun, 14 Feb 2010 09:13:18 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1266013161-31197-3-git-send-email-dzickus@redhat.com>
References: <1266013161-31197-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] nmi_watchdog: Fallback to software events when no hardware pmu detected
Message-ID: <tip-cf454aecb31741a0438ed1201b3dd153c7c7b19a@git.kernel.org>
Git-Commit-ID: cf454aecb31741a0438ed1201b3dd153c7c7b19a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Feb 2010 09:13:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf454aecb31741a0438ed1201b3dd153c7c7b19a
Gitweb:     http://git.kernel.org/tip/cf454aecb31741a0438ed1201b3dd153c7c7b19a
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 12 Feb 2010 17:19:20 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Feb 2010 09:19:44 +0100

nmi_watchdog: Fallback to software events when no hardware pmu detected

Not all arches have a PMU or have perf_event support for their
PMU.  The nmi_watchdog will fail in those cases.  Fallback to
using software events to generate nmi_watchdog traffic with
local apic interrupts.

Tested on a Pentium4 and it worked as expected, excepting for
detecting cpu lockups.

The problem with using software events as a cpu lock up detector
is the nmi_watchdog uses the logic that if local apic interrupts
stop incrementing then the cpu is probably locked up.  But with
software events we use the local apic to trigger the
nmi_watchdog callback to see if local apic interrupts are still
firing, which obviously they are otherwise we wouldn't have been
triggered.

The algorithm to detect cpu lock ups is the same as the old
nmi_watchdog. Perhaps we need to find a better way to detect
lock ups?

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: peterz@infradead.org
Cc: gorcunov@gmail.com
Cc: aris@redhat.com
LKML-Reference: <1266013161-31197-3-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/nmi_watchdog.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/nmi_watchdog.c b/kernel/nmi_watchdog.c
index 73c1954..4f23505 100644
--- a/kernel/nmi_watchdog.c
+++ b/kernel/nmi_watchdog.c
@@ -166,8 +166,12 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		wd_attr.sample_period = hw_nmi_get_sample_period();
 		event = perf_event_create_kernel_counter(&wd_attr, hotcpu, -1, wd_overflow);
 		if (IS_ERR(event)) {
-			printk(KERN_ERR "nmi watchdog failed to create perf event on %i: %p\n", hotcpu, event);
-			return NOTIFY_BAD;
+			wd_attr.type = PERF_TYPE_SOFTWARE;
+			event = perf_event_create_kernel_counter(&wd_attr, hotcpu, -1, wd_overflow);
+			if (IS_ERR(event)) {
+				printk(KERN_ERR "nmi watchdog failed to create perf event on %i: %p\n", hotcpu, event);
+				return NOTIFY_BAD;
+			}
 		}
 		per_cpu(nmi_watchdog_ev, hotcpu) = event;
 		perf_event_enable(per_cpu(nmi_watchdog_ev, hotcpu));
