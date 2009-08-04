Return-Path: <linux-kernel-owner+w=401wt.eu-S933879AbZHEA2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879AbZHEA2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933867AbZHEA2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:28:50 -0400
Received: from n17.bullet.mail.mud.yahoo.com ([68.142.206.144]:20355 "HELO
	n17.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933822AbZHEA2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:28:30 -0400
X-Yahoo-Newman-Id: 658515.55710.bm@omp410.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=k+WtzVw1uf8IK0yyvQ3fVigHOMFiYWuuwmSE7z4L+usRlhLEbRMjiyCp0wwrLp9QYP0mrF2cxunRQ1m7ARb7GCXFuGMbEzZcX5Sl+1m8tdl2vpPJhIcMCe9PZH7yC8RdffDzXKMPH1nRNtl9WgxrWVkFdPBGDxAWxjU1h1PNFII=  ;
X-YMail-OSG: dX5I9WsVM1keuzCOc71hJfv7oY.PH4qarG0gOOOxflN9Aqc6dchfxveCPXGDxmSQ4leWUdZ.UtB8RQe3hISZTwkGiRgIwjQUfTSSlGgufzSIkhHbncVPctlrkxuFPk04MESfuS77qrf5Gj7zicy_LtO91IKxVzfD2o0mce1O6wwT.WpXZXP3rIdMPaOXn45ZP4ZpLu59EoAN8VLQ8pEVPyDTeNdABM2SN24phtJLiH2VBOlsP4XEBMc0O45IPjoZhFYxgJpOs8EYWVw0k9i724psyT9SUq3Bu0YeEOPi67CCFaiNUzUN.PfTfoS__57iKvUeJwwSdgP7vZWOQZva9Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 2/6] mtd: m25p80: Convert to device table matching
Date: Mon, 3 Aug 2009 19:54:50 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben@fluff.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
References: <20090731003957.GA23982@oksana.dev.rtsoft.ru> <20090731004100.GB8371@oksana.dev.rtsoft.ru>
In-Reply-To: <20090731004100.GB8371@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031954.50955.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 July 2009, Anton Vorontsov wrote:
> This patch converts the m25p80 driver so that now it uses .id_table
> for device matching, making it properly detect devices on OpenFirmware
> platforms (prior to this patch the driver misdetected non-JEDEC chips,
> seeing all chips as "m25p80").

I suspect "detect" is a misnomer there.  It only "detects" JEDEC chips.
All others got explicit declarations ... so if there's misbehavior for
other chips, it's because those declarations were poorly handled.  Maybe
they were not properly flagged as non-JDEC

 
> Also, now jedec_probe() only does jedec probing, nothing else. If it
> is not able to detect a chip, NULL is returned and the driver fall
> backs to the information specified by the platform (platform_data, or
> exact ID).

I'd rather keep the warning, so there's a clue about what's really
going on:  JEDEC chip found, but its ID is not handled.


> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/mtd/devices/m25p80.c |  146 +++++++++++++++++++++++-------------------
>  1 files changed, 80 insertions(+), 66 deletions(-)
> 
> diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
> index 10ed195..0d74b38 100644
> --- a/drivers/mtd/devices/m25p80.c
> +++ b/drivers/mtd/devices/m25p80.c
> 			... deletia ...

> @@ -481,74 +480,83 @@ struct flash_info {
>  #define	SECT_4K		0x01		/* OPCODE_BE_4K works uniformly */
>  };
>  
> +#define INFO(_jedec_id, _ext_id, _sector_size, _n_sectors, _flags)	\
> +	((kernel_ulong_t)&(struct flash_info) {				\
> +		.jedec_id = (_jedec_id),				\
> +		.ext_id = (_ext_id),					\
> +		.sector_size = (_sector_size),				\
> +		.n_sectors = (_n_sectors),				\
> +		.flags = (_flags),					\
> +	})

Anonymous inlined structures ... kind of ugly, but I can
understand why you might not want to declare and name a
few dozen single-use structures.


>  
>  /* NOTE: double check command sets and memory organization when you add
>   * more flash chips.  This current list focusses on newer chips, which
>   * have been converging on command sets which including JEDEC ID.
>   */
> -static struct flash_info __devinitdata m25p_data [] = {
> -
> +static const struct spi_device_id m25p_ids[] = {
>  	/* Atmel -- some are (confusingly) marketed as "DataFlash" */
> -	{ "at25fs010",  0x1f6601, 0, 32 * 1024, 4, SECT_4K, },
> -	{ "at25fs040",  0x1f6604, 0, 64 * 1024, 8, SECT_4K, },
> +	{ "at25fs010",  INFO(0x1f6601, 0, 32 * 1024, 4, SECT_4K) },
> +	{ "at25fs040",  INFO(0x1f6604, 0, 64 * 1024, 8, SECT_4K) },
>  
> 		... deletia ...
>  

> @@ -596,6 +602,7 @@ static struct flash_info *__devinit jedec_probe(struct spi_device *spi)
>   */
>  static int __devinit m25p_probe(struct spi_device *spi)
>  {
> +	const struct spi_device_id	*id;
>  	struct flash_platform_data	*data;
>  	struct m25p			*flash;
>  	struct flash_info		*info;
> @@ -608,32 +615,38 @@ static int __devinit m25p_probe(struct spi_device *spi)
>  	 */
>  	data = spi->dev.platform_data;
>  	if (data && data->type) {

At this point I wonder why you're not changing the probe sequence
more.  Get "id" and then "id" here.  If it's for "m25p80" assume
it's an old-style board init and do the current logic.  Else just
verify "info".

There's a new error case of course:  new-style but data->type
doesn't match id->name.


> -		for (i = 0, info = m25p_data;
> -				i < ARRAY_SIZE(m25p_data);
> -				i++, info++) {
> -			if (strcmp(data->type, info->name) == 0)
> -				break;
> +		for (i = 0; i < ARRAY_SIZE(m25p_ids) - 1; i++) {
> +			id = &m25p_ids[i];
> +			info = (void *)m25p_ids[i].driver_data;
> +			if (strcmp(data->type, id->name))
> +				continue;
> +			break;
>  		}
>  
>  		/* unrecognized chip? */
> -		if (i == ARRAY_SIZE(m25p_data)) {
> +		if (i == ARRAY_SIZE(m25p_ids) - 1) {

Better:  "if (info == NULL) ..."   You've got all the pointers
in hand; don't use indices.

>  			DEBUG(MTD_DEBUG_LEVEL0, "%s: unrecognized id %s\n",
>  					dev_name(&spi->dev), data->type);
>  			info = NULL;
>  
>  		/* recognized; is that chip really what's there? */
>  		} else if (info->jedec_id) {
> -			struct flash_info	*chip = jedec_probe(spi);
> +			id = jedec_probe(spi);
>  
> -			if (!chip || chip != info) {
> +			if (id != &m25p_ids[i]) {

Again, don't use indices except during the lookup.

>  				dev_warn(&spi->dev, "found %s, expected %s\n",
> -						chip ? chip->name : "UNKNOWN",
> -						info->name);
> +						id ? id->name : "UNKNOWN",
> +						m25p_ids[i].name);
>  				info = NULL;
>  			}
>  		}
> -	} else
> -		info = jedec_probe(spi);
> +	} else {
> +		id = jedec_probe(spi);
> +		if (!id)
> +			id = spi_get_device_id(spi);
> +
> +		info = (void *)id->driver_data;
> +	}
>  
>  	if (!info)
>  		return -ENODEV;


