Return-Path: <linux-kernel-owner+w=401wt.eu-S932846AbXHOVby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbXHOVby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 17:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXHOVbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 17:31:43 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40970 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbXHOVbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 17:31:42 -0400
Message-ID: <46C370BC.40302@us.ibm.com>
Date: Wed, 15 Aug 2007 14:31:40 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: martin.schwidefsky@de.ibm.com
Subject: [patch] s390 kprobe fix instruction length calculation
Content-Type: multipart/mixed;
 boundary="------------040406030402030906060201"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040406030402030906060201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Placing a kprobe on "bc" instruction (s390/s390x) can cause an oops.
The instruction length is encoded into the first two bits of the s390 
instruction.  Kprobe is incorrectly computing the instruction length.
The instruction length is used for determining what type of "fix-up" is 
needed for conditional branch instruction.  The problem can bee seen by 
placing a kprobe on a  "bc" instruction that will not branch.   The 
results is that  Kprobe incorrectly computes the  new instruction 
pointer (psw.addr) after single stepping the instruction.   The problem 
is corrected with this patch.




--------------040406030402030906060201
Content-Type: text/x-patch;
 name="s390_kprobes_ilen.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="s390_kprobes_ilen.patch"

 arch/s390/kernel/kprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 358d2bb..e40373d 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -85,7 +85,7 @@ void __kprobes get_instruction_type(struct arch_specific_insn *ainsn)
 	ainsn->reg = (*ainsn->insn & 0xf0) >> 4;
 
 	/* save the instruction length (pop 5-5) in bytes */
-	switch (*(__u8 *) (ainsn->insn) >> 4) {
+	switch (*(__u8 *) (ainsn->insn) >> 6) {
 	case 0:
 		ainsn->ilen = 2;
 		break;

--------------040406030402030906060201--
