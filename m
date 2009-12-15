Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbZLOECa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbZLOECa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbZLOEC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:02:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:49016 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567AbZLOEC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:02:28 -0500
Message-ID: <4B270AA6.3050307@kernel.org>
Date: Tue, 15 Dec 2009 13:03:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [this_cpu_xx V7 7/8] Module handling: Use this_cpu_xx to dynamically
 allocate counters
References: <20091214220320.665065925@quilx.com> <20091214220342.473600725@quilx.com>
In-Reply-To: <20091214220342.473600725@quilx.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Rusty Russell cc'd.)

On 12/15/2009 07:03 AM, Christoph Lameter wrote:
> @@ -479,15 +467,15 @@ static inline int try_module_get(struct 
>  	int ret = 1;
>  
>  	if (module) {
> -		unsigned int cpu = get_cpu();
>  		if (likely(module_is_live(module))) {
> -			local_inc(__module_ref_addr(module, cpu));
> +			preempt_disable();
> +			__this_cpu_inc(module->refptr->count);
>  			trace_module_get(module, _THIS_IP_,
> -				local_read(__module_ref_addr(module, cpu)));
> +				__this_cpu_read(module->refptr->count));
> +			preempt_enable();
>  		}
>  		else
>  			ret = 0;
> -		put_cpu();

I think you need preemption disabled while checking whether
module_is_live().  The state is protected by stop_machine or
synchronize_sched().

Thanks.

-- 
tejun
