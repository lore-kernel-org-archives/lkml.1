Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZJEGgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZJEGgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbZJEGgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:36:03 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56079 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbZJEGgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:36:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC9939A.6020702@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 15:35:06 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/10] x86, mce: change writer timeout in mce_read
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com> <4AC990E1.7030708@jp.fujitsu.com>
In-Reply-To: <4AC990E1.7030708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use ndelay().

(This piece originates from Huang's patch, titled:
 "x86, MCE: Fix bugs and issues of MCE log ring buffer")

Originally-From: Huang Ying <ying.huang@intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2d0f9d8..9e8eabd 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -52,6 +52,9 @@ int mce_disabled __read_mostly;
 
 #define SPINUNIT 100	/* 100ns */
 
+/* Timeout log reader to wait writer to finish */
+#define WRITER_TIMEOUT_NS	NSEC_PER_MSEC
+
 atomic_t mce_entry;
 
 DEFINE_PER_CPU(unsigned, mce_exception_count);
@@ -1469,15 +1472,17 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 	prev = 0;
 	do {
 		for (i = prev; i < next; i++) {
-			unsigned long start = jiffies;
+			int timeout = WRITER_TIMEOUT_NS;
 
 			while (!mcelog.entry[i].finished) {
-				if (time_after_eq(jiffies, start + 2)) {
+				if (timeout-- <= 0) {
 					memset(mcelog.entry + i, 0,
 					       sizeof(struct mce));
+					printk(KERN_WARNING "mcelog: timeout "
+					     "waiting for writer to finish!\n");
 					goto timeout;
 				}
-				cpu_relax();
+				ndelay(1);
 			}
 			smp_rmb();
 			err |= copy_to_user(buf, mcelog.entry + i,
-- 
1.6.4.3


