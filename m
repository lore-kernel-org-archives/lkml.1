Return-Path: <linux-kernel-owner+w=401wt.eu-S1760967AbZFRGqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967AbZFRGqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbZFRGqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:46:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36674 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZFRGqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:46:40 -0400
Message-ID: <4A39E2CF.80901@jp.fujitsu.com>
Date: Thu, 18 Jun 2009 15:46:39 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org
Subject: [PATCH 1/7] ia64, kdump: Mask MCA/INIT on freezing cpus
References: <4A39E247.4030908@jp.fujitsu.com>
In-Reply-To: <4A39E247.4030908@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is that the (badly) frozen cpus can be thawed by MCA/INIT.

The kdump_cpu_freeze() is called on cpus except one that initiates
panic and/or kdump, to stop/offline the cpu (on ia64, it means we pass
control of cpus to SAL, or put them in spin-loop).  Note that CPU0(BP)
always go to spin-loop, so if panic was happened on an AP, there are
2cpus (= the AP and BP) which not back to SAL.

On the spinning cpus, interrupts are disabled (rsm psr.i), but MCA/INIT
are still interruptible because psr.mc for mask them is not set unless
kdump_cpu_freeze is not invoked from MCA/INIT context.

Therefore, assume that a panic was happened on an AP, kdump was invoked,
new INIT handlers for kdump kernel was registered and then an INIT is
asserted.  From the viewpoint of SAL, there are 2 online cpus, so INIT
will be delivered to both of them.  It likely means that not only the AP
(= a cpu executing kdump) enters INIT handler which is newly registered,
but also BP (= another cpu spinning in panicked kernel) enters the same
INIT handler.  Of course setting of registers in BP are still old (for
panicked kernel), so what happen with running handler with wrong setting
will be extremely unexpected.  I believe this is not desirable behavior.

How to Reproduce:

  Start kdump on one of APs (e.g. cpu1)
    # taskset 0x2 echo c > /proc/sysrq-trigger
  Then assert INIT after kdump kernel booted

Sample of result:

  I got following console log by asserting INIT after prompt "root:/>".
  It seems two monarchs appeared by one INIT, and one panicked at last:

    :
    [  0 %]dropping to initramfs shell
    exiting this shell will reboot your system
    root:/> Entered OS INIT handler. PSP=fff301a0 cpu=0 monarch=0
    ia64_init_handler: Promoting cpu 0 to monarch.
    Delaying for 5 seconds...
    All OS INIT slaves have reached rendezvous
    Processes interrupted by INIT - 0 (cpu 0 task 0xa000000100af0000)
    :
    <<snip>>
    :
    Entered OS INIT handler. PSP=fff301a0 cpu=0 monarch=1
    Delaying for 5 seconds...
    mlogbuf_finish: printing switched to urgent mode, MCA/INIT might be dodgy or fail.
    OS INIT slave did not rendezvous on cpu 1 2 3
    INIT swapper 0[0]: bugcheck! 0 [1]
    :
    <<snip>>
    :
    Kernel panic - not syncing: Attempted to kill the idle task!

To avoid this problem, This patch inserts ia64_set_psr_mc() before the
deadloop to mask MCA/INIT on cpus going to be frozen.  I confirmed that
weird log like above are disappeared after applying this patch.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: kexec@lists.infradead.org
---
 arch/ia64/kernel/crash.c   |    6 ++++++
 arch/ia64/kernel/mca_asm.S |   27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
index f065093..48b69fd 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -95,6 +95,8 @@ kdump_wait_cpu_freeze(void)
 }
 #endif
 
+extern void ia64_set_psr_mc(void);
+
 void
 machine_crash_shutdown(struct pt_regs *pt)
 {
@@ -129,10 +131,14 @@ void
 kdump_cpu_freeze(struct unw_frame_info *info, void *arg)
 {
 	int cpuid;
+
 	local_irq_disable();
 	cpuid = smp_processor_id();
 	crash_save_this_cpu();
 	current->thread.ksp = (__u64)info->sw - 16;
+
+	ia64_set_psr_mc();	/* mask MCA/INIT and stop reentrance */
+
 	atomic_inc(&kdump_cpu_frozen);
 	kdump_status[cpuid] = 1;
 	mb();
diff --git a/arch/ia64/kernel/mca_asm.S b/arch/ia64/kernel/mca_asm.S
index a06d465..c6ee089 100644
--- a/arch/ia64/kernel/mca_asm.S
+++ b/arch/ia64/kernel/mca_asm.S
@@ -1073,3 +1073,30 @@ GLOBAL_ENTRY(ia64_get_rnat)
 	mov ar.rsc=3
 	br.ret.sptk.many rp
 END(ia64_get_rnat)
+
+
+// ia64_set_psr_mc(void)
+//
+// Set psr.mc bit to mask MCA/INIT.
+GLOBAL_ENTRY(ia64_set_psr_mc)
+	rsm psr.i | psr.ic		// disable interrupts
+	;;
+	srlz.d
+	;;
+	mov r14 = psr			// get psr{36:35,31:0}
+	movl r15 = .return
+	;;
+	dep r14 = -1, r14, PSR_MC, 1	// set psr.mc
+	;;
+	dep r14 = -1, r14, PSR_IC, 1	// set psr.ic
+	;;
+	dep r14 = -1, r14, PSR_BN, 1	// keep bank1 in use
+	;;
+	mov cr.ipsr = r14
+	mov cr.ifs = r0
+	mov cr.iip = r15
+	;;
+	rfi
+.return:
+	br.ret.sptk.many rp
+END(ia64_set_psr_mc)
-- 
1.6.0


