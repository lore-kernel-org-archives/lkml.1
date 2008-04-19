Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbYDSGiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbYDSGiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 02:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYDSGiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 02:38:09 -0400
Received: from www.tglx.de ([62.245.132.106]:44626 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbYDSGiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 02:38:08 -0400
Date: Sat, 19 Apr 2008 08:37:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alex Dubov <oakad@yahoo.com>
cc: joern@logfs.org, linux-kernel@vger.kernel.org, ben@fluff.org
Subject: Re: Smartmedia/xd card support - request for comments
In-Reply-To: <259878.79137.qm@web36703.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.1.10.0804190806110.3261@apollo.tec.linutronix.de>
References: <259878.79137.qm@web36703.mail.mud.yahoo.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008, Alex Dubov wrote:

First off, can you please use a mail client which does line breaks at
around 78 chars ?
 
> As you understand, both smartmedia media and hosts follow certain
> spec (publicly available here:
> http://www.ssfdc.or.jp/spec/index_e.htm, basic registration
> required). xd card spec is almost identical, adding some cosmetic
> features and restrictions (such as prohibition of single page
> programming). This means, that smartmedia access protocol can be
> abstracted out in the reader-independent way. You can seen in the
> xd_card_blk.c that it can operate both completely dumb controllers,
> while taking protocol shortcuts (using host->caps) to accommodate
> smarter readers (the only feature currently not there is
> adapter-side page copy - it can be easily added under FBD_COPY
> clause in xd_card_trans_req). The backend itself (jmb38x_xd.c)
> should not concern itself with details of smartmedia spec, as it
> will directly lead to code duplication among backends.

That's all fine. Nobody asked for the backend to know about smartmedia
on FLASH format details. The MTD NAND FLASH layer does not care about
on FLASH data format at all. It provides merily access on the hardware
level.

I agree that your approach of making the SM/XD layer capable of
handling clever and dumb hardware adapters is a good one.

The point where I stringly disagree is that your implementation is
forcing people with dumb hardware (see drivers/mtd/nand/*) to
reimplement the (maybe already) existing drivers in order to make use
of the ssfdc format, which will not work with the following real world
example:

------------------
| NAND controller |----------| On board NAND
| with HW ECC     |
|                 |----------| SmartMedia Card
------------------

Having a separate driver infrastructure for clever controllers, which
provide only semi raw access to the FLASH chip is fine simply because
such controllers do not fit into the MTD layer.

> I meant here the ability of user to look and modify CIS page, as
> well as look at the current block translation table.

Well, you probably do this with an iotctl anyway. So what's preventing
you to modify the mtd block layer to handle client private ioctls.

Also there is no real requirement to use the mtd block layer at all
for that. Putting your layer on top of the raw MTD device is fine IMO.

> > Correct.  Erase() is the only callback-based function and every single
> > driver implements it synchronous anyway.  Improving this situation is
> > needed for mtd's own sake anyway.  Either that or replacing mtd with
> > something else, likely the block device code.
>
> Revamping the underlying architecture of mtd will break a lot of
> stuff in the process, doesn't it?

That's the best excuse I ever heard for not improving code which has
shortcomings.

Thanks,
	tglx
