Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535Ab0AYHou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab0AYHou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 02:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045Ab0AYHot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 02:44:49 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:37886 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab0AYHot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 02:44:49 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [BUG] agpgart-amd64 not initialized in 2.6.33-rc5 if iommu=allowed in kernel command line
Date: Mon, 25 Jan 2010 09:37:53 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc5; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com
References: <201001232314.55425.mitov@issp.bas.bg> <20100125141006O.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100125141006O.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001250937.53518.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010 07:10:47 am FUJITA Tomonori wrote:
> On Sat, 23 Jan 2010 23:14:55 +0200
> Marin Mitov <mitov@issp.bas.bg> wrote:
> 
> > Hi,
> > 
> > If I start the kernel without command line parameters (4GB RAM)
> > iommu-swiotlb is used due to quirk in VIA K8T800Pro Host Bridge.
> > In that case all is OK.
> > 
> > If I put in the kernel command line: iommu=allowed (+other parameters)
> > I have iommu-gart used but no AGP. dmesg output:
> > 
> > [drm:mga_do_agp_dma_bootstrap] *ERROR* Unable to acquire AGP: -19
> > 
> > For debugging I patched the kernel (mostly prink(), shown at the end)
> > producing the output in the dmesg:
> > 
> > no command line
> > MDM: agp_amd64_init entered
> > MDM: agp_off: false
> > MDM: agp_bridges_found: 0
> > MDM: gart_iommu_aperture: 0
> > MDM: agp_amd64_probe entered
> > 
> > command line: iommu=allowed:
> > MDM: gart_iommu_init
> > MDM: before: no_agp = 0
> > MDM: 	agp_amd64_init entered
> > MDM: 	agp_off: false
> > MDM: 	agp_bridges_found: 0
> > MDM: after: no_agp = 1
> > MDM: agp_amd64_init() < 0: 1
> > MDM: agp_copy_info() < 0: -1
> > MDM: 	agp_amd64_init entered
> > MDM: 	agp_off: false
> > MDM: 	agp_bridges_found: 0
> > 
> > One see in the last case ( iommu=allowed) agp_amd64_init()
> > is executed twice, but agp_amd64_probe() is not executed at all
> > (agp_bridges_found is incremented only in agp_amd64_probe())
> > 
> > Is this expected behavior?
> 
> Duh, it's my stupid mistake. Sorry about that.
> 
> This works for you?
> 
> Can you test this patch with set CONFIG_AGP_AMD64 to both y and m
> (also loading/unloading the module twice)?

If CONFIG_AGP_AMD64=y it works (I have agp) both with no kernel command 
line parameters as well as with iommu=allowed in kernel command line.

If CONFIG_AGP_AMD64=m  it works (I have agp)  with no kernel command
line parameters. If I boot to no graphics (runlevel 3 in slackware), 
lsmod output is:

amd64_agp               7463  1
agpgart                   27765  1 amd64_agp

amd64_agp is in use (not known by who), cannot be unloaded and I cannot 
test load/unload.

If CONFIG_AGP_AMD64=m and  iommu=allowed is in kernel command line
I have no agp.
dmesg:
[drm:mga_do_agp_dma_bootstrap] *ERROR* Unable to acquire AGP: -19
If I boot to no graphics and try:
modprobe amd64_agp
FATAL: Error inserting amd64_agp
(/lib/modules/2.6.33-rc5/kernel/drivers/char/agp/amd64-agp.ko): No such
device

For info: iommu=allowed changes gart_iommu_aperture_allowed from 0 to 1.

I am ready for further testing.

Marin Mitov

> 
> Thanks,
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] x86/agp: fix agp_amd64_init regression
> 
> This fixes the regression introduced by the commit
> 42590a75019a50012f25a962246498dead428433.
> 
> The above commit changes agp_amd64_init() not to do anything if
> gart_iommu_aperture is not zero.
> 
> If GART iommu calls agp_amd64_init(), we need to skip agp_amd64_init()
> when it's called later via module_init.
> 
> The problem is that gart_iommu_init() calls agp_amd64_init() with not
> zero gart_iommu_aperture so agp_amd64_init() is never initialized.
> 
> When gart_iommu_init() calls agp_amd64_init(), agp should be always
> initialized.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/char/agp/amd64-agp.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
> index 1afb896..34cf04e 100644
> --- a/drivers/char/agp/amd64-agp.c
> +++ b/drivers/char/agp/amd64-agp.c
> @@ -729,9 +729,6 @@ int __init agp_amd64_init(void)
>  	if (agp_off)
>  		return -EINVAL;
>  
> -	if (gart_iommu_aperture)
> -		return agp_bridges_found ? 0 : -ENODEV;
> -
>  	err = pci_register_driver(&agp_amd64_pci_driver);
>  	if (err < 0)
>  		return err;
> @@ -768,6 +765,14 @@ int __init agp_amd64_init(void)
>  	return err;
>  }
>  
> +static int __init agp_amd64_mod_init(void)
> +{
> +	if (gart_iommu_aperture)
> +		return agp_bridges_found ? 0 : -ENODEV;
> +
> +	return agp_amd64_init();
> +}
> +
>  static void __exit agp_amd64_cleanup(void)
>  {
>  	if (gart_iommu_aperture)
> @@ -777,7 +782,7 @@ static void __exit agp_amd64_cleanup(void)
>  	pci_unregister_driver(&agp_amd64_pci_driver);
>  }
>  
> -module_init(agp_amd64_init);
> +module_init(agp_amd64_mod_init);
>  module_exit(agp_amd64_cleanup);
>  
>  MODULE_AUTHOR("Dave Jones <davej@redhat.com>, Andi Kleen");
