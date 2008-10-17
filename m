Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbYJQNhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbYJQNhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYJQNhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:37:46 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:65089 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbYJQNhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:37:46 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+4fD630pcmsbXFwYCGzgls
Date: Fri, 17 Oct 2008 06:37:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Fix debugfs_create_*'s error checking method for
	arm/plat-omap
Message-ID: <20081017133732.GG15820@atomide.com>
References: <48F85976.4070609@cn.fujitsu.com> <48F863E3.3070003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F863E3.3070003@cn.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zhaolei <zhaolei@cn.fujitsu.com> [081017 03:08]:
> debugfs_create_*() returns NULL if an error occurs, returns -ENODEV
> when debugfs is not enabled in the kernel.
> 
> Comparing to PATCH v1, because clk_debugfs_init is included in
> "#if defined CONFIG_DEBUG_FS", we only need to check NULL return.
> Thanks Li Zefan <lizf@cn.fujitsu.com>
> 
> debugfs_create_u8() and other function's return value's checking method are
> also fixed in this patch.

Thanks, I've added this into omap-fixes queue for Russell (assuming
Russell did not pick it up yet). I've also pushed it into the
linux-omap tree.

Regards,

Tony


> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  arch/arm/plat-omap/clock.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
> index bf6a10c..be6aab9 100644
> --- a/arch/arm/plat-omap/clock.c
> +++ b/arch/arm/plat-omap/clock.c
> @@ -428,23 +428,23 @@ static int clk_debugfs_register_one(struct clk *c)
>  	if (c->id != 0)
>  		sprintf(p, ":%d", c->id);
>  	d = debugfs_create_dir(s, pa ? pa->dent : clk_debugfs_root);
> -	if (IS_ERR(d))
> -		return PTR_ERR(d);
> +	if (!d)
> +		return -ENOMEM;
>  	c->dent = d;
>  
>  	d = debugfs_create_u8("usecount", S_IRUGO, c->dent, (u8 *)&c->usecount);
> -	if (IS_ERR(d)) {
> -		err = PTR_ERR(d);
> +	if (!d) {
> +		err = -ENOMEM;
>  		goto err_out;
>  	}
>  	d = debugfs_create_u32("rate", S_IRUGO, c->dent, (u32 *)&c->rate);
> -	if (IS_ERR(d)) {
> -		err = PTR_ERR(d);
> +	if (!d) {
> +		err = -ENOMEM;
>  		goto err_out;
>  	}
>  	d = debugfs_create_x32("flags", S_IRUGO, c->dent, (u32 *)&c->flags);
> -	if (IS_ERR(d)) {
> -		err = PTR_ERR(d);
> +	if (!d) {
> +		err = -ENOMEM;
>  		goto err_out;
>  	}
>  	return 0;
> @@ -483,8 +483,8 @@ static int __init clk_debugfs_init(void)
>  	int err;
>  
>  	d = debugfs_create_dir("clock", NULL);
> -	if (IS_ERR(d))
> -		return PTR_ERR(d);
> +	if (!d)
> +		return -ENOMEM;
>  	clk_debugfs_root = d;
>  
>  	list_for_each_entry(c, &clocks, node) {
> -- 
> 1.5.5.3
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
