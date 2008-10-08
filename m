Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbYJHCni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbYJHCni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 22:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYJHCn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 22:43:29 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:63211 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884AbYJHCn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 22:43:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AowFANe660hMQWq+/2dsb2JhbACBcrxdgWo
Date: Tue, 7 Oct 2008 22:43:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: remove 2 exported symbols
Message-ID: <20081008024325.GA29227@Krystal>
References: <48EC199D.40808@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48EC199D.40808@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:38:26 up 125 days,  7:18,  9 users,  load average: 0.36, 0.49,
	0.33
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> 
> __mark_empty_function() and marker_probe_cb_noarg()
> should not be seen by outer code. this patch remove them.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/marker.h b/include/linux/marker.h
> index 1290653..f4d4d28 100644
> --- a/include/linux/marker.h
> +++ b/include/linux/marker.h
> @@ -132,12 +132,8 @@ static inline void __printf(1, 2) ___mark_check_format(const char *fmt, ...)
>  			___mark_check_format(format, ## args);		\
>  	} while (0)
>  
> -extern marker_probe_func __mark_empty_function;
> -

Hi Lai,

Hrm ? Have a good look at the macro __trace_mark() in
include/linux/marker.h, you'll see that __mark_empty_function is
referenced. Have you tested this against code with declared markers ?

>  extern void marker_probe_cb(const struct marker *mdata,
>  	void *call_private, ...);
> -extern void marker_probe_cb_noarg(const struct marker *mdata,
> -	void *call_private, ...);

This second change is correct. marker_probe_cb is referenced by
__trace_mark(), but not marker_probe_cb_noarg, which is only connected
when non-empty format string is found by the registration function in
marker.c.

>  
>  /*
>   * Connect a probe to a marker.
> diff --git a/kernel/marker.c b/kernel/marker.c
> index 7d1faec..4440a09 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -81,11 +81,10 @@ static struct hlist_head marker_table[MARKER_TABLE_SIZE];
>   * though the function pointer change and the marker enabling are two distinct
>   * operations that modifies the execution flow of preemptible code.
>   */
> -void __mark_empty_function(void *probe_private, void *call_private,
> +static void __mark_empty_function(void *probe_private, void *call_private,
>  	const char *fmt, va_list *args)
>  {
>  }
> -EXPORT_SYMBOL_GPL(__mark_empty_function);
>  

Same as comment above.

>  /*
>   * marker_probe_cb Callback that prepares the variable argument list for probes.
> @@ -157,7 +156,7 @@ EXPORT_SYMBOL_GPL(marker_probe_cb);
>   *
>   * Should be connected to markers "MARK_NOARGS".
>   */
> -void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
> +static void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
>  {
>  	va_list args;	/* not initialized */
>  	char ptype;
> @@ -197,7 +196,6 @@ void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
>  	}
>  	preempt_enable();
>  }
> -EXPORT_SYMBOL_GPL(marker_probe_cb_noarg);
>  

This one is ok.

So overall, if you could check why you have not hit any problem when
removing __mark_empty_function, that would be great. The only reason I
see is that you had no markers in your kernel test code.

Mathieu

>  static void free_old_closure(struct rcu_head *head)
>  {
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
