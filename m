Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZJEGeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZJEGeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbZJEGeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:34:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39870 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZJEGeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:34:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC99331.3050705@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 15:33:21 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/10] x86, mce: remove tsc handling from mce_read
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com> <4AC990E1.7030708@jp.fujitsu.com>
In-Reply-To: <4AC990E1.7030708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This handling (looks too buggy) is no longer required.

(This piece originates from Huang's patch, titled:
 "x86, MCE: Fix bugs and issues of MCE log ring buffer")

Originally-From: Huang Ying <ying.huang@intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   30 ------------------------------
 1 files changed, 0 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a6d5d4a..28e1e14 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1449,34 +1449,21 @@ static int mce_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static void collect_tscs(void *data)
-{
-	unsigned long *cpu_tsc = (unsigned long *)data;
-
-	rdtscll(cpu_tsc[smp_processor_id()]);
-}
-
 static DEFINE_MUTEX(mce_read_mutex);
 
 static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 			loff_t *off)
 {
 	char __user *buf = ubuf;
-	unsigned long *cpu_tsc;
 	unsigned prev, next;
 	int i, err;
 
-	cpu_tsc = kmalloc(nr_cpu_ids * sizeof(long), GFP_KERNEL);
-	if (!cpu_tsc)
-		return -ENOMEM;
-
 	mutex_lock(&mce_read_mutex);
 	next = rcu_dereference(mcelog.next);
 
 	/* Only supports full reads right now */
 	if (*off != 0 || usize < MCE_LOG_LEN*sizeof(struct mce)) {
 		mutex_unlock(&mce_read_mutex);
-		kfree(cpu_tsc);
 
 		return -EINVAL;
 	}
@@ -1511,24 +1498,7 @@ timeout:
 
 	synchronize_sched();
 
-	/*
-	 * Collect entries that were still getting written before the
-	 * synchronize.
-	 */
-	on_each_cpu(collect_tscs, cpu_tsc, 1);
-
-	for (i = next; i < MCE_LOG_LEN; i++) {
-		if (mcelog.entry[i].finished &&
-		    mcelog.entry[i].tsc < cpu_tsc[mcelog.entry[i].cpu]) {
-			err |= copy_to_user(buf, mcelog.entry+i,
-					    sizeof(struct mce));
-			smp_rmb();
-			buf += sizeof(struct mce);
-			memset(&mcelog.entry[i], 0, sizeof(struct mce));
-		}
-	}
 	mutex_unlock(&mce_read_mutex);
-	kfree(cpu_tsc);
 
 	return err ? -EFAULT : buf - ubuf;
 }
-- 
1.6.4.3


