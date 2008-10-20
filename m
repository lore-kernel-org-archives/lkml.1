Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYJTUsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYJTUsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbYJTUrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:47:49 -0400
Received: from smtp.ono.com ([62.42.230.12]:26137 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754449AbYJTUrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:47:49 -0400
Date: Mon, 20 Oct 2008 22:47:40 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MMC: Fix race condition in resume/card detect code
Message-ID: <20081020224740.43a5a322@werewolf.home>
In-Reply-To: <1224531708-13624-1-git-send-email-jekhor@gmail.com>
References: <20081018191147.00327019@mjolnir.drzeus.cx>
	<1224531708-13624-1-git-send-email-jekhor@gmail.com>
X-Mailer: Claws Mail 3.6.1cvs9 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008 22:41:48 +0300, Yauhen Kharuzhy <jekhor@gmail.com> wrote:

> When device wakes up by card change interrupt and MMC_UNSAFE_RESUME is
> enabled then race condition between mmc_rescan() and
> mmc_resume()/mmc_sd_resume() appeared.
> 
> Resume functions can sleep into mmc_remove_card() and at this time
> mmc_rescan() can be called by delayed work handler. Double-free of
> kobject or double-remove of host->card can be result of this.
> 
> This patch adds an host->suspended flag which indicated that host is in
> suspend state. mmc_rescan() checks it and returned when
> host->suspended == 1. It's safe because resume code calls
> mmc_detect_change() at end of resume process.
> 
> Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
> ---
>  drivers/mmc/core/core.c  |    7 +++++++
>  include/linux/mmc/host.h |    3 +++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 044d84e..427f283 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -657,6 +657,9 @@ void mmc_rescan(struct work_struct *work)
>  	u32 ocr;
>  	int err;
>  
> +	if (host->suspended)
> +		return;
> +
>  	mmc_bus_get(host);
>  
>  	if (host->bus_ops == NULL) {
> @@ -780,6 +783,8 @@ int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
>  
>  	mmc_power_off(host);
>  
> +	host->suspended = 1;
> +
>  	return 0;
>  }
>  
> @@ -805,6 +810,8 @@ int mmc_resume_host(struct mmc_host *host)
>  	 */
>  	mmc_detect_change(host, 1);
>  
> +	host->suspended = 0;
> +
>  	return 0;
>  }
>  
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 9c288c9..a584239 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -139,6 +139,9 @@ struct mmc_host {
>  #ifdef CONFIG_MMC_DEBUG
>  	unsigned int		removed:1;	/* host is being removed */
>  #endif
> +#ifdef CONFIG_MMC_UNSAFE_RESUME
> +	unsigned int		suspended:1;
> +#endif
>  
>  	struct mmc_card		*card;		/* device attached to this host */
>  

Shouldn't you also bracket any acces to ->suspended with the ifdefs ?
Compilation failed on my box...and I had to enable MMC_UNSAFE_RESUME.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
