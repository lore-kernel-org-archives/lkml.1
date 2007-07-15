Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbXGOBdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbXGOBdM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 21:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbXGOBc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 21:32:58 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:39841 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755584AbXGOBc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 21:32:58 -0400
Date: Sat, 14 Jul 2007 21:32:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Immediate Value - Architecture Independent Code Deferred Sync
Message-ID: <20070715013256.GD23209@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012623.231272637@polymtl.ca> <20070714235243.GA20571@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714235243.GA20571@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:32:19 up 7 days, 15:37,  2 users,  load average: 0.35, 0.21, 0.14
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please drop, wrong thread. Will repost in the right one.

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Linux Kernel Markers - Architecture Independent Code Deferred Sync
> 
> Upon marker probe_unregister, we delay call to synchronize_sched() to
> accelerate mass unregistration (only when there is no more reference to a
> give module do we call synchronize_sched()). However, we need to make sure
> every critical region have ended before we re-arm a marker that has been
> unregistered and then registered back with a different probe data.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Christoph Hellwig <hch@infradead.org>
> ---
>  kernel/marker.c |   22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6-lttng/kernel/marker.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/marker.c	2007-07-14 19:38:11.000000000 -0400
> +++ linux-2.6-lttng/kernel/marker.c	2007-07-14 19:46:25.000000000 -0400
> @@ -30,11 +30,21 @@ extern struct __mark_marker __stop___mar
>  
>  /*
>   * module_mutex nests inside markers_mutex. Markers mutex protects the builtin
> - * and module markers, and the hash table.
> + * and module markers, the hash table and deferred_sync.
>   */
>  DEFINE_MUTEX(markers_mutex);
>  
>  /*
> + * Marker deferred synchronization.
> + * Upon marker probe_unregister, we delay call to synchronize_sched() to
> + * accelerate mass unregistration (only when there is no more reference to a
> + * give module do we call synchronize_sched()). However, we need to make sure
> + * every critical region have ended before we re-arm a marker that has been
> + * unregistered and then registered back with a different probe data.
> + */
> +static int deferred_sync;
> +
> +/*
>   * Marker hash table, containing the active markers.
>   * Protected by module_mutex.
>   */
> @@ -303,8 +313,10 @@ static inline void __marker_update_probe
>  			__stop___markers, probe_module, &refcount);
>  	/* Markers in modules. */
>  	__marker_update_probes_modules(probe_module, &refcount);
> -	if (probe_module && refcount == 0)
> +	if (probe_module && refcount == 0) {
>  		synchronize_sched();
> +		deferred_sync = 0;
> +	}
>  }
>  
>  #ifdef CONFIG_MODULES
> @@ -353,6 +365,10 @@ int marker_probe_register(const char *na
>  		ret = -EBUSY;
>  		goto end;
>  	}
> +	if (deferred_sync) {
> +		synchronize_sched();
> +		deferred_sync = 0;
> +	}
>  	ret = _add_marker(name, format, probe, pdata);
>  	if (ret)
>  		goto end;
> @@ -384,6 +400,7 @@ void *marker_probe_unregister(const char
>  	/* In what module is the probe handler ? */
>  	probe_module = __module_text_address((unsigned long)entry->probe);
>  	pdata = _remove_marker(name);
> +	deferred_sync = 1;
>  	_marker_update_probes(probe_module);
>  end:
>  	mutex_unlock(&markers_mutex);
> @@ -425,6 +442,7 @@ iter_end:
>  	/* In what module is the probe handler ? */
>  	probe_module = __module_text_address((unsigned long)entry->probe);
>  	pdata = _remove_marker(entry->name);
> +	deferred_sync = 1;
>  	_marker_update_probes(probe_module);
>  end:
>  	mutex_unlock(&markers_mutex);
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
