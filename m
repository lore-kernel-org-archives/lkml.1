Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbYIJSte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbYIJSte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYIJSt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:49:26 -0400
Received: from outbound-mail-114.bluehost.com ([69.89.24.4]:40294 "HELO
	outbound-mail-114.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751446AbYIJSt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:49:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=URO9LLr7Caw7e1eQh5GG85uroKWEFzySUffZS52M/RjuLbgQLaIErkf89gqxOSoc1opOBmy/H/DrC5qRXSapXavBC9K+BYIzdaO2jeMUHiw4zhSpuv7QH4SJ4xw0Ibmj;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: unify using pci_mmcfg_insert_resource
Date: Wed, 10 Sep 2008 11:49:05 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1220083122-4058-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1220083122-4058-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101149.06592.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, is this stuff in the same branch with the BAR debugging fix?

Thanks,
Jesse

On Saturday, August 30, 2008 12:58 am Yinghai Lu wrote:
> even with known_bridge insert them late too.
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
> +++ linux-2.6/arch/x86/pci/mmconfig-shared.c
> @@ -209,7 +209,7 @@ static int __init pci_mmcfg_check_hostbr
>  	return name != NULL;
>  }
>
> -static void __init pci_mmcfg_insert_resources(unsigned long
> resource_flags) +static void __init pci_mmcfg_insert_resources(void)
>  {
>  #define PCI_MMCFG_RESOURCE_NAME_LEN 19
>  	int i;
> @@ -233,7 +233,7 @@ static void __init pci_mmcfg_insert_reso
>  			 cfg->pci_segment);
>  		res->start = cfg->address;
>  		res->end = res->start + (num_buses << 20) - 1;
> -		res->flags = IORESOURCE_MEM | resource_flags;
> +		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
>  		insert_resource(&iomem_resource, res);
>  		names += PCI_MMCFG_RESOURCE_NAME_LEN;
>  	}
> @@ -434,11 +434,9 @@ static void __init __pci_mmcfg_init(int
>  	    (pci_mmcfg_config[0].address == 0))
>  		return;
>
> -	if (pci_mmcfg_arch_init()) {
> -		if (known_bridge)
> -			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
> +	if (pci_mmcfg_arch_init())
>  		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
> -	} else {
> +	else {
>  		/*
>  		 * Signal not to attempt to insert mmcfg resources because
>  		 * the architecture mmcfg setup could not initialize.
> @@ -475,7 +473,7 @@ static int __init pci_mmcfg_late_insert_
>  	 * marked so it won't cause request errors when __request_region is
>  	 * called.
>  	 */
> -	pci_mmcfg_insert_resources(0);
> +	pci_mmcfg_insert_resources();
>
>  	return 0;
>  }
