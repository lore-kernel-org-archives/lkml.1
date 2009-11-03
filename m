Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZKCGgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZKCGgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 01:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZKCGgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 01:36:40 -0500
Received: from smtp.nokia.com ([192.100.105.134]:47380 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbZKCGgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 01:36:40 -0500
Subject: Re: [PATCH] mtd: m25p80: make command buffer DMA-safe
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Johannes Stezenbach <js@sig21.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091028132137.GA17813@sig21.net>
References: <20091028132137.GA17813@sig21.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 08:36:05 +0200
Message-Id: <1257230165.21596.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Nov 2009 06:36:07.0835 (UTC) FILETIME=[ECCA8EB0:01CA5C4F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 14:21 +0100, Johannes Stezenbach wrote:
> spi_write() requires the buffer to be DMA-safe, kmalloc()
> it seperately to ensure this.
> 
> Signed-off-by: Johannes Stezenbach <js@sig21.net>
> 
> 
> diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
> index 4c19269..21dd4d9 100644
> --- a/drivers/mtd/devices/m25p80.c
> +++ b/drivers/mtd/devices/m25p80.c
> @@ -79,7 +79,7 @@ struct m25p {
>  	struct mtd_info		mtd;
>  	unsigned		partitioned:1;
>  	u8			erase_opcode;
> -	u8			command[CMD_SIZE + FAST_READ_DUMMY_BYTE];
> +	u8			*command;
>  };
>  
>  static inline struct m25p *mtd_to_m25p(struct mtd_info *mtd)
> @@ -770,6 +770,11 @@ static int __devinit m25p_probe(struct spi_device *spi)
>  	flash = kzalloc(sizeof *flash, GFP_KERNEL);
>  	if (!flash)
>  		return -ENOMEM;
> +	flash->command = kmalloc(CMD_SIZE + FAST_READ_DUMMY_BYTE, GFP_KERNEL);
> +	if (!flash->command) {
> +		kfree(flash);
> +		return -ENOMEM;
> +	}

Even though it is just 4 or 5 bytes it can do DMA? Does not sound too
sane to use DMA in that case. Does this patch fix a real error?

I do not know much about SPI, but for me it sounds like there should be
a method to ask SPI to avoid using DMA, and you should use that method.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

