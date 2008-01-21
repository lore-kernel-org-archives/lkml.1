Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYAUU3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYAUU3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 15:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYAUU2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 15:28:03 -0500
Received: from relay2.sgi.com ([192.48.171.30]:55868 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752101AbYAUU1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 15:27:54 -0500
Message-Id: <20080121202748.444847000@sgi.com>
References: <20080121202747.593568000@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 12:27:53 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 6/8] Powerpc: Use generic per cpu rc8-mm1-fixup
Content-Disposition: inline; filename=power_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Powerpc has a way to determine the address of the per cpu area of the
currently executing processor via the paca and the array of per cpu
offsets is avoided by looking up the per cpu area from the remote
paca's (copying x86_64).

Based on: 2.6.24-rc8-mm1

Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
rc8-mm1-fixup:
  - rebased from 2.6.24-rc6-mm1 to 2.6.24-rc8-mm1
    (removed changes that are in the git-x86.patch)

V1->V2:
- add missing #endif

V2->V3:
- use generic percpy_modcopy()

---
 include/asm-powerpc/percpu.h |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

--- a/include/asm-powerpc/percpu.h
+++ b/include/asm-powerpc/percpu.h
@@ -16,25 +16,9 @@
 #define __my_cpu_offset() get_paca()->data_offset
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
-#define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()))
-#define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, local_paca->data_offset))
+#endif /* CONFIG_SMP */
+#endif /* __powerpc64__ */
 
-extern void setup_per_cpu_areas(void);
-
-#else /* ! SMP */
-
-#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
-#define __get_cpu_var(var)			per_cpu__##var
-#define __raw_get_cpu_var(var)			per_cpu__##var
-
-#endif	/* SMP */
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-
-#else
 #include <asm-generic/percpu.h>
-#endif
 
 #endif /* _ASM_POWERPC_PERCPU_H_ */

-- 
