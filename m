Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZDVTJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZDVTJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZDVTIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:08:45 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3468 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZDVTIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:08:44 -0400
Subject: Re: [git pull] IDE fixes
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200904222048.15556.bzolnier@gmail.com>
References: <200904222048.15556.bzolnier@gmail.com>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 12:06:47 -0700
Message-Id: <1240427207.21848.81.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-22 at 20:48 +0200, Bartlomiej Zolnierkiewicz wrote:
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 3aec19d..3d4e099 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -609,7 +609,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
>  	struct request *rq = hwif->rq;
>  	ide_expiry_t *expiry = NULL;
>  	int dma_error = 0, dma, thislen, uptodate = 0;
> -	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc, nsectors;
> +	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc = 0, nsectors;
>  	int sense = blk_sense_request(rq);
>  	unsigned int timeout;
>  	u16 len;

I think ide is the only subsystem to use the
initialization style of "?:," with additional
declarations.

Would it be better to use a more standard style?

maybe:
	int dma_error = 0, dma, thislen, uptodate = 0, rc = 0, nsectors;
	int write = ((rq_data_dir(rq) == WRITE) ? 1 : 0;

> diff --git a/drivers/ide/palm_bk3710.c b/drivers/ide/palm_bk3710.c
> index c7acca0..d1513b4 100644
> --- a/drivers/ide/palm_bk3710.c
> +++ b/drivers/ide/palm_bk3710.c
[]
> @@ -75,13 +67,19 @@ struct palm_bk3710_udmatiming {
>  
>  static unsigned ideclk_period; /* in nanoseconds */
>  
> +struct palm_bk3710_udmatiming {
> +	unsigned int rptime;	/* tRP -- Ready to pause time (nsec) */
> +	unsigned int cycletime;	/* tCYCTYP2/2 -- avg Cycle Time (nsec) */
> +				/* tENV is always a minimum of 20 nsec */
> +};
> +
>  static const struct palm_bk3710_udmatiming palm_bk3710_udmatimings[6] = {
> -	{160, 240},		/* UDMA Mode 0 */
> -	{125, 160},		/* UDMA Mode 1 */
> -	{100, 120},		/* UDMA Mode 2 */
> -	{100, 90},		/* UDMA Mode 3 */
> -	{100, 60},		/* UDMA Mode 4 */
> -	{85,  40},		/* UDMA Mode 5 */
> +	{160, 240 / 2,},	/* UDMA Mode 0 */
> +	{125, 160 / 2,},	/* UDMA Mode 1 */
> +	{100, 120 / 2,},	/* UDMA Mode 2 */
> +	{100, 90 / 2,},		/* UDMA Mode 3 */
> +	{100, 60 / 2,},		/* UDMA Mode 4 */
> +	{85,  40 / 2,},		/* UDMA Mode 5 */
>  };
>  
>  static void palm_bk3710_setudmamode(void __iomem *base, unsigned int dev,

Odd looking commas.

Maybe:

	{.rptime = 160, .cycletime = 240 / 2 },	/* UDMA Mode 0 */
etc.

