Return-Path: <linux-kernel-owner+w=401wt.eu-S935191AbZKYWQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935191AbZKYWQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbZKYWQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:16:13 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:41653 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935123AbZKYWQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:16:10 -0500
MIME-Version: 1.0
In-Reply-To: <20091125082603.25618.57438.sendpatchset@rxone.opensource.se>
References: <20091125082603.25618.57438.sendpatchset@rxone.opensource.se>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 25 Nov 2009 15:15:54 -0700
X-Google-Sender-Auth: aae9a16b31d9a286
Message-ID: <fa686aa40911251415q624f3610n92cbc20437b12bf6@mail.gmail.com>
Subject: Re: [PATCH] spi: Allow using spi_bitbang_setup() with custom 
	txrx_bufs()
To: Magnus Damm <magnus.damm@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 1:26 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
> From: Magnus Damm <damm@opensource.se>
>
> This patch modifies the shared spi bitbanging code
> to allow using spi_bitbang_setup() even though the
> txrx_word[] callbacks are unset. Useful for drivers
> that want to make use of spi_bitbang_setup() but
> have their own txrx_bufs() callback.
>
> While at it, drop the MSIOF driver workaround.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
>
>  Depends on the MSIOF driver.
>
>  drivers/spi/spi_bitbang.c  |   25 ++++++++++++++-----------
>  drivers/spi/spi_sh_msiof.c |   11 -----------
>  2 files changed, 14 insertions(+), 22 deletions(-)
>
> --- 0001/drivers/spi/spi_bitbang.c
> +++ work/drivers/spi/spi_bitbang.c      2009-11-25 15:30:45.000000000 +0900
> @@ -176,6 +176,14 @@ int spi_bitbang_setup_transfer(struct sp
>  }
>  EXPORT_SYMBOL_GPL(spi_bitbang_setup_transfer);
>
> +static int spi_bitbang_bufs(struct spi_device *spi, struct spi_transfer *t)
> +{
> +       struct spi_bitbang_cs   *cs = spi->controller_state;
> +       unsigned                nsecs = cs->nsecs;
> +
> +       return cs->txrx_bufs(spi, cs->txrx_word, nsecs, t);
> +}
> +
>  /**
>  * spi_bitbang_setup - default setup for per-word I/O loops
>  */
> @@ -183,6 +191,7 @@ int spi_bitbang_setup(struct spi_device
>  {
>        struct spi_bitbang_cs   *cs = spi->controller_state;
>        struct spi_bitbang      *bitbang;
> +       int                     mode_mask = SPI_CPOL | SPI_CPHA;
>        int                     retval;
>        unsigned long           flags;
>
> @@ -196,9 +205,11 @@ int spi_bitbang_setup(struct spi_device
>        }
>
>        /* per-word shift register access, in hardware or bitbanging */
> -       cs->txrx_word = bitbang->txrx_word[spi->mode & (SPI_CPOL|SPI_CPHA)];
> -       if (!cs->txrx_word)
> -               return -EINVAL;
> +       if (bitbang->txrx_bufs == spi_bitbang_bufs) {
> +               cs->txrx_word = bitbang->txrx_word[spi->mode & mode_mask];
> +               if (!cs->txrx_word)
> +                       return -EINVAL;
> +       }

Hmmm... this smells like an ugly hack to me.  It seems to me that if
some bitbang backend drivers don't want this code, then it should be
encoded into a callback so it can be overridden.  Thoughts.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
