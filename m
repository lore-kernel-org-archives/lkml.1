Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbZHUGzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbZHUGzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 02:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932121AbZHUGzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 02:55:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109AbZHUGzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 02:55:43 -0400
Date: Fri, 21 Aug 2009 02:55:04 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
       bernhard.walle@gmx.de, Fenghua Yu <fenghua.yu@intel.com>,
       kamezawa.hiroyu@jp.fujitsu.com,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090821065729.4855.47860.sendpatchset@localhost.localdomain>
In-Reply-To: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
Subject: [Patch 5/8] ia64: implement crashkernel=auto
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since in patch 3/8 we already implement the generic part, this will
add the rest part for ia64.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>

---

Index: linux-2.6/arch/ia64/include/asm/kexec.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/kexec.h
+++ linux-2.6/arch/ia64/include/asm/kexec.h
@@ -19,6 +19,29 @@
                 flush_icache_range(page_addr, page_addr + PAGE_SIZE); \
         } while(0)
 
+#ifdef CONFIG_KEXEC_AUTO_RESERVE
+#define ARCH_HAS_DEFAULT_CRASH_SIZE
+static inline
+unsigned long long arch_default_crash_size(unsigned long long total_size)
+{
+	if (total_size >= 4ULL<<30 && total_size < 12ULL<<30)
+		return 1ULL<<28;
+	else if (total_size >= 12ULL<<30 && total_size < 128ULL<<30)
+		return 1ULL<<29;
+	else if (total_size >= 128ULL<<30 && total_size < 256ULL<<30)
+		return 3ULL<<28;
+	else if (total_size >= 256ULL<<30 && total_size < 378ULL<<30)
+		return 1ULL<<30;
+	else if (total_size >= 318ULL<<30 && total_size < 512ULL<<30)
+		return 3ULL<<29;
+	else if (total_size >= 512ULL<<30 && total_size < 768ULL<<30)
+		return 2ULL<<30;
+	else if (total_size >= 768ULL<<30)
+		return 3ULL<<30;
+}
+#include <asm-generic/kexec.h>
+#endif
+
 extern struct kimage *ia64_kimage;
 extern const unsigned int relocate_new_kernel_size;
 extern void relocate_new_kernel(unsigned long, unsigned long,
