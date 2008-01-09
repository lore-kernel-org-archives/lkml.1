Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYAIQpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYAIQpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 11:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYAIQpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 11:45:31 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:33908 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYAIQpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 11:45:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GGMU6PGxLl4EOi57HXCXO51aRDuTqTuqGoT7GNTJrB7HJqFxa48G6HqRLIJwH9kxtRHv3AbxT6EW06yyR0Vz5g0Td7Zuozlrlv2JThsEGdKUJfhnfszRpn5DdWjrkCQy6NK7uoTcRYcIFmTAzEaa4lzV5imEzO7sWSGHMgG7t3Y=
Message-ID: <386072610801090845r14510fb8tbcca76d605458a96@mail.gmail.com>
Date: Thu, 10 Jan 2008 00:45:27 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Cc: "Cai, Cliff" <Cliff.Cai@analog.com>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080109082325.212ec90d@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
	 <0F1B54C89D5F954D8535DB252AF412FA014FAD4A@chinexm1.ad.analog.com>
	 <20080109082325.212ec90d@poseidon.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 9, 2008 3:23 PM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Wed, 9 Jan 2008 11:21:40 +0800
> "Cai, Cliff" <Cliff.Cai@analog.com> wrote:
>
> >
> >  Hi,all
> >
> > I'd like to say something about this issue.
> > Currently,the blackfin on chip SD host ONLY support 1-bit MMC while
> > support 1-bit/4-bit SD/SDIO.
> > And we want our driver to support both 1-bit MMC and 4-bit SD/SDIO.but
> > the current MMC driver framework
> > Only allow us to set one kind of bus width,either 1-bit or 4-bit.So in
> > order to meet our case,we need more flexible mechanism
> > To inform the upper commom driver to know our situation.
> >
>
> That's just iterating what's already been said. My claim is that 4-bit is 4-bit, regardless if it's MMC or SD. So if you want this patch to go in you need to explain why there is a difference for the blackfin controller.
>

Actually, Blackfin BF54x on-chip SDIO host controller is supposed to
support 1-bit and 4-bit MMC or SD. But in the real platform, when MMC
works at 4-bit mode there will be a FIFO underrun error
(http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3535).
While SD works at 4-bit mode is OK. We believe this is a hardware
issue of the SDIO host controller of BF54x.

We intend to workaround in our own BF54x SDIO host controller driver,
but there is no place for us to determine MMC or SD. One choice is to
hack common code like this:
----
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -358,6 +358,9 @@
 	/*
 	 * Activate wide bus (if supported).
 	 */
+/*Currently,Blackfin 54x only support 1 bit MMC,while support 4 bit SD */
+/*So if card type is MMC don't enable 4 bit mode*/
+#if !defined(CONFIG_BF54x)
 	if ((card->csd.mmca_vsn >= CSD_SPEC_VER_4) &&
 		(host->caps & MMC_CAP_4_BIT_DATA)) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
@@ -367,7 +370,7 @@

 		mmc_set_bus_width(card->host, MMC_BUS_WIDTH_4);
 	}
-
+#endif
 	if (!oldcard)
 		host->card = card;

----

Another choice is to use Mike's patch to split the 4-bit mode into
MMC-4-BIT and SD-4-BIT. So we can support 1-bit and 4-bit SD as well
as 1-bit MMC.

Thanks
-Bryan Wu
