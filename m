Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbYLZHyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbYLZHyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 02:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYLZHyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 02:54:45 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:33700 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbYLZHyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 02:54:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=njijuxlRDq+5mjDkwNmYiNVXl7P6VUXYZNgmssoWYKbo6c0X/izJkUBSkXsEI4MpXO
         MvwQYWppnXIiSNFxCe9rZvY33qodh8amUTCCyKPnc4wKOg6ZGxIg8x7RRj4OGkkgvM3l
         CtbVuBTDCtFrLnCZOJ5s+Vr2FXynB8xnZz2fI=
Message-ID: <cbe409c50812252354q7738cd36ieff5006e07cdeb9a@mail.gmail.com>
Date: Fri, 26 Dec 2008 15:54:42 +0800
From: "eagle black" <rochacker@gmail.com>
To: carlos.aguiar@indt.org.br, linux-kernel@vger.kernel.org,
       Linux-omap-open-source@linux.omap.com, linux-kernel@zh-kernel.org
Subject: Re: [PATCH] Add MMC password protection (lock/unlock) support for linux-2.6.25 and later kernel versions
Cc: linux@arm.linux.org.uk, "David Brownell" <david-b@pacbell.net>,
       "Tony Lindgren" <tony@atomide.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Lizardo Anderson (EXT-INdT/Manaus)" <anderson.lizardo@indt.org.br>,
       "Anderson Briglia" <anderson.briglia@indt.org.br>
