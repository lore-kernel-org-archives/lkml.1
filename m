Return-Path: <linux-kernel-owner+w=401wt.eu-S932517AbZKSD55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbZKSD55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 22:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932424AbZKSD55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 22:57:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405AbZKSD54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 22:57:56 -0500
Message-ID: <4B04C2AF.4040509@redhat.com>
Date: Wed, 18 Nov 2009 22:59:43 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] notifier atomic call chain notrace
References: <cover.1258580048.git.jbaron@redhat.com> <14acd28665b633909f7e9873861075fd657e9a52.1258580048.git.jbaron@redhat.com> <20091118233815.GA28962@Krystal>
In-Reply-To: <20091118233815.GA28962@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
>> Note that this is conditional on gcc >= 4.5. Also there is a !lockdep
>> condition. This is b/c the die_notifier takes an rcu_read_lock() on the
>> int3 trap, which then causes another one etc. Since, we aren't going to be
>> installing removing the handler, the rcu_read_lock() could be avoided for this
>> case with some code restructuring.
>>
> [snip]
> 
> Would the following patch help ? I use it in the LTTng tree to alleviate
> this problem.

Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>

The code itself seems OK for me. :-)

I'd just like to hear the opinion from Ingo, since
this change will change all atomic-notifier's locks to
notrace.

> notifier atomic call chain notrace
> 
> In LTTng, being able to use the atomic notifier from cpu idle entry to
> ensure the tracer flush the last events in the current subbuffer
> requires the rcu read-side to be marked "notrace", otherwise it can end
> up calling back into lockdep and the tracer.
> 
> Also apply to the the die notifier.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Jason Baron <jbaron@redhat.com>
> CC: mingo@elte.hu
> ---
>  kernel/notifier.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6-lttng/kernel/notifier.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/notifier.c	2009-11-12 17:58:56.000000000 -0500
> +++ linux-2.6-lttng/kernel/notifier.c	2009-11-12 18:03:28.000000000 -0500
> @@ -148,7 +148,7 @@ int atomic_notifier_chain_unregister(str
>  	spin_lock_irqsave(&nh->lock, flags);
>  	ret = notifier_chain_unregister(&nh->head, n);
>  	spin_unlock_irqrestore(&nh->lock, flags);
> -	synchronize_rcu();
> +	synchronize_sched();
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
> @@ -178,9 +178,9 @@ int __kprobes __atomic_notifier_call_cha
>  {
>  	int ret;
>  
> -	rcu_read_lock();
> +	rcu_read_lock_sched_notrace();
>  	ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
> -	rcu_read_unlock();
> +	rcu_read_unlock_sched_notrace();
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(__atomic_notifier_call_chain);
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

