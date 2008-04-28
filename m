Return-Path: <linux-kernel-owner+w=401wt.eu-S1765558AbYD1F7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765558AbYD1F7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764962AbYD1F7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:59:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43498 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbYD1F7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:59:16 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fix ia64 local_irq_save() et.al.
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       sfr@canb.auug.org.au
Message-Id: <E1JqMOR-0004le-VO@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 28 Apr 2008 06:59:15 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


psr is not a good name for local variable in macro body when it
has a good chance of being the argument of said macro (actually
is at least in one place)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-ia64/system.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/asm-ia64/system.h b/include/asm-ia64/system.h
index dff8128..26e250b 100644
--- a/include/asm-ia64/system.h
+++ b/include/asm-ia64/system.h
@@ -146,23 +146,23 @@ do {						\
 
 # define local_irq_save(x)					\
 do {								\
-	unsigned long psr;					\
+	unsigned long __psr;					\
 								\
-	__local_irq_save(psr);					\
-	if (psr & IA64_PSR_I)					\
+	__local_irq_save(__psr);				\
+	if (__psr & IA64_PSR_I)					\
 		__save_ip();					\
-	(x) = psr;						\
+	(x) = __psr;						\
 } while (0)
 
-# define local_irq_disable()	do { unsigned long x; local_irq_save(x); } while (0)
+# define local_irq_disable()	do { unsigned long __x; local_irq_save(__x); } while (0)
 
 # define local_irq_restore(x)					\
 do {								\
-	unsigned long old_psr, psr = (x);			\
+	unsigned long __old_psr, __psr = (x);			\
 								\
-	local_save_flags(old_psr);				\
-	__local_irq_restore(psr);				\
-	if ((old_psr & IA64_PSR_I) && !(psr & IA64_PSR_I))	\
+	local_save_flags(__old_psr);				\
+	__local_irq_restore(__psr);				\
+	if ((__old_psr & IA64_PSR_I) && !(__psr & IA64_PSR_I))	\
 		__save_ip();					\
 } while (0)
 
-- 
1.5.3.GIT


