Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab0BUCDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 21:03:33 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:55722 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab0BUCDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 21:03:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=LHynA2lzNx3kHNKjmu6SsgD+TiGttQ1jh7D9hOVs037VIAaABHVjN3m1w+BiOIsPik
         ODh895gRf9QP4Ysj4AAKgp6BWtlGowD8+7s3WnIta/jyLYDlkt/zoYWE0K1I9gs7+GFX
         YOs+Deeoqax7JcNtUnJhIcgr1X0C4wV1nND8U=
Message-ID: <4B80946D.1030503@gmail.com>
Date: Sun, 21 Feb 2010 13:03:25 +1100
From: Graeme Russ <graeme.russ@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: x86 embedded - Problem getting past 'move compressed kernel before
 decompression'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am trying to port Linux to an AMD SC520 based custom (not PC based)
hardware. I have spent a lot of time recently getting the x86 port of
U-Boot to the point where I can load a bzImage into memory and jump into
the startup_32 entry point in linux-2.6/arch/x86/boot/compressed/head_32.S

The hardware is in no way based on any kind of PC architecture, it does not
have a BIOS. U-Boot transitions straight into Protected Mode (refer to
U-Boot\cpu\i386\resetvec.S U-Boot\cpu\i386\start16.S and  performs all the
hardware initialisation in Protected Mode. So I want to use the "32-bit
BOOT PROTOCOL" as described in linux-2.6/Documentation/x86/boot.txt

Now the GDT in U-Boot is defined as follows:

    0x0000, 0x0000, 0x0000, 0x0000	/* 0x00 NULL */
    0x0000, 0x0000, 0x0000, 0x0000	/* 0x08 Unused */
    0xFFFF, 0x0000, 0x9B00, 0x00CF	/* 0x10 32-bit Code */
    0xFFFF, 0x0000, 0x9300, 0x00CF	/* 0x18 32-bit Data */
    0xFFFF, 0x0000, 0x9B00, 0x0010	/* 0x20 16-bit Code */
    0xFFFF, 0x0000, 0x9300, 0x0010	/* 0x28 16-bit Data */

The first 4 entries (in particular 0x10 and 0x18) are identical to how
setup_gdt() in linux-2.6/arch/x86/boot/pm.c appears to set up the GDT and
is as described in the "32-bit BOOT PROTOCOL"

I now also have U-Boot successfully copying the Real Mode (16-bit) part of
bzImage to 0x90000 and the Protected Mode (32-bit) part to 0x100000 (1M)
(copying the Real Mode part is a bit of a legacy and it gives convenient
access to the setup header)

The following is something I have hacked together to jump into the 32-bit
start address of the Linux Kernel:

struct boot_params boot_params __attribute__((aligned(16)));
struct setup_header *hdr = (struct setup_header *)(0x90000 + 0x1f1);

void boot_zimage(void *setup_base)
{
	memset(&boot_params, 0x00, sizeof boot_params);
	memcpy(&boot_params.hdr, hdr, sizeof (*hdr));

	boot_params.alt_mem_k = 128 * 1024;
	boot_params.e820_entries = 1;
	boot_params.e820_map[0].addr = 0x00000000;
	boot_params.e820_map[0].size = 128 * 1024;
	boot_params.e820_map[0].type = 1;

	asm(	"movw	$0x18, %%cx\n" \
		"movl	%%ecx, %%ds\n" \
		"movl	%%ecx, %%es\n" \
		"movl	%%ecx, %%fs\n" \
		"movl	%%ecx, %%gs\n" \
		"movl	%%ecx, %%ss\n" \
		"xorl	%%ebp, %%ebp\n" \
		"xorl	%%edi, %%edi\n" \
		"xorl	%%ebx, %%ebx\n" \
		"movl	%0, %%esi\n"
		"movl   $0x100000, %%eax\n" \
		"jmpl	*%%eax" : : "r"(&boot_params));
}

I have added several instances of the following to test the progress of the
boot-up in linux-2.6/arch/x86/boot/compressed/head_32.S:

	pushl	%eax
	pushl	%edx
	movb	$'!', %al
	movw	$0x3f8, %dx
	outb	%al, %dx
	popl	%edx
	popl	%eax

At first, I noticed that the copy code at lines 96 to 104 was not copying
the compressed kernel as expected. I have since found that the default
build address is now actually 0x1000000 (16M) and not 0x100000 (1M). I
found the only way to change this was to use 'menuconfig' to turn on the
EMBEDDED option which then exposed the CONFIG_PHYSICAL_START option. I
adjusted this to 0x100000 (1M) and now the copy works as expected, but code
execution never reaches the reloacted: label at line 104

I am now a little stuck as to how to further diagnose the problem. If
anyone could provide some ideas, I would be really thankful

TIA

Regards,

Graeme

PS: Can you please Cc me (graeme.russ@gmail.com) as I have not subscribed
to this list (yet)

