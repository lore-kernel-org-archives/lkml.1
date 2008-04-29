Return-Path: <linux-kernel-owner+w=401wt.eu-S1765151AbYD2PCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765151AbYD2PCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbYD2PCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:02:13 -0400
Received: from h155.mvista.com ([63.81.120.155]:20985 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754708AbYD2PCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:02:12 -0400
Message-ID: <4817384C.8020905@ru.mvista.com>
Date: Tue, 29 Apr 2008 19:01:32 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: benh@kernel.crashing.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       list linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ide: fix crash at boot with siimage driver
References: <1209444576.18023.128.camel@pasglop>
In-Reply-To: <1209444576.18023.128.camel@pasglop>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Benjamin Herrenschmidt wrote:

> Some change to the IDE layer are causing the siimage driver to crash
> at boot with a NULL dereference. This is due to the sil_dma_ops not
> containing all the necessary pointers. I suppose it used to just
> "override" the defaults while now, it needs to contain everything.

    Both the patch introducing 'struct ide_dma_ops' into drivers and making 
them 'const' were in the same batch. However, the latter patch (now commit 
f37afdaca711838b50ecd89b9c15fc745270d77c) erroneously missed siimage.c -- 
which I didn't notice when reviewing, sigh...

> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---

> Index: linux-work/drivers/ide/pci/siimage.c
> ===================================================================
> --- linux-work.orig/drivers/ide/pci/siimage.c	2008-04-29 14:44:37.000000000 +1000
> +++ linux-work/drivers/ide/pci/siimage.c	2008-04-29 14:44:44.000000000 +1000
> @@ -780,7 +780,14 @@ static const struct ide_port_ops sil_sat
>  };
>  
>  static struct ide_dma_ops sil_dma_ops = {

    Could you please make this 'const' -- the same way as the mentioned commit 
does in other drivers?

> +	.dma_host_set		= ide_dma_host_set,
> +	.dma_setup		= ide_dma_setup,
> +	.dma_exec_cmd		= ide_dma_exec_cmd,
> +	.dma_start		= ide_dma_start,
> +	.dma_end		= __ide_dma_end,
>  	.dma_test_irq		= siimage_dma_test_irq,
> +	.dma_timeout		= ide_dma_timeout,
> +	.dma_lost_irq		= ide_dma_lost_irq,
>  };
>  
>  #define DECLARE_SII_DEV(name_str, p_ops)		\

MBR, Sergei
