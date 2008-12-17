Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759613AbYLQIt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbYLQIt3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbYLQItS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:49:18 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:4101 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYLQItR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:49:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XaqG4sHJ6HvnPpz/UhBd55vbdzRRwJUvzrdnr/IZksmnQ4aMtCNjuQZEAuBQr6IxtS
         N4/n5sl4iHiYASLQzSN6jzQsu9ZGZ2i3khMO4SGtETuA7CKDPAnMtmWwo7z5A+p8xp+t
         WyFfsCf3m+4wLIqWsXD+i7jv9BBVXapEBf8mg=
Message-ID: <f17812d70812170049y5df3ecd9y57122387075b8302@mail.gmail.com>
Date: Wed, 17 Dec 2008 16:49:16 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Mike Rapoport" <mike@compulab.co.il>
Subject: Re: [RFC PATCH 1/2] Add Dialog DA9030 battery charger driver
Cc: LKML <linux-kernel@vger.kernel.org>, sameo@openedhand.com,
        "eric miao" <eric.miao@marvell.com>, cbou@mail.ru,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Jonathan Cameron" <jic23@cam.ac.uk>
In-Reply-To: <4948B099.1080008@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4948B099.1080008@compulab.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 3:56 PM, Mike Rapoport <mike@compulab.co.il> wrote:
> This patch amends DA903x MFD driver with definitions and methods needed for
> battery charger driver.
>

Patch looks generally good, see some of my concerns below:

> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
>
>  drivers/mfd/da903x.c       |   16 +++++++++++++++-
>  include/linux/mfd/da903x.h |   44 ++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 57 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
> index 0b5bd85..2e04b44 100644
> --- a/drivers/mfd/da903x.c
> +++ b/drivers/mfd/da903x.c
> @@ -151,12 +151,24 @@ int da903x_write(struct device *dev, int reg, uint8_t val)
>  }
>  EXPORT_SYMBOL_GPL(da903x_write);
>
> +int da903x_writes(struct device *dev, int reg, int len, uint8_t *val)
> +{
> +       return __da903x_writes(to_i2c_client(dev), reg, len, val);
> +}
> +EXPORT_SYMBOL_GPL(da903x_writes);
> +
>  int da903x_read(struct device *dev, int reg, uint8_t *val)
>  {
>        return __da903x_read(to_i2c_client(dev), reg, val);
>  }
>  EXPORT_SYMBOL_GPL(da903x_read);
>
> +int da903x_reads(struct device *dev, int reg, int len, uint8_t *val)
> +{
> +       return __da903x_reads(to_i2c_client(dev), reg, len, val);
> +}
> +EXPORT_SYMBOL_GPL(da903x_reads);
> +
>  int da903x_set_bits(struct device *dev, int reg, uint8_t bit_mask)
>  {
>        struct da903x_chip *chip = dev_get_drvdata(dev);
> @@ -254,7 +266,7 @@ static int da9030_unmask_events(struct da903x_chip *chip, unsigned int events)
>  {
>        uint8_t v[3];
>
> -       chip->events_mask &= ~events;
> +       chip->events_mask |= events;
>

I wonder if this is true, it may also impact the da9030_mask_events(),
which is a pair.

>        v[0] = (chip->events_mask & 0xff);
>        v[1] = (chip->events_mask >> 8) & 0xff;
> @@ -391,6 +403,8 @@ static void da903x_irq_work(struct work_struct *work)
>                if (chip->ops->read_events(chip, &events))
>                        break;
>
> +/*             pr_info("%s: events=%x events_mask=%x\n", */
> +/*                     __func__, events, chip->events_mask); */

I'd prefer to remove this if it is annoying, sorry for this initial garbage
I sent.

>                events &= ~chip->events_mask;
>                if (events == 0)
>                        break;
