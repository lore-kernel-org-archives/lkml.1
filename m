Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZB1JJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZB1JJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZB1JJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:09:21 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:44929 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbZB1JJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:09:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=WvEeqkWxbjMsMIZULf4By/aFOyF8aMYH61/ohn+L2LuV07cZrDKhy/DnjkO3Z3p21A
         SqU5A56DZIOnk4G8bJRAvy11mpTiAZB5Wz8rgTS6/hFoL8c1m3zO2KQq2Ek4o26TWl0p
         +lTbesQTkGHBP0I5qO7acHJJE74g4qhvrHx7E=
Date: Sat, 28 Feb 2009 10:09:14 +0100
From: Simon Kagstrom <simon.kagstrom@gmail.com>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andy Green <andy@openmoko.com>, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 2/2] spi_bitbang: Add support for non-blocking
 synchronous transfers
Message-ID: <20090228100914.2ec2ff7f@lska2>
In-Reply-To: <20090228081117.31964.51155.stgit@fedora.yogi>
References: <20090228081036.31964.80618.stgit@fedora.yogi>
	<20090228081117.31964.51155.stgit@fedora.yogi>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for taking this up Balaji!

In the comment below I'm assuming the Openmoko accelerometer use of
this functionality, which would include doing SPI transfers in the
interrupt handler.

On Sat, 28 Feb 2009 13:41:17 +0530
Balaji Rao <balajirrao@openmoko.org> wrote:

> +/* Synchronous non blocking transfer */
> +int
> +spi_bitbang_transfer_sync(struct spi_device *spi, struct spi_message
> *m) +{
> [...]
> +		if (setup_transfer) {
> +			status = setup_transfer(spi, t);
> [...]
> +			if (!m->is_dma_mapped)
> +				t->rx_dma = t->tx_dma = 0;
> +			status = bitbang->txrx_bufs(spi, t);

Another thing that we'd need to take care of is that the stuff being
called from the synhronous transfer is actually callable from interrupt
context. Looking at txrx_bufs for s3c24xx (s3c24xx_spi_txrx), it's
using a wait_for_completion which is in turn completed by the s3c24xx
SPI interrupt handler.

Without trying, I'm guessing that that won't be possible from interrupt
context.

// Simon
