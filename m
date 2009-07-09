Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbZGIHMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbZGIHMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZGIHMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:12:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60057 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZGIHMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:12:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A559832.3080000@jp.fujitsu.com>
Date: Thu, 09 Jul 2009 16:11:46 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org, "Luck, Tony" <tony.luck@intel.com>,
       "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: [PATCH v2 2/7] ia64, kexec: Make INIT safe while transition to kdump/kexec
 kernel
References: <4A39E247.4030908@jp.fujitsu.com> <4A5595F3.2050609@jp.fujitsu.com>
In-Reply-To: <4A5595F3.2050609@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary:

  Asserting INIT on the beginning of kdump/kexec kernel will result
  in unexpected behavior because INIT handler for previous kernel is
  invoked on new kernel.

Description:

  In panic situation, we can receive INIT while kernel transition,
  i.e. from beginning of panic to bootstrap of kdump kernel.
  Since we initialize registers on leave from current kernel, no
  longer monarch/slave handlers of current kernel in virtual mode are
  called safely.  (In fact system goes hang as far as I confirmed)

How to Reproduce:

  Start kdump
    # echo c > /proc/sysrq-trigger
  Then assert INIT while kdump kernel is booting, before new INIT
  handler for kdump kernel is registered.

Expected(Desirable) result:

  kdump kernel boots without any problem, crashdump retrieved

Actual result:

  INIT handler for previous kernel is invoked on kdump kernel
  => panic, hang etc. (unexpected)

Proposed fix:

  We can unregister these init handlers from SAL before jumping into
  new kernel, however then the INIT will fallback to default behavior,
  result in warmboot by SAL (according to the SAL specification) and
  we cannot retrieve the crashdump.

  Therefore this patch introduces a NOP init handler and register it
  to SAL before leave from current kernel, to start kdump safely by
  preventing INITs from entering virtual mode and resulting in warmboot.

  On the other hand, in case of kexec that not for kdump, it also
  has same problem with INIT while kernel transition.
  This patch handles this case differently, because for kexec
  unregistering handlers will be preferred than registering NOP
  handler, since the situation "no handlers registered" is usual
  state for kernel's entry.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: kexec@lists.infradead.org
---
 arch/ia64/include/asm/mca.h      |    1 +
 arch/ia64/kernel/machine_kexec.c |   12 ++++++++++++
 arch/ia64/kernel/mca_asm.S       |   20 ++++++++++++++++++++
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/include/asm/mca.h b/arch/ia64/include/asm/mca.h
index cb0952f..c171cdf 100644
--- a/arch/ia64/include/asm/mca.h
+++ b/arch/ia64/include/asm/mca.h
@@ -145,6 +145,7 @@ extern void ia64_mca_ucmc_handler(struct pt_regs *, struct ia64_sal_os_state *);
 extern void ia64_init_handler(struct pt_regs *,
 			      struct switch_stack *,
 			      struct ia64_sal_os_state *);
+extern void ia64_os_init_on_kdump(void);
 extern void ia64_monarch_init_handler(void);
 extern void ia64_slave_init_handler(void);
 extern void ia64_mca_cmc_vector_setup(void);
diff --git a/arch/ia64/kernel/machine_kexec.c b/arch/ia64/kernel/machine_kexec.c
index 0823de1..571d663 100644
--- a/arch/ia64/kernel/machine_kexec.c
+++ b/arch/ia64/kernel/machine_kexec.c
@@ -24,6 +24,8 @@
 #include <asm/delay.h>
 #include <asm/meminit.h>
 #include <asm/processor.h>
+#include <asm/sal.h>
+#include <asm/mca.h>
 
 typedef NORET_TYPE void (*relocate_new_kernel_t)(
 					unsigned long indirection_page,
@@ -85,11 +87,21 @@ static void ia64_machine_kexec(struct unw_frame_info *info, void *arg)
 	void *pal_addr = efi_get_pal_addr();
 	unsigned long code_addr = (unsigned long)page_address(image->control_code_page);
 	int ii;
+	u64 fp, gp;
+	ia64_fptr_t *init_handler = (ia64_fptr_t *)ia64_os_init_on_kdump;
 
 	BUG_ON(!image);
 	if (image->type == KEXEC_TYPE_CRASH) {
 		crash_save_this_cpu();
 		current->thread.ksp = (__u64)info->sw - 16;
+
+		/* Register noop init handler */
+		fp = ia64_tpa(init_handler->fp);
+		gp = ia64_tpa(ia64_getreg(_IA64_REG_GP));
+		ia64_sal_set_vectors(SAL_VECTOR_OS_INIT, fp, gp, 0, fp, gp, 0);
+	} else {
+		/* Unregister init handlers of current kernel */
+		ia64_sal_set_vectors(SAL_VECTOR_OS_INIT, 0, 0, 0, 0, 0, 0);
 	}
 
 	/* Interrupts aren't acceptable while we reboot */
diff --git a/arch/ia64/kernel/mca_asm.S b/arch/ia64/kernel/mca_asm.S
index 8d2eabe..7461d25 100644
--- a/arch/ia64/kernel/mca_asm.S
+++ b/arch/ia64/kernel/mca_asm.S
@@ -40,6 +40,7 @@
 
 	.global ia64_do_tlb_purge
 	.global ia64_os_mca_dispatch
+	.global ia64_os_init_on_kdump
 	.global ia64_os_init_dispatch_monarch
 	.global ia64_os_init_dispatch_slave
 
@@ -299,6 +300,25 @@ END(ia64_os_mca_virtual_begin)
 //StartMain////////////////////////////////////////////////////////////////////
 
 //
+// NOP init handler for kdump.  In panic situation, we may receive INIT
+// while kernel transition.  Since we initialize registers on leave from
+// current kernel, no longer monarch/slave handlers of current kernel in
+// virtual mode are called safely.
+// We can unregister these init handlers from SAL, however then the INIT
+// will result in warmboot by SAL and we cannot retrieve the crashdump.
+// Therefore register this NOP function to SAL, to prevent entering virtual
+// mode and resulting warmboot by SAL.
+//
+ia64_os_init_on_kdump:
+	mov		r8=r0		// IA64_INIT_RESUME
+	mov             r9=r10		// SAL_GP
+	mov		r22=r17		// *minstate
+	;;
+	mov		r10=r0		// return to same context
+	mov		b0=r12		// SAL_CHECK return address
+	br		b0
+
+//
 // SAL to OS entry point for INIT on all processors.  This has been defined for
 // registration purposes with SAL as a part of ia64_mca_init.  Monarch and
 // slave INIT have identical processing, except for the value of the
-- 
1.6.0


