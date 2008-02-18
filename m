Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbYBRKmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbYBRKmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbYBRKmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:42:14 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:32404 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbYBRKmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:42:11 -0500
Date: Mon, 18 Feb 2008 02:40:25 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
Message-ID: <20080218104025.GA15899@ca-server1.us.oracle.com>
Mail-Followup-To: Ian Campbell <ijc@hellion.org.uk>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mika Penttila <mika.penttila@kolumbus.fi>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org> <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org> <20080215202336.GE26034@mail.oracle.com> <1203274161.27987.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203274161.27987.6.camel@localhost.localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 06:49:21PM +0000, Ian Campbell wrote:
> I've been seeing similar attempts to map 0xf0 but so far I was the only
> one (although that made no sense to me). Does the patch below help at
> all? The problem seems to be that the kernel is trying to map pages at
> 0xf0000 but these are not reserved in the guest E820 map so they could
> contain a page table page etc.
> 
> A useful tip for getting a backtrace out of a crashed Xen guest is to
> set "on_crash=preserve" in your domain config. Then once the crash has
> happened you can use "/usr/lib/xen/bin/xenctx -s System.map <domid>"
> where System.map is the guest kernel System.map.

	That didn't work for me - it gave me "can't trace dom0" for
whatever reason.  But...

> x86/xen: Do not scan for DMI unless the DMI region is reserved by e820.
> 
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index 9008ed5..79525f5 100644
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
> @@ -336,6 +337,10 @@ void __init dmi_scan_machine(void)
>  		}
>  	}
>  	else {
> +
> +		if (!e820_all_mapped(0xF0000, 0xF0000+0x10000, E820_RESERVED))
> +			goto out;
> +
>  		/*
>  		 * no iounmap() for that ioremap(); it would be a no-op, but
>  		 * it's so early in setup that sucker gets confused into doing

	This fixed it.  I'm now booting successfully.  Thank you!  If
you have any furthur patches you'd like to test, I'd be happy to do so.

Joel

-- 

"And yet I find,
 And yet I find repeating in my head.
 If I can't be my own, 
 I'd feel better dead."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
