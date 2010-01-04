Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867Ab0ADS6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab0ADS6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799Ab0ADS6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:58:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:48474 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab0ADS6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:58:43 -0500
Date: Mon, 4 Jan 2010 10:58:34 -0800
From: Jun Sun <jsun@junsun.net>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [uClinux-dev] [PATCH] Valid relocation symbol for FLAT format
	on ARM, v2
Message-ID: <20100104185834.GC19197@Pogoplug>
References: <20100101012645.GB16887@Pogoplug> <20100102230906.GB32298@shareable.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20100102230906.GB32298@shareable.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 02, 2010 at 11:09:07PM +0000, Jamie Lokier wrote:
> Jun Sun wrote:
> > +/* [jsun] new gcc 4.x generates ANCHOR symbols in order to reduce the size
> > + * of GOT table for PIC code. It is possible the ANCHOR is placed beyond
> > + * the end of data/bss segment up to 4K bytes(12 bits), because ARM allows
> > + * negative 12-bit offset. Thus we allow 0x1000 extra in reloc address range.
> > + */
> 
> Can you provide a small test program and *exact* GCC version and
> Binutils version which triggers this?  People have reported using GCC
> 4.x on ARM uClinux for some time, and I haven't seen complaints
> about this problem before.
>

gcc is derived from code saucery's 2008Q2 release, I believe. It is
gcc 4.3.3. So there is minor chance that this ANCHOR feature
is a code sourcery feature rather than a generic gcc 4.3.3. Please help
verify.

I attached the sample code and the assembly output. The command line used
to generate this is:

arm-uclinuxeabi-gcc  -c -Os                     -g -fomit-frame-pointer -pipe -msoft-float -fno-common -fno-builtin -Wall   -DEMBED -D__PIC__ -fpic -msingle-pic-base -Dlinux -D__linux__ -Dunix -D__uClinux__ -S helloworld.c

You can see from the assembly output that .LANCHOR1 is set to 8184, well
beyond the real end of bss/data segment. And it is easy to see why, because
variable x2 is then referred as a negative offset to LANCHOR1.

Cheers.

Jun

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="helloworld.c"

#include <stdio.h>

char msg[]="hello, world";

static char buf[4092];
static int x1;
static int x2;

int main()
{
	buf[0]=0;
	x1 = 5;
	x2 = 6;
	printf("%s\n", msg);
	printf("main() is @ %08x\n", &main);
	printf("buf = 0x%x, x1 @ 0x%x, x2 @ 0x%x\n", buf, &x1, &x2);
	return 0;
}

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="helloworld.s"

	.cpu arm7tdmi
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 4
	.eabi_attribute 18, 4
	.file	"helloworld.c"
	.section	.debug_abbrev,"",%progbits
.Ldebug_abbrev0:
	.section	.debug_info,"",%progbits
.Ldebug_info0:
	.section	.debug_line,"",%progbits
.Ldebug_line0:
	.text
.Ltext0:
	.align	2
	.global	main
	.type	main, %function
main:
.LFB2:
	.file 1 "helloworld.c"
	.loc 1 10 0
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	.loc 1 11 0
	ldr	r3, .L3
	.loc 1 10 0
	stmfd	sp!, {r4, r5, r6, lr}
