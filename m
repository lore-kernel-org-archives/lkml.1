Return-Path: <linux-kernel-owner+w=401wt.eu-S1764812AbYBUUtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764812AbYBUUtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYBUUtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:49:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbYBUUtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:49:05 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       pzijlstr@redhat.com, arjan@infradead.org,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 2/2] make work have a static address in do_boot_cpu()
Date: Thu, 21 Feb 2008 17:40:56 -0300
Message-Id: <1203626456-3101-3-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1203626456-3101-2-git-send-email-gcosta@redhat.com>
References: <1203626456-3101-1-git-send-email-gcosta@redhat.com>
 <1203626456-3101-2-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the work field in create_idle have
a static address. Otherwise, being a stack variable, it can
boild down the lockdep system.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_64.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index f15b774..d79b7a8 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -545,6 +545,7 @@ static void __cpuinit do_fork_idle(struc
 	complete(&c_idle->done);
 }
 
+static DEFINE_PER_CPU(struct create_idle, cpu_idle);
 /*
  * Boot one CPU.
  */
@@ -553,12 +554,12 @@ static int __cpuinit do_boot_cpu(int cpu
 	unsigned long boot_error;
 	int timeout;
 	unsigned long start_rip;
-	struct create_idle create_idle = {
-		.work = __WORK_INITIALIZER(create_idle.work, do_fork_idle),
-		.cpu = cpu,
-		.done = COMPLETION_INITIALIZER_ONSTACK(create_idle.done),
-	};
-	struct create_idle *c_idle = &create_idle;
+	struct create_idle *c_idle = &per_cpu(cpu_idle, cpu);
+	struct work_struct *c_idle_work = &c_idle->work;
+
+	INIT_WORK(c_idle_work, do_fork_idle);
+	c_idle->cpu = cpu;
+	init_completion(&c_idle->done);
 
 	/* allocate memory for gdts of secondary cpus. Hotplug is considered */
 	if (!cpu_gdt_descr[cpu].address &&
-- 
1.4.2

