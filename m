Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbYKHH5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbYKHH5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 02:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbYKHH5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 02:57:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46695 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbYKHH5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 02:57:11 -0500
Date: Sat, 8 Nov 2008 08:57:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [git pull] OProfile fixes
Message-ID: <20081108075700.GA2417@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest oprofile-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git oprofile-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      oprofile: Fix p6 counter overflow check

Carl Love (2):
      Cell OProfile: Incorrect local array size in activate spu profiling function
      Cell OProfile: Incorrect local array size in activate spu profiling function

Jesper Dangaard Brouer (1):
      Change UTF8 chars in Kconfig help text about Oprofile AMD barcelona

Nick Piggin (1):
      oprofile: fix memory ordering

Robert Richter (1):
      Revert "Cell OProfile: Incorrect local array size in activate spu profiling function"


 arch/Kconfig                      |    2 +-
 arch/x86/oprofile/op_model_ppro.c |    9 ++++-----
 drivers/oprofile/event_buffer.c   |    6 +++---
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index e6ab550..8977d99 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -21,7 +21,7 @@ config OPROFILE_IBS
           Instruction-Based Sampling (IBS) is a new profiling
           technique that provides rich, precise program performance
           information. IBS is introduced by AMD Family10h processors
-          (AMD Opteron Quad-Core processor “Barcelona”) to overcome
+          (AMD Opteron Quad-Core processor "Barcelona") to overcome
           the limitations of conventional performance counter
           sampling.
 
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 0620d6d..3f1b81a 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -27,8 +27,7 @@ static int num_counters = 2;
 static int counter_width = 32;
 
 #define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
-#define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
-#define CTR_OVERFLOWED(n) (!((n) & (1U<<(counter_width-1))))
+#define CTR_OVERFLOWED(n) (!((n) & (1ULL<<(counter_width-1))))
 
 #define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
 #define CTRL_READ(l, h, msrs, c) do {rdmsr((msrs->controls[(c)].addr), (l), (h)); } while (0)
@@ -124,14 +123,14 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
 static int ppro_check_ctrs(struct pt_regs * const regs,
 			   struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
 	for (i = 0 ; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
-		CTR_READ(low, high, msrs, i);
-		if (CTR_OVERFLOWED(low)) {
+		rdmsrl(msrs->counters[i].addr, val);
+		if (CTR_OVERFLOWED(val)) {
 			oprofile_add_sample(regs, i);
 			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
 		}
diff --git a/drivers/oprofile/event_buffer.c b/drivers/oprofile/event_buffer.c
index d962ba0..191a320 100644
--- a/drivers/oprofile/event_buffer.c
+++ b/drivers/oprofile/event_buffer.c
@@ -105,7 +105,7 @@ static int event_buffer_open(struct inode *inode, struct file *file)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (test_and_set_bit(0, &buffer_opened))
+	if (test_and_set_bit_lock(0, &buffer_opened))
 		return -EBUSY;
 
 	/* Register as a user of dcookies
@@ -129,7 +129,7 @@ static int event_buffer_open(struct inode *inode, struct file *file)
 fail:
 	dcookie_unregister(file->private_data);
 out:
-	clear_bit(0, &buffer_opened);
+	__clear_bit_unlock(0, &buffer_opened);
 	return err;
 }
 
@@ -141,7 +141,7 @@ static int event_buffer_release(struct inode *inode, struct file *file)
 	dcookie_unregister(file->private_data);
 	buffer_pos = 0;
 	atomic_set(&buffer_ready, 0);
-	clear_bit(0, &buffer_opened);
+	__clear_bit_unlock(0, &buffer_opened);
 	return 0;
 }
 
