Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbZCNUa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbZCNUa6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 16:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbZCNUas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 16:30:48 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:46831 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbZCNUar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 16:30:47 -0400
Date: Sat, 14 Mar 2009 21:30:38 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cliff Cai <cliff.cai@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] mmc: align data size for host which only supports
 power-of-2 block
Message-ID: <20090314213038.4d14526e@mjolnir.ossman.eu>
In-Reply-To: <1236309321-23955-1-git-send-email-cooloney@kernel.org>
References: <1236309321-23955-1-git-send-email-cooloney@kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Mar 2009 11:15:21 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Cliff Cai <cliff.cai@analog.com>
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---

This patch seems premature as there is no associated modification of
any of the host drivers.

>  drivers/mmc/core/core.c  |    8 +++++++-
>  include/linux/mmc/host.h |    1 +
>  2 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index df6ce4a..15119df 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -321,7 +321,13 @@ unsigned int mmc_align_data_size(struct mmc_card *card, unsigned int sz)
>  	 * the core about its problems yet, so for now we just 32-bit
>  	 * align the size.
>  	 */
> -	sz = ((sz + 3) / 4) * 4;
> +
> +	/* Align size for host which only supports power-of-2 block */
> +	if (card->host->powerof2_block) {
> +		if (sz & (sz - 1))
> +			sz = 1 << fls(sz);
> +	} else
> +		sz = ((sz + 3) / 4) * 4;
>  
>  	return sz;
>  }

At the very least, the comment at the top of this function must go. But
really, if we want to improve this we should probably do it properly
and have flags for the different limitations that are available.

Padding to a power of two size can also mean a rather large padding. We
might need to check the host data limits after doing the adjustment.

> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 4e45725..7416ed1 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -162,6 +162,7 @@ struct mmc_host {
>  	struct dentry		*debugfs_root;
>  
>  	unsigned long		private[0] ____cacheline_aligned;
> +	unsigned int		powerof2_block;	/* host only supports power-of-2 block */
>  };
>  
>  extern struct mmc_host *mmc_alloc_host(int extra, struct device *);

This is just broken. Putting it after private completely breaks
accesses to the host driver private data.

Also, there are a whole bunch of alignment issues that can occur. We
need some kind of flags field or a bitfield for this.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
