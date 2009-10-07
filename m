Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbZJGSpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbZJGSpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZJGSpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:45:42 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:61317 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbZJGSpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BPR/Ro2gKYvSAQYCRNl4QdFeyKnUuf+1sYgRevzOHy+ZDvqfMgt6WdKePjroy/0kyE
         74mQPYgFaEJy+DGPdfYcCxDRf3QAjKGo5E0rGTXmJRYDSXGi+JpMjAWMDHmCDnZ983ne
         69v2Rsigh3X1dzC4auBtjNnNhgNc4fqY3lK+8=
MIME-Version: 1.0
In-Reply-To: <200910071847.38163.strakh@ispras.ru>
References: <200910071847.38163.strakh@ispras.ru>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 7 Oct 2009 14:44:45 -0400
Message-ID: <8bd0f97a0910071144k1d0bf30bv60656181edae8af7@mail.gmail.com>
Subject: Re: [BUG] znet.c sleeping function called from invalid context
To: Michael Hennerich <michael.hennerich@analog.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>,
       Alexander Strakh <strakh@ispras.ru>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 14:47, Alexander Strakh wrote:
>        KERNEL_VERSION: 2.6.31
>        DESCRIBE:
> Driver drivers/net/znet.c might sleep in atomic context, because it calls
> free_dma under claim_dma_lock:
>
> .drivers/net/znet.c:
>  168 static int znet_request_resources (struct net_device *dev)
> ...
>  189        flags = claim_dma_lock();
>  190        free_dma (znet->tx_dma);
>  191        release_dma_lock (flags);
> ...
>
> Path to might_sleep macro from znet_request_resources:
> 1. znet_request_resources calls free_dma at
> arch/blackfin/kernel/bfin_dma_5xx.c:181
> 2. free_dma calls arch/blackfin/kernel/bfin_dma_5xx.c:195

i dont think we need the dmalock mutex.  it's only used to protect
read/writes to .chan_status, and that should be atomic already.
-mike
