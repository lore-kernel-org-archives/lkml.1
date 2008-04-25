Return-Path: <linux-kernel-owner+w=401wt.eu-S1765637AbYDYSD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765637AbYDYSD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764814AbYDYR53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:29 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53140 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763453AbYDYR5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:21 -0400
Date: Fri, 25 Apr 2008 13:56:18 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: "Christopher S. Aker" <caker@theshore.net>
Subject: [PATCH 19/19] UML - Physical memory shouldn't include initial stack
Message-ID: <20080425175618.GA11208@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The top of physical memory should be below the initial process stack,
not the top of the address space, at least for as long as the stack
isn't known to the kernel VM system and appropriately reserved.

Cc: "Christopher S. Aker" <caker@theshore.net>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/um_arch.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6-git/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/um_arch.c	2008-04-24 15:16:52.000000000 -0400
+++ linux-2.6-git/arch/um/kernel/um_arch.c	2008-04-24 16:04:52.000000000 -0400
@@ -258,6 +258,7 @@ int __init linux_main(int argc, char **a
 {
 	unsigned long avail, diff;
 	unsigned long virtmem_size, max_physmem;
+	unsigned long stack;
 	unsigned int i, add;
 	char * mode;
 
@@ -347,7 +348,9 @@ int __init linux_main(int argc, char **a
 	}
 
 	virtmem_size = physmem_size;
-	avail = TASK_SIZE - start_vm;
+	stack = (unsigned long) argv;
+	stack &= ~(1024 * 1024 - 1);
+	avail = stack - start_vm;
 	if (physmem_size > avail)
 		virtmem_size = avail;
 	end_vm = start_vm + virtmem_size;