.LCFI0:
	.loc 1 11 0
	ldr	r4, [r9, r3]
	.loc 1 13 0
	ldr	r3, .L3+4
	ldr	r5, [r9, r3]
	.loc 1 14 0
	ldr	r3, .L3+8
	ldr	r1, [r9, r3]
	ldr	r3, .L3+12
	ldr	r0, [r9, r3]
	.loc 1 12 0
	mov	r3, #5
	.loc 1 11 0
	mov	r6, #0
	.loc 1 12 0
	str	r3, [r4, #4092]
	.loc 1 13 0
	add	r3, r3, #1
	str	r3, [r5, #-4088]
	.loc 1 11 0
	strb	r6, [r4, #0]
	.loc 1 14 0
	bl	printf
	.loc 1 15 0
	ldr	r3, .L3+16
	ldr	r0, [r9, r3]
	ldr	r3, .L3+20
	ldr	r1, [r9, r3]
	bl	printf
	.loc 1 16 0
	ldr	r0, .L3+24
	sub	r3, r5, #4080
	add	r2, r4, #4080
	mov	r1, r4
	ldr	r0, [r9, r0]
	add	r2, r2, #12
	sub	r3, r3, #8
	bl	printf
	.loc 1 18 0
	mov	r0, r6
	ldmfd	sp!, {r4, r5, r6, lr}
	bx	lr
.L4:
	.align	2
.L3:
	.word	.LANCHOR0(GOT)
	.word	.LANCHOR1(GOT)
	.word	msg(GOT)
	.word	.LC0(GOT)
	.word	.LC1(GOT)
	.word	main(GOT)
	.word	.LC2(GOT)
.LFE2:
	.size	main, .-main
	.global	msg
	.section	.rodata.str1.1,"aMS",%progbits,1
.LC0:
	.ascii	"%s\012\000"
.LC1:
	.ascii	"main() is @ %08x\012\000"
.LC2:
	.ascii	"buf = 0x%x, x1 @ 0x%x, x2 @ 0x%x\012\000"
	.data
	.type	msg, %object
	.size	msg, 13
msg:
	.ascii	"hello, world\000"
	.bss
	.align	2
	.set	.LANCHOR0,. + 0
	.set	.LANCHOR1,. + 8184
	.type	buf, %object
	.size	buf, 4092
buf:
	.space	4092
	.type	x1, %object
	.size	x1, 4
x1:
	.space	4
	.type	x2, %object
	.size	x2, 4
x2:
	.space	4
	.section	.debug_frame,"",%progbits
.Lframe0:
	.4byte	.LECIE0-.LSCIE0
.LSCIE0:
	.4byte	0xffffffff
	.byte	0x1
	.ascii	"\000"
	.uleb128 0x1
	.sleb128 -4
	.byte	0xe
	.byte	0xc
	.uleb128 0xd
	.uleb128 0x0
	.align	2
.LECIE0:
.LSFDE0:
	.4byte	.LEFDE0-.LASFDE0
.LASFDE0:
	.4byte	.Lframe0
	.4byte	.LFB2
	.4byte	.LFE2-.LFB2
	.byte	0x4
	.4byte	.LCFI0-.LFB2
	.byte	0xe
	.uleb128 0x10
	.byte	0x8e
	.uleb128 0x1
	.byte	0x86
	.uleb128 0x2
	.byte	0x85
	.uleb128 0x3
	.byte	0x84
	.uleb128 0x4
	.align	2
.LEFDE0:
	.text
.Letext0:
	.section	.debug_loc,"",%progbits
.Ldebug_loc0:
.LLST0:
	.4byte	.LFB2-.Ltext0
	.4byte	.LCFI0-.Ltext0
	.2byte	0x1
	.byte	0x5d
	.4byte	.LCFI0-.Ltext0
	.4byte	.LFE2-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 16
	.4byte	0x0
	.4byte	0x0
	.section	.debug_info
	.4byte	0xee
	.2byte	0x2
	.4byte	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.4byte	.LASF10
	.byte	0x1
	.4byte	.LASF11
	.4byte	.LASF12
	.4byte	.Ltext0
	.4byte	.Letext0
	.4byte	.Ldebug_line0
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.4byte	.LASF0
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.4byte	.LASF1
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.4byte	.LASF2
	.uleb128 0x2
	.byte	0x4
	.byte	0x5
	.4byte	.LASF3
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.ascii	"int\000"
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.4byte	.LASF4
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.4byte	.LASF5
	.uleb128 0x4
	.byte	0x4
	.byte	0x7
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.4byte	.LASF6
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.4byte	.LASF7
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.4byte	.LASF8
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.4byte	.LASF9
	.uleb128 0x5
	.byte	0x1
	.4byte	.LASF13
	.byte	0x1
	.byte	0xa
	.4byte	0x41
	.4byte	.LFB2
	.4byte	.LFE2
	.4byte	.LLST0
	.uleb128 0x6
	.4byte	0x48
	.4byte	0x9e
	.uleb128 0x7
	.4byte	0x56
	.2byte	0xffb
	.byte	0x0
	.uleb128 0x8
	.ascii	"buf\000"
	.byte	0x1
	.byte	0x5
	.4byte	0x8d
	.byte	0x5
	.byte	0x3
	.4byte	buf
	.uleb128 0x8
	.ascii	"x1\000"
	.byte	0x1
	.byte	0x6
	.4byte	0x41
	.byte	0x5
	.byte	0x3
	.4byte	x1
	.uleb128 0x8
	.ascii	"x2\000"
	.byte	0x1
	.byte	0x7
	.4byte	0x41
	.byte	0x5
	.byte	0x3
	.4byte	x2
	.uleb128 0x6
	.4byte	0x48
	.4byte	0xdf
	.uleb128 0x9
	.4byte	0x56
	.byte	0xc
	.byte	0x0
	.uleb128 0xa
	.ascii	"msg\000"
	.byte	0x1
	.byte	0x3
	.4byte	0xcf
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	msg
	.byte	0x0
	.section	.debug_abbrev
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x6
	.byte	0x0
	.byte	0x0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0x0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0x0
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0x0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0x0
	.byte	0x0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0x0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.byte	0x0
	.byte	0x0
	.uleb128 0x5
	.uleb128 0x2e
	.byte	0x0
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.byte	0x0
	.byte	0x0
	.uleb128 0x6
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x7
	.uleb128 0x21
	.byte	0x0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0x5
	.byte	0x0
	.byte	0x0
	.uleb128 0x8
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x9
	.uleb128 0x21
	.byte	0x0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0x0
	.byte	0x0
	.uleb128 0xa
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x2
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.section	.debug_pubnames,"",%progbits
	.4byte	0x1f
	.2byte	0x2
	.4byte	.Ldebug_info0
	.4byte	0xf2
	.4byte	0x75
	.ascii	"main\000"
	.4byte	0xdf
	.ascii	"msg\000"
	.4byte	0x0
	.section	.debug_aranges,"",%progbits
	.4byte	0x1c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0x0
	.2byte	0x0
	.2byte	0x0
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	0x0
	.4byte	0x0
	.section	.debug_str,"MS",%progbits,1
.LASF5:
	.ascii	"long long int\000"
.LASF0:
	.ascii	"unsigned int\000"
.LASF11:
	.ascii	"helloworld.c\000"
.LASF13:
	.ascii	"main\000"
.LASF2:
	.ascii	"long unsigned int\000"
.LASF9:
	.ascii	"long long unsigned int\000"
.LASF6:
	.ascii	"unsigned char\000"
.LASF4:
	.ascii	"char\000"
.LASF12:
	.ascii	"/home/jsun/work/lincos/trunk/add_on/helloworld_c\000"
.LASF3:
	.ascii	"long int\000"
.LASF8:
	.ascii	"short int\000"
.LASF1:
	.ascii	"short unsigned int\000"
.LASF7:
	.ascii	"signed char\000"
.LASF10:
	.ascii	"GNU C 4.3.3\000"
	.ident	"GCC: (Netspectrum uClinux EABI) 4.3.3"

--LZvS9be/3tNcYl/X--
