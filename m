Return-Path: <linux-kernel-owner+w=401wt.eu-S933079AbZJNTaC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbZJNTaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:30:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759078AbZJNTaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:30:00 -0400
Received: from claw.goop.org ([74.207.240.146]:55333 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276AbZJNT35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:29:57 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>, Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 07/12] pvclock: there's no need to copy time_info into shadow
Date: Wed, 14 Oct 2009 12:28:31 -0700
Message-Id: <1255548516-15260-8-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use the vcpu_time_info as-is, without needing to copy it.  We just
need to grab a copy of the version number before starting, then we can
compute the time using the time_info directly.  If things changed under
our feet, then we just go back and do the whole thing again.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Glauber Costa <gcosta@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/kernel/pvclock.c |   47 +++++---------------------------------------
 1 files changed, 6 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 963f349..e43cd78 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -20,20 +20,6 @@
 #include <asm/pvclock.h>
 
 /*
- * These are perodically updated
- *    xen: magic shared_info page
- *    kvm: gpa registered via msr
- * and then copied here.
- */
-struct pvclock_shadow_time {
-	u64 tsc_timestamp;     /* TSC at last update of time vals.  */
-	u64 system_timestamp;  /* Time, in nanosecs, since boot.    */
-	u32 tsc_to_nsec_mul;
-	int tsc_shift;
-	u32 version;
-};
-
-/*
  * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
  * yielding a 64-bit result.
  */
@@ -71,30 +57,10 @@ static inline u64 scale_delta(u64 delta, u32 mul_frac, int shift)
 	return product;
 }
 
-static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time *shadow)
-{
-	u64 delta = native_read_tsc() - shadow->tsc_timestamp;
-	return scale_delta(delta, shadow->tsc_to_nsec_mul, shadow->tsc_shift);
-}
-
-/*
- * Reads a consistent set of time-base values from hypervisor,
- * into a shadow data area.
- */
-static unsigned pvclock_get_time_values(struct pvclock_shadow_time *dst,
-					struct pvclock_vcpu_time_info *src)
+static u64 pvclock_get_nsec_offset(const struct pvclock_vcpu_time_info *src)
 {
-	do {
-		dst->version = src->version;
-		rmb();		/* fetch version before data */
-		dst->tsc_timestamp     = src->tsc_timestamp;
-		dst->system_timestamp  = src->system_time;
-		dst->tsc_to_nsec_mul   = src->tsc_to_system_mul;
-		dst->tsc_shift         = src->tsc_shift;
-		rmb();		/* test version after fetching data */
-	} while ((src->version & 1) || (dst->version != src->version));
-
-	return dst->version;
+	u64 delta = native_read_tsc() - src->tsc_timestamp;
+	return scale_delta(delta, src->tsc_to_system_mul, src->tsc_shift);
 }
 
 unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src)
@@ -111,15 +77,14 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src)
 
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 {
-	struct pvclock_shadow_time shadow;
 	unsigned version;
 	cycle_t ret, offset;
 
 	do {
-		version = pvclock_get_time_values(&shadow, src);
+		version = src->version;
 		rdtsc_barrier();
-		offset = pvclock_get_nsec_offset(&shadow);
-		ret = shadow.system_timestamp + offset;
+		offset = pvclock_get_nsec_offset(src);
+		ret = src->system_time + offset;
 		rdtsc_barrier();
 	} while (version != src->version);
 
-- 
1.6.2.5

