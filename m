Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbZFKTVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbZFKTVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbZFKTUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:20:46 -0400
Received: from claw.goop.org ([74.207.240.146]:44159 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbZFKTUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:20:45 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Alok Kataria <akataria@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 4/5] x86-64: move unlazy_fpu() into lazy cpu state part of context switch
Date: Thu, 11 Jun 2009 12:20:39 -0700
Message-Id: <1244748040-27185-5-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1244748040-27185-1-git-send-email-jeremy@goop.org>
References: <1244748040-27185-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Make sure that unlazy_fpu()'s stts gets batched along with the other
cpu state changes during context switch.  (32-bit already does this.)

This makes sure it gets batched when running paravirtualized.

[ Impact: optimise paravirtual FPU context switch ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Alok Kataria <akataria@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/process_64.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 89c46f1..6ed1c57 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -432,6 +432,9 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	load_TLS(next, cpu);
 
+	/* Must be after DS reload */
+	unlazy_fpu(prev_p);
+
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
 	 * This must be done before restoring TLS segments so
@@ -472,9 +475,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
 	prev->gsindex = gsindex;
 
-	/* Must be after DS reload */
-	unlazy_fpu(prev_p);
-
 	/*
 	 * Switch the PDA and FPU contexts.
 	 */
-- 
1.6.2.2

