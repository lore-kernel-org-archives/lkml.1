Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbZHXGBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbZHXGBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZHXGBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:01:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49171 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZHXGBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:01:41 -0400
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A9214E3.2070807@cn.fujitsu.com>
References: <4A9214E3.2070807@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 08:01:00 +0200
Message-Id: <1251093660.7538.119.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 12:19 +0800, Li Zefan wrote:
> If the correspoding module is unloaded before ftrace_profile_disable()
> is called, event->profile_disable() won't be called, which can
> cause oops:
> 
>   # insmod trace-events-sample.ko
>   # perf record -f -a -e sample:foo_bar sleep 3 &
>   # sleep 1
>   # rmmod trace_events_sample
>   # insmod trace-events-sample.ko
>   OOPS!
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Hrmm, feel fragile, why don't we check if all a modules tracepoints are
unused on unload?

> ---
>  kernel/trace/trace_event_profile.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
> index 11ba5bb..55a25c9 100644
> --- a/kernel/trace/trace_event_profile.c
> +++ b/kernel/trace/trace_event_profile.c
> @@ -5,6 +5,7 @@
>   *
>   */
>  
> +#include <linux/module.h>
>  #include "trace.h"
>  
>  int ftrace_profile_enable(int event_id)
> @@ -14,7 +15,8 @@ int ftrace_profile_enable(int event_id)
>  
>  	mutex_lock(&event_mutex);
>  	list_for_each_entry(event, &ftrace_events, list) {
> -		if (event->id == event_id && event->profile_enable) {
> +		if (event->id == event_id && event->profile_enable &&
> +		    try_module_get(event->mod)) {
>  			ret = event->profile_enable(event);
>  			break;
>  		}
> @@ -32,6 +34,7 @@ void ftrace_profile_disable(int event_id)
>  	list_for_each_entry(event, &ftrace_events, list) {
>  		if (event->id == event_id) {
>  			event->profile_disable(event);
> +			module_put(event->mod);
>  			break;
>  		}
>  	}
