Return-Path: <linux-kernel-owner+w=401wt.eu-S1761731AbYHAWoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761731AbYHAWoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbYHAWlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:41:51 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52127 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbYHAWlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:41:50 -0400
Date: Fri, 1 Aug 2008 18:41:26 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       "Christopher S. Aker" <caker@theshore.net>,
       WANG Cong <xiyou.wangcong@gmail.com>
Subject: [PATCH 3/14] uml: physical memory shouldn't include initial stack
Message-ID: <20080801224126.GA13719@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 57c582f7eb25314e650f143c2c5141a0cc4172eb Mon Sep 17 00:00:00 2001

The top of physical memory should be below the initial process stack, not the
top of the address space, at least for as long as the stack isn't known to the
kernel VM system and appropriately reserved.

Cc: "Christopher S. Aker" <caker@theshore.net>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/um/kernel/um_arch.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index a6c1dd1..9cecb42 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -259,6 +259,7 @@ int __init linux_main(int argc, char **argv)
 	unsigned long avail, diff;
 	unsigned long virtmem_size, max_physmem;
 	unsigned int i, add;
+	unsigned long stack;
 	char * mode;
 
 	for (i = 1; i < argc; i++) {
@@ -347,7 +348,9 @@ int __init linux_main(int argc, char **argv)
 	}
 
 	virtmem_size = physmem_size;
-	avail = TASK_SIZE - start_vm;
+	stack = (unsigned long) argv;
+	stack &= ~(1024 * 1024 - 1);
+	avail = stack - start_vm;
 	if (physmem_size > avail)
 		virtmem_size = avail;
 	end_vm = start_vm + virtmem_size;
-- 
1.5.5.1

