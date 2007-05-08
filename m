Return-Path: <linux-kernel-owner+w=401wt.eu-S966235AbXEHMYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966235AbXEHMYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965509AbXEHMYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:24:15 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36360 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964792AbXEHMYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:24:14 -0400
Date: Tue, 8 May 2007 13:52:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Bogus section mismatch errors?
Message-ID: <20070508115220.GA29160@uranus.ravnborg.org>
References: <20070508111759.GA26562@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508111759.GA26562@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 12:17:59PM +0100, Russell King wrote:
> 
> WARNING: arch/arm/mach-realview/built-in.o - Section mismatch:
>  reference to .init.text: from .data between 'realview_timer' (at offset 0x54)
>  and 'clcd_plat_data'
> 
> Weird, these two data structures don't interact with each other.  Probably
> bogus.
modpsot does it best to guess what symbol are represented by an address.
In this case I would assume that realview_timer has a function pointer to a function
that is marked __init.

> 
> WARNING: init/built-in.o - Section mismatch:
>  reference to .init.text: from .text between 'rest_init' (at offset 0x2c)
>  and 'run_init_process'
This is due to the reference to kernel_init - but binutils hardcode the offset
so modpost does not recognize the symbol.
A workaround (that I do not like) it to remove static declaration of kernel_init,
then modpost will recognize the symbol and see this is OK.


> WARNING: mm/built-in.o - Section mismatch:
>  reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x1bd94)
>  and 'cache_reap'
> WARNING: mm/built-in.o - Section mismatch:
>  reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x1bdcc)
>  and 'cache_reap'
There are in slab a function that is not marked __init that refer to a function marked
__init. But the logic surrounding makes it OK.

I have no fix/workaround for this.
Andres has suggested that we should mark functions/data that may refer to __init{data}
with something like: __nowarn and __nowarndata

I am planning to implement something so we can mark functions/data with:
__init_ref_ok and _init_data_ref_ok
Which is indeed more ugly but expalins what is actually OK.

I hope to take a look during the weekend.

	Sam
