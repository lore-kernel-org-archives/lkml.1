Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbYKWOrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbYKWOrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 09:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbYKWOrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 09:47:13 -0500
Received: from ag-out-0708.google.com ([72.14.246.243]:7832 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235AbYKWOrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 09:47:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=FtsWDMEeYk8pi4Tv3tS7b1rmuqguhL9760z0sQFcxHZuciFWGo0FpEuGzf7MgpjWQ0
         p4fu1hnbAi8Uu+aT3+HQl06X79ypo3thmEl1rr/TXy1YvcJsyTX/X4Xi4SJ9bBvU4PuW
         2AV334f3DPZAumqRjmvIamvdJI3qNk8IYfCXM=
Message-ID: <49296CEE.2070905@gmail.com>
Date: Sun, 23 Nov 2008 22:47:10 +0800
From: jia zhang <jia.zhang2008@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, hpa@zytor.com
Subject: [PATCH] x86: remove the confusing entry in call trace
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


avoid the confusion in call trace because of the lack of padding at the tail of function.

Signed-off-by: jia zhang <jia.zhang2008@gmail.com>
---
When do_exit get call, the return address behind call instruction is pushed into stack. If something get wrong in do_exit, for x86_64, the entry "kernel_execve +0x00/0xXX" rather than "child_rip +0xYY/0xZZ" is remained in call trace. It looks confused.

 b/arch/x86/kernel/entry_32.S |    1 +
 b/arch/x86/kernel/entry_64.S |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 28b597e..3290819 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1051,6 +1051,7 @@ ENTRY(kernel_thread_helper)
 	push %eax
 	CFI_ADJUST_CFA_OFFSET 4
 	call do_exit
+	nop			# padding for call trace
 	CFI_ENDPROC
 ENDPROC(kernel_thread_helper)
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b86f332..6f677a6 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1170,6 +1170,7 @@ child_rip:
 	# exit
 	mov %eax, %edi
 	call do_exit
+	nop			# padding for call trace
 	CFI_ENDPROC
 ENDPROC(child_rip)
 
