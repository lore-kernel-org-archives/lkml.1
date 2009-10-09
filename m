Return-Path: <linux-kernel-owner+w=401wt.eu-S933964AbZJISfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933964AbZJISfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933685AbZJISfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:35:46 -0400
Received: from www.tglx.de ([62.245.132.106]:32809 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933351AbZJISfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:35:45 -0400
Date: Fri, 9 Oct 2009 20:34:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, John Kacur <jkacur@redhat.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: Re: [PATCH] mem_class: Drop the bkl from memory_open()
In-Reply-To: <1255113062-5835-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.LFD.2.00.0910092033560.9428@localhost.localdomain>
References: <1255113062-5835-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009, Frederic Weisbecker wrote:

> The generic open callback for the mem class devices is "protected" by
> the bkl.
> 
> Let's look at the datas manipulated inside memory_open:
> 
> - inode and file: safe
> - the devlist: safe because it is constant
> - the memdev classes inside this array are safe too (constant)
> 
> After we find out which memdev file operation we need to use, we call
> its open callback. Depending on the targeted memdev, we call either
> open_port() that doesn't manipulate any racy data (just a capable()
> check), or we call nothing.
> 
> So it's safe to remove the big kernel lock there.

Thanks, queued.

	tglx

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Alessio Igor Bogani <abogani@texware.it>
> ---
>  drivers/char/mem.c |   16 +++++-----------
>  1 files changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index a074fce..599846a 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -892,29 +892,23 @@ static int memory_open(struct inode *inode, struct file *filp)
>  {
>  	int minor;
>  	const struct memdev *dev;
> -	int ret = -ENXIO;
> -
> -	lock_kernel();
>  
>  	minor = iminor(inode);
>  	if (minor >= ARRAY_SIZE(devlist))
> -		goto out;
> +		return -ENXIO;
>  
>  	dev = &devlist[minor];
>  	if (!dev->fops)
> -		goto out;
> +		return -ENXIO;
>  
>  	filp->f_op = dev->fops;
>  	if (dev->dev_info)
>  		filp->f_mapping->backing_dev_info = dev->dev_info;
>  
>  	if (dev->fops->open)
> -		ret = dev->fops->open(inode, filp);
> -	else
> -		ret = 0;
> -out:
> -	unlock_kernel();
> -	return ret;
> +		return dev->fops->open(inode, filp);
> +
> +	return 0;
>  }
>  
>  static const struct file_operations memory_fops = {
> -- 
> 1.6.2.3
> 
