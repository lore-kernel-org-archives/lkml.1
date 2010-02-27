Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968570Ab0B0Q2B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:28:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59969 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968551Ab0B0Q2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:28:00 -0500
Date: Sat, 27 Feb 2010 17:27:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mtrr changes for v2.6.34
Message-ID: <20100227162750.GA5821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mtrr-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mtrr-for-linus

 Thanks,

	Ingo

------------------>
Alan Cox (1):
      x86, mtrr: Kill over the top warn

Emese Revfy (1):
      x86, mtrr: Constify struct mtrr_ops

Thomas Gleixner (1):
      x86: Convert set_atomicity_lock to raw_spinlock


 arch/x86/kernel/cpu/mtrr/amd.c     |    2 +-
 arch/x86/kernel/cpu/mtrr/centaur.c |    2 +-
 arch/x86/kernel/cpu/mtrr/cyrix.c   |    2 +-
 arch/x86/kernel/cpu/mtrr/generic.c |   10 +++++-----
 arch/x86/kernel/cpu/mtrr/main.c    |    6 +++---
 arch/x86/kernel/cpu/mtrr/mtrr.h    |    6 +++---
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/amd.c b/arch/x86/kernel/cpu/mtrr/amd.c
index 33af141..92ba9cd 100644
--- a/arch/x86/kernel/cpu/mtrr/amd.c
+++ b/arch/x86/kernel/cpu/mtrr/amd.c
@@ -108,7 +108,7 @@ amd_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
 	return 0;
 }
 
-static struct mtrr_ops amd_mtrr_ops = {
+static const struct mtrr_ops amd_mtrr_ops = {
 	.vendor            = X86_VENDOR_AMD,
 	.set               = amd_set_mtrr,
 	.get               = amd_get_mtrr,
diff --git a/arch/x86/kernel/cpu/mtrr/centaur.c b/arch/x86/kernel/cpu/mtrr/centaur.c
index de89f14..316fe3e 100644
--- a/arch/x86/kernel/cpu/mtrr/centaur.c
+++ b/arch/x86/kernel/cpu/mtrr/centaur.c
@@ -110,7 +110,7 @@ centaur_validate_add_page(unsigned long base, unsigned long size, unsigned int t
 	return 0;
 }
 
-static struct mtrr_ops centaur_mtrr_ops = {
+static const struct mtrr_ops centaur_mtrr_ops = {
 	.vendor            = X86_VENDOR_CENTAUR,
 	.set               = centaur_set_mcr,
 	.get               = centaur_get_mcr,
diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index 228d982..68a3343 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -265,7 +265,7 @@ static void cyrix_set_all(void)
 	post_set();
 }
 
-static struct mtrr_ops cyrix_mtrr_ops = {
+static const struct mtrr_ops cyrix_mtrr_ops = {
 	.vendor            = X86_VENDOR_CYRIX,
 	.set_all	   = cyrix_set_all,
 	.set               = cyrix_set_arr,
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 55da0c5..9aa5dc7 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -464,7 +464,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 		tmp |= ~((1<<(hi - 1)) - 1);
 
 		if (tmp != mask_lo) {
-			WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
+			printk(KERN_WARNING "mtrr: your BIOS has configured an incorrect mask, fixing it.\n");
 			mask_lo = tmp;
 		}
 	}
@@ -570,7 +570,7 @@ static unsigned long set_mtrr_state(void)
 
 
 static unsigned long cr4;
-static DEFINE_SPINLOCK(set_atomicity_lock);
+static DEFINE_RAW_SPINLOCK(set_atomicity_lock);
 
 /*
  * Since we are disabling the cache don't allow any interrupts,
@@ -590,7 +590,7 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 	 * changes to the way the kernel boots
 	 */
 
-	spin_lock(&set_atomicity_lock);
+	raw_spin_lock(&set_atomicity_lock);
 
 	/* Enter the no-fill (CD=1, NW=0) cache mode and flush caches. */
 	cr0 = read_cr0() | X86_CR0_CD;
@@ -627,7 +627,7 @@ static void post_set(void) __releases(set_atomicity_lock)
 	/* Restore value of CR4 */
 	if (cpu_has_pge)
 		write_cr4(cr4);
-	spin_unlock(&set_atomicity_lock);
+	raw_spin_unlock(&set_atomicity_lock);
 }
 
 static void generic_set_all(void)
@@ -752,7 +752,7 @@ int positive_have_wrcomb(void)
 /*
  * Generic structure...
  */
-struct mtrr_ops generic_mtrr_ops = {
+const struct mtrr_ops generic_mtrr_ops = {
 	.use_intel_if		= 1,
 	.set_all		= generic_set_all,
 	.get			= generic_get_mtrr,
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 84e83de..fe4622e 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -60,14 +60,14 @@ static DEFINE_MUTEX(mtrr_mutex);
 u64 size_or_mask, size_and_mask;
 static bool mtrr_aps_delayed_init;
 
-static struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM];
+static const struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM];
 
-struct mtrr_ops *mtrr_if;
+const struct mtrr_ops *mtrr_if;
 
 static void set_mtrr(unsigned int reg, unsigned long base,
 		     unsigned long size, mtrr_type type);
 
-void set_mtrr_ops(struct mtrr_ops *ops)
+void set_mtrr_ops(const struct mtrr_ops *ops)
 {
 	if (ops->vendor && ops->vendor < X86_VENDOR_NUM)
 		mtrr_ops[ops->vendor] = ops;
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index a501dee..df5e41f 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -32,7 +32,7 @@ extern int generic_get_free_region(unsigned long base, unsigned long size,
 extern int generic_validate_add_page(unsigned long base, unsigned long size,
 				     unsigned int type);
 
-extern struct mtrr_ops generic_mtrr_ops;
+extern const struct mtrr_ops generic_mtrr_ops;
 
 extern int positive_have_wrcomb(void);
 
@@ -53,10 +53,10 @@ void fill_mtrr_var_range(unsigned int index,
 		u32 base_lo, u32 base_hi, u32 mask_lo, u32 mask_hi);
 void get_mtrr_state(void);
 
-extern void set_mtrr_ops(struct mtrr_ops *ops);
+extern void set_mtrr_ops(const struct mtrr_ops *ops);
 
 extern u64 size_or_mask, size_and_mask;
-extern struct mtrr_ops *mtrr_if;
+extern const struct mtrr_ops *mtrr_if;
 
 #define is_cpu(vnd)	(mtrr_if && mtrr_if->vendor == X86_VENDOR_##vnd)
 #define use_intel()	(mtrr_if && mtrr_if->use_intel_if == 1)
