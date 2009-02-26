Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbZBZU0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbZBZU0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbZBZU0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:26:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755581AbZBZU0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:26:06 -0500
Date: Thu, 26 Feb 2009 12:25:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: dbrownell@users.sourceforge.net
Cc: david-b@pacbell.net, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch/RESEND 2.6.29-rc6] NAND:  fix "raw" reads with ECC
 syndrome layouts
Message-Id: <20090226122543.797eac77.akpm@linux-foundation.org>
In-Reply-To: <200902241508.13835.david-b@pacbell.net>
References: <200902241508.13835.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 15:08:13 -0800
David Brownell <david-b@pacbell.net> wrote:

> +static void nand_write_page_raw_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
> +				const uint8_t *buf)
> +{
> +	int eccsize = chip->ecc.size;
> +	int eccbytes = chip->ecc.bytes;
> +	uint8_t *oob = chip->oob_poi;
> +	int temp;

Please don't create variables called "temp" or "tmp".

> +	temp = chip->ecc.steps;
> +	do {
> +		chip->write_buf(mtd, buf, eccsize);
> +		buf += eccsize;
> +
> +		if (chip->ecc.prepad) {
> +			chip->write_buf(mtd, oob, chip->ecc.prepad);
> +			oob += chip->ecc.prepad;
> +		}
> +
> +		chip->read_buf(mtd, oob, eccbytes);
> +		oob += eccbytes;
> +
> +		if (chip->ecc.postpad) {
> +			chip->write_buf(mtd, oob, chip->ecc.postpad);
> +			oob += chip->ecc.postpad;
> +		}
> +	} while (--temp);

It would be clearer to code this as a plain old up-counting for loop.

> +	temp = mtd->oobsize - (oob - chip->oob_poi);
> +	if (temp)
> +		chip->write_buf(mtd, oob, temp);

Here the same woefully-named variable appears to be reemployed for some
semantically quite different purpose.

> +}
