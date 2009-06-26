Return-Path: <linux-kernel-owner+w=401wt.eu-S1759515AbZFZPJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbZFZPJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbZFZPJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:09:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:57908 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZFZPJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:09:48 -0400
Subject: Re: [PATCH][MTD][NAND]: fix omap2.c compile failure and warning
From: David Woodhouse <dwmw2@infradead.org>
To: tom.leiming@gmail.com, jzhang@ti.com, vimalsingh@ti.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       david-b@pacbell.net
In-Reply-To: <1246022509-16194-1-git-send-email-tom.leiming@gmail.com>
References: <1246022509-16194-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 16:09:44 +0100
Message-Id: <1246028984.663.9.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 21:21 +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> drivers/mtd/nand/omap2.c: In function 'omap_wait':
> drivers/mtd/nand/omap2.c:543: error: 'jiffies' undeclared (first use in this function)
> drivers/mtd/nand/omap2.c:543: error: (Each undeclared identifier is reported only once
> drivers/mtd/nand/omap2.c:543: error: for each function it appears in.)
> drivers/mtd/nand/omap2.c:557: error: implicit declaration of function 'time_before'

OK.

> ......
> 
> drivers/mtd/nand/omap2.c: In function 'omap_wait':
> drivers/mtd/nand/omap2.c:545: warning: 'status' may be used uninitialized in this function

Hm, why do you set it to zero? In the (fairly unlikely) case where you
never go through the loop at all, because you're preempted until the
timeout has completed, what value do you want it to return?

Don't just make changes by bashing on the keyboard until the compiler
shuts up; please apply brain.

That way, I think you'll notice that the return value from this function
is completely screwed anyway.... Vimal? Shouldn't it be returning
NAND_STATUS_FAIL in the failure case, not a value read directly from the
hardware register? And shouldn't there be a cpu_relax() (or even
schedule) in there too?

> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/mtd/nand/omap2.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
> index 0cd76f8..2905c79 100644
> --- a/drivers/mtd/nand/omap2.c
> +++ b/drivers/mtd/nand/omap2.c
> @@ -15,6 +15,7 @@
>  #include <linux/mtd/nand.h>
>  #include <linux/mtd/partitions.h>
>  #include <linux/io.h>
> +#include <linux/jiffies.h>
>  
>  #include <asm/dma.h>
>  
> @@ -541,7 +542,8 @@ static int omap_wait(struct mtd_info *mtd, struct nand_chip *chip)
>  	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
>  							mtd);
>  	unsigned long timeo = jiffies;
> -	int status, state = this->state;
> +	int state = this->state;
> +	int status = 0;
>  
>  	if (state == FL_ERASING)
>  		timeo += (HZ * 400) / 1000;
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

