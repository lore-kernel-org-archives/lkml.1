Return-Path: <linux-kernel-owner+w=401wt.eu-S1762049AbZFKJtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762049AbZFKJtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761816AbZFKJtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:49:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:45223 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081AbZFKJtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:49:06 -0400
Date: Thu, 11 Jun 2009 09:48:33 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A30AC83.5010708@jp.fujitsu.com>
References: <4A30AC83.5010708@jp.fujitsu.com>
Subject: [tip:branch?] x86, mce: Fix mce printing
Message-ID: <tip-77e26cca20013e9352a8df86a54640543304a23a@git.kernel.org>
Git-Commit-ID: 77e26cca20013e9352a8df86a54640543304a23a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 11 Jun 2009 09:48:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77e26cca20013e9352a8df86a54640543304a23a
Gitweb:     http://git.kernel.org/tip/77e26cca20013e9352a8df86a54640543304a23a
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Thu, 11 Jun 2009 16:04:35 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Jun 2009 11:42:17 +0200

x86, mce: Fix mce printing

This patch:

 - Adds print_mce_head() instead of first flag
 - Makes the header to be printed always
 - Stops double printing of corrected errors

[ This portion originates from Huang Ying's patch ]

Originally-From: Huang Ying <ying.huang@intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
LKML-Reference: <4A30AC83.5010708@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
