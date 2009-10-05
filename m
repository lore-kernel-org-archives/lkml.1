Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbZJEGiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbZJEGiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbZJEGiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:38:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56178 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbZJEGiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:38:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC9941C.40708@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 15:37:16 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/10] x86, mce: make mce_log buffer to per-CPU, prep
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com> <4AC990E1.7030708@jp.fujitsu.com>
In-Reply-To: <4AC990E1.7030708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move core part of mce_read() into mce_read_buf().  Add mce_empty().
These changes are required to improve readability of next patch.

(This piece originates from Huang's patch, titled:
 "x86, MCE: Fix bugs and issues of MCE log ring buffer")

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   48 ++++++++++++++++++++++++++-----------
 1 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5f88ada..684b42e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1452,20 +1452,12 @@ static int mce_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static DEFINE_MUTEX(mce_read_mutex);
-
-static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
-			loff_t *off)
+static ssize_t mce_read_buf(char __user *inubuf, size_t usize)
 {
-	char __user *buf = ubuf;
+	char __user *ubuf = inubuf;
 	unsigned prev, next;
 	int i, err;
 
-	/* Only supports full reads right now */
-	if (*off != 0 || usize < sizeof(struct mce) * MCE_LOG_LEN)
-		return -EINVAL;
-
-	mutex_lock(&mce_read_mutex);
 	next = rcu_dereference(mcelog.next);
 
 	err = 0;
@@ -1485,9 +1477,9 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 				ndelay(1);
 			}
 			smp_rmb();
-			err |= copy_to_user(buf, mcelog.entry + i,
+			err |= copy_to_user(ubuf, mcelog.entry + i,
 					    sizeof(struct mce));
-			buf += sizeof(struct mce);
+			ubuf += sizeof(struct mce);
 timeout:
 			;
 		}
@@ -1500,15 +1492,43 @@ timeout:
 
 	synchronize_sched();
 
+	return err ? -EFAULT : ubuf - inubuf;
+}
+
+static int mce_empty(void)
+{
+	return !rcu_dereference(mcelog.next);
+}
+
+static DEFINE_MUTEX(mce_read_mutex);
+
+static ssize_t mce_read(struct file *filp, char __user *inubuf, size_t usize,
+			loff_t *off)
+{
+	char __user *ubuf = inubuf;
+	int err;
+
+	/* Only supports full reads right now */
+	if (*off != 0 || usize < sizeof(struct mce) * MCE_LOG_LEN)
+		return -EINVAL;
+
+	mutex_lock(&mce_read_mutex);
+
+	err = mce_read_buf(ubuf, usize);
+	if (err > 0) {
+		ubuf += err;
+		err = 0;
+	}
+
 	mutex_unlock(&mce_read_mutex);
 
-	return err ? -EFAULT : buf - ubuf;
+	return err ? err : ubuf - inubuf;
 }
 
 static unsigned int mce_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &mce_wait, wait);
-	if (rcu_dereference(mcelog.next))
+	if (!mce_empty())
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
-- 
1.6.4.3


