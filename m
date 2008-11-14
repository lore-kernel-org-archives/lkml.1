Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYKNXHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYKNXHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYKNXHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:07:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbYKNXHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:07:20 -0500
Date: Fri, 14 Nov 2008 15:07:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make /proc/sys/vm/drop_caches write only
Message-Id: <20081114150705.c98e5004.akpm@linux-foundation.org>
In-Reply-To: <200811131754.11863.knikanth@suse.de>
References: <200811131754.11863.knikanth@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 17:54:11 +0530
Nikanth Karthikesan <knikanth@suse.de> wrote:

>  /proc/sys/vm/drop_caches is used only to trigger dropping caches. It does not 
> disable the cache. The ability to read the value written to this file long 
> back gives wrong impression.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> 
> diff --git a/fs/drop_caches.c b/fs/drop_caches.c
> index 3e5637f..9892e1b 100644
> --- a/fs/drop_caches.c
> +++ b/fs/drop_caches.c
> @@ -66,11 +66,9 @@ int drop_caches_sysctl_handler(ctl_table *table, int write,
>  	struct file *file, void __user *buffer, size_t *length, loff_t *ppos)
>  {
>  	proc_dointvec_minmax(table, write, file, buffer, length, ppos);
> -	if (write) {
> -		if (sysctl_drop_caches & 1)
> -			drop_pagecache();
> -		if (sysctl_drop_caches & 2)
> -			drop_slab();
> -	}
> +	if (sysctl_drop_caches & 1)
> +		drop_pagecache();
> +	if (sysctl_drop_caches & 2)
> +		drop_slab();
>  	return 0;
>  }
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 9d048fa..dff3c13 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1015,7 +1015,7 @@ static struct ctl_table vm_table[] = {
>  		.procname	= "drop_caches",
>  		.data		= &sysctl_drop_caches,
>  		.maxlen		= sizeof(int),
> -		.mode		= 0644,
> +		.mode		= 0200,
>  		.proc_handler	= drop_caches_sysctl_handler,
>  		.strategy	= &sysctl_intvec,
>  	},

True.  But it's a backward-incompatible change, and there's a (small)
chance that someone's tools will break if we do this.

We have to get these things right first time :(
