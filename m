Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbZBLMlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbZBLMlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbZBLMil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:38:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49215 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758784AbZBLMih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:38:37 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212137.750180365@firstfloor.org>
In-Reply-To: <20090212137.750180365@firstfloor.org>
To: ying.huang@intel.com, akpm@linux-foundation.org, x86@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [9/10] x86: MCE: Fix a race condition in mce_read().
Message-Id: <20090212123728.676E03E666F@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:37:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Huang Ying <ying.huang@intel.com>

Impact: bugfix

Considering the situation as follow:

before: mcelog.next == 1, mcelog.entry[0].finished = 1

+--------------------------------------------------------------------------
R                   W1                  W2                  W3

read mcelog.next (1)
                    mcelog.next++ (2)
                    (working on entry 1,
                    finished == 0)

mcelog.next = 0
                                        mcelog.next++ (1)
                                        (working on entry 0)
                                                           mcelog.next++ (2)
                                                           (working on entry 1)
                        <----------------- race ---------------->
                    (done on entry 1,
                    finished = 1)
                                                           (done on entry 1,
                                                           finished = 1)

To fix the race condition, a cmpxchg loop is added to mce_read() to
ensure no new MCE record can be added between mcelog.next reading and
mcelog.next = 0.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   41 +++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 17 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:56.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:11:06.000000000 +0100
@@ -595,7 +595,7 @@
 {
 	unsigned long *cpu_tsc;
 	static DEFINE_MUTEX(mce_read_mutex);
-	unsigned next;
+	unsigned prev, next;
 	char __user *buf = ubuf;
 	int i, err;
 
@@ -614,25 +614,32 @@
 	}
 
 	err = 0;
-	for (i = 0; i < next; i++) {
-		unsigned long start = jiffies;
-
-		while (!mcelog.entry[i].finished) {
-			if (time_after_eq(jiffies, start + 2)) {
-				memset(mcelog.entry + i,0, sizeof(struct mce));
-				goto timeout;
+	prev = 0;
+	do {
+		for (i = prev; i < next; i++) {
+			unsigned long start = jiffies;
+
+			while (!mcelog.entry[i].finished) {
+				if (time_after_eq(jiffies, start + 2)) {
+					memset(mcelog.entry + i, 0,
+					       sizeof(struct mce));
+					goto timeout;
+				}
+				cpu_relax();
 			}
-			cpu_relax();
+			smp_rmb();
+			err |= copy_to_user(buf, mcelog.entry + i,
+					    sizeof(struct mce));
+			buf += sizeof(struct mce);
+timeout:
+			;
 		}
-		smp_rmb();
-		err |= copy_to_user(buf, mcelog.entry + i, sizeof(struct mce));
-		buf += sizeof(struct mce);
- timeout:
-		;
-	}
 
-	memset(mcelog.entry, 0, next * sizeof(struct mce));
-	mcelog.next = 0;
+		memset(mcelog.entry + prev, 0,
+		       (next - prev) * sizeof(struct mce));
+		prev = next;
+		next = cmpxchg(&mcelog.next, prev, 0);
+	} while (next != prev);
 
 	synchronize_sched();
 
