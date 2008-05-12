Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbYELOYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbYELOYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 10:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYELOYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 10:24:39 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:41161 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbYELOYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 10:24:38 -0400
Subject: Re: [PATCH 1/6] arch/ia64/kernel: remove null pointer dereference
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Julia Lawall <julia@diku.dk>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805121536370.3694@ask.diku.dk>
References: <Pine.LNX.4.64.0805121536370.3694@ask.diku.dk>
Content-Type: text/plain; charset=utf-8
Date: Mon, 12 May 2008 16:37:29 +0200
Message-Id: <1210603050.25310.9.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

man, 12 05 2008 kl. 15:37 +0200, skrev Julia Lawall:
> From: Julia Lawall <julia@diku.dk>
> 
> If data is NULL, it is not possible to access data->ret.
> 
> The problem was detected using the following semantic match
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> expression E, E1;
> identifier f;
> statement S1,S2,S3;
> @@
> 
> * if (E == NULL)
> {
>   ... when != if (E == NULL) S1 else S2
>       when != E = E1
> * E->f
>   ... when any
>   return ...;
> }
> else S3
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> 
> diff -u -p a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
> --- a/arch/ia64/kernel/palinfo.c	2008-05-09 16:46:57.000000000 +0200
> +++ b/arch/ia64/kernel/palinfo.c	2008-05-12 08:43:35.000000000 +0200
> @@ -902,7 +902,6 @@ palinfo_smp_call(void *info)
>  	palinfo_smp_data_t *data = (palinfo_smp_data_t *)info;
>  	if (data == NULL) {
>  		printk(KERN_ERR "palinfo: data pointer is NULL\n");
> -		data->ret = 0; /* no output */
>  		return;
>  	}
>  	/* does this actual call */
> --

The whole if block should just be deleted, as info is never NULL. There
is only palinfo_handle_smp as (indirect) user of palinfo_smp_call (by
way of smp_call_function_single) and surely palinfo_smp_call never pass
NULL.


Simon Holm Thøgersen

