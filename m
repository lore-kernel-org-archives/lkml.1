Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbZE0AAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbZE0AAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbZEZXzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:55:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38619 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbZEZXyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:51 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 21/31] x86: MCE: Support more than 256 CPUs in struct mce
Date: Wed, 27 May 2009 01:54:23 +0200
Message-Id: <ecbed09ba385129558d6341f6a48c64edaa164b4.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <314f7c278aaaa41854bf4f0837a4ca6126160fc8.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
 <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
 <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
 <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
 <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
 <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>
 <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>
 <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>
 <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com>
 <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com>
 <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com>
 <314f7c278aaaa41854bf4f0837a4ca6126160fc8.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The old struct mce had a limitation to 256 CPUs. But x86 Linux supports more than
that now with x2apic. Add a new field extcpu to report the extended number.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/mce.h              |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   10 +++++-----
 arch/x86/kernel/cpu/mcheck/mce.c        |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 6f45a87..ee7d427 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -40,9 +40,9 @@ struct mce {
 	__u64 res2;	/* dito. */
 	__u8  cs;		/* code segment */
 	__u8  bank;	/* machine check bank */
-	__u8  cpu;	/* cpu that raised the error */
+	__u8  cpu;	/* cpu number; obsolete; use extcpu now */
 	__u8  finished;   /* entry is valid */
-	__u32 pad;
+	__u32 extcpu;	/* linux cpu number that detected the error */
 };
 
 /*
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 58afac4..e6cfa1a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -23,14 +23,14 @@
 /* Update fake mce registers on current CPU. */
 static void inject_mce(struct mce *m)
 {
-	struct mce *i = &per_cpu(injectm, m->cpu);
+	struct mce *i = &per_cpu(injectm, m->extcpu);
 
 	/* Make sure noone reads partially written injectm */
 	i->finished = 0;
 	mb();
 	m->finished = 0;
 	/* First set the fields after finished */
-	i->cpu = m->cpu;
+	i->extcpu = m->extcpu;
 	mb();
 	/* Now write record in order, finished last (except above) */
 	memcpy(i, m, sizeof(struct mce));
@@ -49,7 +49,7 @@ static void raise_mce(unsigned long data)
 {
 	struct delayed_mce *dm = (struct delayed_mce *)data;
 	struct mce *m = &dm->m;
-	int cpu = m->cpu;
+	int cpu = m->extcpu;
 
 	inject_mce(m);
 	if (m->status & MCI_STATUS_UC) {
@@ -93,7 +93,7 @@ static ssize_t mce_write(struct file *filp, const char __user *ubuf,
 	if (copy_from_user(&m, ubuf, usize))
 		return -EFAULT;
 
-	if (m.cpu >= NR_CPUS || !cpu_online(m.cpu))
+	if (m.extcpu >= NR_CPUS || !cpu_online(m.extcpu))
 		return -EINVAL;
 
 	dm = kmalloc(sizeof(struct delayed_mce), GFP_KERNEL);
@@ -108,7 +108,7 @@ static ssize_t mce_write(struct file *filp, const char __user *ubuf,
 	memcpy(&dm->m, &m, sizeof(struct mce));
 	setup_timer(&dm->timer, raise_mce, (unsigned long)dm);
 	dm->timer.expires = jiffies + 2;
-	add_timer_on(&dm->timer, m.cpu);
+	add_timer_on(&dm->timer, m.extcpu);
 	return usize;
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index c31cbcf..aa87530 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -108,7 +108,7 @@ static inline int skip_bank_init(int i)
 void mce_setup(struct mce *m)
 {
 	memset(m, 0, sizeof(struct mce));
-	m->cpu = smp_processor_id();
+	m->cpu = m->extcpu = smp_processor_id();
 	rdtscll(m->tsc);
 }
 
@@ -172,7 +172,7 @@ static void print_mce(struct mce *m)
 	       KERN_EMERG "HARDWARE ERROR\n"
 	       KERN_EMERG
 	       "CPU %d: Machine Check Exception: %16Lx Bank %d: %016Lx\n",
-	       m->cpu, m->mcgstatus, m->bank, m->status);
+	       m->extcpu, m->mcgstatus, m->bank, m->status);
 	if (m->ip) {
 		printk(KERN_EMERG "RIP%s %02x:<%016Lx> ",
 		       !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
-- 
1.6.0.2

