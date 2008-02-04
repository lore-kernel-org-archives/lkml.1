Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbYBDAEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbYBDAEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 19:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYBDAEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 19:04:45 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34043 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753588AbYBDAEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 19:04:45 -0500
Date: Mon, 4 Feb 2008 01:05:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: wakeup code translated to .c
Message-ID: <20080204000501.GL2799@elf.ucw.cz>
References: <20080130120111.GB22820@elf.ucw.cz> <200802040054.43863.rjw@sisk.pl> <20080203235927.GK2799@elf.ucw.cz> <200802040059.38963.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <200802040059.38963.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 2008-02-04 00:59:38, Rafael J. Wysocki wrote:
> On Monday, 4 of February 2008, Pavel Machek wrote:
> > Hi!
> > 
> > > BTW, I don't like the way in which the 'struct wakeup_header' fields are
> > > reproduced in rm/wakeup.S very much, because it makes the code fragile.
> > > It might be better to define the offsets in asm-offsets*.c and refer to them
> > > relative to wakeup_header (if possible).
> > 
> > If you can do that.. yes, that would be nice. I triple-checked it, but
> > indeed is fragile.
> 
> Do you want me to remove the unused fields from 'struct wakeup_header' too?

I think I did that already. My wakeup.S/wakeup.h is attached. If you
can find more unused fields, kill them for sure.

(I'm not sure about fields needed on 32-bit only. I'm leaving them in
because it does not really matter).


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--VbJkn9YxBvnuCH5J
Content-Type: text/x-chdr; charset=us-ascii
Content-Disposition: attachment; filename="wakeup.h"

/*
 * Definitions for the wakeup data structure at the head of the
 * wakeup code.
 */

#ifndef ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
#define ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H

#include <linux/types.h>

/* This must match data at wakeup.S */
struct wakeup_header {
	u16 entry;		/* unused */
	u16 total;		/* unused */
	u16 video_mode;		/* Video mode number */
	u16 _jmp1;
	u32 pmode_entry;	/* Protected mode resume point */
	u16 _jmp2;
	u32 pmode_cr0;		/* Protected mode cr0 */
	u32 pmode_cr3;		/* Protected mode cr3 */
	u32 pmode_cr4;		/* Protected mode cr4 */
	u32 pmode_efer_low;	/* Protected mode EFER */
	u32 pmode_efer_high;
	u64 pmode_gdt;
	u32 realmode_flags;
	u32 real_magic;
	u16 trampoline_segment;
	u32 signature;		/* To check we have correct structure */
} __attribute__((__packed__));

#endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wakeup.S"

/*
 * ACPI wakeup real mode startup stub
 */
#include <asm/segment.h>
#include <asm/msr-index.h>
#include <asm/page_64.h>
#include <asm/pgtable_64.h>

	.code16
	.section ".header", "a"

/* This should match the structure in wakeup.h */
		.globl	wakeup_header
wakeup_header:
entry:		.short	_start	/* unused */
total:		.short	_end	/* unused */
video_mode:	.short	0	/* Video mode number */
pmode_return:	.byte	0x66, 0xea	/* ljmpl */
		.long	0		/* offset goes here */
		.short	__KERNEL_CS
pmode_cr0:	.long	0		/* Saved %cr0 */
pmode_cr3:	.long	0		/* Saved %cr3 */
pmode_cr4:	.long	0		/* Saved %cr4 */
pmode_efer:	.quad	0		/* Saved EFER */
pmode_gdt:	.quad	0
realmode_flags:	.long	0
real_magic:	.long	0
trampoline_segment:	.word 0
signature:	.long	0x51ee1111

	.text
	.globl	_start
	.code16
wakeup_code:
_start:
	cli
	cld

	/* Set up segments */
	movw	%cs,%ax
	movw	%ax,%ds
	movw	%ax,%es
	movw	%ax,%ss

	movl	$wakeup_stack_end, %esp

	/* Clear the EFLAGS */
	pushl	$0
	popfl

	/* Check header signature... */
	movl	signature, %eax
	cmpl	$0x51ee1111, %eax
	jne	bogus_real_magic

	/* Check we really have everything... */
	movl	end_signature, %eax
	cmpl	$0x65a22c82, %eax
	jne	bogus_real_magic

	/* Zero the bss */
	xorl	%eax, %eax
	movw	$__bss_start, %di
	movw	$__bss_end+3, %cx
	subw	%di, %cx
	shrw	$2, %cx
	rep; stosl

	/* Call the C code */
	calll	main

	/* Do any other stuff... */
	
#ifndef CONFIG_64BIT
	/* This could also be done in C code... */
	movl	pmode_cr3, %eax
	movl	%eax, %cr3

	movl	pmode_cr4, %ecx
	jecxz	1f
	movl	%ecx, %cr4
1:
	movl	pmode_efer, %eax
	movl	pmode_efer+4, %edx
	movl	%eax, %ecx
	orl	%edx, %ecx
	jz	1f
	movl	$0xc0000080, %ecx
	wrmsr
1:

	lgdtl	pmode_gdt

	/* This really couldn't... */
	movl	pmode_cr0, %eax
	movl	%eax, %cr0
	jmp	pmode_return
#else
	pushw	$0
	pushw	trampoline_segment
	pushw	$0
	lret	
#endif

bogus_real_magic:
1:
	hlt
	jmp	1b
	
	.data
	.balign	4
	.globl	HEAP, heap_end
HEAP:
	.long	wakeup_heap
heap_end:
	.long	wakeup_stack

	.bss
wakeup_heap:
	.space	2048
wakeup_stack:
	.space	2048
wakeup_stack_end:


--VbJkn9YxBvnuCH5J--
