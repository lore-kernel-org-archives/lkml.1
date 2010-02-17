Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab0BQLnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 06:43:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:39794 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab0BQLnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 06:43:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=MkrSQDUe/OMBsu4H4jG4eF9C17MnkCmbDc+4UEpc6p+t7mZoWRmlqL0J/aT0MJwZxx
         LPoJvN2cUEhFqhtoq8iDt4StgWjMOo5ZzLQMCMOsDhAqSrL+4ewRr5xxAubzvp4EHYbq
         MoANKIoAwNX2XunqU1p37qDLlcwTrPUixeY2c=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 10/10] x86-32: panic on !CX8 && XMM
Date: Wed, 17 Feb 2010 12:42:42 +0100
Message-Id: <1266406962-17463-11-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No known CPU should have this combination, and future ones are very
unlikely to.

However, should this happen, we would generate working but non-atomic
code, so panic instead.
---
 arch/x86/lib/atomic64_32.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index 9ff8589..35dbd12 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -47,6 +47,17 @@ EXPORT_SYMBOL(cx8_atomic64_inc_not_zero_cx8call);
 union generic_atomic64_lock generic_atomic64_lock[ATOMIC64_NR_LOCKS] __cacheline_aligned_in_smp;
 pure_initcall(init_generic_atomic64_lock);
 
+static int __init panic_on_sse_without_cx8(void)
+{
+	/* no known CPU should do this, and we generate non-atomic code in this case
+	 * because we mix the generic spinlock-reliant code and the SSE code
+	 */
+	if (!boot_cpu_has(X86_FEATURE_CX8) && boot_cpu_has(X86_FEATURE_XMM))
+		panic("CPUs without CX8 but with SSE are not supported\nBoot with clearcpuid=25 and report your CPU model to linux-kernel@vger.kernel.org\n");
+	return 0;
+}
+core_initcall(panic_on_sse_without_cx8);
+
 EXPORT_SYMBOL(generic_atomic64_add);
 EXPORT_SYMBOL(generic_atomic64_add_return);
 EXPORT_SYMBOL(generic_atomic64_sub);
-- 
1.6.6.1.476.g01ddb

