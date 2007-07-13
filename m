Return-Path: <linux-kernel-owner+w=401wt.eu-S935720AbXGMSha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935720AbXGMSha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbXGMShV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:37:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51145 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755171AbXGMShT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:37:19 -0400
Date: Fri, 13 Jul 2007 11:36:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: greg@kroah.com, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Egor Martovetsky <egor@pasemi.com>
Subject: Re: [PATCH 3/8] drivers edac new pasemi driver
Message-Id: <20070713113641.52157b67.akpm@linux-foundation.org>
In-Reply-To: <4697adf6.ml1pGGjvWEkYBXbh%dougthompson@xmission.com>
References: <4697adf6.ml1pGGjvWEkYBXbh%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 10:53:10 -0600
dougthompson@xmission.com wrote:

> From: Egor Martovetsky <egor@pasemi.com>
> 
> NEW EDAC driver for the memory controllers on PA Semi PA6T-1682M.
> 
> Changes since last submission:
> 
> * Rebased on top of 2.6.22-rc4-mm2 with the EDAC changes merged there.
> * Minor checkpatch.pl cleanups
> * Renamed ctl_name
> * Added dev_name
> * edac_mc.h -> edac_core.h
> 
> ...
>
> +static int pasemi_edac_init_csrows(struct mem_ctl_info *mci,
> +				   struct pci_dev *pdev,
> +				   enum edac_type edac_mode)
> +{
> +	struct csrow_info *csrow;
> +	u32 rankcfg;
> +	int index;
> +
> +	for (index = 0; index < mci->nr_csrows; index++) {
> +		csrow = &mci->csrows[index];
> +
> +		pci_read_config_dword(pdev,
> +				      MCDRAM_RANKCFG + (index * 12),
> +				      &rankcfg);
> +
> +		if (!(rankcfg & MCDRAM_RANKCFG_EN))
> +			continue;
> +
> +		switch ((rankcfg & MCDRAM_RANKCFG_TYPE_SIZE_M) >>
> +			MCDRAM_RANKCFG_TYPE_SIZE_S) {
> +		case 0:
> +			csrow->nr_pages = 128 << (20 - PAGE_SHIFT);
> +			break;
> +		case 1:
> +			csrow->nr_pages = 256 << (20 - PAGE_SHIFT);
> +			break;
> +		case 2:
> +		case 3:
> +			csrow->nr_pages = 512 << (20 - PAGE_SHIFT);
> +			break;
> +		case 4:
> +			csrow->nr_pages = 1024 << (20 - PAGE_SHIFT);
> +			break;
> +		case 5:
> +			csrow->nr_pages = 2048 << (20 - PAGE_SHIFT);
> +			break;
> +		default:
> +			edac_mc_printk(mci, KERN_ERR,
> +				       "Unrecognized Rank Config\n");

If this message ever comes out, you're gonna say "argh, I wish I'd printed
rankcfg".

Do you want to do this??

--- a/drivers/edac/pasemi_edac.c~drivers-edac-new-pasemi-driver-fix
+++ a/drivers/edac/pasemi_edac.c
@@ -168,7 +168,8 @@ static int pasemi_edac_init_csrows(struc
 			break;
 		default:
 			edac_mc_printk(mci, KERN_ERR,
-				       "Unrecognized Rank Config\n");
+				"Unrecognized Rank Config. rankcfg=%u\n",
+				rankcfg);
 			return -EINVAL;
 		}
 
@@ -244,9 +245,8 @@ static int __devinit pasemi_edac_probe(s
 	 */
 	pasemi_edac_get_error_info(mci);
 
-	if (edac_mc_add_mc(mci, system_mmc_id++)) {
+	if (edac_mc_add_mc(mci, system_mmc_id++))
 		goto fail;
-	}
 
 	/* get this far and it's successful */
 	return 0;
_

