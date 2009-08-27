Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZH0DTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZH0DTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZH0DTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:19:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZH0DTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:19:19 -0400
Date: Wed, 26 Aug 2009 23:16:42 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       kamezawa.hiroyu@jp.fujitsu.com, Andi Kleen <andi@firstfloor.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Amerigo Wang <amwang@redhat.com>, "M. Mohan Kumar" <mohan@in.ibm.com>,
       akpm@linux-foundation.org, bernhard.walle@gmx.de,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090827031909.4534.24859.sendpatchset@localhost.localdomain>
In-Reply-To: <20090827031800.4534.94868.sendpatchset@localhost.localdomain>
References: <20090827031800.4534.94868.sendpatchset@localhost.localdomain>
Subject: [Patch 6/8] powerpc: implement crashkernel=auto
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since in patch 2/8 we already implement the generic part, this will
add the rest part for powerpc.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: M. Mohan Kumar <mohan@in.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>

---

Index: linux-2.6/arch/powerpc/include/asm/kexec.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/kexec.h
+++ linux-2.6/arch/powerpc/include/asm/kexec.h
@@ -39,6 +39,45 @@ typedef void (*crash_shutdown_t)(void);
 
 #ifdef CONFIG_KEXEC
 
+#ifdef CONFIG_KEXEC_AUTO_RESERVE
+
+#ifndef KEXEC_AUTO_THRESHOLD
+#define KEXEC_AUTO_THRESHOLD (1ULL<<31) /* 2G */
+#endif
+
+#ifndef arch_default_crash_base
+static inline
+unsigned long long arch_default_crash_base(void)
+{
+	return KDUMP_KERNELBASE;
+}
+#define arch_default_crash_base arch_default_crash_base
+#endif
+
+#ifndef arch_default_crash_size
+static inline
+unsigned long long arch_default_crash_size(unsigned long long total_size)
+{
+	if (total_size < KEXEC_AUTO_THRESHOLD)
+		return 0;
+	if (total_size < (1ULL<<32))
+		return 1ULL<<27;
+	else {
+#ifdef CONFIG_64BIT
+		if (total_size > (1ULL<<37)) /* 128G */
+			return 1ULL<<32; /* 4G */
+		return 1ULL<<ilog2(roundup(total_size/32, 1ULL<<21));
+#else
+		return 1ULL<<28;
+#endif
+	}
+}
+#define arch_default_crash_size arch_default_crash_size
+#endif
+
+#endif
+#include <asm-generic/kexec.h>
+
 /*
  * This function is responsible for capturing register states if coming
  * via panic or invoking dump using sysrq-trigger.
