Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0BIRPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:15:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34396 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab0BIRPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:15:07 -0500
Subject: Re: [PATCH 01/17] MTD: create lockless versions of
 {get,put}_mtd_device This will be used to resolve deadlock in block
 translation layer.
From: Peter Zijlstra <peterz@infradead.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <1265734665-22656-2-git-send-email-maximlevitsky@gmail.com>
References: <1265734665-22656-1-git-send-email-maximlevitsky@gmail.com>
	 <1265734665-22656-2-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 18:14:53 +0100
Message-ID: <1265735693.11509.253.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-09 at 18:57 +0200, Maxim Levitsky wrote:
> These functions can be used as long as we don't need access to global mtd table, but have
> a pointer to the mtd device.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/mtd/mtdcore.c   |   60 ++++++++++++++++++++++++++++++----------------
>  include/linux/mtd/mtd.h |    3 +-
>  2 files changed, 41 insertions(+), 22 deletions(-)

> +int __get_mtd_device(struct mtd_info *mtd)
> +{
> +	int err;
> +
> +	if (!try_module_get(mtd->owner))
> +		return -ENODEV;
> +
> +	if (mtd->get_device) {
> +
> +		err = mtd->get_device(mtd);
> +
> +		if (err) {
> +			module_put(mtd->owner);
> +			return err;
> +		}
> +	}
> +	mtd->usecount++;
> +	return 0;
>  }

> +void __put_mtd_device(struct mtd_info *mtd)
> +{
> +	--mtd->usecount;
> +	BUG_ON(mtd->usecount < 0);
> +
>  	if (mtd->put_device)
>  		mtd->put_device(mtd);
>  
>  	module_put(mtd->owner);
>  }

That's racy, use kref.

