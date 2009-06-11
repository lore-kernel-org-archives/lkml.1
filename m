Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbZFKGnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbZFKGnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 02:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZFKGnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 02:43:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60776 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbZFKGnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 02:43:11 -0400
Message-ID: <4A30A779.4040101@jp.fujitsu.com>
Date: Thu, 11 Jun 2009 15:43:05 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v5] x86: MCE: Re-implement MCE log ring buffer as per-CPU
 ring buffer
References: <1244445115.8361.576.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1244445115.8361.576.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Re-implement MCE log ring buffer as per-CPU ring buffer for better
> scalability.

It seems your patch implicitly includes some bug fix for tip/mce3.
Still discussion of generic lockless ring buffer is going on, so how
about dividing the patch into 2 pieces, for improvement and for bug fix?

Maybe improvement part need to be reworked, so I pulled out the bug fix
part from your patch.

If it's all right, I'd like to put this on top of tip/mce3 asap.


Thanks,
H.Seto

==

[PATCH] x86, mce: fix mce printing

 - Add print_mce_head() instead of first flag
 - Make header to be printed always
 - Stop double printing of corrected errors

[ This portion is originate from Huang Ying's patch ]

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d4e7b59..6a3127e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -180,12 +180,8 @@ void mce_log(struct mce *mce)
 	set_bit(0, &notify_user);
 }
 
-static void print_mce(struct mce *m, int *first)
+static void print_mce(struct mce *m)
 {
-	if (*first) {
-		printk(KERN_EMERG "\n" KERN_EMERG "HARDWARE ERROR\n");
-		*first = 0;
-	}
 	printk(KERN_EMERG
 	       "CPU %d: Machine Check Exception: %16Lx Bank %d: %016Lx\n",
 	       m->extcpu, m->mcgstatus, m->bank, m->status);
@@ -208,6 +204,11 @@ static void print_mce(struct mce *m, int *first)
 			m->apicid);
 }
 
+static void print_mce_head(void)
+{
+	printk(KERN_EMERG "\n" KERN_EMERG "HARDWARE ERROR\n");
+}
+
 static void print_mce_tail(void)
 {
 	printk(KERN_EMERG "This is not a software problem!\n"
@@ -234,7 +235,6 @@ static void wait_for_panic(void)
 static void mce_panic(char *msg, struct mce *final, char *exp)
 {
 	int i;
-	int first = 1;
 
 	/*
 	 * Make sure only one CPU runs in machine check panic
@@ -245,23 +245,27 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 
 	bust_spinlocks(1);
 	console_verbose();
+	print_mce_head();
 	/* First print corrected ones that are still unlogged */
 	for (i = 0; i < MCE_LOG_LEN; i++) {
 		struct mce *m = &mcelog.entry[i];
-		if ((m->status & MCI_STATUS_VAL) &&
-			!(m->status & MCI_STATUS_UC))
-			print_mce(m, &first);
+		if (!(m->status & MCI_STATUS_VAL))
+			continue;
+		if (!(m->status & MCI_STATUS_UC))
+			print_mce(m);
 	}
 	/* Now print uncorrected but with the final one last */
 	for (i = 0; i < MCE_LOG_LEN; i++) {
 		struct mce *m = &mcelog.entry[i];
 		if (!(m->status & MCI_STATUS_VAL))
 			continue;
+		if (!(m->status & MCI_STATUS_UC))
+			continue;
 		if (!final || memcmp(m, final, sizeof(struct mce)))
-			print_mce(m, &first);
+			print_mce(m);
 	}
 	if (final)
-		print_mce(final, &first);
+		print_mce(final);
 	if (cpu_missing)
 		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
 	print_mce_tail();
-- 
1.6.3

