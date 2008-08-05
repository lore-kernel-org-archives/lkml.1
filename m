Return-Path: <linux-kernel-owner+w=401wt.eu-S1764989AbYHEUTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764989AbYHEUTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763745AbYHEUOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:14:46 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48092 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763694AbYHEUOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:14:44 -0400
Date: Tue, 5 Aug 2008 16:14:04 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/14] uml: physical memory shouldn't include initial stack
Message-ID: <20080805201404.GA11782@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 60a2988aea701a6424809a5432bf068667aac177

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

