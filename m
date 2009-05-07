Return-Path: <linux-kernel-owner+w=401wt.eu-S1763251AbZEHAf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763251AbZEHAf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759767AbZEHAK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:59 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52708
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754923AbZEHAJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:57 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 4/5] x86-64: move unlazy_fpu() into lazy cpu state part of context switch
Date: Thu,  7 May 2009 13:32:52 -0700
Message-Id: <1241728373-3537-5-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241728373-3537-1-git-send-email-jeremy@goop.org>
References: <1241728373-3537-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Make sure that unlazy_fpu()'s stts gets batched along with the other
cpu state changes during context switch.  (32-bit already does this.)

This makes sure it gets batched when running paravirtualized.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/process_64.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 2b659f2..534859b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -422,6 +422,9 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	load_TLS(next, cpu);
 
+	/* Must be after DS reload */
+	unlazy_fpu(prev_p);
+
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
 	 * This must be done before restoring TLS segments so
@@ -462,9 +465,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
 	prev->gsindex = gsindex;
 
-	/* Must be after DS reload */
-	unlazy_fpu(prev_p);
-
 	/*
 	 * Switch the PDA and FPU contexts.
 	 */
-- 
1.6.0.6

