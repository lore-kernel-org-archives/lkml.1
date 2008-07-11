Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbYGKRu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbYGKRu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 13:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYGKRuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 13:50:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41839 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbYGKRuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 13:50:19 -0400
Date: Fri, 11 Jul 2008 19:50:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [patch] x86: fix savesegment() bug causing crashes on 64-bit
Message-ID: <20080711175002.GA32116@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_00,URI_HEX autolearn=no SpamAssassin version=3.2.3
	0.4 URI_HEX                URI: URI hostname has long hexadecimal sequence
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    
i spent a fair amount of time chasing a 64-bit bootup crash in 
tip/master that manifested itself as bootup segfaults:
    
      S10network[1825]: segfault at 7f3e2b5d16b8 ip 00000031108748c9 sp 00007fffb9c14c70 error 4 in libc-2.7.so[3110800000+14d000]
    
eventually causing init to die and panic the system:
    
      Kernel panic - not syncing: Attempted to kill init!
      Pid: 1, comm: init Not tainted 2.6.26-rc9-tip #13878
    
after a marathonic bisection session, the bad commit turned out to be 
this one in tip/x86/*:
    
    | b7675791859075418199c7af86a116ea34eaf5bd is first bad commit
    | commit b7675791859075418199c7af86a116ea34eaf5bd
    | Author: Jeremy Fitzhardinge <jeremy@goop.org>
    | Date:   Wed Jun 25 00:19:00 2008 -0400
    |
    |     x86: remove open-coded save/load segment operations
    |
    |     This removes a pile of buggy open-coded implementations of savesegment
    |     and loadsegment.
    
after some more bisection of this patch itself, it turns out that what
makes the difference are the savesegment() changes to __switch_to().
    
Taking a look at this portion of arch/x86/kernel/process_64.o revealed
this crutial difference:
    
    | good:    99c:       8c e0                   mov    %fs,%eax
    |          99e:       89 45 cc                mov    %eax,-0x34(%rbp)
    |
    | bad:     99c:       8c 65 cc                mov    %fs,-0x34(%rbp)
    
which is due to:
    
    |                 unsigned fsindex;
    | -               asm volatile("movl %%fs,%0" : "=r" (fsindex));
    | +               savesegment(fs, fsindex);
    
savesegment() is implemented as:
    
     #define savesegment(seg, value)                                \
              asm("mov %%" #seg ",%0":"=rm" (value) : : "memory")
    
note the "m" modifier - it allows GCC to generate the segment move
into a memory operand as well.
    
But regarding segment operands there's a subtle detail in the x86
instruction set: the above 16-bit moves are zero-extend, but only
    
If it goes to a memory operand, -0x34(%rbp) in the above case, there's
no zero-extend to 32-bit and the instruction will only save 16 bits
    
The other 16 bits is random data - which can cause problems when that 
value is used later on.
    
The solution is to only allow segment operands to go to registers. This 
fix allows my test-system to boot up without crashing.
    
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/system.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 45641bc..929345a 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -164,7 +164,7 @@ extern void native_load_gs_index(unsigned);
  * Save a segment register away
  */
 #define savesegment(seg, value)				\
-	asm("mov %%" #seg ",%0":"=rm" (value) : : "memory")
+	asm("mov %%" #seg ",%0":"=r" (value) : : "memory")
 
 static inline unsigned long get_limit(unsigned long segment)
 {
