Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZKPUYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZKPUYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 15:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbZKPUYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 15:24:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753664AbZKPUY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 15:24:29 -0500
Date: Mon, 16 Nov 2009 12:23:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       504391@bugs.debian.org, Wouter van Heyst <larstiq@larstiq.dyndns.org>,
       Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] mmc: add module parameter to set whether cards are
 assumed removable
Message-Id: <20091116122329.847916b6.akpm@linux-foundation.org>
In-Reply-To: <1257914676.2237.57.camel@localhost>
References: <1257914676.2237.57.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 04:44:36 +0000
Ben Hutchings <ben@decadent.org.uk> wrote:

> Some people run general-purpose distribution kernels on netbooks with
> a card that is physically non-removable or logically non-removable
> (e.g. used for /home) and cannot be cleanly unmounted during suspend.
> Add a module parameter to set whether cards are assumed removable or
> non-removable, with the default set by CONFIG_MMC_UNSAFE_RESUME.
> 

The description really doesn't give me enough info to work out what's
happening here and why this is being proposed.  But it smells nasty.


> index ab37a6d..bb22ffd 100644
> --- a/drivers/mmc/core/Kconfig
> +++ b/drivers/mmc/core/Kconfig
> @@ -3,7 +3,7 @@
>  #
>  
>  config MMC_UNSAFE_RESUME
> -	bool "Allow unsafe resume (DANGEROUS)"
> +	bool "Assume MMC/SD cards are non-removable (DANGEROUS)"
>  	help
>  	  If you say Y here, the MMC layer will assume that all cards
>  	  stayed in their respective slots during the suspend. The
> @@ -14,3 +14,5 @@ config MMC_UNSAFE_RESUME
>  	  This option is usually just for embedded systems which use
>  	  a MMC/SD card for rootfs. Most people should say N here.
>  
> +	  This option sets a default which can be overridden by the
> +	  module parameter "removable=0" or "removable=1".
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index d98b0e2..010c964 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -48,6 +48,22 @@ int use_spi_crc = 1;
>  module_param(use_spi_crc, bool, 0);
>  
>  /*
> + * We normally treat cards as removed during suspend if they are not
> + * known to be on a non-removable bus, to avoid the risk of writing
> + * back data to a different card after resume.  Allow this to be
> + * overridden if necessary.
> + */

So we have a module parameter which nobody knows about.  If they don't
set this parameter which they don't know about, the kernel will trash
their filesystem??


> +#ifdef CONFIG_MMC_UNSAFE_RESUME
> +int mmc_assume_removable;
> +#else
> +int mmc_assume_removable = 1;
> +#endif
> +module_param_named(removable, mmc_assume_removable, bool, 0644);
> +MODULE_PARM_DESC(
> +	removable,
> +	"MMC/SD cards are removable and may be removed during suspend");
> +

