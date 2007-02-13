Return-Path: <linux-kernel-owner+w=401wt.eu-S1030609AbXBMAod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030609AbXBMAod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030611AbXBMAod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:44:33 -0500
Received: from web36714.mail.mud.yahoo.com ([209.191.85.48]:28301 "HELO
	web36714.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030609AbXBMAoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:44:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=EndQZdQbFYZSrf2Cb26S0hEXe0Hjdc6UwpmTt325LJUlcRUD993XG2kXpV2y1Ck6nsJIMVSlqQNsFzV8+dTewblqG9oRJ4d/WwkbrHTnZXJYPmX1kdchBt2q5vXkMZNSOvgZwliGbpS8ZYgdqxU7H5tTa9nai3ZeXSfpvFrcLnM=  ;
Message-ID: <20070213004431.64499.qmail@web36714.mail.mud.yahoo.com>
X-YMail-OSG: vly1IUAVM1kC9D8Ko..6wk4TSZ9gJUQEgsyWYz0Msz6FBHII8.EiSCF0QTQ6o_TPZMxoA7UqDNXNeMlspLWliTPwBXGB0bJgUIJ7kFi29Iq_Ad7j4VYVcXGZ.XCZFp1Rg9j1KMozewk9cbQ-
Date: Mon, 12 Feb 2007 16:44:31 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Recent and not-so problems with tifm_sd driver
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D07075.7090302@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:

> Alex Dubov wrote:
> > I removed that line altogether (it does not really needed as mmc host will not be accessed
> > anymore). The problem is more elaborate. Here, the card fails, mmc_host_remove is called
> without
> > sleep beforehand, and "after remove" message is printed immediately after it. Only then,
> mmc_block
> > remembers to finish its business. If I leave the sleep in place, mmc_block's stuff will get
> > scheduled before the mmc_remove_host and everything will be all right.
> > You may also notice that host is already powered off ("Setting ... power 0" message) and still
> > mmc_block continues to make requests like nothing happened.
> > 
> 
> How did you do the "after remove" detection? Patch?
>
(Power message is printed by ios callback) 
Here's my current (SVN) remove function:

static void tifm_sd_remove(struct tifm_dev *sock)
{
        struct mmc_host *mmc = tifm_get_drvdata(sock);
        struct tifm_sd *host = mmc_priv(mmc);
        unsigned long flags;

        tasklet_kill(&host->finish_tasklet);
        spin_lock_irqsave(&sock->lock, flags);
        host->flags |= EJECT;
        writel(0, sock->addr + SOCK_MMCSD_INT_ENABLE);
        mmiowb();
        
        if (host->req) {
                writel(TIFM_FIFO_INT_SETALL,
                       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
                writel(0, sock->addr + SOCK_DMA_FIFO_INT_ENABLE_SET);
                host->req->cmd->error = MMC_ERR_TIMEOUT;
                if (host->req->stop)
                        host->req->stop->error = MMC_ERR_TIMEOUT;
                tasklet_schedule(&host->finish_tasklet);
        }
        spin_unlock_irqrestore(&sock->lock, flags);
        // temporary hack
        msleep(1000);
        mmc_remove_host(mmc);
        dev_dbg(&sock->dev, "after remove\n");

        /* The meaning of the bit majority in this constant is unknown. */
        writel(0xfff8 & readl(sock->addr + SOCK_CONTROL),
               sock->addr + SOCK_CONTROL);

        mmc_free_host(mmc);
}


 
____________________________________________________________________________________
Finding fabulous fares is fun.  
Let Yahoo! FareChase search your favorite travel sites to find flight and hotel bargains.
http://farechase.yahoo.com/promo-generic-14795097
