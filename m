Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbXEJTAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbXEJTAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbXEJTAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:00:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:19370 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319AbXEJTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QpwR/EsYv0YRyriBAM6DQXc+tfIgdcOj3Jtvdue240TqArjJ7YAlO1I0I7BD1q4WN+ZbiG5QGd9PYg7B2vbQX0VAX3Oi6GOM8a3ig9Vx6x+UfpuaV3pxD73RkH/OfY27xvi7qJXcvp28zIvnTZWymgDxOTrWDCnFTUyZzbz+RUU=
Date: Thu, 10 May 2007 23:00:27 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 02/10] Linux Kernel Markers, architecture independent code.
Message-ID: <20070510190027.GA5709@martell.zuzino.mipt.ru>
References: <20070510015555.973107048@polymtl.ca> <20070510020915.609367244@polymtl.ca> <20070510051043.GA6640@martell.zuzino.mipt.ru> <20070510131240.GD22424@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510131240.GD22424@Krystal>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 09:12:41AM -0400, Mathieu Desnoyers wrote:
> Linux Kernel Markers - Architecture Independant Code fix 2
>
> Fix trivial SMP bug in list_modules.

> --- linux-2.6-lttng.orig/kernel/module.c	2007-05-10 08:51:02.000000000 -0400
> +++ linux-2.6-lttng/kernel/module.c	2007-05-10 08:51:06.000000000 -0400
> @@ -2657,13 +2657,16 @@
>  	/* Enumerate loaded modules */
>  	struct list_head	*i;
>  	struct module		*mod;
> -	unsigned long refcount = 0;
> +	unsigned long refcount;
> +	int cpu;
>
>  	mutex_lock(&module_mutex);
>  	list_for_each(i, &modules) {
>  		mod = list_entry(i, struct module, list);
> +		refcount = 0;
>  #ifdef CONFIG_MODULE_UNLOAD
> -		refcount = local_read(&mod->ref[0].count);
> +		for_each_online_cpu(cpu)
> +			refcount += local_read(&mod->ref[cpu].count);
>  #endif //CONFIG_MODULE_UNLOAD

Still wrong: module_get on cpu X, cpu X hot unplugged. There is
module_refcount() for you.

