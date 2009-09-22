Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbZIVOPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbZIVOPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZIVOPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:15:54 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:53981 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbZIVOPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZrpPbPP9C2E97m+MQCrvhOJ46RTOoEkWO1YErj0Kp/yB9fYQVxjNhIqyTm9P/AuqXx
         DXUfHC903Xntd4ELzknIXHkJdGwcvKG7u4893xtVls9XpTbB9JXSWSsYuz5pKPsku6WC
         LBYISJKyxy0f152ysN7MijI7xZ7Ym3BmDWKdA=
MIME-Version: 1.0
In-Reply-To: <1253224997-7422-1-git-send-email-vapier@gentoo.org>
References: <1253224997-7422-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 22 Sep 2009 10:15:37 -0400
Message-ID: <8bd0f97a0909220715y48fb95bclda87370eca67dfd9@mail.gmail.com>
Subject: Re: [PATCH 1/2] spi: new SPI bus lock/unlock functions
To: Yi Li <yi.li@analog.com>
Cc: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 18:03, Mike Frysinger wrote:
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -653,6 +653,54 @@ static void spi_complete(void *arg)
> +int spi_lock_bus(struct spi_device *spi)
> +{
> +       if (spi->master->lock_bus)
> +               return spi->master->lock_bus(spi);
> +       else
> +               return 0;
> +}
> +EXPORT_SYMBOL_GPL(spi_lock_bus);
> +
> +int spi_unlock_bus(struct spi_device *spi)
> +{
> +       if (spi->master->unlock_bus)
> +               return spi->master->unlock_bus(spi);
> +       else
> +               return 0;
> +}
> +EXPORT_SYMBOL_GPL(spi_unlock_bus);

there's nothing Blackfin-specific in the implementation of these
functions.  i think the way we should be handling these is by doing:
 - remove {lock,unlock}_bus functions from spi_master
 - move the {lock,unlock}_bus code from spi_bfin5xx.c to spi.c
 - drop the SPI_BFIN_LOCK Kconfig
 - add a new spi_master flag to spi.h like SPI_MASTER_HALF_DUPLEX --
SPI_MASTER_LOCK_BUS
 - have spi_bfin5xx.c/bfin_sport_spi.c add that flag to its master setup
 - have the common spi code key off of that flag to return ENOSYS
 - have the mmc_spi code check that bit in the master before falling
back to its hack
-mike
