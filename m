Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbXEJFKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbXEJFKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbXEJFK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:10:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:33456 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050AbXEJFKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:10:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=i9kLjbRxaGsI3/wkqn6QUwSUnmTbeWfGQdE10H9WqI60WbxjCQIGnXll+oRgn+NgtPpKFzn0aGlSb7zlmxphsN4757AmrWmGJAoax1s/34N4boxC2rYP2o40zbzon0S/hunffuoJX17C51855E537qT4/zROD+2fkdtBZ2bPFv4=
Date: Thu, 10 May 2007 09:10:43 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 02/10] Linux Kernel Markers, architecture independent code.
Message-ID: <20070510051043.GA6640@martell.zuzino.mipt.ru>
References: <20070510015555.973107048@polymtl.ca> <20070510020915.609367244@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510020915.609367244@polymtl.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 09:55:57PM -0400, Mathieu Desnoyers wrote:
> --- /dev/null
> +++ linux-2.6-lttng/include/linux/marker.h
> @@ -0,0 +1,124 @@

> +#ifdef __KERNEL__

Just don't add this file to include/linux/Kbuild and remove __KERNEL__
ifdef.

> --- linux-2.6-lttng.orig/include/linux/module.h
> +++ linux-2.6-lttng/include/linux/module.h
> @@ -356,6 +356,9 @@
>  	/* The command line arguments (may be mangled).  People like
>  	   keeping pointers to this stuff */
>  	char *args;
> +
> +	const struct __mark_marker *markers;
> +	unsigned int num_markers;

#ifdef CONFIG_MARKERS, please.

> --- linux-2.6-lttng.orig/kernel/module.c
> +++ linux-2.6-lttng/kernel/module.c

> @@ -1659,6 +1884,9 @@
>  	unsigned int unusedcrcindex;
>  	unsigned int unusedgplindex;
>  	unsigned int unusedgplcrcindex;
> +	unsigned int markersindex;
> +	unsigned int markersdataindex;
> +	unsigned int markersstringsindex;

Bunch of underscores wouldn't hurt.

> +void list_modules(void)
> +{
> +	/* Enumerate loaded modules */
> +	struct list_head	*i;
> +	struct module		*mod;
> +	unsigned long refcount = 0;
> +
> +	mutex_lock(&module_mutex);
> +	list_for_each(i, &modules) {
> +		mod = list_entry(i, struct module, list);
> +#ifdef CONFIG_MODULE_UNLOAD
> +		refcount = local_read(&mod->ref[0].count);
						^
Buy second CPU, already. ;-)

> +#endif //CONFIG_MODULE_UNLOAD
> +		trace_mark(list_module, "%s %d %lu",
> +				mod->name, mod->state, refcount);
> +	}
> +	mutex_unlock(&module_mutex);
> +}

