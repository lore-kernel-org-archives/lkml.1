Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbXFTSpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbXFTSpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761051AbXFTSf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:35:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:44802 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761041AbXFTSfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:35:54 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18i8ZxhB7ciFX6TlyCImnDyWPwU8QPHzX3Dp+ftVr
	boHG4H+ntyuXqG
Date: Wed, 20 Jun 2007 20:35:51 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Andi Kleen <ak@suse.de>, eranian@hpl.hp.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, levon@movementarian.org,
       perfmon@napali.hpl.hp.com, oprofile-list@lists.sourceforge.net,
       wcohen@redhat.com, akpm@linux-foundation.org
Subject: [PATCH 2/2] Reserve the right performance counter for the Intel PerfMon NMI watchdog
Message-ID: <20070620183551.GC3251@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Andi Kleen <ak@suse.de>, eranian@hpl.hp.com, mingo@elte.hu,
	linux-kernel@vger.kernel.org, levon@movementarian.org,
	perfmon@napali.hpl.hp.com, oprofile-list@lists.sourceforge.net,
	wcohen@redhat.com, akpm@linux-foundation.org
References: <20070618103214.GA12045@atjola.homenet> <200706201431.44014.ak@suse.de> <20070620124959.GB24906@frankl.hpl.hp.com> <200706201501.02582.ak@suse.de> <20070620183315.GA3251@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070620183315.GA3251@atjola.homenet>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel PerfMon NMI watchdog was using the generic reservation
function which always reserves the first performance counter. But the
watchdog actually uses the second performance counter, thus we need a
specialised function.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
---
 arch/i386/kernel/cpu/perfctr-watchdog.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
index a12dbcf..efc3232 100644
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -562,9 +562,27 @@ static int setup_intel_arch_watchdog(unsigned nmi_hz)
 	return 1;
 }
 
+static int intel_arch_reserve(void)
+{
+	if (!reserve_perfctr_nmi(MSR_ARCH_PERFMON_PERFCTR1))
+		return 0;
+
+	if (!reserve_evntsel_nmi(MSR_ARCH_PERFMON_EVENTSEL1)) {
+		release_perfctr_nmi(MSR_ARCH_PERFMON_PERFCTR1);
+		return 0;
+	}
+	return 1;
+}
+
+static void intel_arch_unreserve(void)
+{
+	release_evntsel_nmi(MSR_ARCH_PERFMON_EVENTSEL1);
+	release_perfctr_nmi(MSR_ARCH_PERFMON_PERFCTR1);
+}
+
 static struct wd_ops intel_arch_wd_ops = {
-	.reserve = single_msr_reserve,
-	.unreserve = single_msr_unreserve,
+	.reserve = intel_arch_reserve,
+	.unreserve = intel_arch_unreserve,
 	.setup = setup_intel_arch_watchdog,
 	.rearm = p6_rearm,
 	.stop = single_msr_stop_watchdog,
-- 
1.5.2.2

