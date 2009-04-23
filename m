Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZDWDH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZDWDH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 23:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZDWDHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 23:07:48 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:43534 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbZDWDHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 23:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sHncmOFwGubbK5U12K1+DpjZ6n45qhtNi5BGjhqRg1XlwdSt+vK76RUH1ObICQkOxP
         kBFGE3BbsK5yL8jCAeC3C1UugzR/d8yKvn1DkAitxIkawkNjmguKhVixM/pH0kGT6m4L
         iRSGEzph1XygzGVSATwIOPfpxIIzZJiQL0z1w=
MIME-Version: 1.0
In-Reply-To: <1239903641-14342-1-git-send-email-cliffcai.sh@gmail.com>
References: <1239903641-14342-1-git-send-email-cliffcai.sh@gmail.com>
Date: Wed, 22 Apr 2009 23:07:46 -0400
Message-ID: <8bd0f97a0904222007w3f2493c7v12b60a6558d643a4@mail.gmail.com>
Subject: Re: [PATCH][RESEND][mmc/host]:Blackfin SD Host Controller Driver
From: Mike Frysinger <vapier.adi@gmail.com>
To: cliffcai.sh@gmail.com
Cc: pierre@ossman.eu, linux-kernel@vger.kernel.org, cliff.cai@analog.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 13:40,  <cliffcai.sh@gmail.com> wrote:
> +#define NR_SG  32

seems silly to have a define when it's used only once

> +struct sdh_host {
> +       struct mmc_host         *mmc;
> +       spinlock_t              lock; /* Why I have to give a comment here? */

why ?

> +static void sdh_setup_data(struct sdh_host *host, struct mmc_data *data)
> +{
> +       pr_debug("%s enter flags:0x%x\n", __func__, data->flags);

i wonder why these fixes exist in this patch but not the Blackfin tree
(__FUNCTION__ -> __func__) ...

also, many of these pr_debug()'s should probably be dev_dbg() ...

> +/* RSI DMA doesn't work in array mode */

comment should be indented

> +static int sdh_get_ro(struct mmc_host *mmc)
> +{
> +       /* Host doesn't support read only detection so assume writeable */
> +       return -ENOSYS;
> +}

the common code already checks to see if get_ro is NULL before calling
it, so we dont want this stub

> +       if (ios->bus_width == MMC_BUS_WIDTH_4) {
> +               cfg = bfin_read_SDH_CFG();
> +               cfg &= ~0x80;
> +               cfg |= 0x40;
> +               /* Enable 4 bit SDIO */
> +               cfg |= 0x0c;

shouldnt these magic numbers be defines ?

> +static int __devinit sdh_probe(struct platform_device *pdev)
> +{
> +       struct mmc_host *mmc;
> +       struct sdh_host *host = NULL;

dont think this is actually needed

> +       mmc = mmc_alloc_host(sizeof(struct sdh_host), &pdev->dev);

sizeof(*mmc)

> +       mmc->f_min = get_sclk() >> 9;
> +       mmc->f_max = get_sclk();

store get_sclk() once to avoid calling this function twice
mmc->f_max = get_sclk();
mmc->f_min = mmc->f_max >> 9;

> +       sd_entry = create_proc_entry("driver/sdh", 0600, NULL);
> +       sd_entry->read_proc = NULL;
> +       sd_entry->write_proc = proc_write;
> +       sd_entry->data = host;

and if create_proc_entry() returns NULL ?  like when procfs support is
turned off ?

> +static struct platform_driver sdh_driver = {
> +       .probe          = sdh_probe,
> +       .remove         = sdh_remove,

shouldnt that be __devexit_p(sdh_remove) ?
-mike
