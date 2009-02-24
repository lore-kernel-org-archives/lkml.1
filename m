Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZBXNjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZBXNjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbZBXNjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:39:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50192 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbZBXNjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:39:40 -0500
Date: Tue, 24 Feb 2009 14:35:05 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] physmap: Fix leak of memory returned by
	parse_mtd_partitions
Message-ID: <20090224133505.GJ21900@pengutronix.de>
References: <20081112.235733.01917391.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112.235733.01917391.anemo@mba.ocn.ne.jp>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 13:46:44 up 6 days,  4:40, 30 users,  load average: 0.00, 0.06,
	0.87
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry to reply to such an old thread, but...

On Wed, Nov 12, 2008 at 11:57:33PM +0900, Atsushi Nemoto wrote:
> The mtd partition parser returns an allocated pointer array of
> mtd_partition.  The caller must free it.  The array is used only for
> add_mtd_partitions(), so free it just after the call.

This patch breaks command line parsing support. With command line
partition parsing the struct mtd_partition array is allocated, but only
once. On my board with NAND and NOR (both with command line partition
parsing) It fails badly in parse_cmdline_partitions() when the second
device gets parsed.

The following patch fixes it, but I don't know if this is
the correct solution. Does anybody have more insights on this?

Sascha

diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index 50a3403..14c00dd 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -335,7 +335,13 @@ static int parse_cmdline_partitions(struct mtd_info *master,
 				}
 				offset += part->parts[i].size;
 			}
-			*pparts = part->parts;
+
+			*pparts = kmalloc(sizeof (struct mtd_partition) * part->num_parts, GFP_KERNEL);
+			if (!*pparts)
+				return -ENOMEM;
+
+			memcpy(*pparts, part->parts, sizeof (struct mtd_partition) * part->num_parts);
+
 			return part->num_parts;
 		}
 	}

> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
>  drivers/mtd/maps/physmap.c |   17 ++++++++---------
>  1 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
> index 7ca048d..cc26b41 100644
> --- a/drivers/mtd/maps/physmap.c
> +++ b/drivers/mtd/maps/physmap.c
> @@ -29,7 +29,6 @@ struct physmap_flash_info {
>  	struct map_info		map[MAX_RESOURCES];
>  #ifdef CONFIG_MTD_PARTITIONS
>  	int			nr_parts;
> -	struct mtd_partition	*parts;
>  #endif
>  };
>  
> @@ -56,14 +55,10 @@ static int physmap_flash_remove(struct platform_device *dev)
>  	for (i = 0; i < MAX_RESOURCES; i++) {
>  		if (info->mtd[i] != NULL) {
>  #ifdef CONFIG_MTD_PARTITIONS
> -			if (info->nr_parts) {
> +			if (info->nr_parts || physmap_data->nr_parts)
>  				del_mtd_partitions(info->mtd[i]);
> -				kfree(info->parts);
> -			} else if (physmap_data->nr_parts) {
> -				del_mtd_partitions(info->mtd[i]);
> -			} else {
> +			else
>  				del_mtd_device(info->mtd[i]);
> -			}
>  #else
>  			del_mtd_device(info->mtd[i]);
>  #endif
> @@ -86,6 +81,9 @@ static int physmap_flash_probe(struct platform_device *dev)
>  	int err = 0;
>  	int i;
>  	int devices_found = 0;
> +#ifdef CONFIG_MTD_PARTITIONS
> +	struct mtd_partition *parts;
> +#endif
>  
>  	physmap_data = dev->dev.platform_data;
>  	if (physmap_data == NULL)
> @@ -166,9 +164,10 @@ static int physmap_flash_probe(struct platform_device *dev)
>  		goto err_out;
>  
>  #ifdef CONFIG_MTD_PARTITIONS
> -	err = parse_mtd_partitions(info->cmtd, part_probe_types, &info->parts, 0);
> +	err = parse_mtd_partitions(info->cmtd, part_probe_types, &parts, 0);
>  	if (err > 0) {
> -		add_mtd_partitions(info->cmtd, info->parts, err);
> +		add_mtd_partitions(info->cmtd, parts, err);
> +		kfree(parts);
>  		return 0;
>  	}
>  
> -- 
> 1.5.6.3
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
