Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962Ab0B0FGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 00:06:55 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60024 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab0B0FGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 00:06:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KXP3N9jAPkrwmL1rfqmcrStOsIKzjne305CtzAlM1wzUEo8a+67M0kHgVmQvUCt92C
         qpcqVROkO3lU9Sj4l+NYPfmJfMUNe2JOOSBiWFvHV/Vx0XWiSgdzVAIml4vLz2qBpy28
         9m3WeMJbF+gKwOXbTTNidLgWXPcRbousk6uVo=
Message-ID: <4B88A865.2080009@gmail.com>
Date: Sat, 27 Feb 2010 16:06:45 +1100
From: Graeme Russ <graeme.russ@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86 embedded - Problem getting past 'move compressed kernel 
 before decompression'
References: <4B80946D.1030503@gmail.com> <4B80C892.9000303@zytor.com>	 <4B80CA55.3040402@zytor.com> <d66caabb1002211451s5a68565fue6096e17b99402f7@mail.gmail.com>
In-Reply-To: <d66caabb1002211451s5a68565fue6096e17b99402f7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Graeme Russ wrote:
> On Sun, Feb 21, 2010 at 4:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 02/20/2010 09:45 PM, H. Peter Anvin wrote:
>>
> Thanks Peter - I gave that a try but no luck. I am in the process of
> writing some routines which will dump the contents of the registers
> upon entering startup_32 and the relocation jump address prior to
> the jump.
> 
> My assembler is a bit rusty, so it is taking a bit of time
> 

Sorry for the delay - been very busy lately.

I borrowed __show_regs() from process_32.c and implemented crash dump and
break dump handlers in u-boot. So now I can int3 and dump all registers.

To give some context to what I am doing in u-boot:

#define DECLARE_INTERRUPT(x) \
	".globl irq_"#x"\n" \
	".hidden irq_"#x"\n" \
	".type irq_"#x", @function\n" \
	"irq_"#x":\n" \
	"pushl $"#x"\n" \
	"jmp irq_common_entry\n"

