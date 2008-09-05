Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbYIEW1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbYIEW1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 18:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbYIEW1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 18:27:38 -0400
Received: from h155.mvista.com ([63.81.120.155]:65185 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750768AbYIEW1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 18:27:37 -0400
Message-ID: <48C1B253.4060805@ru.mvista.com>
Date: Sat, 06 Sep 2008 02:27:31 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Masoud Sharbiani <masouds@google.com>
Cc: bzolnier@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix pointer arithmetic in hpt3xx driver code (2nd attempt)
References: <20080905210110.GE26371@google.com>
In-Reply-To: <20080905210110.GE26371@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Masoud Sharbiani wrote:

> Hi there, 
>   

   Er... I think the maintainer will have to remove this... :-)

> git commit 74811f355f4f69a187fa74892dcf2a684b84ce99 causes crash at
> module load (or boot) time on my machine with a hpt374 controller.
> Sergei says this is due to the pointer arithmatic. This patch fixes that
> and makes my machine boot again.
> cheers, 
> Masoud
>   

   And "cheers" too...

> Signed-Off-By: Masoud Sharbiani <masouds@google.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
> index eb107ee..4e04d0a 100644
> --- a/drivers/ide/pci/hpt366.c
> +++ b/drivers/ide/pci/hpt366.c
> @@ -613,6 +613,14 @@ static int check_in_drive_list(ide_drive_t *drive, const char **list)
>  	return 0;
>  }
>  
> +static struct hpt_info *hpt3xx_get_info(struct device *dev)
>   

   That also will do. Though 'struct pci_dev' seems preferrable as it's 
always pre-calculated by the callers and otherwise needed in them in 4 
cases out of 7.

> +{
> +	struct pci_dev *pci_dev = to_pci_dev(dev);
> +	struct ide_host *host	= pci_get_drvdata(pci_dev);
>   

   Could be just:

	struct ide_host *host	= pci_get_drvdata(to_pci_dev(dev));


> +	struct hpt_info *info	= (struct hpt_info *)host->host_priv;
>   

   No epmty line after declaration block again. :-)

> +	return dev == host->dev[1] ? info + 1 : info;
> +}
> +
>  /*
>   * The Marvell bridge chips used on the HighPoint SATA cards do not seem
>   * to support the UltraDMA modes 1, 2, and 3 as well as any MWDMA modes...
> @@ -621,9 +629,7 @@ static int check_in_drive_list(ide_drive_t *drive, const char **list)
>  static u8 hpt3xx_udma_filter(ide_drive_t *drive)
>  {
>  	ide_hwif_t *hwif	= HWIF(drive);
> -	struct pci_dev *dev	= to_pci_dev(hwif->dev);
> -	struct ide_host *host	= pci_get_drvdata(dev);
> -	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
> +	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
>  	u8 mask 		= hwif->ultra_mask;
>  
>  	switch (info->chip_type) {
> @@ -662,9 +668,7 @@ static u8 hpt3xx_udma_filter(ide_drive_t *drive)
>  static u8 hpt3xx_mdma_filter(ide_drive_t *drive)
>  {
>  	ide_hwif_t *hwif	= HWIF(drive);
> -	struct pci_dev *dev	= to_pci_dev(hwif->dev);
> -	struct ide_host *host	= pci_get_drvdata(dev);
> -	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
> +	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
>  
>  	switch (info->chip_type) {
>  	case HPT372 :
> @@ -700,8 +704,7 @@ static void hpt3xx_set_mode(ide_drive_t *drive, const u8 speed)
>  {
>  	ide_hwif_t *hwif	= drive->hwif;
>  	struct pci_dev *dev	= to_pci_dev(hwif->dev);
> -	struct ide_host *host	= pci_get_drvdata(dev);
> -	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
> +	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
>  	struct hpt_timings *t	= info->timings;
>  	u8  itr_addr		= 0x40 + (drive->dn * 4);
>  	u32 old_itr		= 0;
> @@ -743,9 +746,8 @@ static void hpt3xx_quirkproc(ide_drive_t *drive)
>  static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
>  {
>  	ide_hwif_t *hwif	= HWIF(drive);
> -	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
> -	struct ide_host *host	= pci_get_drvdata(dev);
> -	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
> +	struct pci_dev  *dev    = to_pci_dev(hwif->dev);
> +	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
>  
>  	if (drive->quirk_list) {
>  		if (info->chip_type >= HPT370) {
> @@ -973,8 +975,7 @@ static int __devinit hpt37x_calibrate_dpll(struct pci_dev *dev, u16 f_low, u16 f
>  static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev)
>  {
>  	unsigned long io_base	= pci_resource_start(dev, 4);
> -	struct ide_host *host	= pci_get_drvdata(dev);
> -	struct hpt_info *info	= host->host_priv + (&dev->dev == host->dev[1]);
> +	struct hpt_info *info	= hpt3xx_get_info(&dev->dev);
>  	const char *name	= DRV_NAME;
>  	u8 pci_clk,  dpll_clk	= 0;	/* PCI and DPLL clock in MHz */
>  	u8 chip_type;
> @@ -1217,8 +1218,7 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev)
>  static u8 hpt3xx_cable_detect(ide_hwif_t *hwif)
>  {
>  	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
> -	struct ide_host *host	= pci_get_drvdata(dev);
> -	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
> +	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
>  	u8 chip_type		= info->chip_type;
>  	u8 scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;
>  
> @@ -1262,8 +1262,7 @@ static u8 hpt3xx_cable_detect(ide_hwif_t *hwif)
>  static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
>  {
>  	struct pci_dev *dev	= to_pci_dev(hwif->dev);
> -	struct ide_host *host	= pci_get_drvdata(dev);
> -	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
> +	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
>  	int serialize		= HPT_SERIALIZE_IO;
>  	u8  chip_type		= info->chip_type;
>  	u8  new_mcr, old_mcr	= 0;
>   

MBR, Sergei


