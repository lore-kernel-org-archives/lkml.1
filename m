Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbZIVK1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbZIVK1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZIVK1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:27:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56903 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311AbZIVK1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:27:36 -0400
Date: Tue, 22 Sep 2009 12:27:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [origin tree build failure] [PATCH] Re: [git pull] drm tree.
Message-ID: <20090922102726.GA31054@elte.hu>
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

btw., i hope you have not commited this yet, there's a trivial problem 
with this patch:

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

that ';' in the inline prototype is bogus, this wont build.

	Ingo
