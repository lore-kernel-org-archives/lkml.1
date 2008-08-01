Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbYHANuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbYHANuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbYHANty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:49:54 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:58951 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbYHANtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:49:53 -0400
Date: Fri, 1 Aug 2008 15:49:31 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Gerard Kam <gerardk5@verizon.net>
Cc: David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net,
       Lars Steubesand <lars.steubesand@philips.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_spi: fix hang due to missed interrupt
Message-ID: <20080801154931.120632f1@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <1217524213-4027-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1217524213-4027-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Aug 2008 13:49:32.0220 (UTC) FILETIME=[6D018FC0:01C8F3DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
>  		spi_writel(as, RNCR, 0);
>  		spi_writel(as, TNCR, 0);
> +		ieval = SPI_BIT(RXBUFF) | SPI_BIT(ENDRX) | SPI_BIT(OVRES);

Actually, I think the real bug happens right here: Writing RNCR to 0
will clear any pending ENDRX interrupt, so if the transfer is completed
before this, we won't see any interrupt. These writes are also
completely pointless -- RNCR is zeroed automatically after it gets
shifted into RCR. TNCR works the same way.

The RXBUFF interrupt is only cleared by writing a nonzero RCR or RNCR,
so your patch should fix it. But I'm wondering if there may be another
race left to fix: If we queue two transfers, and both of them complete
before we handle the interrupt, I think we only consider one of them to
be complete. If RXBUFF is set, we should complete any "next" transfer
we have queued up as well.

It could be your patch fixes this last case too -- when this happens,
RXBUFF stays set when we return from the interrupt handler, so the
interrupt gets retriggered immediately. We could handle this more
efficiently, but I think it's handled correctly with your patch applied.

I'll see if I can find a way to clean up the somewhat headache-inducing
control flow in this driver, but until then, your patch should
definitely improve things.

As for the overruns, I'm beginning to suspect that the only way to get
rid of those and still maintain a reasonable transfer rate is to use
bounce buffers in faster RAM (e.g. on-chip SRAM).

Haavard
