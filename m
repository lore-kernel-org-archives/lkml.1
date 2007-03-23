Return-Path: <linux-kernel-owner+w=401wt.eu-S1945898AbXCWO0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945898AbXCWO0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945899AbXCWO0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:26:47 -0400
Received: from twin.jikos.cz ([213.151.79.26]:56774 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945898AbXCWO0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:26:46 -0400
Date: Fri, 23 Mar 2007 15:25:23 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] [bugfix] loop.c
In-Reply-To: <20070323151956.1ac6a47b.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703231522200.5030@twin.jikos.cz>
References: <4603DE86.1090009@slax.org> <20070323151956.1ac6a47b.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, Eric Dumazet wrote:

> -	if (max_loop < 1 || max_loop > 256) {
> -		printk(KERN_WARNING "loop: invalid max_loop (must be between"
> -				    " 1 and 256), using default (8)\n");
> +	if (max_loop < 1) {
> +		printk(KERN_WARNING "loop: invalid max_loop (must be > 1)"
> +				    ", using default (8)\n");
>  		max_loop = 8;
>  	}
[...]
> +	loop_dev = kmalloc(max_loop * sizeof(struct loop_device *), GFP_KERNEL);
> +	if (!loop_dev) {
> +		loop_dev = vmalloc(max_loop * sizeof(struct loop_device *));
> +		if (!loop_dev)
> +			goto out_mem;
> +		loop_dev_vmalloced = 1;
>  	}

Why did you remove the upper bound check for max_loop value? Now you 
effectively allow to max_loop * sizeof(struct loop_device *) to overflow, 
when passed value of max_loop which is large enough. Or am I just blind?

The "while (nbl < max_loop)" which immediately follows is then going to 
corrupt memory, right?

-- 
Jiri Kosina
