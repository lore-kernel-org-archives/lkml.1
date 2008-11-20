Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbYKTUvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbYKTUvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbYKTUvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:51:36 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22303 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755397AbYKTUvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:51:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BD1FcY3hDnC6WTAeGW7r3lGIMtoCB/KeMPWQprVaAs2C/KC9hpvc5ErQFnHWuoDQaA2rREWCUtGS2F8Xxr58odZTrkRaQqR0vXGTtK/bhPHBEu8r5TRXZrN4QkZYjQBxu9hHkQ6vkpJYYAcxofJ8iBtN7UQc4WtSD+sXVXGsDPU=  ;
X-YMail-OSG: M5c1I.kVM1n4ydedICi8rl61vcBIqVSYht_J1ilLNxNu45tpmJkXctDpxCsBpyAGJHAzIJDdV_8begbWvZB96Li97zs9TxvmNKxjpl12UfaGDkVp0MiNg5sSDCFjIwu73WQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 01/16] Blackfin SPI Driver: ensure cache coherency before doing DMA
Date: Thu, 20 Nov 2008 12:24:15 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Vitja Makarov <vitja.makarov@gmail.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <1226994760-4301-2-git-send-email-cooloney@kernel.org>
In-Reply-To: <1226994760-4301-2-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811201224.15493.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Bryan Wu wrote:
>                         /* set transfer mode, and enable SPI */
>                         dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
>  
> +                       /* invalidate caches, if needed */
> +                       if (bfin_addr_dcachable((unsigned long) drv_data->rx))
> +                               invalidate_dcache_range((unsigned long) drv_data->rx,
> +                                                       (unsigned long) (drv_data->rx +
> +                                                       drv_data->len));

Could you explain why you're not using dma_map_*() calls
or the rx_dma (and tx_dma) addresses the caller may pass?

As a rule, you should use the standard kernel interfaces
for such stuff instead of platform-specific calls like
those two.  There are a LOT more developers who can find
and fix bugs that way.


Also, this patch affects the "not full duplex" branch of
this routine.  DMA here seems unusually convoluted ... but
if you didn't invalidate the cache (RX path) before
flushing it (TX path) and instead did it the other way
aroound, would you actually *need* separate branches?


> +
>                         /* clear tx reg soformer data is not shifted out */
>                         write_TDBR(drv_data, 0xFFFF);
>  


