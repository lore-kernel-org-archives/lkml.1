Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbZIPPK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbZIPPK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759190AbZIPPKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:10:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:39038 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759124AbZIPPKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:10:54 -0400
Date: Wed, 16 Sep 2009 15:10:21 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Disable wakeup balancing
Message-ID: <tip-182a85f8a119c789610a9d464f4129ded9f3c107@git.kernel.org>
Git-Commit-ID: 182a85f8a119c789610a9d464f4129ded9f3c107
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 15:10:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  182a85f8a119c789610a9d464f4129ded9f3c107
Gitweb:     http://git.kernel.org/tip/182a85f8a119c789610a9d464f4129ded9f3c107
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Sep 2009 13:24:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Sep 2009 16:44:33 +0200

sched: Disable wakeup balancing

Sysbench thinks SD_BALANCE_WAKE is too agressive and kbuild doesn't
really mind too much, SD_BALANCE_NEWIDLE picks up most of the
slack.

On a dual socket, quad core, dual thread nehalem system:

sysbench (--num_threads=16):

 SD_BALANCE_WAKE-: 13982 tx/s
 SD_BALANCE_WAKE+: 15688 tx/s

kbuild (-j16):

 SD_BALANCE_WAKE-: 47.648295846  seconds time elapsed   ( +-   0.312% )
 SD_BALANCE_WAKE+: 47.608607360  seconds time elapsed   ( +-   0.026% )

(same within noise)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/ia64/include/asm/topology.h           |    2 --
 arch/mips/include/asm/mach-ip27/topology.h |    1 -
 arch/powerpc/include/asm/topology.h        |    1 -
 arch/sh/include/asm/topology.h             |    1 -
 arch/sparc/include/asm/topology_64.h       |    1 -
 arch/x86/include/asm/topology.h            |    2 +-
 include/linux/topology.h                   |    6 +++---
 7 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index 569b9da..d0141fb 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -68,7 +68,6 @@ void build_cpu_to_node_map(void);
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
-				| SD_BALANCE_WAKE	\
 				| SD_WAKE_AFFINE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
@@ -94,7 +93,6 @@ void build_cpu_to_node_map(void);
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
-				| SD_BALANCE_WAKE	\
 				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 64,			\
diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
index d833239..2305917 100644
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -48,7 +48,6 @@ extern unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];
 	.cache_nice_tries	= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_WAKE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index 1a2c9eb..394edcb 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -63,7 +63,6 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_NEWIDLE	\
-				| SD_BALANCE_WAKE	\
 				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
index a8cc564..f8c40cc 100644
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -21,7 +21,6 @@
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_WAKE	\
 				| SD_BALANCE_NEWIDLE	\
 				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 10b979d..26cd25c 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -57,7 +57,6 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_WAKE	\
 				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 589f123..6f0695d 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -141,7 +141,7 @@ extern unsigned long node_remap_size[];
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 1*SD_BALANCE_WAKE			\
+				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
diff --git a/include/linux/topology.h b/include/linux/topology.h
index a6614b0..809b26c 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -95,7 +95,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 1*SD_BALANCE_WAKE			\
+				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
@@ -127,7 +127,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 1*SD_BALANCE_WAKE			\
+				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
@@ -160,7 +160,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 1*SD_BALANCE_WAKE			\
+				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
