Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbZCATzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbZCATzG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 14:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZCATyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 14:54:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:50513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620AbZCATyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 14:54:54 -0500
Date: Sun, 1 Mar 2009 20:54:50 +0100
From: Karsten Keil <kkeil@suse.de>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       kkeil@suse.de, linux-isdn@vger.kernel.org,
       Frank Seidel <frank@f-seidel.de>,
       Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Andreas Eversberg <andreas@eversberg.eu>,
       Hannes Eder <hannes@hanneseder.net>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCHv2] isdn: reduce stack size of mISDN_dsp
Message-ID: <20090301195450.GA18618@pingi.kke.suse.de>
References: <49AAB8B2.8060801@suse.de> <49AAC180.9000707@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AAC180.9000707@suse.de>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.60-0.34-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 06:10:24PM +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> Reduce stack size memory footprint of mISDN_dsp.
> (From 1468 bytes for dsp_cmx_send on i386 down
> to 44).

Looks safer and has the same function as before, but
I think we should work on a better solution later, which
use one buffer per instance and allocate it on creation time.
Andreas, what do you think ?

> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/isdn/mISDN/dsp_cmx.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> --- a/drivers/isdn/mISDN/dsp_cmx.c
> +++ b/drivers/isdn/mISDN/dsp_cmx.c
> @@ -1592,13 +1592,21 @@ dsp_cmx_send(void *arg)
>  	struct dsp_conf_member *member;
>  	struct dsp *dsp;
>  	int mustmix, members;
> -	s32 mixbuffer[MAX_POLL+100], *c;
> +	s32 *mixbuffer;
> +	s32 *c;
>  	u8 *p, *q;
>  	int r, rr;
>  	int jittercheck = 0, delay, i;
>  	u_long flags;
>  	u16 length, count;
>  
> +	mixbuffer = kmalloc(sizeof(*mixbuffer) * (MAX_POLL + 100), GFP_KERNEL);
> +	if (!mixbuffer) {
> +		printk(KERN_ERR "mISDN_dsp: cannot allocate buffer(%s)\n",
> +		       __func__);
> +		return;
> +	}
> +
>  	/* lock */
>  	spin_lock_irqsave(&dsp_lock, flags);
>  
> @@ -1811,6 +1819,8 @@ dsp_cmx_send(void *arg)
>  
>  	/* unlock */
>  	spin_unlock_irqrestore(&dsp_lock, flags);
> +
> +	kfree(mixbuffer);
>  }
>  
>  /*

-- 
Karsten Keil
