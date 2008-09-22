Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbYIVROS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbYIVROS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYIVRNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:13:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59563 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbYIVRNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:13:50 -0400
Date: Mon, 22 Sep 2008 13:14:13 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, prarit@redhat.com,
       vgoyal@redhat.com
Subject: [PATCH] NMI watchdog: when booting with reset_devices, clear the
	performance counters
Message-ID: <20080922171408.GJ16840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

P4s have a quirk that makes necessary to clear P4_CCCR_OVF bit on the CCCR
everytime the PMI is triggered. When booting the kernel with reset_devices
(more specific kdump case), the counters reach zero and the PMI will be
generated. This is not a problem on other processors but on P4s, it'll
continue to generate NMIs until that bit is cleared. Since there may be
other users of the performance counters, clear and disable all of them
when booting with reset_devices option.

We have a P4 box here that crashes because of this problem. Since the kdump
kernel usually boots with only one processor active, the second logical
unit won't be set up, therefore, MSR_P4_IQ_CCCR1 (and other performance
counter registers) won't be cleared and P4_CCCR_OVF may be still set because
the previous kernel was using this register. An NMI is triggered because of
the MSR_P4_IQ_CCCR1 right after the NMI delivery is enabled, triggering the
race fixed on my previous email.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>

---
 arch/x86/kernel/cpu/perfctr-watchdog.c |   40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- linus-2.6.orig/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-09-22 10:53:22.000000000 -0400
+++ linus-2.6/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-09-22 10:54:43.000000000 -0400
@@ -444,6 +444,27 @@ static const struct wd_ops p6_wd_ops = {
 #define P4_CCCR_ENABLE		(1 << 12)
 #define P4_CCCR_OVF 		(1 << 31)
 
+#define P4_CONTROLS 18
+static unsigned int p4_controls[18] = {
+	MSR_P4_BPU_CCCR0,
+	MSR_P4_BPU_CCCR1,
+	MSR_P4_BPU_CCCR2,
+	MSR_P4_BPU_CCCR3,
+	MSR_P4_MS_CCCR0,
+	MSR_P4_MS_CCCR1,
+	MSR_P4_MS_CCCR2,
+	MSR_P4_MS_CCCR3,
+	MSR_P4_FLAME_CCCR0,
+	MSR_P4_FLAME_CCCR1,
+	MSR_P4_FLAME_CCCR2,
+	MSR_P4_FLAME_CCCR3,
+	MSR_P4_IQ_CCCR0,
+	MSR_P4_IQ_CCCR1,
+	MSR_P4_IQ_CCCR2,
+	MSR_P4_IQ_CCCR3,
+	MSR_P4_IQ_CCCR4,
+	MSR_P4_IQ_CCCR5,
+};
 /*
  * Set up IQ_COUNTER0 to behave like a clock, by having IQ_CCCR0 filter
  * CRU_ESCR0 (with any non-null event selector) through a complemented
@@ -485,6 +506,26 @@ static int setup_p4_watchdog(unsigned nm
 		evntsel_msr = MSR_P4_CRU_ESCR0;
 		cccr_msr = MSR_P4_IQ_CCCR0;
 		cccr_val = P4_CCCR_OVF_PMI0 | P4_CCCR_ESCR_SELECT(4);
+
+		/*
+		 * If we're on the kdump kernel or other situation, we may
+		 * still have other performance counter registers set to
+		 * interrupt and they'll keep interrupting forever because
+		 * of the P4_CCCR_OVF quirk. So we need to ACK all the
+		 * pending interrupts and disable all the registers here,
+		 * before reenabling the NMI delivery. Refer to p4_rearm()
+		 * about the P4_CCCR_OVF quirk.
+		 */
+		if (reset_devices) {
+			unsigned int low, high;
+			int i;
+
+			for (i = 0; i < P4_CONTROLS; i++) {
+				rdmsr(p4_controls[i], low, high);
+				low &= ~(P4_CCCR_ENABLE | P4_CCCR_OVF);
+				wrmsr(p4_controls[i], low, high);
+			}
+		}
 	} else {
 		/* logical cpu 1 */
 		perfctr_msr = MSR_P4_IQ_PERFCTR1;

