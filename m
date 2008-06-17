Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbYFQOHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbYFQOHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbYFQOHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:07:45 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:64837 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755250AbYFQOHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:07:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAL1cV0hMQW1O/2dsb2JhbACBW60T
Date: Tue, 17 Jun 2008 10:07:42 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: tzanussi@gmail.com, linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 2/3] Better interface for hooking early initcalls.
Message-ID: <20080617140742.GD10316@Krystal>
References: <20080615180508.71d1cbcc@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080615180508.71d1cbcc@linux360.ro>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:03:40 up 12 days, 18:44,  4 users,  load average: 0.99, 0.68,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> Added early initcall (pre-SMP) support, using an identical interface to
> that of regular initcalls. Functions called from do_pre_smp_initcalls()
> could be converted to use this cleaner interface.
> 
> This is required by CPU hotplug, because early users have to register
> notifiers before going SMP. One such CPU hotplug user is the relay
> interface with buffer-only channels, which needs to register such a
> notifier, to be usable in early code. This in turn is used by kmemtrace.
> 

I am not sure it's worth it trying to define a generic "early" initcall,
since definition of "how early it is" may change with time.

Currently, it's earlier than SMP init, but later on, it could become
earlier than mm init. If there are only few users of this, and given
that they must be designed "knowing" how early they are initialized wrt
other subsystems, I think it would make sense to call them directly from
the init code without putting them in a "early initcall" category.

> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
 .... 
> -extern initcall_t __initcall_start[], __initcall_end[];
> +extern initcall_t __initcall_start[], __initcall_end[], __early_initcall_end[];
>  
>  static void __init do_initcalls(void)
>  {
>  	initcall_t *call;
>  
> -	for (call = __initcall_start; call < __initcall_end; call++)
> +	for (call = __early_initcall_end; call < __initcall_end; call++)
>  		do_one_initcall(*call);
>  
>  	/* Make sure there is no pending stuff from the initcall sequence */
> @@ -775,6 +775,14 @@ static int __init nosoftlockup_setup(char *str)
>  }
>  __setup("nosoftlockup", nosoftlockup_setup);
>  
> +static void __init __do_pre_smp_initcalls(void)
> +{
> +	initcall_t *call;
> +
> +	for (call = __initcall_start; call < __early_initcall_end; call++)
> +		(*call)();

why not do_one_initcall(*call); ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
