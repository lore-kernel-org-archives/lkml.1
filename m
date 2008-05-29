Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbYE2G1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbYE2G1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 02:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYE2G1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 02:27:12 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:35935 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751168AbYE2G1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 02:27:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=joAEurk1LDoQMQWq5BqpsZZIuEGlPr+ki95xtSzSCNiCysmqKIoU+XYKpMza5m6LJoc+2irgWhsil3f0YjL8TowwlOpT8ho2xrtIN7LOa5UQv+RU4Q4WHpjBFKY5QJNrOgRSW5CzYYu59UELHegcSGwCe63DKl6A8hQAf3FXGF8=  ;
X-YMail-OSG: ZcBwgTwVM1kswMwM9F6QRr2e40ldTl0E8R1T8zc_pXc3J53zey5tv8eqd_ZDkfUyW5CAhKDl8ho0qP6dPN9PdCQLCgqAxLZG1fHQPHa5mYxtMFGm3crHByhCCPr_COK6pSk-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Stas Sergeev <stsp@aknet.ru>, akpm@linux-foundation.org
Subject: Re: [patch][resend] provide rtc_cmos platform device, take 2
Date: Wed, 28 May 2008 23:27:08 -0700
User-Agent: KMail/1.9.9
Cc: ambx1@neo.rr.com, bjorn.helgaas@hp.com, mingo@elte.hu, tglx@linutronix.de,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Linux kernel <linux-kernel@vger.kernel.org>
References: <200805212334.m4LNY42M006425@imap1.linux-foundation.org> <483BEF1A.3080808@aknet.ru>
In-Reply-To: <483BEF1A.3080808@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805282327.08981.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2008, Stas Sergeev wrote:
> --- a/arch/x86/kernel/rtc.c
> +++ b/arch/x86/kernel/rtc.c
> @@ -4,9 +4,12 @@
>  #include <linux/acpi.h>
>  #include <linux/bcd.h>
>  #include <linux/mc146818rtc.h>
> +#include <linux/platform_device.h>
> +#include <linux/pnp.h>
>  
>  #include <asm/time.h>
>  #include <asm/vsyscall.h>
> +#include <asm/mc146818rtc.h>

The <asm/mc146818rtc.h> isn't needed, since it's automatically
included via <linux/mc146818rtc.h> ... see right at the top.

And for good fun, notice how the asm file includes the linux
version ... seems like a cleanup would be nice someday.  :)


> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c

> @@ -958,20 +946,33 @@ static struct platform_driver cmos_platform_driver = {
>  
>  static int __init cmos_init(void)
>  {
> +#ifdef CONFIG_PNP
> +       if (pnp_platform_devices)
> +               return pnp_register_driver(&cmos_pnp_driver);
> +       else
> +               return platform_driver_probe(&cmos_platform_driver,
> +                       cmos_platform_probe);
> +#else
>         return platform_driver_probe(&cmos_platform_driver,
>                         cmos_platform_probe);
> +#endif /* CONFIG_PNP */
>  }
>  module_init(cmos_init);

That's kind of ugly, but not wrong.

My only question is whether that resolves the problem Russell was 
reporting.  I think his situation needed to register *both* types
of bus glue (but I never saw his patch).  If we're going to fix this,
best merge just one patch...

- Dave


