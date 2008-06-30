Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYF3NJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYF3NJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761784AbYF3NJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:09:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44558 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761740AbYF3NJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:09:25 -0400
Subject: Re: [Linux-ATM-General] [PATCH] firmware: convert Ambassador ATM
	driver to request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
Cc: netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <200806301259.m5UCxewW022114@cmf.nrl.navy.mil>
References: <200806301259.m5UCxewW022114@cmf.nrl.navy.mil>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 14:09:22 +0100
Message-Id: <1214831362.10393.340.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-30 at 08:59 -0400, Chas Williams (CONTRACTOR) wrote:
> In message <1214818473.10393.337.camel@pmac.infradead.org>,David Woodhouse writ
> es:
> >A couple of comments though... it looks like you forgot to add
> >MODULE_FIRMWARE(). And shouldn't 'fw_data' in
> >fore200e_load_and_start_firmware() be a (__le32 *) not a (u32 *)?
> 
> this look ok:
> 
> 
> diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
> index d5c1bbf..91710d4 100644
> --- a/drivers/atm/fore200e.c
> +++ b/drivers/atm/fore200e.c
> @@ -2562,7 +2562,8 @@ fore200e_load_and_start_fw(struct fore200e* fore200e)
>      const struct firmware *firmware;
>      struct device *device;
>      struct fw_header *fw_header;
> -    u32 *fw_data, fw_size;
> +    __le32 *fw_data;
> +    u32 fw_size;
>      u32 __iomem *load_addr;
>      char buf[48];
>      int err = -ENODEV;
> @@ -2582,7 +2583,7 @@ fore200e_load_and_start_fw(struct fore200e* fore200e)
>  	return err;
>      }
>  
> -    fw_data = (u32 *) firmware->data;
> +    fw_data = (__le32 *) firmware->data;

Actually, it should probably be 'const' too.

>      fw_size = firmware->size / sizeof(u32);
>      fw_header = (struct fw_header *) firmware->data;
>      load_addr = fore200e->virt_base + le32_to_cpu(fw_header->load_offset);
> @@ -3199,6 +3200,7 @@ static const struct fore200e_bus fore200e_bus[] = {
>      {}
>  };
>  
> -#ifdef MODULE_LICENSE
>  MODULE_LICENSE("GPL");
> -#endif

#ifdef CONFIG_SBUS
> +MODULE_FIRMWARE("sba200e.bin");
#ifdef CONFIG_PCI
#ifdef __LITTLE_ENDIAN
> +MODULE_FIRMWARE("pca200e.bin");
#else /* big-endian */
> +MODULE_FIRMWARE("pca200e_ecd.bin");
#endif
#endif

And wasn't it sba200e_ecd.bin ? 

-- 
dwmw2

