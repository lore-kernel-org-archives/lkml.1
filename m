Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbZJGSUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbZJGSUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbZJGSUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:20:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZJGSUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:20:35 -0400
Date: Wed, 7 Oct 2009 20:19:32 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
cc: linux-rt-users@vger.kernel.org, Clark Williams <williams@redhat.com>
Subject: [PATCH RFC] BKL not necessary in cpuid_open
Message-ID: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been staring at the BKL lock in cpuid_open, and I can't see what it 
is protecting. However, I may have missed something - even something 
obvious, so comments are welcome.

>From 25c0f07b3ec5533c0e690e06198baa4300ee4a8c Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Wed, 7 Oct 2009 20:06:12 +0200
Subject: [PATCH] The BKL is not necessary in cpuid_open
 Most of the variables are local to the function. It IS possible that for
 struct cpuinfo_x86 *c
 c could point to the same area. However, this is used read only.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/x86/kernel/cpuid.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 6a52d4b..8bb8401 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -118,8 +118,6 @@ static int cpuid_open(struct inode *inode, struct file *file)
 	struct cpuinfo_x86 *c;
 	int ret = 0;
 
-	lock_kernel();
-
 	cpu = iminor(file->f_path.dentry->d_inode);
 	if (cpu >= nr_cpu_ids || !cpu_online(cpu)) {
 		ret = -ENXIO;	/* No such CPU */
@@ -129,7 +127,6 @@ static int cpuid_open(struct inode *inode, struct file *file)
 	if (c->cpuid_level < 0)
 		ret = -EIO;	/* CPUID not supported */
 out:
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.6.0.6

