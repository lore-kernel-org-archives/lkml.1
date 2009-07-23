Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZGWUhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZGWUhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 16:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbZGWUhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 16:37:18 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33333 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbZGWUhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 16:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dpQESugfyKKC9IfUdF0MvzPw9Q9uDM6JS09dNgCoH49X30HgxXu0BiXjkd9YILH1YD
         lIYhiTtxm/EJZ21H8TmhhRtYEJnDGtVit0dRo7Eh3Yg1qkITzVzTT/hg3IaY/taAwNEj
         pwgjsH1o3lxLicuTA49cZm6ccAtTF5fjSTqTs=
MIME-Version: 1.0
In-Reply-To: <20090710124011.1262.73298.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
	 <20090710124011.1262.73298.sendpatchset@ahunter-tower>
Date: Thu, 23 Jul 2009 22:37:14 +0200
Message-ID: <63386a3d0907231337s28050ad6o119f3f33df5ee642@mail.gmail.com>
Subject: Re: [PATCH 1/32] mmc: add 'enable' and 'disable' methods to mmc host
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

And please drop my other patch in favor of this one then.

Linus Walleij

2009/7/10 Adrian Hunter <adrian.hunter@nokia.com>:
> From a0164897276e4d1f972fd90b1e9499e1ab8d221e Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Wed, 22 Apr 2009 12:50:45 +0300
> Subject: [PATCH] mmc: add 'enable' and 'disable' methods to mmc host
>
> MMC hosts that support power saving can use the 'enable' and
> 'disable' methods to exit and enter power saving states.
> An explanation of their use is provided in the comments
> added to include/linux/mmc/host.h.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
> ---
>  drivers/mmc/core/core.c  |  174 ++++++++++++++++++++++++++++++++++++++++++++--
>  drivers/mmc/core/host.c  |    1 +
>  drivers/mmc/core/host.h  |    2 +
>  include/linux/mmc/host.h |   47 ++++++++++++
>  4 files changed, 218 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index d84c880..41fd127 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -344,6 +344,98 @@ unsigned int mmc_align_data_size(struct mmc_card *card, unsigned int sz)
>  EXPORT_SYMBOL(mmc_align_data_size);
>
>  /**
> + *     mmc_host_enable - enable a host.
> + *     @host: mmc host to enable
> + *
> + *     Hosts that support power saving can use the 'enable' and 'disable'
> + *     methods to exit and enter power saving states. For more information
> + *     see comments for struct mmc_host_ops.
> + */
> +int mmc_host_enable(struct mmc_host *host)
> +{
> +       if (!(host->caps & MMC_CAP_DISABLE))
> +               return 0;
> +
> +       if (host->en_dis_recurs)
> +               return 0;
> +
> +       if (host->nesting_cnt++)
> +               return 0;
> +
> +       cancel_delayed_work_sync(&host->disable);
> +
> +       if (host->enabled)
> +               return 0;
> +
> +       if (host->ops->enable) {
> +               int err;
> +
> +               host->en_dis_recurs = 1;
> +               err = host->ops->enable(host);
> +               host->en_dis_recurs = 0;
> +
> +               if (err) {
> +                       pr_debug("%s: enable error %d\n",
> +                                mmc_hostname(host), err);
> +                       return err;
> +               }
> +       }
> +       host->enabled = 1;
> +       return 0;
> +}
> +EXPORT_SYMBOL(mmc_host_enable);
> +
> +static int mmc_host_do_disable(struct mmc_host *host, int lazy)
> +{
> +       if (host->ops->disable) {
> +               int err;
> +
> +               host->en_dis_recurs = 1;
> +               err = host->ops->disable(host, lazy);
> +               host->en_dis_recurs = 0;
> +
> +               if (err < 0) {
> +                       pr_debug("%s: disable error %d\n",
> +                                mmc_hostname(host), err);
> +                       return err;
> +               }
> +               if (err > 0)
> +                       mmc_schedule_delayed_work(&host->disable, err);
> +       }
> +       host->enabled = 0;
> +       return 0;
> +}
> +
> +/**
> + *     mmc_host_disable - disable a host.
> + *     @host: mmc host to disable
> + *
> + *     Hosts that support power saving can use the 'enable' and 'disable'
> + *     methods to exit and enter power saving states. For more information
> + *     see comments for struct mmc_host_ops.
> + */
> +int mmc_host_disable(struct mmc_host *host)
> +{
> +       int err;
> +
> +       if (!(host->caps & MMC_CAP_DISABLE))
> +               return 0;
> +
> +       if (host->en_dis_recurs)
> +               return 0;
> +
> +       if (--host->nesting_cnt)
> +               return 0;
> +
> +       if (!host->enabled)
> +               return 0;
> +
> +       err = mmc_host_do_disable(host, 0);
> +       return err;
> +}
> +EXPORT_SYMBOL(mmc_host_disable);
> +
> +/**
>  *     __mmc_claim_host - exclusively claim a host
>  *     @host: mmc host to claim
>  *     @abort: whether or not the operation should be aborted
> @@ -379,11 +471,81 @@ int __mmc_claim_host(struct mmc_host *host, atomic_t *abort)
>                wake_up(&host->wq);
>        spin_unlock_irqrestore(&host->lock, flags);
>        remove_wait_queue(&host->wq, &wait);
> +       if (!stop)
> +               mmc_host_enable(host);
>        return stop;
>  }
>
>  EXPORT_SYMBOL(__mmc_claim_host);
>
> +static int mmc_try_claim_host(struct mmc_host *host)
> +{
> +       int claimed_host = 0;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&host->lock, flags);
> +       if (!host->claimed) {
> +               host->claimed = 1;
> +               claimed_host = 1;
> +       }
> +       spin_unlock_irqrestore(&host->lock, flags);
> +       return claimed_host;
> +}
> +
> +static void mmc_do_release_host(struct mmc_host *host)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&host->lock, flags);
> +       host->claimed = 0;
> +       spin_unlock_irqrestore(&host->lock, flags);
> +
> +       wake_up(&host->wq);
> +}
> +
> +void mmc_host_deeper_disable(struct work_struct *work)
> +{
> +       struct mmc_host *host =
> +               container_of(work, struct mmc_host, disable.work);
> +
> +       /* If the host is claimed then we do not want to disable it anymore */
> +       if (!mmc_try_claim_host(host))
> +               return;
> +       mmc_host_do_disable(host, 1);
> +       mmc_do_release_host(host);
> +}
> +
> +/**
> + *     mmc_host_lazy_disable - lazily disable a host.
> + *     @host: mmc host to disable
> + *
> + *     Hosts that support power saving can use the 'enable' and 'disable'
> + *     methods to exit and enter power saving states. For more information
> + *     see comments for struct mmc_host_ops.
> + */
> +int mmc_host_lazy_disable(struct mmc_host *host)
> +{
> +       if (!(host->caps & MMC_CAP_DISABLE))
> +               return 0;
> +
> +       if (host->en_dis_recurs)
> +               return 0;
> +
> +       if (--host->nesting_cnt)
> +               return 0;
> +
> +       if (!host->enabled)
> +               return 0;
> +
> +       if (host->disable_delay) {
> +               mmc_schedule_delayed_work(&host->disable,
> +                               msecs_to_jiffies(host->disable_delay));
> +               return 0;
> +       } else
> +               return mmc_host_do_disable(host, 1);
> +}
> +EXPORT_SYMBOL(mmc_host_lazy_disable);
> +
>  /**
>  *     mmc_release_host - release a host
>  *     @host: mmc host to release
> @@ -393,15 +555,11 @@ EXPORT_SYMBOL(__mmc_claim_host);
>  */
>  void mmc_release_host(struct mmc_host *host)
>  {
> -       unsigned long flags;
> -
>        WARN_ON(!host->claimed);
>
> -       spin_lock_irqsave(&host->lock, flags);
> -       host->claimed = 0;
> -       spin_unlock_irqrestore(&host->lock, flags);
> +       mmc_host_lazy_disable(host);
>
> -       wake_up(&host->wq);
> +       mmc_do_release_host(host);
>  }
>
>  EXPORT_SYMBOL(mmc_release_host);
> @@ -947,6 +1105,8 @@ void mmc_stop_host(struct mmc_host *host)
>        spin_unlock_irqrestore(&host->lock, flags);
>  #endif
>
> +       if (host->caps & MMC_CAP_DISABLE)
> +               cancel_delayed_work(&host->disable);
>        cancel_delayed_work(&host->detect);
>        mmc_flush_scheduled_work();
>
> @@ -975,6 +1135,8 @@ void mmc_stop_host(struct mmc_host *host)
>  */
>  int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
>  {
> +       if (host->caps & MMC_CAP_DISABLE)
> +               cancel_delayed_work(&host->disable);
>        cancel_delayed_work(&host->detect);
>        mmc_flush_scheduled_work();
>
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 5e945e6..a268d12 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -83,6 +83,7 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
>        spin_lock_init(&host->lock);
>        init_waitqueue_head(&host->wq);
>        INIT_DELAYED_WORK(&host->detect, mmc_rescan);
> +       INIT_DELAYED_WORK_DEFERRABLE(&host->disable, mmc_host_deeper_disable);
>
>        /*
>         * By default, hosts do not support SGIO or large requests.
> diff --git a/drivers/mmc/core/host.h b/drivers/mmc/core/host.h
> index c2dc3d2..8c87e11 100644
> --- a/drivers/mmc/core/host.h
> +++ b/drivers/mmc/core/host.h
> @@ -14,5 +14,7 @@
>  int mmc_register_host_class(void);
>  void mmc_unregister_host_class(void);
>
> +void mmc_host_deeper_disable(struct work_struct *work);
> +
>  #endif
>
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 3e7615e..583c068 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -51,6 +51,35 @@ struct mmc_ios {
>  };
>
>  struct mmc_host_ops {
> +       /*
> +        * Hosts that support power saving can use the 'enable' and 'disable'
> +        * methods to exit and enter power saving states. 'enable' is called
> +        * when the host is claimed and 'disable' is called (or scheduled with
> +        * a delay) when the host is released. The 'disable' is scheduled if
> +        * the disable delay set by 'mmc_set_disable_delay()' is non-zero,
> +        * otherwise 'disable' is called immediately. 'disable' may be
> +        * scheduled repeatedly, to permit ever greater power saving at the
> +        * expense of ever greater latency to re-enable. Rescheduling is
> +        * determined by the return value of the 'disable' method. A positive
> +        * value gives the delay in jiffies.
> +        *
> +        * In the case where a host function (like set_ios) may be called
> +        * with or without the host claimed, enabling and disabling can be
> +        * done directly and will nest correctly. Call 'mmc_host_enable()' and
> +        * 'mmc_host_lazy_disable()' for this purpose, but note that these
> +        * functions must be paired.
> +        *
> +        * Alternatively, 'mmc_host_enable()' may be paired with
> +        * 'mmc_host_disable()' which calls 'disable' immediately.  In this
> +        * case the 'disable' method will be called with 'lazy' set to 0.
> +        * This is mainly useful for error paths.
> +        *
> +        * Because lazy disble may be called from a work queue, the 'disable'
> +        * method must claim the host when 'lazy' != 0, which will work
> +        * correctly because recursion is detected and handled.
> +        */
> +       int (*enable)(struct mmc_host *host);
> +       int (*disable)(struct mmc_host *host, int lazy);
>        void    (*request)(struct mmc_host *host, struct mmc_request *req);
>        /*
>         * Avoid calling these three functions too often or in a "fast path",
> @@ -118,6 +147,7 @@ struct mmc_host {
>  #define MMC_CAP_SPI            (1 << 4)        /* Talks only SPI protocols */
>  #define MMC_CAP_NEEDS_POLL     (1 << 5)        /* Needs polling for card-detection */
>  #define MMC_CAP_8_BIT_DATA     (1 << 6)        /* Can the host do 8 bit transfers */
> +#define MMC_CAP_DISABLE                (1 << 7)        /* Can the host be disabled */
>
>        /* host specific block data */
>        unsigned int            max_seg_size;   /* see blk_queue_max_segment_size */
> @@ -142,6 +172,13 @@ struct mmc_host {
>        unsigned int            removed:1;      /* host is being removed */
>  #endif
>
> +       /* Only used with MMC_CAP_DISABLE */
> +       int                     enabled;        /* host is enabled */
> +       int                     nesting_cnt;    /* "enable" nesting count */
> +       int                     en_dis_recurs;  /* detect recursion */
> +       unsigned int            disable_delay;  /* disable delay in msecs */
> +       struct delayed_work     disable;        /* disabling work */
> +
>        struct mmc_card         *card;          /* device attached to this host */
>
>        wait_queue_head_t       wq;
> @@ -197,5 +234,15 @@ struct regulator;
>  int mmc_regulator_get_ocrmask(struct regulator *supply);
>  int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit);
>
> +int mmc_host_enable(struct mmc_host *host);
> +int mmc_host_disable(struct mmc_host *host);
> +int mmc_host_lazy_disable(struct mmc_host *host);
> +
> +static inline void mmc_set_disable_delay(struct mmc_host *host,
> +                                        unsigned int disable_delay)
> +{
> +       host->disable_delay = disable_delay;
> +}
> +
>  #endif
>
> --
> 1.5.6.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
