Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYGYIYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYGYIYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYGYIYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:24:33 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:53883 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752319AbYGYIYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:24:31 -0400
Date: Fri, 25 Jul 2008 09:24:24 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mmc: Add per-card debugfs support
Message-ID: <20080725082424.GD8301@fluff.org.uk>
References: <1216901939-4187-1-git-send-email-haavard.skinnemoen@atmel.com> <1216901939-4187-2-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216901939-4187-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 02:18:58PM +0200, Haavard Skinnemoen wrote:
> For each card successfully added to the bus, create a subdirectory under
> the host's debugfs root with information about the card.
> 
> At the moment, only a single file is added to the card directory for
> all cards: "state". It reflects the "state" field in struct mmc_card,
> indicating whether the card is present, readonly, etc.
> 
> For MMC and SD cards (not SDIO), another file is added: "status".
> Reading this file will ask the card about its current status and
> return it. This can be useful if the card just refuses to respond to
> any commands, which might indicate that the card state is not what the
> MMC core thinks it is (due to a missing stop command, for example.)
> 
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

out of interest, why not have an standard sysfs node for the
current voltage setting?
 
> Changes since v2:
>   * Don't rely on the compiler to optimize out unused code

which compiler? the gcc 4 series seem quite good at it, gcc 3.4
and later tended to eliminate only the code and not the associated
data created with it.

> Changes since v1:
>   * move card debugfs stuff into debugfs.c
>   * add "state" file corresponding to the "state" field in struct
>     mmc_card.
>   * only create the "status" file if the card is an MMC or SD memory
>     card since SDIO doesn't support the SEND_STATUS command.
> ---
>  drivers/mmc/core/bus.c     |    8 ++++++
>  drivers/mmc/core/core.h    |    3 ++
>  drivers/mmc/core/debugfs.c |   61 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mmc/card.h   |    2 +
>  4 files changed, 74 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
> index fd95b18..0d9b2d6 100644
> --- a/drivers/mmc/core/bus.c
> +++ b/drivers/mmc/core/bus.c
> @@ -252,6 +252,10 @@ int mmc_add_card(struct mmc_card *card)
>  	if (ret)
>  		return ret;
>  
> +#ifdef CONFIG_DEBUG_FS
> +	mmc_add_card_debugfs(card);
> +#endif
> +

why not make mmc_add_card_debugfs() an empty function
in the header if there is no debugfs support?

>  	mmc_card_set_present(card);
>  
>  	return 0;
> @@ -263,6 +267,10 @@ int mmc_add_card(struct mmc_card *card)
>   */
>  void mmc_remove_card(struct mmc_card *card)
>  {
> +#ifdef CONFIG_DEBUG_FS
> +	mmc_remove_card_debugfs(card);
> +#endif
> +

ditto above comment.

>  	if (mmc_card_present(card)) {
>  		if (mmc_host_is_spi(card->host)) {
>  			printk(KERN_INFO "%s: SPI card removed\n",
> diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
> index 745da98..c819eff 100644
> --- a/drivers/mmc/core/core.h
> +++ b/drivers/mmc/core/core.h
> @@ -56,5 +56,8 @@ extern int use_spi_crc;
>  void mmc_add_host_debugfs(struct mmc_host *host);
>  void mmc_remove_host_debugfs(struct mmc_host *host);
>  
#ifdef CONFIG_DEBUG_FS
void mmc_add_card_debugfs(struct mmc_card *card);
void mmc_remove_card_debugfs(struct mmc_card *card);
#else
static inline void mmc_add_card_debugfs(struct mmc_card *card) { }
static inline void mmc_remove_card_debugfs(struct mmc_card *card) { }

>  #endif
>  
> diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
> index 133c6e5..1237bb4 100644
> --- a/drivers/mmc/core/debugfs.c
> +++ b/drivers/mmc/core/debugfs.c
> @@ -12,9 +12,11 @@
>  #include <linux/seq_file.h>
>  #include <linux/stat.h>
>  
> +#include <linux/mmc/card.h>
>  #include <linux/mmc/host.h>
>  
>  #include "core.h"
> +#include "mmc_ops.h"
>  
>  /* The debugfs functions are optimized away when CONFIG_DEBUG_FS isn't set. */
>  static int mmc_ios_show(struct seq_file *s, void *data)
> @@ -162,3 +164,62 @@ void mmc_remove_host_debugfs(struct mmc_host *host)
>  {
>  	debugfs_remove_recursive(host->debugfs_root);
>  }
> +
> +static int mmc_dbg_card_status_get(void *data, u64 *val)
> +{
> +	struct mmc_card	*card = data;
> +	u32		status;
> +	int		ret;
> +
> +	mmc_claim_host(card->host);
> +
> +	ret = mmc_send_status(data, &status);
> +	if (!ret)
> +		*val = status;
> +
> +	mmc_release_host(card->host);
> +
> +	return ret;
> +}
> +DEFINE_SIMPLE_ATTRIBUTE(mmc_dbg_card_status_fops, mmc_dbg_card_status_get,
> +		NULL, "%08llx\n");
> +
> +void mmc_add_card_debugfs(struct mmc_card *card)
> +{
> +	struct mmc_host	*host = card->host;
> +	struct dentry	*root;
> +
> +	if (!host->debugfs_root)
> +		return;
> +
> +	root = debugfs_create_dir(mmc_card_id(card), host->debugfs_root);
> +	if (IS_ERR(root))
> +		/* Don't complain -- debugfs just isn't enabled */
> +		return;
> +	if (!root)
> +		/* Complain -- debugfs is enabled, but it failed to
> +		 * create the directory. */
> +		goto err;
> +
> +	card->debugfs_root = root;
> +
> +	if (!debugfs_create_x32("state", S_IRUSR, root, &card->state))
> +		goto err;
> +
> +	if (mmc_card_mmc(card) || mmc_card_sd(card))
> +		if (!debugfs_create_file("status", S_IRUSR, root, card,
> +					&mmc_dbg_card_status_fops))
> +			goto err;
> +
> +	return;
> +
> +err:
> +	debugfs_remove_recursive(root);
> +	card->debugfs_root = NULL;
> +	dev_err(&card->dev, "failed to initialize debugfs\n");
> +}
> +
> +void mmc_remove_card_debugfs(struct mmc_card *card)
> +{
> +	debugfs_remove_recursive(card->debugfs_root);
> +}
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index 0d508ac..ee6e822 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -111,6 +111,8 @@ struct mmc_card {
>  	unsigned		num_info;	/* number of info strings */
>  	const char		**info;		/* info strings */
>  	struct sdio_func_tuple	*tuples;	/* unknown common tuples */
> +
> +	struct dentry		*debugfs_root;
>  };
>  
>  #define mmc_card_mmc(c)		((c)->type == MMC_TYPE_MMC)
> -- 
> 1.5.6.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
