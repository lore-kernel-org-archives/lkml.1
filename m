Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbZL1HUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbZL1HUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 02:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZL1HUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 02:20:36 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:37574 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbZL1HUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 02:20:35 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [BUG] agpgart-amd64 not initialized in 2.6.33-rc2
Date: Mon, 28 Dec 2009 09:18:35 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc2; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
References: <200912271719.39306.mitov@issp.bas.bg> <20091228153704Z.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091228153704Z.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912280918.36067.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 December 2009 08:37:33 am FUJITA Tomonori wrote:
> On Sun, 27 Dec 2009 17:19:39 +0200
> Marin Mitov <mitov@issp.bas.bg> wrote:
> 
> > Hi all,
> > 
> > Recently (2.6.33-rc2 kernel, x86_64, 4GB RAM) I found (in dmesg):
> > 
> > [drm:mga_do_agp_dma_bootstrap] *ERROR* Unable to acquire AGP: -19
> > 
> > and there is no /dev/agpgart device on the machine while all is OK 
> > if booting 2.6.32.2. 
> > 
> > In both kernels I have:
> > 
> > CONFIG_AGP=y
> > CONFIG_AGP_AMD64=y
> > 
> > CONFIG_GART_IOMMU=y
> > 
> > but nevertheless dmesg shows:
> > 
> > PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> > 
> > due to quirks in via K8T800Pro host bridge.
> > 
> > Looking for the reason I found that agp_amd64_init() appears in:
> > 
> > #ifndef CONFIG_GART_IOMMU
> > module_init(agp_amd64_init);
> > module_exit(agp_amd64_cleanup);
> > #endif
> > 
> >  /*  so it is not invoked here due to CONFIG_GART_IOMMU=y   */
> > 
> > and also appears in:
> >  
> > arch/x86/kernel/pci-gart_64.c, function: gart_iommu_init()
> > 
> > The last one is part of the struct x86_init_ops(struct x86_init_iommu, as a function pointer) 
> > only if gart-iommu is successfully detected, which is not the case here due to the quirk, 
> > so agp_amd64_init() is not invoked here neither. 
> > 
> > Sure, configuring the kernel without CONFIG_GART_IOMMU=y (which is not user selectable)
> > 
> > should solve the problem, but usually users do not know about quirks, so it should
> > work even as set here (and it works up to 2.6.32.2). I believe the bug is introduced
> > with the changes in the order iommu detect/init works for 2.6.33.
> > 
> > I am here for additional info/tests.
> 
> Sorry about the regression. Does this works?

Yes, it works for me, thank you.

Marin Mitov

> diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
> index 2fb2e6c..5aa7a58 100644
> --- a/drivers/char/agp/amd64-agp.c
> +++ b/drivers/char/agp/amd64-agp.c
> @@ -725,9 +725,14 @@ static struct pci_driver agp_amd64_pci_driver = {
>  int __init agp_amd64_init(void)
>  {
>  	int err = 0;
> +	static int done = 0;
>  
>  	if (agp_off)
>  		return -EINVAL;
> +
> +	if (done++)
> +		return agp_bridges_found ? 0 : -ENODEV;
> +
>  	err = pci_register_driver(&agp_amd64_pci_driver);
>  	if (err < 0)
>  		return err;
> @@ -771,12 +776,8 @@ static void __exit agp_amd64_cleanup(void)
>  	pci_unregister_driver(&agp_amd64_pci_driver);
>  }
>  
> -/* On AMD64 the PCI driver needs to initialize this driver early
> -   for the IOMMU, so it has to be called via a backdoor. */
> -#ifndef CONFIG_GART_IOMMU
>  module_init(agp_amd64_init);
>  module_exit(agp_amd64_cleanup);
> -#endif
>  
>  MODULE_AUTHOR("Dave Jones <davej@redhat.com>, Andi Kleen");
>  module_param(agp_try_unsupported, bool, 0);
> 
