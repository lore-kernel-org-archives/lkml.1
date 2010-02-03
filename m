Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab0BCPW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:22:29 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:48576 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702Ab0BCPW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:22:26 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [BUG] agpgart-amd64 not initialized in 2.6.33-rc5 if iommu=allowed in kernel command line
Date: Wed, 3 Feb 2010 17:19:48 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc6; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com
References: <20100125141006O.fujita.tomonori@lab.ntt.co.jp> <20100202202328O.fujita.tomonori@lab.ntt.co.jp> <20100203004905T.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100203004905T.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002031719.48603.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 February 2010 05:49:20 pm FUJITA Tomonori wrote:
> On Tue, 2 Feb 2010 20:23:40 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > > If CONFIG_AGP_AMD64=m  it works (I have agp)  with no kernel command
> > > line parameters. If I boot to no graphics (runlevel 3 in slackware), 
> > > lsmod output is:
> > > 
> > > amd64_agp               7463  1
> > > agpgart                   27765  1 amd64_agp
> > > 
> > > amd64_agp is in use (not known by who), cannot be unloaded and I cannot 
> > > test load/unload.
> > > 
> > > If CONFIG_AGP_AMD64=m and  iommu=allowed is in kernel command line
> > > I have no agp.
> > > dmesg:
> > > [drm:mga_do_agp_dma_bootstrap] *ERROR* Unable to acquire AGP: -19
> > 
> > This works with 2.6.32, right?  The following patch works?
> 
> Duh, sorry, please this instead:

Sorry to be late.

First, the patch do not apply cleanly on  2.6.33-rc6 (I'm running now).
I have to apply the patch in:

http://lkml.org/lkml/2010/1/25/4

first, then to apply:

http://lkml.org/lkml/2010/2/2/241

over it. 

In this configuration (both patches applied) it works for me with/without kernel 
command line (iommu=allowed + ....) when either amd64-agp is built in the kernel 
(CONFIG_AGP_AMD64=y), or as a module (CONFIG_AGP_AMD64=m).

> > > lsmod output:
> > > 
> > > amd64_agp               7463  1
> > > agpgart                   27765  1 amd64_agp

I have still amd64_agp used, so I cannot test load/unload  amd64_agp:

Thanks,

Marin Mitov

> 
> diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
> index 34cf04e..fd50ead 100644
> --- a/drivers/char/agp/amd64-agp.c
> +++ b/drivers/char/agp/amd64-agp.c
> @@ -767,16 +767,19 @@ int __init agp_amd64_init(void)
>  
>  static int __init agp_amd64_mod_init(void)
>  {
> +#ifndef MODULE
>  	if (gart_iommu_aperture)
>  		return agp_bridges_found ? 0 : -ENODEV;
> -
> +#endif
>  	return agp_amd64_init();
>  }
>  
>  static void __exit agp_amd64_cleanup(void)
>  {
> +#ifndef MODULE
>  	if (gart_iommu_aperture)
>  		return;
> +#endif
>  	if (aperture_resource)
>  		release_resource(aperture_resource);
>  	pci_unregister_driver(&agp_amd64_pci_driver);
> 
