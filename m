Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYIWN4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYIWN4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYIWNsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:48:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52438 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbYIWNrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:55 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 33/40] x86: paravirt: factor out cpu_khz to common code
Date: Tue, 23 Sep 2008 16:46:47 +0300
Message-Id: <1222177614-26669-34-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

KVM intends to use paravirt code to calibrate khz. Xen
current code will do just fine. So as a first step, factor out
code to pvclock.c.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kernel/pvclock.c |   12 ++++++++++++
 arch/x86/xen/time.c       |   11 ++---------
 include/asm-x86/pvclock.h |    1 +
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 05fbe9a..1c54b5f 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -97,6 +97,18 @@ static unsigned pvclock_get_time_values(struct pvclock_shadow_time *dst,
 	return dst->version;
 }
 
+unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src)
+{
+	u64 tsc_khz = 1000000ULL << 32;
+
+	do_div(tsc_khz, src->tsc_to_system_mul);
+	if (src->tsc_shift < 0)
+		tsc_khz <<= -src->tsc_shift;
+	else
+		tsc_khz >>= src->tsc_shift;
+	return tsc_khz;
+}
+
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 {
 	struct pvclock_shadow_time shadow;
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 685b774..1eb88fe 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -200,17 +200,10 @@ unsigned long long xen_sched_clock(void)
 /* Get the TSC speed from Xen */
 unsigned long xen_tsc_khz(void)
 {
-	u64 xen_khz = 1000000ULL << 32;
-	const struct pvclock_vcpu_time_info *info =
+	struct pvclock_vcpu_time_info *info =
 		&HYPERVISOR_shared_info->vcpu_info[0].time;
 
-	do_div(xen_khz, info->tsc_to_system_mul);
-	if (info->tsc_shift < 0)
-		xen_khz <<= -info->tsc_shift;
-	else
-		xen_khz >>= info->tsc_shift;
-
-	return xen_khz;
+	return pvclock_tsc_khz(info);
 }
 
 static cycle_t xen_clocksource_read(void)
diff --git a/include/asm-x86/pvclock.h b/include/asm-x86/pvclock.h
index 85b1bba..28783bc 100644
--- a/include/asm-x86/pvclock.h
+++ b/include/asm-x86/pvclock.h
@@ -6,6 +6,7 @@
 
 /* some helper functions for xen and kvm pv clock sources */
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src);
+unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src);
 void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct pvclock_vcpu_time_info *vcpu,
 			    struct timespec *ts);
-- 
1.6.0.1

