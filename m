Return-Path: <linux-kernel-owner+w=401wt.eu-S1760402AbZLQVxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760402AbZLQVxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbZLQVxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:53:35 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:30105 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbZLQVxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:53:34 -0500
Subject: Re: -tip: origin tree build failure
From: Myron Stowe <myron.stowe@hp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
In-Reply-To: <20091217075025.GA314@elte.hu>
References: <20091217075025.GA314@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 14:53:11 -0700
Message-ID: <1261086791.2505.13.camel@zim.stowe>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 08:50 +0100, Ingo Molnar wrote:
> Today's -tip failed to build because commit 
> 9e368fa011d4e0aa050db348d69514900520e40b ("ipmi: add PNP discovery (ACPI 
> namespace via PNPACPI)") from today's upstream kernel causes the following 
> build failure on x86, for CONFIG_ACPI=n && CONFIG_IPMI_SI=y:
> 
>  drivers/char/ipmi/ipmi_si_intf.c:3208: error: 'ipmi_pnp_driver' undeclared (first use in this function)
>  drivers/char/ipmi/ipmi_si_intf.c:3208: error: (Each undeclared identifier is reported only once
>  drivers/char/ipmi/ipmi_si_intf.c:3208: error: for each function it appears in.)
>  drivers/char/ipmi/ipmi_si_intf.c:3334: error: 'ipmi_pnp_driver' undeclared (first use in this function)
> 
> The reason is that the ipmi_pnp_driver depends on ACPI facilities and is only 
> made available under ACPI - while the registration and unregistration is made 
> dependent on CONFIG_PNP:
> 
>  #ifdef CONFIG_PNP
>  	pnp_register_driver(&ipmi_pnp_driver);
>  #endif
> 
> The solution is to only register this driver under ACPI. (Also, the CONFIG_PNP 
> dependency is not needed because pnp_register_driver() is stubbed out in the 
> !CONFIG_PNP case.)

Yes, sorry we missed this case.
> 
> I've applied the patch below to tip:out-of-tree for now.

Looks good to us.  Thanks!

Myron
> 
> Thanks,
> 
> 	Ingo
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 679cd08..176f175 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -3204,7 +3204,7 @@ static __devinit int init_ipmi_si(void)
>  #ifdef CONFIG_ACPI
>  	spmi_find_bmc();
>  #endif
> -#ifdef CONFIG_PNP
> +#ifdef CONFIG_ACPI
>  	pnp_register_driver(&ipmi_pnp_driver);
>  #endif
>  
> @@ -3330,7 +3330,7 @@ static __exit void cleanup_ipmi_si(void)
>  #ifdef CONFIG_PCI
>  	pci_unregister_driver(&ipmi_pci_driver);
>  #endif
> -#ifdef CONFIG_PNP
> +#ifdef CONFIG_ACPI
>  	pnp_unregister_driver(&ipmi_pnp_driver);
>  #endif
>  
> 


-- 
Myron Stowe                             HP Open Source Linux Lab (OSLL)