In-Reply-To: <cbe409c50812150414s19dd3fb2v3b2d899a2b85b371@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cbe409c50812150414s19dd3fb2v3b2d899a2b85b371@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 8:14 PM, eagle black <rochacker@gmail.com> wrote:
> HI all:
>     I modify the patch from
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/broken-out/git-mmc.patch.
> For the interface of sysfs was modify since linux-2.6.25,([PATCH] mmc: use
> sysfs groups to handle conditional attributes
> http://linux.derkeiler.com/Mailing−Lists/Kernel/2008−03/msg08390.html )  so
> the that patch can not work on the later kernel.
> So I modify it and now it seems can work for linux-2.6.25 kernel version,
> and I think it can also work for the later versions.
>     I test it on a google phone,  which has an android system, and used the
> keyutils (http://people.redhat.com/dhowells/keyutils/) .
> And it seems work ok. For more about the mmc password protection
> (lock/unlock) we can see
> http://www.gossamer-threads.com/lists/linux/kernel/716331?#716331.
>
> diff -uprN -X linux-2.6.25.orig/Documentation/dontdiff
> linux-2.6.25.orig/drivers/mmc/core/bus.c linux-2.6.25/drivers/mmc/core/bus.c
> --- linux-2.6.25.orig/drivers/mmc/core/bus.c    2008-04-17
> 10:49:44.000000000 +0800
> +++ linux-2.6.25/drivers/mmc/core/bus.c    2008-12-02 20:06:44.000000000
> +0800
> @@ -50,9 +50,21 @@ static struct device_attribute mmc_dev_a
>   * This currently matches any MMC driver to any MMC card - drivers
>   * themselves make the decision whether to drive this card in their
>   * probe method.
> + *
> + * We also fail for all locked cards; drivers expect to be able to do block
> + * I/O still on probe(), which is not possible while the card is locked.
> + * Device probing must be triggered sometime later to make the card
> available
> + * to the block driver.
>   */
>  static int mmc_bus_match(struct device *dev, struct device_driver *drv)
>  {
> +    struct mmc_card *card = dev_to_mmc_card(dev);
> +
> +    if (mmc_card_locked(card)) {
> +        dev_dbg(&card->dev, "card is locked; binding is deferred\n");
> +        return 0;
> +    }
> +
>      return 1;
>  }
>
> diff -uprN -X linux-2.6.25.orig/Documentation/dontdiff
> linux-2.6.25.orig/drivers/mmc/core/core.c
> linux-2.6.25/drivers/mmc/core/core.c
> --- linux-2.6.25.orig/drivers/mmc/core/core.c    2008-04-17
> 10:49:44.000000000 +0800
> +++ linux-2.6.25/drivers/mmc/core/core.c    2008-12-02 20:06:44.000000000
> +0800
> @@ -30,6 +30,7 @@
>  #include "bus.h"
>  #include "host.h"
>  #include "sdio_bus.h"
> +#include "lock.h"
>
>  #include "mmc_ops.h"
>  #include "sd_ops.h"
> @@ -802,8 +803,14 @@ static int __init mmc_init(void)
>      if (ret)
>          goto unregister_host_class;
>
> +    ret = mmc_register_key_type();
> +    if (ret)
> +        goto unregister_sdio;
> +
>      return 0;
>
> +unregister_sdio:
> +    sdio_unregister_bus();
>  unregister_host_class:
>      mmc_unregister_host_class();
>  unregister_bus:
> @@ -816,6 +823,7 @@ destroy_workqueue:
>
>  static void __exit mmc_exit(void)
>  {
> +    mmc_unregister_key_type();
>      sdio_unregister_bus();
>      mmc_unregister_host_class();
>      mmc_unregister_bus();
> diff -uprN -X linux-2.6.25.orig/Documentation/dontdiff
> linux-2.6.25.orig/drivers/mmc/core/Kconfig
> linux-2.6.25/drivers/mmc/core/Kconfig
> --- linux-2.6.25.orig/drivers/mmc/core/Kconfig    2008-04-17
> 10:49:44.000000000 +0800
> +++ linux-2.6.25/drivers/mmc/core/Kconfig    2008-12-02 20:06:44.000000000
> +0800
> @@ -14,3 +14,15 @@ config MMC_UNSAFE_RESUME
>        This option is usually just for embedded systems which use
>        a MMC/SD card for rootfs. Most people should say N here.
>
> +config MMC_PASSWORDS
> +    boolean "MMC card lock/unlock passwords (EXPERIMENTAL)"
> +    depends on EXPERIMENTAL
> +    select KEYS
> +    help
> +      Say Y here to enable the use of passwords to lock and unlock
> +      MMC cards.  This uses the access key retention support, using
> +      request_key to look up the key associated with each card.
> +
> +      For example, if you have an MMC card that was locked using
> +      Symbian OS on your cell phone, you won't be able to read it
> +      on Linux without this support.
> diff -uprN -X linux-2.6.25.orig/Documentation/dontdiff
> linux-2.6.25.orig/drivers/mmc/core/lock.c
> linux-2.6.25/drivers/mmc/core/lock.c
> --- linux-2.6.25.orig/drivers/mmc/core/lock.c    1970-01-01
> 08:00:00.000000000 +0800
> +++ linux-2.6.25/drivers/mmc/core/lock.c    2008-12-09 20:17:07.000000000
> +0800
> @@ -0,0 +1,185 @@
> +/*
> + *  linux/drivers/mmc/core/lock.h
> + *
> + *  Copyright 2006 Instituto Nokia de Tecnologia (INdT), All Rights
> Reserved.
> + *  Copyright 2007 Pierre Ossman
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * MMC password key handling.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/key-type.h>
> +#include <linux/err.h>
> +
> +#include <linux/mmc/card.h>
> +#include <linux/mmc/host.h>
> +#include <linux/mmc/mmc.h>
> +
> +#include "mmc_ops.h"
> +#include "lock.h"
> +
> +#define MMC_KEYLEN_MAXBYTES 32
> +
> +#define dev_to_mmc_card(d)    container_of(d, struct mmc_card, dev)
> +
> +static int mmc_key_instantiate(struct key *key, const void *data, size_t
> datalen)
> +{
> +    struct mmc_key_payload *mpayload;
> +    int ret;
> +
> +    ret = -EINVAL;
> +    if (datalen <= 0 || datalen > MMC_KEYLEN_MAXBYTES || !data) {
> +        pr_debug("Invalid data\n");
> +        goto error;
> +    }
> +
> +    ret = key_payload_reserve(key, datalen);
> +    if (ret < 0) {
> +        pr_debug("ret = %d\n", ret);
> +        goto error;
> +    }
> +
> +    ret = -ENOMEM;
> +    mpayload = kmalloc(sizeof(*mpayload) + datalen, GFP_KERNEL);
> +    if (!mpayload) {
> +        pr_debug("Unable to allocate mpayload structure\n");
> +        goto error;
> +    }
> +    mpayload->datalen = datalen;
> +    memcpy(mpayload->data, data, datalen);
> +
> +    rcu_assign_pointer(key->payload.data, mpayload);
> +
> +    /* ret = 0 if there is no error */
> +    ret = 0;
> +
> +error:
> +    return ret;
> +}
> +
> +static int mmc_key_match(const struct key *key, const void *description)
> +{
> +    return strcmp(key->description, description) == 0;
> +}
> +
> +/*
> + * dispose of the data dangling from the corpse of a mmc key
> + */
> +static void mmc_key_destroy(struct key *key)
> +{
> +    struct mmc_key_payload *mpayload = key->payload.data;
> +
> +    kfree(mpayload);
> +}
> +
> +static struct key_type mmc_key_type = {
> +    .name        = "mmc",
> +    .def_datalen    = MMC_KEYLEN_MAXBYTES,
> +    .instantiate    = mmc_key_instantiate,
> +    .match        = mmc_key_match,
> +    .destroy    = mmc_key_destroy,
> +};
> +
> +int mmc_register_key_type(void)
> +{
> +    return register_key_type(&mmc_key_type);
> +}
> +
> +void mmc_unregister_key_type(void)
> +{
> +    unregister_key_type(&mmc_key_type);
> +}
> +
> +static ssize_t
> +mmc_lockable_show(struct device *dev, struct device_attribute *att, char
> *buf)
> +{
> +    struct mmc_card *card = dev_to_mmc_card(dev);
> +
> +    return sprintf(buf, "%slocked\n", mmc_card_locked(card) ? "" : "un");
> +}
> +
> +/*
> + * implement MMC password functions: force erase, remove password, change
> + * password, unlock card and assign password.
> + */
> +static ssize_t
> +mmc_lockable_store(struct device *dev, struct device_attribute *att,
> +    const char *data, size_t len)
> +{
> +    struct mmc_card *card = dev_to_mmc_card(dev);
> +    int ret;
> +    struct key *mmc_key;
> +
> +    WARN_ON(!(mmc_card_mmc(card) || mmc_card_sd(card)));
> +    WARN_ON(!(card->csd.cmdclass & CCC_LOCK_CARD));
> +
> +    if(!data)
> +        return -EINVAL;
> +    if((card->type != MMC_TYPE_MMC) && (card->type != MMC_TYPE_SD))
> +        return -EINVAL;
> +    if(!(card->csd.cmdclass & CCC_LOCK_CARD))
> +        return -EINVAL;
> +
> +    mmc_claim_host(card->host);
> +
> +    ret = -EINVAL;
> +    if (mmc_card_locked(card) && !strncmp(data, "erase", 5)) {
> +        /* forced erase only works while card is locked */
> +        mmc_lock_unlock(card, NULL, MMC_LOCK_MODE_ERASE);
> +        ret = len;
> +    } else if (!mmc_card_locked(card) && !strncmp(data, "remove", 6)) {
> +        /* remove password only works while card is unlocked */
> +        mmc_key = request_key(&mmc_key_type, "mmc:key", "remove");
> +
> +        if (!IS_ERR(mmc_key)) {
> +            ret =  mmc_lock_unlock(card, mmc_key, MMC_LOCK_MODE_CLR_PWD);
> +            if (!ret)
> +                ret = len;
> +        } else
> +            dev_dbg(&card->dev, "request_key returned error %ld\n",
> PTR_ERR(mmc_key));
> +    } else if (!mmc_card_locked(card) && ((!strncmp(data, "assign", 6)) ||
> +                          (!strncmp(data, "change", 6)))) {
> +        /* assign or change */
> +        if(!(strncmp(data, "assign", 6)))
> +            mmc_key = request_key(&mmc_key_type, "mmc:key", "assign");
> +        else
> +            mmc_key = request_key(&mmc_key_type, "mmc:key", "change");
> +
> +        if (!IS_ERR(mmc_key)) {
> +            ret = mmc_lock_unlock(card, mmc_key, MMC_LOCK_MODE_SET_PWD);
> +            if (!ret)
> +                ret = len;
> +        } else
> +            dev_dbg(&card->dev, "request_key returned error %ld\n",
> PTR_ERR(mmc_key));
> +    } else if (mmc_card_locked(card) && !strncmp(data, "unlock", 6)) {
> +        /* unlock */
> +        mmc_key = request_key(&mmc_key_type, "mmc:key", "unlock");
> +        if (!IS_ERR(mmc_key)) {
> +            ret = mmc_lock_unlock(card, mmc_key, MMC_LOCK_MODE_UNLOCK);
> +            if (ret) {
> +                dev_dbg(&card->dev, "Wrong password\n");
> +                ret = -EINVAL;
> +            }
> +            else {
> +                mmc_release_host(card->host);
> +                device_release_driver(dev);
> +                ret = device_attach(dev);
> +                if(!ret)
> +                    return -EINVAL;
> +                else
> +                    return len;
> +            }
> +        } else
> +            dev_dbg(&card->dev, "request_key returned error %ld\n",
> PTR_ERR(mmc_key));
> +    }
> +
> +    mmc_release_host(card->host);
> +    return ret;
> +}
> +
> +
> +DEVICE_ATTR(lockable, S_IWUSR | S_IRUGO, mmc_lockable_show,
> mmc_lockable_store);
> diff -uprN -X linux-2.6.25.orig/Documentation/dontdiff
> linux-2.6.25.orig/drivers/mmc/core/lock.h
> linux-2.6.25/drivers/mmc/core/lock.h
> --- linux-2.6.25.orig/drivers/mmc/core/lock.h    1970-01-01
> 08:00:00.000000000 +0800
> +++ linux-2.6.25/drivers/mmc/core/lock.h    2008-12-03 15:27:16.000000000
> +0800
> @@ -0,0 +1,40 @@
> +/*
> + *  linux/drivers/mmc/core/lock.h
> + *
> + *  Copyright 2006 Instituto Nokia de Tecnologia (INdT), All Rights
> Reserved.
> + *  Copyright 2007 Pierre Ossman
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef _MMC_CORE_LOCK_H
> +#define _MMC_CORE_LOCK_H
> +
> +#ifdef CONFIG_MMC_PASSWORDS
> +
> +/* core-internal data */
> +struct mmc_key_payload {
> +    struct rcu_head    rcu;        /* RCU destructor */
> +    unsigned short    datalen;    /* length of this data */
> +    char        data[0];    /* actual data */
> +};
> +
> +int mmc_register_key_type(void);
> +void mmc_unregister_key_type(void);
> +extern struct device_attribute dev_attr_lockable ;
> +
> +#else
> +
> +static inline int mmc_register_key_type(void)
> +{
> +    return 0;
> +}
> +
> +static inline void mmc_unregister_key_type(void)
> +{
> +}
> +
> +#endif
> +
> +#endif
> diff -uprN -X linux-2.6.25.orig/Documentation/dontdiff
> linux-2.6.25.orig/drivers/mmc/core/Makefile
> linux-2.6.25/drivers/mmc/core/Makefile
> --- linux-2.6.25.orig/drivers/mmc/core/Makefile    2008-04-17
> 10:49:44.000000000 +0800
> +++ linux-2.6.25/drivers/mmc/core/Makefile    2008-12-02 20:06:44.000000000
> +0800
> @@ -11,4 +11,5 @@ mmc_core-y            := core.o bus.o host.o \
>                     mmc.o mmc_ops.o sd.o sd_ops.o \
>                     sdio.o sdio_ops.o sdio_bus.o \
>                     sdio_cis.o sdio_io.o sdio_irq.o
> +mmc_core-$(CONFIG_MMC_PASSWORDS) += lock.o
>
> diff -uprN -X linux-2.6.25.orig/Documentation/dontdiff
> linux-2.6.25.orig/drivers/mmc/core/mmc.c linux-2.6.25/drivers/mmc/core/mmc.c
> --- linux-2.6.25.orig/drivers/mmc/core/mmc.c    2008-04-17
> 10:49:44.000000000 +0800
> +++ linux-2.6.25/drivers/mmc/core/mmc.c    2008-12-03 14:16:19.000000000
> +0800
> @@ -18,6 +18,7 @@
>
>  #include "core.h"
>  #include "bus.h"
> +#include "lock.h"
>  #include "mmc_ops.h"
>
>  static const unsigned int tran_exp[] = {
> @@ -269,6 +270,9 @@ static struct attribute *mmc_std_attrs[]
>      &dev_attr_name.attr,
>      &dev_attr_oemid.attr,
>      &dev_attr_serial.attr,
> +#ifdef CONFIG_MMC_PASSWORDS
> +    &dev_attr_lockable.attr,
> +#endif
>      NULL,
>  };
>
> @@ -298,6 +302,7 @@ static int mmc_init_card(struct mmc_host
>      int err;
>      u32 cid[4];
>      unsigned int max_dtr;
> +    u32 status;
>
>      BUG_ON(!host);
>      WARN_ON(!host->claimed);
> @@ -367,6 +372,15 @@ static int mmc_init_card(struct mmc_host
>          mmc_set_bus_mode(host, MMC_BUSMODE_PUSHPULL);
>      }
>
> +    /*
> +     * Check if card is locked.
> +     */
> +    err = mmc_send_status(card, &status);
> +    if (err)
> +        goto free_card;
> +    if (status & R1_CARD_IS_LOCKED)
> +        mmc_card_set_locked(card);
> +
>      if (!oldcard) {
>          /*
>           * Fetch CSD from card.
> @@ -509,7 +523,7 @@ static void mmc_suspend(struct mmc_host
>      mmc_claim_host(host);
>      if (!mmc_host_is_spi(host))
>          mmc_deselect_cards(host);
> -    host->card->state &= ~MMC_STATE_HIGHSPEED;
> +    host->card->state &= ~(MMC_STATE_HIGHSPEED | MMC_STATE_LOCKED);
>      mmc_release_host(host);
>  }
>
> diff -uprN -X linux-2.6.25.orig/Documentation/dontdiff
> linux-2.6.25.orig/drivers/mmc/core/mmc_ops.c
> linux-2.6.25/drivers/mmc/core/mmc_ops.c
> --- linux-2.6.25.orig/drivers/mmc/core/mmc_ops.c    2008-04-17
> 10:49:44.000000000 +0800
> +++ linux-2.6.25/drivers/mmc/core/mmc_ops.c    2008-12-02 20:06:44.000000000
> +0800
> @@ -2,6 +2,8 @@
>   *  linux/drivers/mmc/core/mmc_ops.h
>   *
>   *  Copyright 2006-2007 Pierre Ossman
> + *  MMC password protection (C) 2006 Instituto Nokia de Tecnologia (INdT),
> + *     All Rights Reserved.
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -11,12 +13,14 @@
>
>  #include <linux/types.h>
>  #include <linux/scatterlist.h>
> +#include <linux/key.h>
>
>  #include <linux/mmc/host.h>
>  #include <linux/mmc/card.h>
>  #include <linux/mmc/mmc.h>
>
>  #include "core.h"
> +#include "lock.h"
>  #include "mmc_ops.h"
>
>  static int _mmc_select_card(struct mmc_host *host, struct mmc_card *card)
> @@ -395,3 +399,116 @@ int mmc_send_status(struct mmc_card *car
>      return 0;
>  }
>
> +#ifdef CONFIG_MMC_PASSWORDS
> +
> +int mmc_lock_unlock(struct mmc_card *card, struct key *key, int mode)
> +{
> +    struct mmc_request mrq;
> +    struct mmc_command cmd;
> +    struct mmc_data data;
> +    struct scatterlist sg;
> +    struct mmc_key_payload *mpayload;
> +    unsigned long erase_timeout;
> +    int err, data_size;
> +    u8 *data_buf;
> +
> +    mpayload = NULL;
> +    data_size = 1;
> +    if (!(mode & MMC_LOCK_MODE_ERASE)) {
> +        mpayload = rcu_dereference(key->payload.data);
> +        data_size = 2 + mpayload->datalen;
> +    }
> +
> +    data_buf = kzalloc(data_size, GFP_KERNEL);
> +    if (!data_buf)
> +        return -ENOMEM;
> +
> +    data_buf[0] |= mode;
> +    if (mode & MMC_LOCK_MODE_UNLOCK)
> +        data_buf[0] &= ~MMC_LOCK_MODE_UNLOCK;
> +
> +    if (!(mode & MMC_LOCK_MODE_ERASE)) {
> +        data_buf[1] = mpayload->datalen;
> +        memcpy(data_buf + 2, mpayload->data, mpayload->datalen);
> +    }
> +
> +    memset(&cmd, 0, sizeof(struct mmc_command));
> +
> +    cmd.opcode = MMC_SET_BLOCKLEN;
> +    cmd.arg = data_size;
> +    cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
> +    err = mmc_wait_for_cmd(card->host, &cmd, MMC_CMD_RETRIES);
> +    if (err)
> +        goto out;
> +
> +    memset(&cmd, 0, sizeof(struct mmc_command));
> +
> +    cmd.opcode = MMC_LOCK_UNLOCK;
> +    cmd.arg = 0;
> +    cmd.flags = MMC_RSP_R1B | MMC_CMD_ADTC;
> +
> +    memset(&data, 0, sizeof(struct mmc_data));
> +
> +    data.blksz = data_size;
> +    data.blocks = 1;
> +    data.flags = MMC_DATA_WRITE;
> +    data.sg = &sg;
> +    data.sg_len = 1;
> +
> +    mmc_set_data_timeout(&data, card);
> +
> +    memset(&mrq, 0, sizeof(struct mmc_request));
> +
> +    mrq.cmd = &cmd;
> +    mrq.data = &data;
> +
> +    sg_init_one(&sg, data_buf, data_size);
> +    mmc_wait_for_req(card->host, &mrq);
> +    err = cmd.error;
> +    if (err)
> +        goto out;
> +    err = data.error;
> +    if (err)
> +        goto out;
> +
> +    memset(&cmd, 0, sizeof(struct mmc_command));
> +
> +    cmd.opcode = MMC_SEND_STATUS;
> +    cmd.arg = card->rca << 16;
> +    cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
> +
> +    /* set timeout for forced erase operation to 3 min. (see MMC spec) */
> +    erase_timeout = jiffies + 180 * HZ;
> +    do {
> +        /* we cannot use "retries" here because the
> +         * R1_LOCK_UNLOCK_FAILED bit is cleared by subsequent reads to
> +         * the status register, hiding the error condition */
> +        err = mmc_wait_for_cmd(card->host, &cmd, 0);
> +        if (err)
> +            break;
> +        /* the other modes don't need timeout checking */
> +        if (!(mode & MMC_LOCK_MODE_ERASE))
> +            continue;
> +        if (time_after(jiffies, erase_timeout)) {
> +            dev_dbg(&card->dev, "forced erase timed out\n");
> +            err = -ETIMEDOUT;
> +            break;
> +        }
> +    } while (!(cmd.resp[0] & R1_READY_FOR_DATA));
> +    if (cmd.resp[0] & R1_LOCK_UNLOCK_FAILED) {
> +        dev_dbg(&card->dev, "LOCK_UNLOCK operation failed\n");
> +        err = -EIO;
> +    }
> +
> +    if (cmd.resp[0] & R1_CARD_IS_LOCKED)
> +        mmc_card_set_locked(card);
> +    else
> +        card->state &= ~MMC_STATE_LOCKED;
> +
> +out:
> +    kfree(data_buf);
> +
> +    return err;
> +}
> +
> +#endif /* CONFIG_MMC_PASSWORDS */
> diff -uprN -X linux-2.6.25.orig/Documentation/dontdiff
> linux-2.6.25.orig/drivers/mmc/core/mmc_ops.h
> linux-2.6.25/drivers/mmc/core/mmc_ops.h
> --- linux-2.6.25.orig/drivers/mmc/core/mmc_ops.h    2008-04-17
> 10:49:44.000000000 +0800
> +++ linux-2.6.25/drivers/mmc/core/mmc_ops.h    2008-12-02 20:06:44.000000000
> +0800
> @@ -12,6 +12,8 @@
>  #ifndef _MMC_MMC_OPS_H
>  #define _MMC_MMC_OPS_H
>
> +struct key;
> +
>  int mmc_select_card(struct mmc_card *card);
>  int mmc_deselect_cards(struct mmc_host *host);
>  int mmc_go_idle(struct mmc_host *host);
> @@ -25,6 +27,7 @@ int mmc_send_status(struct mmc_card *car
>  int mmc_send_cid(struct mmc_host *host, u32 *cid);
>  int mmc_spi_read_ocr(struct mmc_host *host, int highcap, u32 *ocrp);
>  int mmc_spi_set_crc(struct mmc_host *host, int use_crc);
> +int mmc_lock_unlock(struct mmc_card *card, struct key *key, int mode);
>
>  #endif
>
> diff -uprN -X linux-2.6.25.orig/Documentation/dontdiff
> linux-2.6.25.orig/drivers/mmc/core/sd.c linux-2.6.25/drivers/mmc/core/sd.c
> --- linux-2.6.25.orig/drivers/mmc/core/sd.c    2008-04-17 10:49:44.000000000
> +0800
> +++ linux-2.6.25/drivers/mmc/core/sd.c    2008-12-09 19:47:46.000000000
> +0800
> @@ -19,6 +19,7 @@
>
>  #include "core.h"
>  #include "bus.h"
> +#include "lock.h"
>  #include "mmc_ops.h"
>  #include "sd_ops.h"
>
> @@ -296,6 +297,7 @@ MMC_DEV_ATTR(oemid, "0x%04x\n", card->ci
>  MMC_DEV_ATTR(serial, "0x%08x\n", card->cid.serial);
>
>
> +
>  static struct attribute *sd_std_attrs[] = {
>      &dev_attr_cid.attr,
>      &dev_attr_csd.attr,
> @@ -307,6 +309,9 @@ static struct attribute *sd_std_attrs[]
>      &dev_attr_name.attr,
>      &dev_attr_oemid.attr,
>      &dev_attr_serial.attr,
> +#ifdef CONFIG_MMC_PASSWORDS
> +    &dev_attr_lockable.attr,
> +#endif
>      NULL,
>  };
>
> @@ -336,6 +341,7 @@ static int mmc_sd_init_card(struct mmc_h
>      int err;
>      u32 cid[4];
>      unsigned int max_dtr;
> +    u32 status;
>
>      BUG_ON(!host);
>      WARN_ON(!host->claimed);
> @@ -413,6 +419,15 @@ static int mmc_sd_init_card(struct mmc_h
>          mmc_set_bus_mode(host, MMC_BUSMODE_PUSHPULL);
>      }
>
> +    /*
> +     * Check if card is locked.
> +     */
> +    err = mmc_send_status(card, &status);
> +    if (err)
> +        goto free_card;
> +    if (status & R1_CARD_IS_LOCKED)
> +        mmc_card_set_locked(card);
> +
>      if (!oldcard) {
>          /*
>           * Fetch CSD from card.
> @@ -438,16 +453,20 @@ static int mmc_sd_init_card(struct mmc_h
>      }
>
>      if (!oldcard) {
> -        /*
> -         * Fetch SCR from card.
> -         */
> -        err = mmc_app_send_scr(card, card->raw_scr);
> -        if (err)
> -            goto free_card;
> -
> -        err = mmc_decode_scr(card);
> -        if (err < 0)
> -            goto free_card;
> +
> +        if (!mmc_card_locked(card)) {
> +
> +            /*
> +             * Fetch SCR from card. But if the card is locked,
> +             * this command will fail, then the card will be freed.
> +             * So we won't send the scr command while card is locked.
> +             */
> +            err = mmc_app_send_scr(card, card->raw_scr);
> +            if (err)
> +                goto free_card;
> +
> +            err = mmc_decode_scr(card);
> +            if (err < 0)
> +                goto free_card;
> +        }
>
>          /*
>           * Fetch switch information from card.
> @@ -571,7 +590,7 @@ static void mmc_sd_suspend(struct mmc_ho
>      mmc_claim_host(host);
>      if (!mmc_host_is_spi(host))
>          mmc_deselect_cards(host);
> -    host->card->state &= ~MMC_STATE_HIGHSPEED;
> +    host->card->state &= ~(MMC_STATE_HIGHSPEED | MMC_STATE_LOCKED);
>      mmc_release_host(host);
>  }
>
> diff -uprN -X linux-2.6.25.orig/Documentation/dontdiff
> linux-2.6.25.orig/include/linux/mmc/card.h
> linux-2.6.25/include/linux/mmc/card.h
> --- linux-2.6.25.orig/include/linux/mmc/card.h    2008-04-17
> 10:49:44.000000000 +0800
> +++ linux-2.6.25/include/linux/mmc/card.h    2008-12-02 20:06:44.000000000
> +0800
> @@ -94,6 +94,7 @@ struct mmc_card {
>  #define MMC_STATE_READONLY    (1<<1)        /* card is read-only */
>  #define MMC_STATE_HIGHSPEED    (1<<2)        /* card is in high speed mode
> */
>  #define MMC_STATE_BLOCKADDR    (1<<3)        /* card uses block-addressing
> */
> +#define MMC_STATE_LOCKED    (1<<4)        /* card is currently locked */
>
>      u32            raw_cid[4];    /* raw card CID */
>      u32            raw_csd[4];    /* raw card CSD */
> @@ -121,11 +122,13 @@ struct mmc_card {
>  #define mmc_card_readonly(c)    ((c)->state & MMC_STATE_READONLY)
>  #define mmc_card_highspeed(c)    ((c)->state & MMC_STATE_HIGHSPEED)
>  #define mmc_card_blockaddr(c)    ((c)->state & MMC_STATE_BLOCKADDR)
> +#define mmc_card_locked(c)    ((c)->state & MMC_STATE_LOCKED)
>
>  #define mmc_card_set_present(c)    ((c)->state |= MMC_STATE_PRESENT)
>  #define mmc_card_set_readonly(c) ((c)->state |= MMC_STATE_READONLY)
>  #define mmc_card_set_highspeed(c) ((c)->state |= MMC_STATE_HIGHSPEED)
>  #define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)
> +#define mmc_card_set_locked(c)    ((c)->state |= MMC_STATE_LOCKED)
>
>  #define mmc_card_name(c)    ((c)->cid.prod_name)
>  #define mmc_card_id(c)        ((c)->dev.bus_id)
> diff -uprN -X linux-2.6.25.orig/Documentation/dontdiff
> linux-2.6.25.orig/include/linux/mmc/mmc.h
> linux-2.6.25/include/linux/mmc/mmc.h
> --- linux-2.6.25.orig/include/linux/mmc/mmc.h    2008-04-17
> 10:49:44.000000000 +0800
> +++ linux-2.6.25/include/linux/mmc/mmc.h    2008-12-02 20:06:44.000000000
> +0800
> @@ -280,5 +280,13 @@ struct _mmc_csd {
>  #define MMC_SWITCH_MODE_CLEAR_BITS    0x02    /* Clear bits which are 1 in
> value */
>  #define MMC_SWITCH_MODE_WRITE_BYTE    0x03    /* Set target to value */
>
> +/*
> + * MMC_LOCK_UNLOCK modes
> + */
> +#define MMC_LOCK_MODE_ERASE    (1<<3)
> +#define MMC_LOCK_MODE_UNLOCK    (1<<2)
> +#define MMC_LOCK_MODE_CLR_PWD    (1<<1)
> +#define MMC_LOCK_MODE_SET_PWD    (1<<0)
> +
>  #endif  /* MMC_MMC_PROTOCOL_H */
>
> Comments and suggestions are always welcome.
>
>
