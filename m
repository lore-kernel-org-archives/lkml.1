Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0CNIHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 04:07:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:57615 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab0CNIHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 04:07:18 -0400
Date: Sun, 14 Mar 2010 08:06:44 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267830207-9474-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267830207-9474-3-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] x86/mce: Fix build bug with CONFIG_PROVE_LOCKING=y && CONFIG_X86_MCE_INTEL=y
Message-ID: <tip-2aa2b50dd62b5d0675bd7453fbeb5732dc2d7866@git.kernel.org>
Git-Commit-ID: 2aa2b50dd62b5d0675bd7453fbeb5732dc2d7866
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Mar 2010 08:06:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2aa2b50dd62b5d0675bd7453fbeb5732dc2d7866
Gitweb:     http://git.kernel.org/tip/2aa2b50dd62b5d0675bd7453fbeb5732dc2d7866
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 14 Mar 2010 08:57:03 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Mar 2010 08:57:03 +0100

x86/mce: Fix build bug with CONFIG_PROVE_LOCKING=y && CONFIG_X86_MCE_INTEL=y

Commit f56e8a076 "x86/mce: Fix RCU lockdep splats" introduced the
following build bug:

  arch/x86/kernel/cpu/mcheck/mce.c: In function 'mce_log':
  arch/x86/kernel/cpu/mcheck/mce.c:166: error: 'mce_read_mutex' undeclared (first use in this function)
  arch/x86/kernel/cpu/mcheck/mce.c:166: error: (Each undeclared identifier is reported only once
  arch/x86/kernel/cpu/mcheck/mce.c:166: error: for each function it appears in.)

Move the in-the-middle-of-file lock variable up to the variable
definition section, the top of the .c file.

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1267830207-9474-3-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bd58de4..3ab9c88 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -46,6 +46,8 @@
 
 #include "mce-internal.h"
 
+static DEFINE_MUTEX(mce_read_mutex);
+
 #define rcu_dereference_check_mce(p) \
 	rcu_dereference_check((p), \
 			      rcu_read_lock_sched_held() || \
@@ -1490,8 +1492,6 @@ static void collect_tscs(void *data)
 	rdtscll(cpu_tsc[smp_processor_id()]);
 }
 
-static DEFINE_MUTEX(mce_read_mutex);
-
 static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 			loff_t *off)
 {
