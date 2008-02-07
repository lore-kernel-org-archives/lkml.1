Return-Path: <linux-kernel-owner+w=401wt.eu-S1761489AbYBGXIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489AbYBGXIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbYBGXI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:08:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40449 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783AbYBGXI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:08:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Date: Fri, 8 Feb 2008 00:06:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
References: <20080205190600.GB11613@elf.ucw.cz> <200802072312.31430.rjw@sisk.pl> <47AB887E.7010000@zytor.com>
In-Reply-To: <47AB887E.7010000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802080006.54151.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 7 of February 2008, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
> > Index: linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.S
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.S
> > @@ -0,0 +1,122 @@
> > +/*
> > + * ACPI wakeup real mode startup stub
> > + */
> > +#include <asm/segment.h>
> > +#include <asm/msr-index.h>
> > +#include <asm/page_64.h>
> > +#include <asm/pgtable_64.h>
> > +
> > +	.code16
> > +	.section ".header", "a"
> > +
> > +/* This should match the structure in wakeup.h */
> > +		.globl	wakeup_header
> > +wakeup_header:
> > +video_mode:	.short	0	/* Video mode number */
> > +pmode_return:	.byte	0x66, 0xea	/* ljmpl */
> > +		.long	0	/* offset goes here */
> > +		.short	__KERNEL_CS
> 
> Missing a .short pad here... Pavel fixed that at some point, I thought.

Hm, the struct in wakeup.h doesn't contain it too.  Why exactly is it
necessary?

[--snip--]
> >  	}
> > -	memcpy((void *)acpi_wakeup_address, &wakeup_start,
> > -	       &wakeup_end - &wakeup_start);
> > -	acpi_copy_wakeup_routine(acpi_wakeup_address);
> > +	memcpy((void *)acpi_realmode, &wakeup_code_start, 4*PAGE_SIZE);
> 
> Using a PAGE_SIZE multiplier here isn't a good thing...

Yes, I'll fix that in one of the next iterations.

> 
> > +	header = (struct wakeup_header *)(acpi_realmode + 0x3f00);
> 
> ... especially not with magic constants like this.

Yeah.  Pavel, what's at 0x3f00, btw?

> If you're putting the "header" at the end, then you should also replace 
> the end_signature stuff since that's, then, redundant.

In fact, I'd prefer to remove .signature from the header and use the
end_signature only, so that I can use struct wakeup_header for addressing
the header fields in the assembly too.

> Furthermore, by doing so, you're also padding the binary out to its maximum
> length, so you might as well just remove the .bss-clearing stuff.

Do you mean placing the header at the end will fill the area between it and the
code with zeros, so the .bss clearing is not necessary?

> It's not really clear to me why to do this what way...
> 
> > +	if (header->signature != 0x51ee1111) {
> > +		printk(KERN_ERR "wakeup header does not match\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	header->video_mode = saved_video_mode;
> > +
> > +#ifndef CONFIG_64BIT
> > +	store_gdt(&header->pmode_gdt);
> > +
> > +	header->pmode_efer_low = nx_enabled;
> > +	if (header->pmode_efer_low & 1) {
> > +		/* This is strange, why not save efer, always? */
> > +		rdmsr(MSR_EFER, header->pmode_efer_low,
> > +			header->pmode_efer_high);
> > +	}
> 
> Yes, why not save EFER every time?

Well, I think we can do that.

Rafael