asm(".globl irq_common_entry\n" \
	".hidden irq_common_entry\n" \
	".type irq_common_entry, @function\n" \
	"irq_common_entry:\n" \
	"cld\n" \
	"pushl %gs\n" \
	"pushl %fs\n" \
	"pushl %es\n" \
	"pushl %ds\n" \
	"pushl %eax\n" \
	"pushl %ebp\n" \
	"pushl %edi\n" \
	"pushl %esi\n" \
	"pushl %edx\n" \
	"pushl %ecx\n" \
	"pushl %ebx\n" \
	"mov   %esp, %eax\n" \
	"pushl %ebp\n" \
	"movl %esp,%ebp\n" \
	"pushl %eax\n" \
	"call irq_llsr\n" \
	"popl %eax\n" \
	"leave\n"\
	"popl %ebx\n" \
	"popl %ecx\n" \
	"popl %edx\n" \
	"popl %esi\n" \
	"popl %edi\n" \
	"popl %ebp\n" \
	"popl %eax\n" \
	"popl %ds\n" \
	"popl %es\n" \
	"popl %fs\n" \
	"popl %gs\n" \
	"add  $4, %esp\n" \
	"iret\n" \
	DECLARE_INTERRUPT(0) \
	DECLARE_INTERRUPT(1) \
	DECLARE_INTERRUPT(2) \
.
.
.
	DECLARE_INTERRUPT(255)

/* IRQ Low-Level Service Routine */
__isr__ irq_llsr(struct pt_regs *regs)
{
	switch (regs->orig_eax) {
 	case 0x00:
		printf("Divide Error (Division by zero)\n");
		dump_regs(regs);
 		while(1);
 		break;
 	case 0x01:
		printf("Debug Interrupt (Single step)\n");
		dump_regs(regs);
 		break;
 	case 0x02:
		printf("NMI Interrupt\n");
		dump_regs(regs);
 		break;
 	case 0x03:
		printf("Breakpoint\n");
		dump_regs(regs);
 		break;
etc
}

dump_regs() is pretty much the same as __show_regs() in process_32.c

I've pulled the latest 6.2.33 kernel source and applied the following patch
to trace progress through the 32-bit Boot Protocol:

diff --git a/arch/x86/boot/compressed/head_32.S
b/arch/x86/boot/compressed/head_32.S
index f543b70..3535470 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -32,6 +32,7 @@

 	__HEAD
 ENTRY(startup_32)
+	int3
 	cld
 	/*
 	 * Test KEEP_SEGMENTS flag to see if the bootloader is asking
@@ -93,12 +94,14 @@ ENTRY(startup_32)
  * Copy the compressed kernel to the end of our buffer
  * where decompression in place becomes safe.
  */
+	int3
 	pushl	%esi
 	leal	(_bss-4)(%ebp), %esi
 	leal	(_bss-4)(%ebx), %edi
 	movl	$(_bss - startup_32), %ecx
 	shrl	$2, %ecx
 	std
+	int3
 	rep	movsl
 	cld
 	popl	%esi
@@ -106,12 +109,15 @@ ENTRY(startup_32)
 /*
  * Jump to the relocated address.
  */
+	int3
 	leal	relocated(%ebx), %eax
+	int3
 	jmp	*%eax
 ENDPROC(startup_32)

 	.text
 relocated:
+	int3

 /*
  * Clear BSS (stack is currently empty)

and in u-boot, to boot the kernel, I have:

struct boot_params boot_params __attribute__((aligned(16)));
struct setup_header *hdr = (struct setup_header *)(0x90000 + 0x1f1);

void boot_zimage(void *setup_base)
{
	printf("&boot_params = 0x%8.8lx\n", (ulong)&boot_params);
	printf("sizeof (*hdr) = 0x%8.8lx\n", (ulong)(sizeof (*hdr)));

	memset(&boot_params, 0x00, sizeof boot_params);
	memcpy(&boot_params.hdr, hdr, sizeof (*hdr));

	boot_params.alt_mem_k = 128 * 1024;
	boot_params.e820_entries = 1;
	boot_params.e820_map[0].addr = 0x00000000;
	boot_params.e820_map[0].size = 128 * 1024;
	boot_params.e820_map[0].type = 1;

	printf("Entering Linux\n");

       asm volatile(
               "movl   %2, %%ds\n" \
               "movl   %2, %%es\n" \
               "movl   %2, %%fs\n" \
               "movl   %2, %%gs\n" \
               "movl   %2, %%ss\n" \
               "xorl   %%ebp, %%ebp\n" \
               "xorl   %%ebx, %%ebx\n" \
               "int3\n" \
               "ljmpl  $0x10,$0x100000"
	        : : "S" (&boot_params), "D" (0), "r" (0x18));
}


The result is:

&boot_params = 0x03ffb350
sizeof (*hdr) = 0x00000067
Entering Linux
Breakpoint
EIP: 0010:[<03fe3e0b>] EFLAGS: 00000046
EAX: 00000018 EBX: 00000000 ECX: 000003f8 EDX: 000003f8
ESI: 03ffb350 EDI: 00000000 EBP: 00000000 ESP: 03ff42f3
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 01f1
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080099
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<00100001>] EFLAGS: 00000046
EAX: 00000018 EBX: 00000000 ECX: 000003f8 EDX: 000003f8
ESI: 03ffb350 EDI: 00000000 EBP: 00000000 ESP: 03ff42f3
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 01f1
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080099
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<00100042>] EFLAGS: 00000002
EAX: 00000018 EBX: 00377000 ECX: 000003f8 EDX: 000003f8
ESI: 03ffb350 EDI: 00000000 EBP: 00100000 ESP: 00000000
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080099
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<00100059>] EFLAGS: 00000416
EAX: 00000018 EBX: 00377000 ECX: 00070828 EDX: 000003f8
ESI: 002c209c EDI: 0053909c EBP: 00100000 ESP: 03ffb350
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080099
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<0010005e>] EFLAGS: 00000016
EAX: 00000018 EBX: 00377000 ECX: 00000000 EDX: 000003f8
ESI: 03ffb350 EDI: 00376ffc EBP: 00100000 ESP: 00000000
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080099
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<00100065>] EFLAGS: 00000016
EAX: 005379c4 EBX: 00377000 ECX: 00000000 EDX: 000003f8
ESI: 03ffb350 EDI: 00376ffc EBP: 00100000 ESP: 00000000
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080099
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Invalid Opcode (UnDefined Opcode)
EIP: 0010:[<dd013ea8>] EFLAGS: 00010016
EAX: 005379c4 EBX: 00377000 ECX: 00000000 EDX: 873d0328
ESI: 03ffb350 EDI: 00376ffc EBP: 00100000 ESP: 00000018
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080099
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400

I don't understand what is going on with SS and ESP, but everything else is
looking good up until:
 	jmp	*%eax

At which point, eax appears to hold a reasonably value. But:

boot > md 5379c4
005379c4: c11c0e7f b0c2ea61 2d43c068 f02e6fa0    ....a...h.C-.o..
005379d4: 3d0328ba 76651e87 c4c6e98e 26fddcad    .(.=..ev.......&
005379e4: 1983b874 c9edece7 793c2ce4 a8de5f50    t........,<yP_..
005379f4: a29afa5b e7b42f13 c4233d0a bc6e8424    [..../...=#.$.n.
00537a04: cb90001b dcea7bb4 969601e8 707fbe4a    .....{......J..p
00537a14: dfead2ec b8e62d5b fd7d2b53 b8ad16ef    ....[-..S+}.....
00537a24: e0252df2 28044367 9c80c800 beec457e    .-%.gC.(....~E..
00537a34: 22d27b84 4f32a8cc 9d1eb9b3 aac36b6a    .{."..2O....jk..
00537a44: f7f79e53 54af3ec6 f32eebe6 5a89fe1d    S....>.T.......Z
00537a54: 3e3aadfa 63e0b27f 5086cadd b438532e    ..:>...c...P.S8.
00537a64: 0a4daef6 f68fb9fc b525a3f1 c0cd58e7    ..M.......%..X..
00537a74: 3f727ad6 061e1199 793d150a 5fd8a267    .zr?......=yg.._
00537a84: fca2d658 4f1e392c dbdd62d3 4fed04dd    X...,9.O.b.....O
00537a94: 07caba83 1274f371 e18ef1f5 e1c32aef    ....q.t......*..
00537aa4: 964ff812 f214be9d a59e8b2c 281d0dd6    ..O.....,......(
00537ab4: 0d5a95fc 818d59e7 11d33442 73b99e6b    ..Z..Y..B4..k..s

(Note: each of the above longs is in reverse byte order, so 0x005379c4 is
actually 0x7f

I would have expected a 0xcc at 0x005379c4.

>From u-boot, if I jump straight to 0x005379c4 I get pretty much the same
crash. So it looks like a problem with the calculation of the copy source
or target address, or the calculation of the relocated jump address.

Any ideas?

Regards

Graeme
