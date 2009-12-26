Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZLZMgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZLZMgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 07:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZLZMgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 07:36:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:19078 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZLZMgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 07:36:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=G0QPgpgp3HJXcbZoax8Q69EmVuZSN2h1WvE08FwqDjYQhCoWElst8x3QcoB/Yhfcgs
         7ANSDa8UPO1Vf9ZFewWxKjO+Bc+Mgnay0637WCCa23kPwpd8Cs56RJWgH6P7U4772OWt
         tzk+1hECl7q4pXUmEFvoeXVJfb2YY77CWHK8U=
MIME-Version: 1.0
In-Reply-To: <20091217075025.GA314@elte.hu>
References: <20091217075025.GA314@elte.hu>
Date: Sat, 26 Dec 2009 13:36:14 +0100
X-Google-Sender-Auth: 94ec948555aeb09d
Message-ID: <10f740e80912260436t753494bi6125f3582a6905ea@mail.gmail.com>
Subject: Re: -tip: origin tree build failure
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Myron Stowe <myron.stowe@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 08:50, Ingo Molnar <mingo@elte.hu> wrote:
> Today's -tip failed to build because commit
> 9e368fa011d4e0aa050db348d69514900520e40b ("ipmi: add PNP discovery (ACPI
> namespace via PNPACPI)") from today's upstream kernel causes the following
> build failure on x86, for CONFIG_ACPI=n && CONFIG_IPMI_SI=y:
>
>  drivers/char/ipmi/ipmi_si_intf.c:3208: error: 'ipmi_pnp_driver' undeclared (first use in this function)
>  drivers/char/ipmi/ipmi_si_intf.c:3208: error: (Each undeclared identifier is reported only once
>  drivers/char/ipmi/ipmi_si_intf.c:3208: error: for each function it appears in.)
>  drivers/char/ipmi/ipmi_si_intf.c:3334: error: 'ipmi_pnp_driver' undeclared (first use in this function)
>
> The reason is that the ipmi_pnp_driver depends on ACPI facilities and is only
> made available under ACPI - while the registration and unregistration is made
> dependent on CONFIG_PNP:
>
>  #ifdef CONFIG_PNP
>        pnp_register_driver(&ipmi_pnp_driver);
>  #endif
>
> The solution is to only register this driver under ACPI. (Also, the CONFIG_PNP
> dependency is not needed because pnp_register_driver() is stubbed out in the
> !CONFIG_PNP case.)
>
> I've applied the patch below to tip:out-of-tree for now.

Any chance we can see this fixed in mainline soon, so allmodconfig builds again
on non-ACPI platforms? Thx!

> Thanks,
>
>        Ingo
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 679cd08..176f175 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -3204,7 +3204,7 @@ static __devinit int init_ipmi_si(void)
>  #ifdef CONFIG_ACPI
>        spmi_find_bmc();
>  #endif
> -#ifdef CONFIG_PNP
> +#ifdef CONFIG_ACPI
>        pnp_register_driver(&ipmi_pnp_driver);
>  #endif
>
> @@ -3330,7 +3330,7 @@ static __exit void cleanup_ipmi_si(void)
>  #ifdef CONFIG_PCI
>        pci_unregister_driver(&ipmi_pci_driver);
>  #endif
> -#ifdef CONFIG_PNP
> +#ifdef CONFIG_ACPI
>        pnp_unregister_driver(&ipmi_pnp_driver);
>  #endif
>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
