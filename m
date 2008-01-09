Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbYAIXoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbYAIXoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYAIXoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:44:01 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60454 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754018AbYAIXn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:43:59 -0500
Date: Wed, 9 Jan 2008 15:42:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, len.brown@intel.com, venkatesh.pallipadi@intel.com,
       abelay@novell.com, a.p.zijlstra@chello.nl, ak@suse.de
Subject: Re: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
Message-Id: <20080109154251.c70798d5.akpm@linux-foundation.org>
In-Reply-To: <1199911330.975.3.camel@localhost.localdomain>
References: <1199759244.26343.35.camel@localhost.localdomain>
	<20080108033329.GI2998@bingen.suse.de>
	<1199911330.975.3.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait

s/cpus_/cpu_/

On Wed, 09 Jan 2008 15:42:10 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> This patch is different than the first patch I sent out.
> This one just sends an IPI to all CPUS that don't check in after 1 sec.
> 
> 
> Sometimes cpu_idle_wait gets stuck because it might miss CPUS that are
> already in idle, have no tasks waiting to run and have no interrupts
> going to them.  This is common on bootup when switching cpu idle
> governors.
> 
> This patch gives those CPUS that don't check in an IPI kick.
> 

(wakes up)

> 
> Index: linux-compile-i386.git/arch/x86/kernel/process_32.c
> ===================================================================
> --- linux-compile-i386.git.orig/arch/x86/kernel/process_32.c	2008-01-09 14:09:36.000000000 -0500
> +++ linux-compile-i386.git/arch/x86/kernel/process_32.c	2008-01-09 14:09:45.000000000 -0500
> @@ -204,6 +204,10 @@ void cpu_idle(void)
>  	}
>  }
>  
> +static void do_nothing(void *unused)
> +{
> +}
> +
>  void cpu_idle_wait(void)
>  {
>  	unsigned int cpu, this_cpu = get_cpu();
> @@ -228,6 +232,13 @@ void cpu_idle_wait(void)
>  				cpu_clear(cpu, map);
>  		}
>  		cpus_and(map, map, cpu_online_map);
> +		/*
> +		 * We waited 1 sec, if a CPU still did not call idle
> +		 * it may be because it is in idle and not waking up
> +		 * because it has nothing to do.
> +		 * Give all the remaining CPUS a kick.
> +		 */
> +		smp_call_function_mask(map, do_nothing, 0, 0);
>  	} while (!cpus_empty(map));
>  
>  	set_cpus_allowed(current, tmp);

This seems rather hacky.  Although it may turn out to be the most efficient
fix, dunno.

I'd have thought that the right fix would be to plug the race which you
described at the top-of-thread.  That might require some redesign, but it
sounds like the design is wrong anyway.

Maybe your proposed fix is suitable for a 2.6.24 bandaid..

<looks at cpu_idle_wait()>

<pokes his tongue out at the person who put in a global,
exported-to-modules interface and didn't bother documenting it>

OK, it's called infrequently, so a few extra IPIs there won't hurt.


btw, it's pretty damn sad that cpu_idle_wait() will always stall for at
least one second.  That's a huge amount of time and I bet it's thousands of
times longer than is actually needed..
