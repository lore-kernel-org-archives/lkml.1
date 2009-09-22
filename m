Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbZIVJhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbZIVJhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbZIVJhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:37:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47825 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702AbZIVJhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:37:04 -0400
Date: Tue, 22 Sep 2009 11:36:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [origin tree build failure] [PATCH] Re: [git pull] drm tree.
Message-ID: <20090922093651.GA30786@elte.hu>
References: <alpine.DEB.2.00.0909210610200.26881@skynet.skynet.ie> <20090921161207.GA9741@elte.hu> <alpine.DEB.2.00.0909220450440.7648@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0909220450440.7648@skynet.skynet.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Airlie <airlied@linux.ie> wrote:

> > there's a new build failure:
> > 
> > drivers/built-in.o: In function `drm_irq_uninstall':
> > (.text+0xb719e): undefined reference to `vga_client_register'
> > drivers/built-in.o: In function `drm_irq_install':
> > (.text+0xb7309): undefined reference to `vga_client_register'
> > drivers/built-in.o: In function `radeon_device_fini':
> > (.text+0xe400f): undefined reference to `vga_client_register'
> > drivers/built-in.o: In function `radeon_device_init':
> > (.text+0xe455b): undefined reference to `vga_client_register'
> > 
> > with the attached config, introduced with upstream merge 44040f1.
> > 
> > At first sight it appears to be due to CONFIG_DRM_RADEON relying on 
> > VGA_ARB facilities but this is not expressed in the Kconfig rules. The 
> > patch below solves this - but this is just a quick patch, i have not 
> > investigated any deeper.
> > 
> > Review of the code suggests that i915 has a similar dependency problem - 
> > i fixed that too.
> 
> The way it should work is VGA ARB should be enabled on any platforms we
> have PCI unless EMBEDDED turns it off, since arbitration of VGA isn't 
> reliant on a drm device, I'm not sure what Kconfig magic this would 
> require, and where it would need to be. This patch should at least allow
> builds to work until I figure out any Kconfig magic.
> 
> >From 8a874578cbf8b07b988e666c15fa0ba767f3c1cb Mon Sep 17 00:00:00 2001
> From: Dave Airlie <airlied@redhat.com>
> Date: Tue, 22 Sep 2009 13:53:00 +1000
> Subject: [PATCH] vgaarb: wrap the client register API so we can disable VGA ARB.
> 
> This provides an dummy register function so everything builds
> if VGA arb is turned off.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
>  include/linux/vgaarb.h |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
> index e81c64a..b0feb79 100644
> --- a/include/linux/vgaarb.h
> +++ b/include/linux/vgaarb.h
> @@ -41,7 +41,7 @@
>   *     interrupts at any time.
>   */
>  extern void vga_set_legacy_decoding(struct pci_dev *pdev,
> -									unsigned int decodes);
> +				    unsigned int decodes);
>  
>  /**
>   *     vga_get         - acquire & locks VGA resources
> @@ -193,8 +193,17 @@ static inline int vga_conflicts(struct pci_dev *p1, struct pci_dev *p2)
>   * They driver will get a callback when VGA arbitration is first used
>   * by userspace since we some older X servers have issues.
>   */
> +#if defined(CONFIG_VGA_ARB)
>  int vga_client_register(struct pci_dev *pdev, void *cookie,
>  			void (*irq_set_state)(void *cookie, bool state),
>  			unsigned int (*set_vga_decode)(void *cookie, bool state));
> +#else
> +static inline int vga_client_register(struct pci_dev *pdev, void *cookie,
> +				      void (*irq_set_state)(void *cookie, bool state),
> +				      unsigned int (*set_vga_decode)(void *cookie, bool state));
> +{
> +	return 0;
> +}
> +#endif

Yeah - making APIs config invariant is a good idea in any case, 
regardless of Kconfig magic.

Thanks,

	Ingo
