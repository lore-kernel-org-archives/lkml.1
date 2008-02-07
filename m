Return-Path: <linux-kernel-owner+w=401wt.eu-S934637AbYBGW2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637AbYBGW2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758501AbYBGW2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:28:30 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:44018 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761815AbYBGW23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:28:29 -0500
Date: Thu, 7 Feb 2008 23:28:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Message-ID: <20080207222833.GA23004@uranus.ravnborg.org>
References: <20080205190600.GB11613@elf.ucw.cz> <200802060227.14385.rjw@sisk.pl> <200802070049.00461.rjw@sisk.pl> <200802072312.31430.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802072312.31430.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ===================================================================
> --- /dev/null
> +++ linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.ld
> @@ -0,0 +1,51 @@
> +/*
> + * wakeup.ld
> + *
> + * Linker script for the real-mode wakeup code
> + */
> +OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
> +OUTPUT_ARCH(i386)
> +ENTRY(_start)
> +
> +SECTIONS
> +{
> +	. = 0x3f00;
> +	.header		: { *(.header) }

Can we please use C style in this file.
Like this:

{
	.header : {
		*(.header)
	}

It is not as short as the above but it pays of to keep
an consistent style in the whole file and across
different .lds files.

And for good measure name it wakeup.lds.

Do we never need data from a .h file?
If we do name it wakeup.lds.S and kbuild
will fix it (assuming we have wakeup.lds
as a prerequisite where it is needed.

> +
> +	. = 0;
> +	.text		: { *(.text*) }
> +
> +	. = ALIGN(16);
Why?
> +	.rodata		: { *(.rodata*) }
> +
> +	.videocards	: {
> +		video_cards = .;
> +		*(.videocards)
> +		video_cards_end = .;
> +	}
> +
> +	. = ALIGN(16);
Why?
> +	.data		: { *(.data*) }
> +
> +	.signature	: {
> +		end_signature = .;
> +		LONG(0x65a22c82)
> +	}
> +
> +	. = ALIGN(16);
Why?
> +	.bss		:
> +	{
> +		__bss_start = .;
> +		*(.bss)
> +		__bss_end = .;
> +	}
> +
> +	. = ALIGN(16);
Why?
> +	_end = .;
> +
> +	/DISCARD/ : { *(.note*) }
> +
> +	/* Adjust this as appropriate */
> +	/* This allows 4 pages (16K) */
> +	. = ASSERT(_end <= 0x4000, "Wakeup too big!");
PAGE_SIZE * 4?


	Sam
