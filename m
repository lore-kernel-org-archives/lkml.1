Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbYAYXh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbYAYXh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYAYXhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:37:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48535 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYAYXhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:37:12 -0500
Message-ID: <479A7269.1060007@zytor.com>
Date: Fri, 25 Jan 2008 15:36:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: factor out common s2ram wakeup code
References: <20080122193719.GA3791@elf.ucw.cz> <4796519C.6040501@zytor.com> <20080122205625.GC4317@elf.ucw.cz> <47965B13.9080705@zytor.com> <20080122212440.GF4317@elf.ucw.cz> <47966546.6040002@zytor.com> <20080122220301.GA8019@elf.ucw.cz> <47969BB2.2020409@zytor.com> <20080125231215.GA2146@elf.ucw.cz>
In-Reply-To: <20080125231215.GA2146@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> diff --git a/arch/x86/kernel/acpi/rm/wakemain.c b/arch/x86/kernel/acpi/rm/wakemain.c
> new file mode 100644
> index 0000000..d3173cc
> --- /dev/null
> +++ b/arch/x86/kernel/acpi/rm/wakemain.c
> @@ -0,0 +1,18 @@
> +#include "wakeup.h"
> +#include "boot.h"
> +
> +extern struct wakeup_header wakeup_header;
> +
> +void main(void)
> +{
> +	asm volatile("lcallw   $0xc000,$3;	movw    %cs, %ax;	movw    %ax, %ds;	movw	%ax, %es; movw    %ax, %ss");
> +
> +//	asm volatile("inb	$97, %al; 		outb	%al, $0x80; 		movb	$3, %al; 		outb	%al, $97; 		outb	%al, $0x80; 		movb	$-74, %al; 		outb	%al, $67; 		outb	%al, $0x80; 		movb	$-119, %al; 		outb	%al, $66; 		outb	%al, $0x80; 		movb	$15, %al; 		outb	%al, $66");
> +
> +	/* Need to call BIOS */
> +	probe_cards(0);
> +//	set_mode(wakeup_header.video_mode);
> +	set_mode(6);
> +
> +	/* Set up GDT and IDT here, possibly CR4 and EFER */
> +}

Surely this needs some cleaning up?  ;)

> diff --git a/arch/x86/kernel/acpi/rm/wakeup.S b/arch/x86/kernel/acpi/rm/wakeup.S
> new file mode 100644
> index 0000000..bfa348c
> --- /dev/null
> +++ b/arch/x86/kernel/acpi/rm/wakeup.S
> @@ -0,0 +1,129 @@
> +/*
> + * ACPI wakeup real mode startup stub
> + */
> +#include <asm/segment.h>
> +#include <asm/msr-index.h>
> +
> +	
> +#define BEEP \
> +	inb	$97, %al; 	\
> +	outb	%al, $0x80; 	\
> +	movb	$3, %al; 	\
> +	outb	%al, $97; 	\
> +	outb	%al, $0x80; 	\
> +	movb	$-74, %al; 	\
> +	outb	%al, $67; 	\
> +	outb	%al, $0x80; 	\
> +	movb	$-119, %al; 	\
> +	outb	%al, $66; 	\
> +	outb	%al, $0x80; 	\
> +	movb	$15, %al; 	\
> +	outb	%al, $66;
> +

BEEP isn't actually used here and should probably be a C function if 
needed.  Note: in real mode you can also produce a beep by calling
int $0x10 with %ax = 0x0e07.  Please note that some int $0x10 
implementations clobber certain registers... see the INT10 macro in the 
bootup code.

Seriously cool, though, that you're getting this far.

	-hpa
