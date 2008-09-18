Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYIRPz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYIRPz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbYIRPzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:55:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:19369 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYIRPzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NoWWcx7kbtRBPuvc6JETgnmAE5Y0hqnSzb+yBsFKc7VGoRGXcklkXBZBhFWIBpptVY
         djpzaOgL7DQv7FUCYfk8oJBcHFE4wL/aQTQhGEQXXee9vibLiSgacvMnCNLQ+wLX4yNI
         cn+mXvNkg27TSLwosRykqzYCGNjMcvG29FdQA=
Message-ID: <5767b9100809180855j58150b4ct4e2a4b9bb5ac7885@mail.gmail.com>
Date: Thu, 18 Sep 2008 23:55:48 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: s3c24xx nand: add command line partition table parsing support (resend)
Cc: Linux-arm-kernel@lists.arm.linux.org.uk, "Ben Dooks" <ben-linux@fluff.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080918112703.GA25491@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5767b9100809171813u7e26d516x12558a178b78f852@mail.gmail.com>
	 <20080918112703.GA25491@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks! I'd re-write and resend the patch

On 9/18/08, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Thu, Sep 18, 2008 at 09:13:01AM +0800, Conke Hu wrote:
> > @@ -875,7 +890,7 @@ static int s3c24xx_nand_probe(struct platform_device *pdev,
> >
> >       /* allocate our information */
> >
> > -       size = nr_sets * sizeof(*info->mtds);
> > +       size = nr_sets * (sizeof(*info->mtds) + S3C_NAND_NAME_LEN);
>
> Why not make the 'name' part of struct s3c2410_nand_mtd?  IOW:
>
>  struct s3c2410_nand_mtd {
>        struct mtd_info                 mtd;
>        struct nand_chip                chip;
>        struct s3c2410_nand_set         *set;
>        struct s3c2410_nand_info        *info;
>        int                             scan_res;
> +       char                            name[S3C_NAND_NAME_LEN];
>  };
>
> That way you can avoid...
>
> >       info->mtds = kmalloc(size, GFP_KERNEL);
> >       if (info->mtds == NULL) {
> >               dev_err(&pdev->dev, "failed to allocate mtd storage\n");
> > @@ -888,10 +903,15 @@ static int s3c24xx_nand_probe(struct
> > platform_device *pdev,
> >       /* initialise all possible chips */
> >
> >       nmtd = info->mtds;
> > +       name = (char *)(info->mtds + nr_sets);
>
> This pointer arithmetic.
>
> >
> >       for (setno = 0; setno < nr_sets; setno++, nmtd++) {
> >               pr_debug("initialising set %d (%p, info %p)\n", setno,
> > nmtd, info);
> >
> > +               sprintf(name, "s3c_nand%d", setno);
> > +               nmtd->mtd.name = name;
> > +               name += S3C_NAND_NAME_LEN;
> > +
>
> And this can become the more safe:
>
>                snprintf(nmtd->name, sizeof(nmtd->name), "s3c_nand%d", setno);
>                nmtd->mtd.name = nmtd->name;
>
> >               s3c2410_nand_init_chip(info, nmtd, sets);
> >
> >               nmtd->scan_res = nand_scan_ident(&nmtd->mtd,
> >
> > -------------------------------------------------------------------
> > List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> > FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> > Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
>
