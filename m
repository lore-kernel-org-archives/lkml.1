Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbYBZC7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbYBZC7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 21:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbYBZC7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 21:59:07 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:60056 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbYBZC7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 21:59:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAMoOw0dMQWRV/2dsb2JhbACBVapl
Date: Mon, 25 Feb 2008 21:59:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Don't risk NULL deref in marker
Message-ID: <20080226025902.GA13199@Krystal>
References: <200802260014.24253.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200802260014.24253.jesper.juhl@gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:57:28 up 14 days, 22:57,  3 users,  load average: 0.19, 0.37,
	0.41
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesper Juhl (jesper.juhl@gmail.com) wrote:
> 
> get_marker() may return NULL, so test for it.
> 

Hrm, yes, if we have two marker_probe_unregister callers calling it for
the same marker, one expecting it to fail and they race, yes, it can
happen. Although this is not expected to happen often if the caller acts
sanely, it's a good thing to fix it. Thanks!

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
> diff --git a/kernel/marker.c b/kernel/marker.c
> index 50effc0..f211f08 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -698,12 +698,11 @@ int marker_probe_unregister(const char *name,
>  {
>  	struct marker_entry *entry;
>  	struct marker_probe_closure *old;
> -	int ret = 0;
> +	int ret = -ENOENT;
>  
>  	mutex_lock(&markers_mutex);
>  	entry = get_marker(name);
>  	if (!entry) {
> -		ret = -ENOENT;
>  		goto end;
>  	}
>  	if (entry->rcu_pending)
> @@ -713,12 +712,16 @@ int marker_probe_unregister(const char *name,
>  	marker_update_probes();		/* may update entry */
>  	mutex_lock(&markers_mutex);
>  	entry = get_marker(name);
> +	if (!entry) {
> +		goto end;
> +	}
>  	entry->oldptr = old;
>  	entry->rcu_pending = 1;
>  	/* write rcu_pending before calling the RCU callback */
>  	smp_wmb();
>  	call_rcu(&entry->rcu, free_old_closure);
>  	remove_marker(name);	/* Ignore busy error message */
> +	ret = 0;
>  end:
>  	mutex_unlock(&markers_mutex);
>  	return ret;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
