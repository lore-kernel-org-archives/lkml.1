Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbZCDUCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbZCDUCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757819AbZCDUCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:02:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:33016 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262AbZCDUCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:02:15 -0500
Date: Wed, 4 Mar 2009 20:00:48 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, kevin@koconnor.net,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, kevin@koconnor.net,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49AE4901.3090801@kernel.org>
References: <49AE4901.3090801@kernel.org>
Subject: [tip:x86/mm] x86: ioremap mptable
Message-ID: <tip-8d4dd919b46ed982da6ef6bf6fcec454cd7a5b1b@git.kernel.org>
Git-Commit-ID: 8d4dd919b46ed982da6ef6bf6fcec454cd7a5b1b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 20:00:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d4dd919b46ed982da6ef6bf6fcec454cd7a5b1b
Gitweb:     http://git.kernel.org/tip/8d4dd919b46ed982da6ef6bf6fcec454cd7a5b1b
Author:     "Yinghai Lu" <yinghai@kernel.org>
AuthorDate: Wed, 4 Mar 2009 01:25:21 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 20:55:04 +0100

x86: ioremap mptable

Impact: fix boot with mptable above max_low_mapped

Try to use early_ioremap() to map MPC to make sure it works even it is
at the end of ram.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <49AE4901.3090801@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reported-and-tested-by: Kevin O'Connor <kevin@koconnor.net>


---
 arch/x86/kernel/mpparse.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 37cb1bd..ae9060c 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -558,6 +558,19 @@ static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 
 static struct mpf_intel *mpf_found;
 
+static unsigned long __init get_mpc_size(unsigned long physptr)
+{
+	struct mpc_table *mpc;
+	unsigned long size;
+
+	mpc = early_ioremap(physptr, PAGE_SIZE);
+	size = mpc->length;
+	early_iounmap(mpc, PAGE_SIZE);
+	apic_printk(APIC_VERBOSE, "  mpc: %lx-%lx\n", physptr, physptr + size);
+
+	return size;
+}
+
 /*
  * Scan the memory blocks for an SMP configuration block.
  */
@@ -611,12 +624,16 @@ static void __init __get_smp_config(unsigned int early)
 		construct_default_ISA_mptable(mpf->feature1);
 
 	} else if (mpf->physptr) {
+		struct mpc_table *mpc;
+		unsigned long size;
 
+		size = get_mpc_size(mpf->physptr);
+		mpc = early_ioremap(mpf->physptr, size);
 		/*
 		 * Read the physical hardware table.  Anything here will
 		 * override the defaults.
 		 */
-		if (!smp_read_mpc(phys_to_virt(mpf->physptr), early)) {
+		if (!smp_read_mpc(mpc, early)) {
 #ifdef CONFIG_X86_LOCAL_APIC
 			smp_found_config = 0;
 #endif
@@ -624,8 +641,10 @@ static void __init __get_smp_config(unsigned int early)
 			       "BIOS bug, MP table errors detected!...\n");
 			printk(KERN_ERR "... disabling SMP support. "
 			       "(tell your hw vendor)\n");
+			early_iounmap(mpc, size);
 			return;
 		}
+		early_iounmap(mpc, size);
 
 		if (early)
 			return;
