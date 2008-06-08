Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYFHHN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYFHHN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 03:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYFHHNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 03:13:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4065 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753795AbYFHHNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 03:13:48 -0400
Date: Sun, 8 Jun 2008 09:13:03 +0200
From: Pavel Machek <pavel@suse.cz>
To: Keith Packard <keithp@keithp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       airlied@linux.ie, Keith Packard <keith@keithp.com>
Subject: Re: [intel-agp] Rewrite GTT on resume
Message-ID: <20080608071302.GA4739@ucw.cz>
References: <1212550880.4677.5.camel@koto.keithp.com> <20080606135015.3f42820d.akpm@linux-foundation.org> <1212787027.8384.31.camel@koto.keithp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212787027.8384.31.camel@koto.keithp.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From 26b58f13ecbe95a7eaca7434aeb885def057b835 Mon Sep 17 00:00:00 2001
> From: Keith Packard <keithp@keithp.com>
> Date: Tue, 3 Jun 2008 20:34:54 -0700
> Subject: [PATCH] [INTEL-AGP] Re-write GATT on resume
> 
> Keep a list of current GATT mappings. At resume time, rewrite them into the
> GATT. This is needed on Intel (at least) as the entire GATT is cleared
> across suspend/resume. The list is protected by a spinlock.

Is this needed in case of iommu enabled, agp disabled, too?

> diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
> index eeea50a..7f1a96e 100644
> --- a/drivers/char/agp/intel-agp.c
> +++ b/drivers/char/agp/intel-agp.c
> @@ -2176,6 +2176,7 @@ static void __devexit agp_intel_remove(struct pci_dev *pdev)
>  static int agp_intel_resume(struct pci_dev *pdev)
>  {
>  	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
> +	int ret_val;
>  
>  	pci_restore_state(pdev);
>  
> @@ -2203,6 +2204,10 @@ static int agp_intel_resume(struct pci_dev *pdev)
>  	else if (bridge->driver == &intel_i965_driver)
>  		intel_i915_configure();
>  
> +	ret_val = agp_rebind_memory();
> +	if (ret_val != 0)
> +		return ret_val;
> +
>  	return 0;
>  }
>  #endif

Should this move early (sysdev?) because other drivers may depend on
iommu working?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
