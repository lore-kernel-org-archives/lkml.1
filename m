Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbZG3OUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbZG3OUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZG3OUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:20:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:47123 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZG3OUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:20:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wuMZ5Iaia+h6wuTZw95FEX9avsObVBj456cKexQXewjNpp/ERmCVB9KO9/LOYzWLoa
         u2mStkHZn6J+XyDcU7oPwKWMMS7cZ5+ocj/IZ9d+4WpdchPti/fGnAl3E2wiNQX5/gzB
         hXq3kyNsFPgN5knz2tok3bvxzB/FEjc34UdZ8=
MIME-Version: 1.0
In-Reply-To: <1248782203-13095-1-git-send-email-saeed@marvell.com>
References: <1248782203-13095-1-git-send-email-saeed@marvell.com>
Date: Thu, 30 Jul 2009 17:20:53 +0300
Message-ID: <c70ff3ad0907300720m599c184ahcffa7db47573a4bd@mail.gmail.com>
Subject: Re: [PATCH] [MTD] fix the conversion from dev to mtd_info
From: saeed bishara <saeed.bishara@gmail.com>
To: Saeed Bishara <saeed@marvell.com>
Cc: linux-kernel@vger.kernel.org, testers@vger.kernel.org, david-b@pacbell.net,
       David.Woodhouse@intel.com, eric.y.miao@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Tue, Jul 28, 2009 at 2:56 PM, Saeed Bishara<saeed@marvell.com> wrote:
> The patch fixes a bug when converting dev to mtd_info by using the
> drvdata of the dev, the previous code used
> container_of(dev, struct mtd_info, dev), but won't work for the mtdXro
> devices as they created without being contained inside mtd_info structure.
>
> Signed-off-by: Saeed Bishara <saeed@marvell.com>
> ---
>  drivers/mtd/mtdcore.c   |    7 ++++---
>  include/linux/mtd/mtd.h |    2 +-
>  2 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index fac54a3..00ebf7a 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -65,8 +65,8 @@ static void mtd_release(struct device *dev)
>  static int mtd_cls_suspend(struct device *dev, pm_message_t state)
>  {
>        struct mtd_info *mtd = dev_to_mtd(dev);
> -
> -       if (mtd->suspend)
> +
> +       if (mtd && mtd->suspend)
>                return mtd->suspend(mtd);
>        else
>                return 0;
> @@ -76,7 +76,7 @@ static int mtd_cls_resume(struct device *dev)
>  {
>        struct mtd_info *mtd = dev_to_mtd(dev);
>
> -       if (mtd->resume)
> +       if (mtd && mtd->resume)
>                mtd->resume(mtd);
>        return 0;
>  }
> @@ -298,6 +298,7 @@ int add_mtd_device(struct mtd_info *mtd)
>                        mtd->dev.class = &mtd_class;
>                        mtd->dev.devt = MTD_DEVT(i);
>                        dev_set_name(&mtd->dev, "mtd%d", i);
> +                       dev_set_drvdata(&mtd->dev, mtd);
>                        if (device_register(&mtd->dev) != 0) {
>                                mtd_table[i] = NULL;
>                                break;
> diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
> index 5675b63..0f32a9b 100644
> --- a/include/linux/mtd/mtd.h
> +++ b/include/linux/mtd/mtd.h
> @@ -251,7 +251,7 @@ struct mtd_info {
>
>  static inline struct mtd_info *dev_to_mtd(struct device *dev)
>  {
> -       return dev ? container_of(dev, struct mtd_info, dev) : NULL;
> +       return dev ? dev_get_drvdata(dev) : NULL;
>  }
>
>  static inline uint32_t mtd_div_by_eb(uint64_t sz, struct mtd_info *mtd)
> --
> 1.6.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
