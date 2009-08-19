Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZHSXff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZHSXff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZHSXfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:35:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718AbZHSXfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:35:32 -0400
Date: Wed, 19 Aug 2009 16:34:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dimitri.gorokhovik@free.fr
Cc: David Woodhouse <dwmw2@infradead.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Scott James Remnant <scott@canonical.com>, Julia Lawall <julia@diku.dk>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nftl: fix offset alignments
Message-Id: <20090819163426.fa90cf9f.akpm@linux-foundation.org>
In-Reply-To: <785022442.3397251250633188592.JavaMail.root@zimbra3-e1.priv.proxad.net>
References: <605152405.3397101250633087167.JavaMail.root@zimbra3-e1.priv.proxad.net>
	<785022442.3397251250633188592.JavaMail.root@zimbra3-e1.priv.proxad.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 00:06:28 +0200 (CEST) dimitri.gorokhovik@free.fr wrote:

> Arithmetic conversion in the mask computation makes the upper word 
> of the second argument passed down to mtd->read_oob(), be always 0
> (assuming 'offs' being a 64-bit signed long long type, and 
> 'mtd->writesize' being a 32-bit unsigned int type). 
> 
> This patch applies over the other one adding masking in nftl_write,
> "nftl: write support is broken".
> 
> Signed-off-by: <dimitri.gorokhovik@free.fr>
> ---
>  
> diff --git a/drivers/mtd/nftlcore.c b/drivers/mtd/nftlcore.c
> index 665d3eb..d2fd066 100644
> --- a/drivers/mtd/nftlcore.c
> +++ b/drivers/mtd/nftlcore.c
> @@ -135,16 +135,17 @@ static void nftl_remove_dev(struct mtd_blktrans_dev *dev)
>  int nftl_read_oob(struct mtd_info *mtd, loff_t offs, size_t len,
>  		  size_t *retlen, uint8_t *buf)
>  {
> +	typeof(offs) mask = mtd->writesize - 1;

I see no reason to use typeof here.  Plain old

	loff_t mask = mtd->writesize - 1;

would be more conventional.

>  	struct mtd_oob_ops ops;
>  	int res;
>  
>  	ops.mode = MTD_OOB_PLACE;
> -	ops.ooboffs = offs & (mtd->writesize - 1);
> +	ops.ooboffs = offs & mask;
>  	ops.ooblen = len;
>  	ops.oobbuf = buf;
>  	ops.datbuf = NULL;
>  
> -	res = mtd->read_oob(mtd, offs & ~(mtd->writesize - 1), &ops);
> +	res = mtd->read_oob(mtd, offs & ~mask, &ops);

yup.

