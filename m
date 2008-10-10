Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYJJHbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYJJHbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 03:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYJJHbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 03:31:38 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:32941 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028AbYJJHbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 03:31:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAC6d7khMQWq+/2dsb2JhbACBcrtLgWo
Date: Fri, 10 Oct 2008 03:31:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: bit-field is not thread-safe nor smp-safe
Message-ID: <20081010073136.GC23247@Krystal>
References: <48EEF9AD.9040401@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48EEF9AD.9040401@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 03:23:47 up 127 days, 12:04,  9 users,  load average: 0.36, 0.51,
	0.42
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> 
> bit-field is not thread-safe nor smp-safe.
> 
> struct marker_entry.rcu_pending is not protected by any lock
> in rcu-callback free_old_closure().
> so we must turn it into a safe type.
> 


hrm, yes, you are right. I first test for 

        if (entry->rcu_pending)
           rcu_barrier_sched();

To check if I must execute the rcu callback, and _this_ races against
the entry->rcu_pending = 0; within the callback.

Your fix is therefore needed.

Thanks !

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> detail:
> 
> I suppose rcu_pending and ptype are store in struct marker_entry.tmp1
> 
> free_old_closure() side:           change ptype side:
> 
>                                 |  load struct marker_entry.tmp1
> --------------------------------|--------------------------------
>                                 |  change ptype bit in tmp1
> load struct marker_entry.tmp1   |
> change rcu_pending bit in tmp1  |
> store tmp1                      |
> --------------------------------|--------------------------------
>                                 |  store tmp1
> 
> now this result equals that free_old_closure() do not change rcu_pending
> bit, bug! This bug will cause redundant rcu_barrier_sched() called.
> not too harmful.
> 
> ----- corresponding:
> 
> free_old_closure() side:           change ptype side:
> 
> load struct marker_entry.tmp1   |
> --------------------------------|--------------------------------
>                                 |  load struct marker_entry.tmp1
> change rcu_pending bit in tmp1  |
>                                 |  change ptype bit in tmp1
>                                 |  store tmp1
> --------------------------------|--------------------------------
> store tmp1                      |
> 
> now this result equals that change ptype side do not change ptype
> bit, bug! this bug cause marker_probe_cb() access to invalid memory.
> oops!
> 
> see also: http://en.wikipedia.org/wiki/Bit_field
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/marker.c b/kernel/marker.c
> index 7d1faec..95c62da 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -62,7 +62,7 @@ struct marker_entry {
>  	int refcount;	/* Number of times armed. 0 if disarmed. */
>  	struct rcu_head rcu;
>  	void *oldptr;
> -	unsigned char rcu_pending:1;
> +	int rcu_pending;
>  	unsigned char ptype:1;
>  	char name[0];	/* Contains name'\0'format'\0' */
>  };
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
