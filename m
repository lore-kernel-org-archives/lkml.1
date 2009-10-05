Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbZJEGnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbZJEGnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbZJEGno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:43:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53855 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbZJEGnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:43:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC99568.7060703@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 15:42:48 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/10] x86, mce: make mce_log buffer to ring buffer
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com> <4AC990E1.7030708@jp.fujitsu.com>
In-Reply-To: <4AC990E1.7030708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements Per-CPU ring buffer data structure.

  + An array is used to hold MCE records. integer "head" indicates
    next writing position and integer "tail" indicates next reading
    position.

  + To distinguish buffer empty and full, head and tail wrap to 0 at
    MCE_LOG_LIMIT instead of MCE_LOG_LEN. Then the real next writing
    position is head % MCE_LOG_LEN, and real next reading position is
    tail % MCE_LOG_LEN. If buffer is empty, head == tail, if buffer is
    full, head % MCE_LOG_LEN == tail % MCE_LOG_LEN and head != tail.

(This piece originates from Huang's patch, titled:
 "x86, MCE: Fix bugs and issues of MCE log ring buffer")

Originally-From: Huang Ying <ying.huang@intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h       |    6 +++
 arch/x86/kernel/cpu/mcheck/mce.c |   77 +++++++++++++++++++++----------------
 2 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index c5d4144..4b5ef3c 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -82,6 +82,12 @@ struct mce {
  */
 
 #define MCE_LOG_LEN		32
+#define MCE_LOG_LIMIT		(MCE_LOG_LEN * 2 - 1)
+
+static inline int mce_log_index(int n)
+{
+	return n >= MCE_LOG_LEN ? n - MCE_LOG_LEN : n;
+}
 
 struct mce_log_cpu;
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 655915b..63a7820 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -123,7 +123,8 @@ EXPORT_PER_CPU_SYMBOL_GPL(mce_fake_banks);
  */
 
 struct mce_log_cpu {
-	unsigned next;
+	int head;
+	int tail;
 	struct mce entry[MCE_LOG_LEN];
 };
 
@@ -139,32 +140,34 @@ static struct mce_log mcelog = {
 void mce_log(struct mce *mce)
 {
 	struct mce_log_cpu *mcelog_cpu = &__get_cpu_var(mce_log_cpus);
-	unsigned next, entry;
+	int head, ihead, tail, next;
 
 	/* mce->finished must be set to 0 before written to buffer */
 	mce->finished = 0;
 	smp_wmb();
 
 	do {
-		entry = mcelog_cpu->next;
+		head = mcelog_cpu->head;
+		tail = mcelog_cpu->tail;
+		ihead = mce_log_index(head);
+
 		/*
 		 * When the buffer fills up discard new entries.
 		 * Assume that the earlier errors are the more
-		 * interesting ones:
+		 * interesting.
 		 */
-		if (entry >= MCE_LOG_LEN) {
+		if (ihead == mce_log_index(tail) && head != tail) {
 			set_bit(MCE_OVERFLOW, (unsigned long *)&mcelog.flags);
 			return;
 		}
-		smp_rmb();
-		next = entry + 1;
-	} while (cmpxchg_local(&mcelog_cpu->next, entry, next) != entry);
+		next = head == MCE_LOG_LIMIT ? 0 : head + 1;
+	} while (cmpxchg_local(&mcelog_cpu->head, head, next) != head);
 
-	memcpy(mcelog_cpu->entry + entry, mce, sizeof(struct mce));
+	memcpy(mcelog_cpu->entry + ihead, mce, sizeof(struct mce));
 
 	/* ".finished" of MCE record in buffer must be set after copy */
 	smp_wmb();
-	mcelog_cpu->entry[entry].finished = 1;
+	mcelog_cpu->entry[ihead].finished = 1;
 
 	/* bit 0 of notify_user should be set after finished be set */
 	smp_wmb();
@@ -1486,42 +1489,50 @@ static ssize_t mce_read_cpu(int cpu, char __user *inubuf, size_t usize)
 {
 	struct mce_log_cpu *mcelog_cpu = &per_cpu(mce_log_cpus, cpu);
 	char __user *ubuf = inubuf;
-	unsigned prev, next;
-	int i, err;
+	int head, tail, pos, i, err = 0;
 
-	next = mcelog_cpu->next;
-	if (!next)
+	head = mcelog_cpu->head;
+	tail = mcelog_cpu->tail;
+	if (head == tail)
 		return 0;
 
-	err = 0;
-	prev = 0;
-	do {
-		for (i = prev; i < next; i++) {
+	for (pos = tail; pos != head && usize >= sizeof(struct mce);
+	     pos = pos == MCE_LOG_LIMIT ? 0 : pos+1) {
+		i = mce_log_index(pos);
+		if (!mcelog_cpu->entry[i].finished) {
 			int timeout = WRITER_TIMEOUT_NS;
 
 			while (!mcelog_cpu->entry[i].finished) {
 				if (timeout-- <= 0) {
 					memset(mcelog_cpu->entry + i, 0,
 					       sizeof(struct mce));
+					head = mcelog_cpu->head;
 					printk(KERN_WARNING "mcelog: timeout "
 					     "waiting for writer to finish!\n");
 					goto timeout;
 				}
 				ndelay(1);
 			}
-			smp_rmb();
-			err |= copy_to_user(ubuf, mcelog_cpu->entry + i,
-					    sizeof(struct mce));
-			ubuf += sizeof(struct mce);
-timeout:
-			;
 		}
-
-		memset(mcelog_cpu->entry + prev, 0,
-		       (next - prev) * sizeof(struct mce));
-		prev = next;
-		next = cmpxchg(&mcelog_cpu->next, prev, 0);
-	} while (next != prev);
+		/*
+		 * finished field should be checked before
+		 * copy_to_user()
+		 */
+		smp_rmb();
+		err |= copy_to_user(ubuf, mcelog_cpu->entry + i,
+				   sizeof(struct mce));
+		ubuf += sizeof(struct mce);
+		usize -= sizeof(struct mce);
+		mcelog_cpu->entry[i].finished = 0;
+timeout:
+		;
+	}
+	/*
+	 * mcelog_cpu->tail must be updated after ".finished" of
+	 * corresponding MCE records are clear.
+	 */
+	smp_wmb();
+	mcelog_cpu->tail = pos;
 
 	return err ? -EFAULT : ubuf - inubuf;
 }
@@ -1533,7 +1544,7 @@ static int mce_empty(void)
 
 	for_each_possible_cpu(cpu) {
 		mcelog_cpu = &per_cpu(mce_log_cpus, cpu);
-		if (mcelog_cpu->next)
+		if (mcelog_cpu->head != mcelog_cpu->tail)
 			return 0;
 	}
 	return 1;
@@ -1548,14 +1559,14 @@ static ssize_t mce_read(struct file *filp, char __user *inubuf, size_t usize,
 	int cpu, err = 0;
 
 	/* Only supports full reads right now */
-	if (*off != 0 || usize < sizeof(struct mce) * MCE_LOG_LEN)
+	if (*off != 0 || usize < sizeof(struct mce))
 		return -EINVAL;
 
 	mutex_lock(&mce_read_mutex);
 
 	while (!mce_empty()) {
 		for_each_possible_cpu(cpu) {
-			if (usize < MCE_LOG_LEN * sizeof(struct mce))
+			if (usize < sizeof(struct mce))
 				goto out;
 			err = mce_read_cpu(cpu, ubuf, sizeof(struct mce));
 			if (err > 0) {
-- 
1.6.4.3


