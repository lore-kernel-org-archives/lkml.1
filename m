Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZBVPPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZBVPPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 10:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZBVPPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 10:15:14 -0500
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:35277 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793AbZBVPPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 10:15:12 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-02.arcor-online.net B6FB53FE713
From: Prakash Punnoor <prakash@punnoor.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Sun, 22 Feb 2009 16:17:20 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5; KDE/4.2.0; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200902221308.55053.prakash@punnoor.de> <m1iqn2ein5.fsf@fess.ebiederm.org>
In-Reply-To: <m1iqn2ein5.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902221617.21621.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonntag 22 Februar 2009 13:54:54 Eric W. Biederman wrote:
> Prakesh could you try this patch instead?
>
> I think the problem is simply that the MCP55 ht mapping capability
> requires an address to be programed into it and it wasn't in your
> case.
>
> It should not hurt to enable one msi ht mapping capability too many.

I tried it, but unfortunately doesn't help. I run into the same issue.

>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index baad093..f7a0370 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2017,10 +2017,19 @@ static void __devinit ht_enable_msi_mapping(struct
> pci_dev *dev) while (pos && ttl--) {
>  		u8 flags;
>
> -		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
> -					 &flags) == 0) {
> +		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags))
> +			return;
> +
> +		if (!(flags & HT_MSI_FLAGS_ENABLE)) {
>  			dev_info(&dev->dev, "Enabling HT MSI Mapping\n");
>
> +			if (!(flags & HT_MSI_FLAGS_FIXED)) {
> +				pci_write_config_dword(dev, pos + HT_MSI_ADDR_LO,
> +					(HT_MSI_FIXED_ADDR & HT_MSI_FIXED_ADDR));
> +				pci_write_config_dword(dev, pos + HT_MSI_ADDR_HI,
> +					(HT_MSI_FIXED_ADDR >> 32));
> +			}
> +
>  			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
>  					      flags | HT_MSI_FLAGS_ENABLE);
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

