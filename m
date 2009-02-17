Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbZBQQe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbZBQQe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbZBQQeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:34:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40218 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZBQQeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:34:17 -0500
Date: Tue, 17 Feb 2009 17:34:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core fixes
Message-ID: <20090217163406.GA2153@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
David Woodhouse (1):
      iommu: fix Intel IOMMU write-buffer flushing

Peter Zijlstra (1):
      futex: fix reference leak


 drivers/pci/intel-iommu.c |   16 ++++++++++++-
 kernel/futex.c            |   53 +++++++++++++++++++++++---------------------
 2 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index f4b7c79..f3f6865 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -61,6 +61,8 @@
 /* global iommu list, set NULL for ignored DMAR units */
 static struct intel_iommu **g_iommus;
 
+static int rwbf_quirk;
+
 /*
  * 0: Present
  * 1-11: Reserved
@@ -785,7 +787,7 @@ static void iommu_flush_write_buffer(struct intel_iommu *iommu)
 	u32 val;
 	unsigned long flag;
 
-	if (!cap_rwbf(iommu->cap))
+	if (!rwbf_quirk && !cap_rwbf(iommu->cap))
 		return;
 	val = iommu->gcmd | DMA_GCMD_WBF;
 
@@ -3137,3 +3139,15 @@ static struct iommu_ops intel_iommu_ops = {
 	.unmap		= intel_iommu_unmap_range,
 	.iova_to_phys	= intel_iommu_iova_to_phys,
 };
+
+static void __devinit quirk_iommu_rwbf(struct pci_dev *dev)
+{
+	/*
+	 * Mobile 4 Series Chipset neglects to set RWBF capability,
+	 * but needs it:
+	 */
+	printk(KERN_INFO "DMAR: Forcing write-buffer flush capability\n");
+	rwbf_quirk = 1;
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_rwbf);
diff --git a/kernel/futex.c b/kernel/futex.c
index f89d373..438701a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1165,6 +1165,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
 {
 	struct task_struct *curr = current;
+	struct restart_block *restart;
 	DECLARE_WAITQUEUE(wait, curr);
 	struct futex_hash_bucket *hb;
 	struct futex_q q;
@@ -1216,11 +1217,13 @@ retry:
 
 		if (!ret)
 			goto retry;
-		return ret;
+		goto out;
 	}
 	ret = -EWOULDBLOCK;
-	if (uval != val)
-		goto out_unlock_put_key;
+	if (unlikely(uval != val)) {
+		queue_unlock(&q, hb);
+		goto out_put_key;
+	}
 
 	/* Only actually queue if *uaddr contained val.  */
 	queue_me(&q, hb);
@@ -1284,38 +1287,38 @@ retry:
 	 */
 
 	/* If we were woken (and unqueued), we succeeded, whatever. */
+	ret = 0;
 	if (!unqueue_me(&q))
-		return 0;
+		goto out_put_key;
+	ret = -ETIMEDOUT;
 	if (rem)
-		return -ETIMEDOUT;
+		goto out_put_key;
 
 	/*
 	 * We expect signal_pending(current), but another thread may
 	 * have handled it for us already.
 	 */
+	ret = -ERESTARTSYS;
 	if (!abs_time)
-		return -ERESTARTSYS;
-	else {
-		struct restart_block *restart;
-		restart = &current_thread_info()->restart_block;
-		restart->fn = futex_wait_restart;
-		restart->futex.uaddr = (u32 *)uaddr;
-		restart->futex.val = val;
-		restart->futex.time = abs_time->tv64;
-		restart->futex.bitset = bitset;
-		restart->futex.flags = 0;
-
-		if (fshared)
-			restart->futex.flags |= FLAGS_SHARED;
-		if (clockrt)
-			restart->futex.flags |= FLAGS_CLOCKRT;
-		return -ERESTART_RESTARTBLOCK;
-	}
+		goto out_put_key;
 
-out_unlock_put_key:
-	queue_unlock(&q, hb);
-	put_futex_key(fshared, &q.key);
+	restart = &current_thread_info()->restart_block;
+	restart->fn = futex_wait_restart;
+	restart->futex.uaddr = (u32 *)uaddr;
+	restart->futex.val = val;
+	restart->futex.time = abs_time->tv64;
+	restart->futex.bitset = bitset;
+	restart->futex.flags = 0;
+
+	if (fshared)
+		restart->futex.flags |= FLAGS_SHARED;
+	if (clockrt)
+		restart->futex.flags |= FLAGS_CLOCKRT;
 
+	ret = -ERESTART_RESTARTBLOCK;
+
+out_put_key:
+	put_futex_key(fshared, &q.key);
 out:
 	return ret;
 }
