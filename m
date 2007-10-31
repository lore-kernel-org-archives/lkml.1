Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbXJaCIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbXJaCIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 22:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXJaCIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 22:08:35 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:62847 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287AbXJaCIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 22:08:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAF6AJ0dMQWvU/2dsb2JhbACBWo5c
Date: Tue, 30 Oct 2007 22:08:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: fix marker warnings
Message-ID: <20071031020830.GA1176@Krystal>
References: <1193774725.24087.303.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1193774725.24087.303.camel@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:05:03 up 93 days,  2:23,  5 users,  load average: 1.19, 0.73, 0.55
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen (haveblue@us.ibm.com) wrote:
> I'm seeing these in the latest git:
> 
> kernel/marker.c: In function `marker_probe_unregister':
> kernel/marker.c:355: warning: `probe_module' might be used uninitialized in this function
> kernel/marker.c: In function `marker_probe_unregister_private_data':
> kernel/marker.c:389: warning: `probe_module' might be used uninitialized in this function
> kernel/marker.c:392: warning: `entry' might be used uninitialized in this function
> 
> It's due to gcc not detecting that the need_update condition is actually
> constant, and will never call marker_update_probes() on an uninitialized
> probe_module.
> 
> However, that need_update bit is all due to dropping the mutex before
> calling marker_update_probes().  As far as I can tell, every call to
> marker_update_probes() has this lock dropping behavior just before
> calling it.  So, let's just hold the locks over the
> marker_update_probes() and document that it needs to have a lock taken
> instead.  
> 
> This removes code overall.  Untested except for a quick compile.
> Consider it just a style suggestion. :)
> 

Ok, just ran it and it seems good. It did not appear as trivial during
development because locking was is a different order until recently.

I wonder what gcc version you are using though, because mine does not
warn about anything. I wonder if it is really necessary to "fix" false
gcc warnings like this. Let's take it as a cleanup.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> marker_probe_unregister_private_data() also has a bit of a goto mess
> that produces similar warnings.  I'll look at it next.
> 
> ---
> 
>  linux-2.6.git-dave/kernel/marker.c |   34 +++++++++++-----------------------
>  1 file changed, 11 insertions(+), 23 deletions(-)
> 
> diff -puN kernel/marker.c~fix-marker-warnings kernel/marker.c
> --- linux-2.6.git/kernel/marker.c~fix-marker-warnings	2007-10-30 12:54:36.000000000 -0700
> +++ linux-2.6.git-dave/kernel/marker.c	2007-10-30 13:03:39.000000000 -0700
> @@ -288,12 +288,13 @@ void marker_update_probe_range(struct ma
>   * Issues a synchronize_sched() when no reference to the module passed
>   * as parameter is found in the probes so the probe module can be
>   * safely unloaded from now on.
> + *
> + * must hold markers_mutex
>   */
> -static void marker_update_probes(struct module *probe_module)
> +static void __marker_update_probes(struct module *probe_module)
>  {
>  	int refcount = 0;
>  
> -	mutex_lock(&markers_mutex);
>  	/* Core kernel markers */
>  	marker_update_probe_range(__start___markers,
>  			__stop___markers, probe_module, &refcount);
> @@ -303,7 +304,6 @@ static void marker_update_probes(struct 
>  		synchronize_sched();
>  		deferred_sync = 0;
>  	}
> -	mutex_unlock(&markers_mutex);
>  }
>  
>  /**
> @@ -320,7 +320,7 @@ int marker_probe_register(const char *na
>  			marker_probe_func *probe, void *private)
>  {
>  	struct marker_entry *entry;
> -	int ret = 0, need_update = 0;
> +	int ret = 0;
>  
>  	mutex_lock(&markers_mutex);
>  	entry = get_marker(name);
> @@ -335,11 +335,9 @@ int marker_probe_register(const char *na
>  	ret = add_marker(name, format, probe, private);
>  	if (ret)
>  		goto end;
> -	need_update = 1;
> +	__marker_update_probes(NULL);
>  end:
>  	mutex_unlock(&markers_mutex);
> -	if (need_update)
> -		marker_update_probes(NULL);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(marker_probe_register);
> @@ -355,7 +353,6 @@ void *marker_probe_unregister(const char
>  	struct module *probe_module;
>  	struct marker_entry *entry;
>  	void *private;
> -	int need_update = 0;
>  
>  	mutex_lock(&markers_mutex);
>  	entry = get_marker(name);
> @@ -368,11 +365,9 @@ void *marker_probe_unregister(const char
>  	probe_module = __module_text_address((unsigned long)entry->probe);
>  	private = remove_marker(name);
>  	deferred_sync = 1;
> -	need_update = 1;
> +	__marker_update_probes(probe_module);
>  end:
>  	mutex_unlock(&markers_mutex);
> -	if (need_update)
> -		marker_update_probes(probe_module);
>  	return private;
>  }
>  EXPORT_SYMBOL_GPL(marker_probe_unregister);
> @@ -392,7 +387,6 @@ void *marker_probe_unregister_private_da
>  	struct marker_entry *entry;
>  	int found = 0;
>  	unsigned int i;
> -	int need_update = 0;
>  
>  	mutex_lock(&markers_mutex);
>  	for (i = 0; i < MARKER_TABLE_SIZE; i++) {
> @@ -414,11 +408,9 @@ iter_end:
>  	probe_module = __module_text_address((unsigned long)entry->probe);
>  	private = remove_marker(entry->name);
>  	deferred_sync = 1;
> -	need_update = 1;
> +	__marker_update_probes(probe_module);
>  end:
>  	mutex_unlock(&markers_mutex);
> -	if (need_update)
> -		marker_update_probes(probe_module);
>  	return private;
>  }
>  EXPORT_SYMBOL_GPL(marker_probe_unregister_private_data);
> @@ -434,7 +426,7 @@ EXPORT_SYMBOL_GPL(marker_probe_unregiste
>  int marker_arm(const char *name)
>  {
>  	struct marker_entry *entry;
> -	int ret = 0, need_update = 0;
> +	int ret = 0;
>  
>  	mutex_lock(&markers_mutex);
>  	entry = get_marker(name);
> @@ -447,11 +439,9 @@ int marker_arm(const char *name)
>  	 */
>  	if (entry->refcount++)
>  		goto end;
> -	need_update = 1;
>  end:
> +	__marker_update_probes(NULL);
>  	mutex_unlock(&markers_mutex);
> -	if (need_update)
> -		marker_update_probes(NULL);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(marker_arm);
> @@ -467,7 +457,7 @@ EXPORT_SYMBOL_GPL(marker_arm);
>  int marker_disarm(const char *name)
>  {
>  	struct marker_entry *entry;
> -	int ret = 0, need_update = 0;
> +	int ret = 0;
>  
>  	mutex_lock(&markers_mutex);
>  	entry = get_marker(name);
> @@ -486,11 +476,9 @@ int marker_disarm(const char *name)
>  		ret = -EPERM;
>  		goto end;
>  	}
> -	need_update = 1;
>  end:
> +	__marker_update_probes(NULL);
>  	mutex_unlock(&markers_mutex);
> -	if (need_update)
> -		marker_update_probes(NULL);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(marker_disarm);
> _
> 
> 
> -- Dave
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
