Return-Path: <linux-kernel-owner+w=401wt.eu-S965562AbXCVA16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965562AbXCVA16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 20:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965564AbXCVA16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 20:27:58 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45635 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965562AbXCVA15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 20:27:57 -0400
Message-ID: <4601D736.9020409@us.ibm.com>
Date: Wed, 21 Mar 2007 18:09:10 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0.7 (X11/20050923)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@us.ibm.com, schwidefsky@de.ibm.com
Subject: [patch] s390 kprobes: Align probe address
Content-Type: multipart/mixed;
 boundary="------------070600020803010909020304"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070600020803010909020304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

[This patch applies to both linux and mm trees.  Please send comments 
off list, thanks]

--------------070600020803010909020304
Content-Type: text/x-patch;
 name="s390_swap_instruction_align.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="s390_swap_instruction_align.patch"

Running a probe on s390 with a probe address that is not 4 byte aligned
results in a Kernel BUG.  The problem is that the stura instruction used
by swap_instruction requires the destination address to be 4 byte aligned.
As stura only writes 4 bytes, aligning to the next 4 byte aligned address
results in the breakpoint instruction being stored past the probe address.
The fix is to align the address backward (to the previous 4 byte aligned
address) and writing the two byte breakpoint instruction in the appropriate
bytes.

Signed-off-by: David Wilder <dwilder@us.ibm.com>
------------------------
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 8af549e..993f353 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -167,7 +167,7 @@ static int __kprobes swap_instruction(vo
 	 * shall not cross any page boundaries (vmalloc area!) when writing
 	 * the new instruction.
 	 */
-	addr = (u32 *)ALIGN((unsigned long)args->ptr, 4);
+	addr = (u32 *)((unsigned long)args->ptr & -4UL);
 	if ((unsigned long)args->ptr & 2)
 		instr = ((*addr) & 0xffff0000) | args->new;
 	else

--------------070600020803010909020304--
