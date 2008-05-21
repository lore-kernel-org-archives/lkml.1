Return-Path: <linux-kernel-owner+w=401wt.eu-S933894AbYEUXFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894AbYEUXFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbYEUXFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:05:46 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:43263 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758385AbYEUXFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:05:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EvxtGcpaldOzDe+G4R078qHqjAuVXQ8v3wKwgGuVhVcGAvR3idHGJFqCRdRHjl94RmTI8mkbRxJitTGXEf4Ic0yCdxbJrjq0UTRi56hneK9A80UKz/GPQWfKbo2mD9YM1yAnhxrWh6QS6g2LSsNIMIrIew8Gp6tNlQCz1SdLmH4=  ;
X-YMail-OSG: MVMm_X4VM1nTUq5nVp8SLmgfkytdYATaFXUuKdLBMdMOI5e.p7qig6Zr.kTeBNTHF7Y7shMnCovZF4h60Tp9rIkOF5jOchqjZzHd_rv2GiVfmf_reDeHIodR3pcaeiVXR3U-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Stas Sergeev <stsp@aknet.ru>
Subject: Re: [patch] provide rtc_cmos platform device
Date: Wed, 21 May 2008 16:05:39 -0700
User-Agent: KMail/1.9.9
Cc: Linux kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <483317B4.7060601@aknet.ru>
In-Reply-To: <483317B4.7060601@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805211605.39930.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2008, Stas Sergeev wrote:
> Hello.
> 
> Recently (around 2.6.25) I've noticed
> that RTC no longer works for me.
> It turned out this is because I use
> pnpacpi=off kernel option to work
> around the parport_pc bugs.
> I always did so, but RTC used to work
> fine in the past, and now it have
> regressed.

Well, "regression" is the wrong phrase.  You've switched
drivers (from the legacy RTC to the new one), so this is
not the thing which worked for you before.

Nonetheless, this should get fixed soonish; it just happens
to be something nobody reported before.

See two comments about patch brokenness below, though ...
this patch is broken and should not be merged.


> The attached patch fixes the problem
> by creating the platform device for
> the RTC when PNP is disabled.

If I had realized there was a "pnpacpi=off" option, I'd
have sent in my patch addressing this problem way back
when the rtc-cmos code merged!  I was deluded into thinking
this was a non-problem once ACPI and PNPACPI entered the
"always selected" mode, right about that time.


> This may also help running the
> PNP-enabled kernel on an older PCs.

As in, pre-PNP.  That's pretty darn old!  Although one
person mentioned an example of a system with broken PNP
support, which didn't report the RTC device (just stuck
its resources in the middle of a bunch of reserved
addresses).  So you might want to consider looking at
the case where PNP exists, but an RTC device doesn't ...

- Dave


(1) On an ARM build (with no PNP configured):

  CC      drivers/rtc/rtc-cmos.o
drivers/rtc/rtc-cmos.c: In function 'cmos_init':
drivers/rtc/rtc-cmos.c:949: error: 'pnp_platform_devices' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c:949: error: (Each undeclared identifier is reported only once
drivers/rtc/rtc-cmos.c:949: error: for each function it appears in.)
drivers/rtc/rtc-cmos.c:950: error: implicit declaration of function 'pnp_register_driver'
drivers/rtc/rtc-cmos.c:950: error: 'cmos_pnp_driver' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_exit':
drivers/rtc/rtc-cmos.c:959: error: 'pnp_platform_devices' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c:960: error: implicit declaration of function 'pnp_unregister_driver'
drivers/rtc/rtc-cmos.c:960: error: 'cmos_pnp_driver' undeclared (first use in this function)
make[1]: *** [drivers/rtc/rtc-cmos.o] Error 1
make: *** [drivers/rtc/rtc-cmos.o] Error 2

(2)

> --- a/include/asm-x86/rtc.h
> +++ b/include/asm-x86/rtc.h
> @@ -1 +1,5 @@
>  #include <asm-generic/rtc.h>
> +
> +#define RTC_PORT_START 0x70
> +#define RTC_PORT_END 0x71
> +#define RTC_IRQ 8

You shouldn't define those symbols; the right values are already
defined in <asm/mc146818rtc.h>.  RTC_PORT(0) and RTC_PORT(1) are
the symbolss to use; RTC_IRQ is already defined.  All this stuff
is used in the <asm-generic/rtc.h> code ...

