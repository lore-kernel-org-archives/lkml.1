Return-Path: <linux-kernel-owner+w=401wt.eu-S1760273AbZIPWfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273AbZIPWfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758197AbZIPWfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:35:47 -0400
Received: from kroah.org ([198.145.64.141]:40999 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757040AbZIPWct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:49 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:29:05 2009
Message-Id: <20090916222904.882120418@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:28:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Brian King <brking@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 24/24] powerpc/pseries: Fix to handle slb resize across migration
References: <20090916222819.244332644@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-pseries-fix-to-handle-slb-resize-across-migration.patch
In-Reply-To: <20090916222934.GA31846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Brian King <brking@linux.vnet.ibm.com>

commit 46db2f86a3b2a94e0b33e0b4548fb7b7b6bdff66 upstream.

The SLB can change sizes across a live migration, which was not
being handled, resulting in possible machine crashes during
migration if migrating to a machine which has a smaller max SLB
size than the source machine. Fix this by first reducing the
SLB size to the minimum possible value, which is 32, prior to
migration. Then during the device tree update which occurs after
migration, we make the call to ensure the SLB gets updated. Also
add the slb_size to the lparcfg output so that the migration
tools can check to make sure the kernel has this capability
before allowing migration in scenarios where the SLB size will change.

BenH: Fixed #include <asm/mmu-hash64.h> -> <asm/mmu.h> to avoid
      breaking ppc32 build

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/include/asm/mmu-hash64.h     |    2 ++
 arch/powerpc/kernel/lparcfg.c             |    3 +++
 arch/powerpc/kernel/rtas.c                |    7 ++++++-
 arch/powerpc/mm/slb.c                     |   16 ++++++++++++----
 arch/powerpc/platforms/pseries/reconfig.c |    9 ++++++++-
 5 files changed, 31 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/mmu-hash64.h
+++ b/arch/powerpc/include/asm/mmu-hash64.h
@@ -41,6 +41,7 @@ extern char initial_stab[];
 
 #define SLB_NUM_BOLTED		3
 #define SLB_CACHE_ENTRIES	8
+#define SLB_MIN_SIZE		32
 
 /* Bits in the SLB ESID word */
 #define SLB_ESID_V		ASM_CONST(0x0000000008000000) /* valid */
@@ -296,6 +297,7 @@ extern void slb_flush_and_rebolt(void);
 extern void stab_initialize(unsigned long stab);
 
 extern void slb_vmalloc_update(void);
+extern void slb_set_size(u16 size);
 #endif /* __ASSEMBLY__ */
 
 /*
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -35,6 +35,7 @@
 #include <asm/prom.h>
 #include <asm/vdso_datapage.h>
 #include <asm/vio.h>
+#include <asm/mmu.h>
 
 #define MODULE_VERS "1.8"
 #define MODULE_NAME "lparcfg"
@@ -501,6 +502,8 @@ static int pseries_lparcfg_data(struct s
 
 	seq_printf(m, "shared_processor_mode=%d\n", lppaca[0].shared_proc);
 
+	seq_printf(m, "slb_size=%d\n", mmu_slb_size);
+
 	return 0;
 }
 
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -38,6 +38,7 @@
 #include <asm/syscalls.h>
 #include <asm/smp.h>
 #include <asm/atomic.h>
+#include <asm/mmu.h>
 
 struct rtas_t rtas = {
 	.lock = SPIN_LOCK_UNLOCKED
@@ -692,6 +693,7 @@ static void rtas_percpu_suspend_me(void 
 {
 	long rc = H_SUCCESS;
 	unsigned long msr_save;
+	u16 slb_size = mmu_slb_size;
 	int cpu;
 	struct rtas_suspend_me_data *data =
 		(struct rtas_suspend_me_data *)info;
@@ -714,13 +716,16 @@ static void rtas_percpu_suspend_me(void 
 		/* All other cpus are in H_JOIN, this cpu does
 		 * the suspend.
 		 */
+		slb_set_size(SLB_MIN_SIZE);
 		printk(KERN_DEBUG "calling ibm,suspend-me on cpu %i\n",
 		       smp_processor_id());
 		data->error = rtas_call(data->token, 0, 1, NULL);
 
-		if (data->error)
+		if (data->error) {
 			printk(KERN_DEBUG "ibm,suspend-me returned %d\n",
 			       data->error);
+			slb_set_size(slb_size);
+		}
 	} else {
 		printk(KERN_ERR "H_JOIN on cpu %i failed with rc = %ld\n",
 		       smp_processor_id(), rc);
--- a/arch/powerpc/mm/slb.c
+++ b/arch/powerpc/mm/slb.c
@@ -247,14 +247,22 @@ void switch_slb(struct task_struct *tsk,
 static inline void patch_slb_encoding(unsigned int *insn_addr,
 				      unsigned int immed)
 {
-	/* Assume the instruction had a "0" immediate value, just
-	 * "or" in the new value
-	 */
-	*insn_addr |= immed;
+	*insn_addr = (*insn_addr & 0xffff0000) | immed;
 	flush_icache_range((unsigned long)insn_addr, 4+
 			   (unsigned long)insn_addr);
 }
 
+void slb_set_size(u16 size)
+{
+	extern unsigned int *slb_compare_rr_to_size;
+
+	if (mmu_slb_size == size)
+		return;
+
+	mmu_slb_size = size;
+	patch_slb_encoding(slb_compare_rr_to_size, mmu_slb_size);
+}
+
 void slb_initialize(void)
 {
 	unsigned long linear_llp, vmalloc_llp, io_llp;
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -20,6 +20,7 @@
 #include <asm/machdep.h>
 #include <asm/uaccess.h>
 #include <asm/pSeries_reconfig.h>
+#include <asm/mmu.h>
 
 
 
@@ -439,9 +440,15 @@ static int do_update_property(char *buf,
 	if (!newprop)
 		return -ENOMEM;
 
+	if (!strcmp(name, "slb-size") || !strcmp(name, "ibm,slb-size"))
+		slb_set_size(*(int *)value);
+
 	oldprop = of_find_property(np, name,NULL);
-	if (!oldprop)
+	if (!oldprop) {
+		if (strlen(name))
+			return prom_add_property(np, newprop);
 		return -ENODEV;
+	}
 
 	rc = prom_update_property(np, newprop, oldprop);
 	if (rc)


