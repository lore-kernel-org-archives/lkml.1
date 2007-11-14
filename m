Return-Path: <linux-kernel-owner+w=401wt.eu-S1759734AbXKNSwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbXKNSwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbXKNSwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:52:25 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:52585 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbXKNSwY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:52:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FANzSOkdMROHU/2dsb2JhbACBXA
Date: Wed, 14 Nov 2007 13:52:20 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] Immediate Values x86 Optimization Declare Discarded
	Instruction
Message-ID: <20071114185220.GA29533@Krystal>
References: <20071113194550.GA4400@Krystal> <473A017D.2030501@zytor.com> <20071113204033.GB7450@Krystal> <473A166E.3070708@zytor.com> <20071113220227.GB9057@Krystal> <473A26A2.7090007@zytor.com> <20071114003409.GA18032@Krystal> <473A4909.1020609@zytor.com> <20071114014445.GB19901@Krystal> <473A6471.4040700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <473A6471.4040700@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:47:17 up 10 days, 21:52,  4 users,  load average: 0.70, 1.21,
	0.98
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(the patch follows at the end of the discussion, it applies on top of
the "Immediate Values x86 Optimization (update 2)" patch.

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> Immediate Values - x86 Optimization
>> x86 optimization of the immediate values which uses a movl with code 
>> patching
>> to set/unset the value used to populate the register used as variable 
>> source.
>> Changelog:
>> - Use text_poke_early with cr0 WP save/restore to patch the bypass. We are 
>> doing
>>   non atomic writes to a code region only touched by us (nobody can 
>> execute it
>>   since we are protected by the immediate_mutex).
>> - Put immediate_set and _immediate_set in the architecture independent 
>> header.
>> - Use $0 instead of %2 with (0) operand.
>> - Add x86_64 support, ready for i386+x86_64 -> x86 merge.
>> - Use asm-x86/asm.h.
>> Ok, so the most flexible solution that I see, that should fit for both
>> i386 and x86_64 would be :
>> 1 byte  : "=Q" : Any register accessible as rh: a, b, c, and d.
>> 2, 4 bytes : "=R" : Legacy register—the eight integer registers 
>> available
>>                  on all i386 processors (a, b, c, d, si, di, bp, sp). 8
>> bytes : (only for x86_64)
>>           "=r" : A register operand is allowed provided that it is in a
>>                  general register.
>> That should make sure x86_64 won't try to use REX prefixed opcodes for
>> 1, 2 and 4 bytes values.
>
> I just had a couple of utterly sick ideas.
>
> Consider this variant (this example is for a 32-bit immediate on x86-64, 
> but the obvious macroizations apply):
>

nitpicking :

> 	.section __discard,"a",@progbits

could we simply declare a 

     .section __discard,"",@progbits instead ?

I think this should remove the need to tweak the linker script, since
the section would not be allocated.

> 1:	movl $0x12345678,%r9d
> 2:
> 	.previous
>
> 	.section __immediate,"a",@progbits
> 	.quad foo_immediate, (3f)-4, 4
> 	.previous
> 	
> 	.org . + ((-.-(2b-1b)) & 3), 0x90

So in general we would have :

    .org . + ((-.-(2b-1b)) & (immediate_size - 1)), 0x90

Here is the result, on i386, for an immediate value used by markers. I
normally use a 1 byte immediate value for this, but I tried to change
the data type to check the result. The resulting assembly and binary
generated on x86_64 follows.

* A 1 byte immediate value (no need to align) :

#APP
        .section __immediate,"a",@progbits
         .long __mark_kernel_sched_try_wakeup.30104+8, (3f)-1, 1
        .previous
        mov $0,%al
        3:

.LVL1116:
#NO_APP
.LBE2180:
        testb   %al, %al
        jne     .L1028


* A 2 bytes immediate value :

#APP
	.section __discard,"",@progbits
	1:
	mov $0,%ax
	2:
	.previous
	.section __immediate,"a",@progbits
	 .long __mark_kernel_sched_try_wakeup.30104+8, (3f)-2, 2
	.previous
	.org . + ((-.-(2b-1b)) & (2-1)), 0x90
	mov $0,%ax
	3:
	
.LVL1116:
#NO_APP
.LBE2180:
	testw	%ax, %ax
	jne	.L1028


* A 4 bytes immediate value :

#APP
        .section __discard,"",@progbits
        1:
        mov $0,%eax
        2:
        .previous
        .section __immediate,"a",@progbits
         .long __mark_kernel_sched_try_wakeup.30104+8, (3f)-4, 4
        .previous
        .org . + ((-.-(2b-1b)) & (4-1)), 0x90
        mov $0,%eax
        3:
        
.LVL1116:
#NO_APP
.LBE2180:
        testl   %eax, %eax
        jne     .L1028


And on x86_64 :

* A 1 byte immediate value :

#APP
        .section __immediate,"a",@progbits
         .quad __mark_kernel_sched_try_wakeup.31114+16, (3f)-1, 1
        .previous
        mov $0,%al
        3:

.LVL705:
#NO_APP
.LBE2003:
        testb   %al, %al
        je      .L676

Resulting binary :

    28c0:       b0 00                   mov    $0x0,%al
    28c2:       84 c0                   test   %al,%al
    28c4:       74 21                   je     28e7 <try_to_wake_up+0x50>


* A 2 bytes immediate value :
#APP
        .section __discard,"",@progbits
        1:
        mov $0,%ax
        2:
        .previous
        .section __immediate,"a",@progbits
         .quad __mark_kernel_sched_try_wakeup.31114+16, (3f)-2, 2
        .previous
        .org . + ((-.-(2b-1b)) & (2-1)), 0x90
        mov $0,%ax
        3:

.LVL705:
#NO_APP
.LBE2003:
        testw   %ax, %ax
        je      .L676

Resulting binary :

    28c0:       66 b8 00 00             mov    $0x0,%ax
    28c4:       66 85 c0                test   %ax,%ax
    28c7:       74 21                   je     28ea <try_to_wake_up+0x53>


* A 4 bytes immediate value :

#APP
        .section __discard,"",@progbits
        1:
        mov $0,%eax
        2:
        .previous
        .section __immediate,"a",@progbits
         .quad __mark_kernel_sched_try_wakeup.31114+16, (3f)-4, 4
        .previous
        .org . + ((-.-(2b-1b)) & (4-1)), 0x90
        mov $0,%eax
        3:

.LVL705:
#NO_APP
.LBE2003:
        testl   %eax, %eax
        je      .L676

Resulting binary :

    28c0:       90                      nop    
    28c1:       90                      nop    
    28c2:       90                      nop    
    28c3:       b8 00 00 00 00          mov    $0x0,%eax
    28c8:       85 c0                   test   %eax,%eax


* An 8 bytes immediate value :

#APP
        .section __discard,"",@progbits
        1:
        mov $0xFEFEFEFE01010101,%rax
        2:
        .previous
        .section __immediate,"a",@progbits
         .quad __mark_kernel_sched_try_wakeup.31114+16, (3f)-8, 8
        .previous
        .org . + ((-.-(2b-1b)) & (8-1)), 0x90
        mov $0xFEFEFEFE01010101,%rax
        3:

.LVL705:
#NO_APP
.LBE2003:
        testq   %rax, %rax
        je      .L676

And the corresponding binary (for x86_64, using a 8 bytes immediate) :

    28c0:       90                      nop    
    28c1:       90                      nop    
    28c2:       90                      nop    
    28c3:       90                      nop    
    28c4:       90                      nop    
    28c5:       90                      nop    
    28c6:       48 b8 01 01 01 01 fe    mov    $0xfefefefe01010101,%rax
    28cd:       fe fe fe 
    28d0:       48 85 c0                test   %rax,%rax

The patch is at the bottom of this email.

Mathieu

> 	movl $0x12345678,%r9d
> 3:
>
>
> The idea is that the instruction is emitted into a section, which is marked 
> DISCARD in the linker script.  That lets us actually measure the length, 
> and since we know the immediate is always at the end of the instruction... 
> done!
>
> 	-hpa
>

Immediate Values x86 Optimization Declare Discarded Instruction

- Create the instruction in a discarded section to calculate its size. This is
  how we can align the beginning of the instruction on an address that will
  permit atomic modificatino of the immediate value without knowing the size of
  the opcode used by the compiler.
- Bugfix : 8 bytes 64 bits immediate value was declared as "4 bytes" in the
  immediate structure.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-x86/immediate.h |   93 +++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 48 deletions(-)

Index: linux-2.6-lttng/include/asm-x86/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/immediate.h	2007-11-14 13:39:39.000000000 -0500
+++ linux-2.6-lttng/include/asm-x86/immediate.h	2007-11-14 13:40:18.000000000 -0500
@@ -30,22 +30,18 @@ struct __immediate {
  * Reads the value of @name.
  * Optimized version of the immediate.
  * Do not use in __init and __exit functions. Use _immediate_read() instead.
- * Makes sure the 2 and 4 bytes update will be atomic by aligning the immediate
- * value. 2 bytes (short) uses a 66H prefix. If size is bigger than 4 bytes,
- * fall back on a memory read.
- * The 64 bits load immediates produced by gas have a 2 bytes opcode.
+ * If size is bigger than the architecture long size, fall back on a memory
+ * read.
+ *
  * Make sure to populate the initial static 64 bits opcode with a value
- * what will generate an instruction with 2 bytes opcode and 8 bytes immediate
- * value.
- * A solution that should fit for both i386 and x86_64 would be :
- * 1 byte  : "=Q" : Any register accessible as rh: a, b, c, and d.
- * 2, 4 bytes : "=R" : Legacy register—the eight integer registers available
- *               on all i386 processors (a, b, c, d, si, di, bp, sp).
- * 8 bytes : (only for x86_64)
- *              "=r" : A register operand is allowed provided that it is in a
- *              general register.
- * That should make sure x86_64 won't try to use REX prefixed opcodes for
- * 1, 2 and 4 bytes values.
+ * what will generate an instruction with 8 bytes immediate value (not the REX.W
+ * prefixed one that loads a sign extended 32 bits immediate value in a r64
+ * register).
+ *
+ * Create the instruction in a discarded section to calculate its size. This is
+ * how we can align the beginning of the instruction on an address that will
+ * permit atomic modificatino of the immediate value without knowing the size of
+ * the opcode used by the compiler. The operand size is known in advance.
  */
 #define immediate_read(name)						\
 	({								\
@@ -53,49 +49,50 @@ struct __immediate {
 		switch (sizeof(value)) {				\
 		case 1:							\
 			asm(".section __immediate,\"a\",@progbits\n\t"	\
-					_ASM_PTR "%c1, (0f)+1, 1\n\t"	\
-					".previous\n\t"			\
-					"0:\n\t"			\
-					"mov $0,%0\n\t"			\
-				: "=Q" (value)				\
-				: "i" (&name##__immediate));		\
+				_ASM_PTR "%c1, (3f)-%c2, %c2\n\t"	\
+				".previous\n\t"				\
+				"mov $0,%0\n\t"				\
+				"3:\n\t"				\
+				: "=q" (value)				\
+				: "i" (&name##__immediate),		\
+				  "i" (sizeof(value)));			\
 			break;						\
 		case 2:							\
-			asm(".section __immediate,\"a\",@progbits\n\t"	\
-					_ASM_PTR "%c1, (0f)+2, 2\n\t"	\
-					".previous\n\t"			\
-					"1:\n\t"			\
-					".align 2\n\t"			\
-					"0:\n\t"			\
-					"mov $0,%0\n\t"			\
-				: "=R" (value)				\
-				: "i" (&name##__immediate));		\
-			break;						\
 		case 4:							\
-			asm(".section __immediate,\"a\",@progbits\n\t"	\
-					_ASM_PTR "%c1, (0f)+1, 4\n\t"	\
-					".previous\n\t"			\
-					"1:\n\t"			\
-					".org . + 3 - (. & 3), 0x90\n\t" \
-					"0:\n\t"			\
-					"mov $0,%0\n\t"			\
-				: "=R" (value)				\
-				: "i" (&name##__immediate));		\
+			asm(".section __discard,\"\",@progbits\n\t"	\
+				"1:\n\t"				\
+				"mov $0,%0\n\t"				\
+				"2:\n\t"				\
+				".previous\n\t"				\
+				".section __immediate,\"a\",@progbits\n\t" \
+				_ASM_PTR "%c1, (3f)-%c2, %c2\n\t"	\
+				".previous\n\t"				\
+				".org . + ((-.-(2b-1b)) & (%c2-1)), 0x90\n\t" \
+				"mov $0,%0\n\t"				\
+				"3:\n\t"				\
+				: "=r" (value)				\
+				: "i" (&name##__immediate),		\
+				  "i" (sizeof(value)));			\
 			break;						\
 		case 8:							\
 			if (sizeof(long) < 8) {				\
 				value = name##__immediate;		\
 				break;					\
 			}						\
-			asm(".section __immediate,\"a\",@progbits\n\t"	\
-					_ASM_PTR "%c1, (0f)+1, 4\n\t"	\
-					".previous\n\t"			\
-					"1:\n\t"			\
-					".org . + 6 - (. & 7), 0x90\n\t" \
-					"0:\n\t"			\
-					"mov $0xFEFEFEFE01010101,%0\n\t" \
+			asm(".section __discard,\"\",@progbits\n\t"	\
+				"1:\n\t"				\
+				"mov $0xFEFEFEFE01010101,%0\n\t" 	\
+				"2:\n\t"				\
+				".previous\n\t"				\
+				".section __immediate,\"a\",@progbits\n\t" \
+				_ASM_PTR "%c1, (3f)-%c2, %c2\n\t"	\
+				".previous\n\t"				\
+				".org . + ((-.-(2b-1b)) & (%c2-1)), 0x90\n\t" \
+				"mov $0xFEFEFEFE01010101,%0\n\t" 	\
+				"3:\n\t"				\
 				: "=r" (value)				\
-				: "i" (&name##__immediate));		\
+				: "i" (&name##__immediate),		\
+				  "i" (sizeof(value)));			\
 			break;						\
 		default:value = name##__immediate;			\
 			break;						\
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
