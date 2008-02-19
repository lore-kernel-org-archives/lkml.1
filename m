Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbYBSOtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbYBSOtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758191AbYBSOpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:45:38 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:44637 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbYBSOpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:45:11 -0500
Message-Id: <20080219144505.823632804@de.ibm.com>
References: <20080219144047.587547541@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 15:40:59 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: stable <stable@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 12/13] Fix futex_atomic_cmpxchg_std inline assembly.
Content-Disposition: inline; filename=012-futex-extable.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Add missing exception table entry so that the kernel can handle
proctection exceptions as well on the cs instruction. Currently only
specification exceptions are handled correctly.
The missing entry allows user space to crash the kernel.

Cc: stable <stable@kernel.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/lib/uaccess_std.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: quilt-2.6/arch/s390/lib/uaccess_std.c
===================================================================
--- quilt-2.6.orig/arch/s390/lib/uaccess_std.c
+++ quilt-2.6/arch/s390/lib/uaccess_std.c
@@ -293,10 +293,10 @@ int futex_atomic_cmpxchg_std(int __user 
 
 	asm volatile(
 		"   sacf 256\n"
-		"   cs   %1,%4,0(%5)\n"
-		"0: lr   %0,%1\n"
-		"1: sacf 0\n"
-		EX_TABLE(0b,1b)
+		"0: cs   %1,%4,0(%5)\n"
+		"1: lr   %0,%1\n"
+		"2: sacf 0\n"
+		EX_TABLE(0b,2b) EX_TABLE(1b,2b)
 		: "=d" (ret), "+d" (oldval), "=m" (*uaddr)
 		: "0" (-EFAULT), "d" (newval), "a" (uaddr), "m" (*uaddr)
 		: "cc", "memory" );

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

