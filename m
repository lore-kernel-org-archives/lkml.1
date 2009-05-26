Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbZEZURR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbZEZURR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbZEZURE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:17:04 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48091 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbZEZURD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:17:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z3JMcuUhoPvIp22ZXVLui42wTj0yk/9ahTqsR/tGJRvUGWVt1D9mcCw10YDEtX9G/X
         iaU+W6GiWzNSaiXipLnFhrqkZfpHS64j4MqzA0p0rJ9vo3+7ux8bMNB5w8BLJ72UYPAU
         33rdF7O68WHsRVJgXgm2jgbbmXAmw7jjbcyFY=
MIME-Version: 1.0
In-Reply-To: <1243279681-4233-3-git-send-email-philipp.zabel@gmail.com>
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
	 <1243279681-4233-3-git-send-email-philipp.zabel@gmail.com>
Date: Tue, 26 May 2009 22:16:59 +0200
Message-ID: <74d0deb30905261316hd100bbdr96e5e544eed94c2e@mail.gmail.com>
Subject: Re: [PATCH 2/5] mmc: tmio_mmc: add bus_shift support
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <spyro@f2s.com>, Pierre Ossman <pierre@ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 9:27 PM, Philipp Zabel <philipp.zabel@gmail.com> wrote:
> Some ASIC3 devices in the wild are connected with the address bus shifted
> by one line, so that its 16-bit registers appear 32-bit aligned in host
> memory space.

This patch has to be amended:

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 245de05..8223977 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -495,7 +495,8 @@ static int tmio_mmc_resume(struct platform_device *dev)

        /* Enable the MMC/SD Control registers */
        sd_config_write16(host, CNF_CMD, SDCREN);
-       sd_config_write32(host, CNF_CTL_BASE, dev->resource[0].start & 0xfffe);
+       sd_config_write32(host, CNF_CTL_BASE,
+               (dev->resource[0].start >> host->bus_shift) & 0xfffe);

        /* Tell the MFD core we are ready to be enabled */
        if (cell->enable) {
@@ -566,7 +567,8 @@ static int __devinit tmio_mmc_probe(struct
platform_device *dev)

        /* Enable the MMC/SD Control registers */
        sd_config_write16(host, CNF_CMD, SDCREN);
-       sd_config_write32(host, CNF_CTL_BASE, dev->resource[0].start & 0xfffe);
+       sd_config_write32(host, CNF_CTL_BASE,
+               (dev->resource[0].start >> host->bus_shift) & 0xfffe);

        /* Tell the MFD core we are ready to be enabled */
        if (cell->enable) {

The resources have to be shifted back when configuring the SD control
register space.

regards
Philipp
