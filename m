Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbZDGPOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbZDGPOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbZDGPID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48865 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200AbZDGPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:08:01 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [16/28] x86: MCE: Drop BKL in mce_open
Message-Id: <20090407150758.79B1C1D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

Don't think BKL is needed for anything in mce_open, so drop it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:11.000000000 +0200
@@ -12,7 +12,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/rcupdate.h>
 #include <linux/kallsyms.h>
@@ -723,12 +722,10 @@
 
 static int mce_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
 	spin_lock(&mce_state_lock);
 
 	if (open_exclu || (open_count && (file->f_flags & O_EXCL))) {
 		spin_unlock(&mce_state_lock);
-		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -737,7 +734,6 @@
 	open_count++;
 
 	spin_unlock(&mce_state_lock);
-	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
