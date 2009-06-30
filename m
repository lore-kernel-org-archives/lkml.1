Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbZF3XTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbZF3XTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759721AbZF3XRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:17:22 -0400
Received: from ozlabs.org ([203.10.76.45]:39651 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759588AbZF3XRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:17:19 -0400
Message-Id: <20090630230141.407009407@samba.org>
References: <20090630230043.464194676@samba.org>
User-Agent: quilt/0.46-1
Date: Wed, 01 Jul 2009 09:00:51 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [patch 8/8] powerpc: Fix PCL vdso detection
Content-Disposition: inline; filename=pcl_fix_powerpc_vdso_detection.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCL uses arch_vma_name() to detect a vdso region which in turn uses
current->mm->context.vdso_base. We need to initialise this before doing
the mmap or else we fail to detect the vdso.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-tip/arch/powerpc/kernel/vdso.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/kernel/vdso.c	2009-06-30 09:57:23.000000000 +1000
+++ linux-2.6-tip/arch/powerpc/kernel/vdso.c	2009-06-30 09:58:37.000000000 +1000
@@ -235,6 +235,13 @@
 	}
 
 	/*
+	 * Put vDSO base into mm struct. We need to do this before calling
+	 * install_special_mapping or the perf counter mmap tracking code
+	 * will fail to recognise it as a vDSO (since arch_vma_name fails).
+	 */
+	current->mm->context.vdso_base = vdso_base;
+
+	/*
 	 * our vma flags don't have VM_WRITE so by default, the process isn't
 	 * allowed to write those pages.
 	 * gdb can break that with ptrace interface, and thus trigger COW on
@@ -254,11 +261,10 @@
 				     VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
 				     VM_ALWAYSDUMP,
 				     vdso_pagelist);
-	if (rc)
+	if (rc) {
+		current->mm->context.vdso_base = 0;
 		goto fail_mmapsem;
-
-	/* Put vDSO base into mm struct */
-	current->mm->context.vdso_base = vdso_base;
+	}
 
 	up_write(&mm->mmap_sem);
 	return 0;

-- 

