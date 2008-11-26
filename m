Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbYKZNJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbYKZNJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYKZNJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:09:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44385 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbYKZNI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:08:59 -0500
Date: Wed, 26 Nov 2008 14:08:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, benh@kernel.crashing.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: [PATCH] sched: convert struct root_domain to cpumask_var_t, fix
Message-ID: <20081126130834.GA26594@elte.hu>
References: <20081126123612.GA20432@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126123612.GA20432@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi Ingo,
> 
> Running a cross-compiling for powerpc64, I ran into this :
> 
> /home/compudj/git/linux.trees.git/kernel/sched.c: In function 'sd_init_NODE':
> /home/compudj/git/linux.trees.git/kernel/sched.c:7319: error: non-static initialization of a flexible array member
> /home/compudj/git/linux.trees.git/kernel/sched.c:7319: error: (near initialization for '(anonymous)')
> 
> Any idea what's going on here ?
> 
> I use gcc-4.1.1.

fallout from the cpumask changes, the fix is below. (or pull latest 
tip/master)

	Ingo


------------------>

>From 1c39194878c09bd88ffc9c9d4c2f01c3397c7aed Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 26 Nov 2008 14:13:42 +0100
Subject: [PATCH] sched: convert struct root_domain to cpumask_var_t, fix

Mathieu Desnoyers reported this build failure on powerpc:

 kernel/sched.c: In function 'sd_init_NODE':
 kernel/sched.c:7319: error: non-static initialization of a flexible array member
 kernel/sched.c:7319: error: (near initialization for '(anonymous)')

this happens because .span changed to cpumask_var_t, hence
the static CPU_MASK_NONE initializers in the SD_*_INIT
templates are not type-correct anymore.

Remove them, as they default to empty anyway.

Also remove them from IA64, MIPS and SH.

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/ia64/include/asm/topology.h           |    2 --
 arch/mips/include/asm/mach-ip27/topology.h |    1 -
 arch/powerpc/include/asm/topology.h        |    1 -
 arch/sh/include/asm/topology.h             |    1 -
 4 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index 35bcb64..a3cc9f6 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -55,7 +55,6 @@
 void build_cpu_to_node_map(void);
 
 #define SD_CPU_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
 	.parent			= NULL,			\
 	.child			= NULL,			\
 	.groups			= NULL,			\
@@ -80,7 +79,6 @@ void build_cpu_to_node_map(void);
 
 /* sched_domains SD_NODE_INIT for IA64 NUMA machines */
 #define SD_NODE_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
 	.parent			= NULL,			\
 	.child			= NULL,			\
 	.groups			= NULL,			\
diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
index 7785bec..1fb959f 100644
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -37,7 +37,6 @@ extern unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];
 
 /* sched_domains SD_NODE_INIT for SGI IP27 machines */
 #define SD_NODE_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
 	.parent			= NULL,			\
 	.child			= NULL,			\
 	.groups			= NULL,			\
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index c32da6f..373fca3 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -48,7 +48,6 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 
 /* sched_domains SD_NODE_INIT for PPC64 machines */
 #define SD_NODE_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
 	.parent			= NULL,			\
 	.child			= NULL,			\
 	.groups			= NULL,			\
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
index 95f0085..279d9cc 100644
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -5,7 +5,6 @@
 
 /* sched_domains SD_NODE_INIT for sh machines */
 #define SD_NODE_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
 	.parent			= NULL,			\
 	.child			= NULL,			\
 	.groups			= NULL,			\
