Return-Path: <linux-kernel-owner+w=401wt.eu-S1760977AbXEQV2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbXEQV2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760505AbXEQV2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:28:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:58280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbXEQV2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:28:07 -0400
Message-ID: <464CC8E1.5010407@cv-sv.de>
Date: Thu, 17 May 2007 23:28:01 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.2) Gecko/20070218 SUSE/1.1.1-5.1 SeaMonkey/1.1.1
MIME-Version: 1.0
CC: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org, ak@suse.de,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <464BB252.8010008@cv-sv.de>
In-Reply-To: <464BB252.8010008@cv-sv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19fRNAEtlNS9vRt7++rZj6ACuh/I0ouCZP6ph/
 6F6ARo3a0NWN7pi+f0AuJi8/sEYL1CWBwgFU/n3gAb4TDklKAA
 9N1MoqCoTetnmsjv8G6sQ==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian wrote:
Hmm, I really think so...:
> 
> May I brought up a wrong reason with the command cmpxchg64.
> But disabling CONFIG_X86_CMPXCHG64 helps.
> 


Hi,


I found some time to investigate. My resume is:

- kernel/verify_cpu.S causes the stop at boot time
  Cause the required flag for CMPXCHG8B is not set.

- boot/setup.S did not print "PANIC: CPU too old for this kernel"
  ( not visible, also the message did not match )

- VIA C3_2: CMPXCHG8B should work always. Via C3 EBGA Datasheet R1.90 page 30 (3-4)
  But the bit is not set cause of some early Win NT bugs.

- X86_CMPXCHG64 can be set and used. Just verify_cpu.S requires a change
  to ignore the missing indicator at boot time.



My suggestion for the fix is:

- kernel/verify_cpu.S should be more tolerant if CONFIG_MVIAC3_2 is set
  ( see patch below )

- boot/setup.S should be fixed to print out a proper error message
  ( see below )

- X86_CMPXCHG64 patch(earlier mail in thread ) should not be used.


- Important: somebody to check other CPU types if the same behavior happens.

- middle term solution already planed: introduce arch/i386/boot/cpucheck.c



To be done by somebody with more detail knowledge than me: (never did x86 assembler before)

- I add "# missed before: set ds"
  => somebody should check if I am right with the way to set.
  => seems to be a generic error in setup.S not to set "ds" for error messages.

- other X86-CPU than AMD (?) or Intel
  => correct verify_cpu.S or set bits if required.


Best regards,

Christian

--- arch/i386/kernel/verify_cpu.S     2007-05-17 05:17:40.000000000 +0200
+++ arch/i386/kernel/verify_cpu.S       2007-05-17 23:14:18.266679323 +0200
@@ -54,6 +54,12 @@

        andl    $REQUIRED_MASK1,%edx
        xorl    $REQUIRED_MASK1,%edx
+/* VIAC3 does not report the existing CMPXCHG64 by default. So do not go to bad for CMPXCHG64 for this */
+/* via C3 EBGA datasheet R1.9 tells the command works also without shown bit. */
+#if CONFIG_MVIAC3_2
+       andl    $~NEED_CMPXCHG64,%edx
+#endif
+
        jnz     bad
 #endif /* REQUIRED_MASK1 */


--- arch/i386/boot/setup.S     2007-05-17 21:53:08.009226208 +0200
+++ arch/i386/boot/setup.S      2007-05-17 23:12:36.815989168 +0200
@@ -310,12 +310,15 @@
        call verify_cpu
        testl  %eax,%eax
        jz      cpu_ok
+       # missed before: set ds
+       movw    %cs, %ax                # aka SETUPSEG
+       movw    %ax, %ds
        lea     cpu_panic_mess,%si
        call    prtstr
 1:     jmp     1b

 cpu_panic_mess:
-       .asciz  "PANIC: CPU too old for this kernel."
+       .asciz  "PANIC: CPU too old for this kernel or CPUID function bits are wrong."

 #include "../kernel/verify_cpu.S"


