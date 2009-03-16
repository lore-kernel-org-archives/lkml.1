Return-Path: <linux-kernel-owner+w=401wt.eu-S1761066AbZCPWq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761066AbZCPWq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbZCPWqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:46:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:31063 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbZCPWqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:46:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vn2HLzusfz57pxMeTupAo7B0bPrwI3eXuUniJ2ABT7ZBYdoPCph7XnI2O1KA55ti7s
         U6djXiCoxBJ9xm1CWgPDjKdoCF+emrRxrdI2QP+7qHgWlxMTFv3RrJclGpwWHoJRJ5Sy
         fGsn5FNIJTVHg22W011KWvzsJM4ifFqBbeHRE=
MIME-Version: 1.0
In-Reply-To: <49B8AF67.8080309@renesas.com>
References: <49B8AF67.8080309@renesas.com>
Date: Mon, 16 Mar 2009 15:46:45 -0700
X-Google-Sender-Auth: c5d7a78ae0b70ffc
Message-ID: <e9c3a7c20903161546i5de80305r1b0df1605c7718d8@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: sh: Add support DMA-Engine driver for DMA of 
	SuperH
From: Dan Williams <dan.j.williams@intel.com>
To: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Cc: Linux-sh <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 11:44 PM, Nobuhiro Iwamatsu
<iwamatsu.nobuhiro@renesas.com> wrote:
> This supports DMA-Engine driver for DMA of SuperH.
> This supported all DMA channels, and it was tested in SH7722/SH7780.
> This can not use with SH DMA API and can control this in Kconfig.
>
> Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/sh/drivers/dma/Kconfig  |   12 +-
>  arch/sh/drivers/dma/Makefile |    3 +-
>  arch/sh/include/asm/dma-sh.h |   11 +
>  drivers/dma/Kconfig          |    9 +
>  drivers/dma/Makefile         |    2 +
>  drivers/dma/shdma.c          |  743 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/dma/shdma.h          |   65 ++++
>  7 files changed, 840 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/dma/shdma.c
>  create mode 100644 drivers/dma/shdma.h

Hi,

I have not finished a full review but one problem jumps out, the use
of spin_lock_irqsave to protect against channel/descriptor
manipulations.  The highest level of protection that net_dma and
async_tx assume is spin_lock_bh.  It seems like the pieces of
sh_dmae_interrupt() that touch the descriptor can be moved to the
tasklet, then the locks can be downgraded.

Your other patch, to set the alignment in dmatest, makes me wonder if
this engine can handle unaligned accesses?  If it can not then set the
DMA_PRIVATE capability bit at device registration time to prevent
net_dma and other "public" clients from using these channels.  Public
clients assume that there are no alignment constraints.

Thanks,
Dan
