Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbYBTHs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbYBTHs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 02:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760095AbYBTHsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 02:48:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44399 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987AbYBTHsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 02:48:00 -0500
Message-ID: <47BBDA20.8030105@zytor.com>
Date: Tue, 19 Feb 2008 23:43:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Joel Becker <Joel.Becker@oracle.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>	 <20080215202336.GE26034@mail.oracle.com>	 <1203274161.27987.6.camel@localhost.localdomain>	 <20080218104025.GA15899@ca-server1.us.oracle.com> <1203458366.26910.15.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1203458366.26910.15.camel@cthulhu.hellion.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Mon, 2008-02-18 at 02:40 -0800, Joel Becker wrote:
>> On Sun, Feb 17, 2008 at 06:49:21PM +0000, Ian Campbell wrote:
> 
>>> x86/xen: Do not scan for DMI unless the DMI region is reserved by e820.
> 
>> 	This fixed it.  I'm now booting successfully.  Thank you!
> 
> Excellent. Jeremy, are you happy for this to go in?
> 

NAK!

It's pretty standard for 0xf0000...0x100000 to be marked RESERVED in 
E820 on real hardware (including the system I'm typing on right now.) 
It is so marked to indicate that hardware cannot be mapped into that 
space.  However, you can't rely on this fact -- heck, you can't rely on 
E820 even existing on a real machine.  I have specimens of real-life 
machines that go both ways.

This patch WILL break real hardware.

What's particularly damning is that it's titled "x86/xen: Do not scan 
for DMI unless the DMI region is reserved by e820." whereas in fact it 
changes (breaks) generic code.

	-hpa

>>From 23e4ec12b95064320f83fca1cc1ad5c7b2eb3386 Mon Sep 17 00:00:00 2001
> From: Ian Campbell <ijc@hellion.org.uk>
> Date: Tue, 19 Feb 2008 21:57:45 +0000
> Subject: [PATCH] x86/xen: Do not scan for DMI unless the DMI region is reserved by e820.
> 
> Under Xen the memory at 0xf0000 is regular RAM and so can potentially contain a
> page table and hence cannot be mapped. The e820 map given to guest reflects
> this.
> 
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> ---
>  drivers/firmware/dmi_scan.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index 653265a..7d29403 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -7,6 +7,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/slab.h>
>  #include <asm/dmi.h>
> +#include <asm/e820.h>
>  
>  static char dmi_empty_string[] = "        ";
>  
> @@ -371,6 +372,9 @@ void __init dmi_scan_machine(void)
>  		}
>  	}
>  	else {
> +		if (!e820_all_mapped(0xF0000, 0xF0000+0x10000, E820_RESERVED))
> +			goto out;
> +
>  		/*
>  		 * no iounmap() for that ioremap(); it would be a no-op, but
>  		 * it's so early in setup that sucker gets confused into doing
