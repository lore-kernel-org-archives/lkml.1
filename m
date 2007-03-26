Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbXCZUx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbXCZUx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXCZUxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:53:33 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:7801 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbXCZUwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:52:53 -0400
Message-Id: <20070326205250.559611310@de.ibm.com>
References: <20070326205225.438154546@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Mar 2007 22:52:28 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Wilder <dwilder@us.ibm.com>
Subject: [patch 3/6] kprobes: Align probe address.
Content-Disposition: inline; filename=003-kprobes.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Wilder <dwilder@us.ibm.com>

Running a probe on s390 with a probe address that is not 4 byte aligned
results in a Kernel BUG.  The problem is that the stura instruction used
by swap_instruction requires the destination address to be 4 byte aligned.
As stura only writes 4 bytes, aligning to the next 4 byte aligned address
results in the breakpoint instruction being stored past the probe address.
The fix is to align the address backward (to the previous 4 byte aligned
address) and writing the two byte breakpoint instruction in the appropriate
bytes.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 arch/s390/kernel/kprobes.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/s390/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/kprobes.c
+++ linux-2.6/arch/s390/kernel/kprobes.c
@@ -167,7 +167,7 @@ static int __kprobes swap_instruction(vo
 	 * shall not cross any page boundaries (vmalloc area!) when writing
 	 * the new instruction.
 	 */
-	addr = (u32 *)ALIGN((unsigned long)args->ptr, 4);
+	addr = (u32 *)((unsigned long)args->ptr & -4UL);
 	if ((unsigned long)args->ptr & 2)
 		instr = ((*addr) & 0xffff0000) | args->new;
 	else

-- 
