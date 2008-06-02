Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYFBPTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYFBPTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYFBPTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:19:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39858 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752364AbYFBPTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:19:09 -0400
Date: Mon, 2 Jun 2008 10:19:02 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] sched: CPU hotplug events must not destroy scheduler
 domains created by the cpusets
Message-Id: <20080602101902.cf8cdf11.pj@sgi.com>
In-Reply-To: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this patch is ok --- though (1) perhaps it should have been two patches,
as it seems to fix two bugs, and (2) I only managed to get my head about 80% of
the way around this, so while I confident enough to Ack this one, I'm not
as certain as I might be.

Acked-by: Paul Jackson <pj@sgi.com>


I did see a couple of places where the code could be more clearly presented,
and a couple of lines ending in space characters in *.c files (the Doc files
are hopelessly failing this space terminator test, so I gave up on them.)

Your patch includes the following.  Note the embedded "line ends in space"'s.

> @@ -7058,6 +7071,7 @@ static int update_sched_domains(struct notifier_block *nfb,
>  	case CPU_DOWN_PREPARE:
>  	case CPU_DOWN_PREPARE_FROZEN:
>  		detach_destroy_domains(&cpu_online_map);
> +		free_sched_domains();
>  		return NOTIFY_OK;
>  
>  	case CPU_UP_CANCELED:
> @@ -7076,8 +7090,16 @@ static int update_sched_domains(struct notifier_block *nfb,
>  		return NOTIFY_DONE;
>  	}
>  
> +#ifndef CONFIG_CPUSETS
> +	/* 

Above line ends in space.

> +	 * Create default domain partitioning if cpusets are disabled.
> +	 * Otherwise we let cpusets rebuild the domains based on the 

Above line ends in space.

> +	 * current setup.
> +	 */
> +
>  	/* The hotplug lock is already held by cpu_up/cpu_down */
>  	arch_init_sched_domains(&cpu_online_map);
> +#endif
>  
>  	return NOTIFY_OK;
>  }


The above patch, on top of the code already there, ends up with the
following code for update_sched_domains():

============================== begin ==============================
static int update_sched_domains(struct notifier_block *nfb,
                                unsigned long action, void *hcpu)
{
        switch (action) {
        case CPU_UP_PREPARE:
        case CPU_UP_PREPARE_FROZEN:
        case CPU_DOWN_PREPARE:
        case CPU_DOWN_PREPARE_FROZEN:
                detach_destroy_domains(&cpu_online_map);
                free_sched_domains();
                return NOTIFY_OK;

        case CPU_UP_CANCELED:
        case CPU_UP_CANCELED_FROZEN:
        case CPU_DOWN_FAILED:
        case CPU_DOWN_FAILED_FROZEN:
        case CPU_ONLINE:
        case CPU_ONLINE_FROZEN:
        case CPU_DEAD:
        case CPU_DEAD_FROZEN:
                /*
                 * Fall through and re-initialise the domains.
                 */
                break;
        default:
                return NOTIFY_DONE;
        }

#ifndef CONFIG_CPUSETS
        /*
         * Create default domain partitioning if cpusets are disabled.
         * Otherwise we let cpusets rebuild the domains based on the
         * current setup.
         */

        /* The hotplug lock is already held by cpu_up/cpu_down */
        arch_init_sched_domains(&cpu_online_map);
#endif

        return NOTIFY_OK;
}
=============================== end ===============================

The "Fall through", break, ifndef and out of the switch call seem to be
a more convoluted way of writing that routine than is necessary.

How about:
 1) Defining arch_init_sched_domains() for all CONFIGs, CPUSET or not
    (see for example how free_sched_groups() is defined, NUMA or not)
 2) Then the ifndef can be removed from here.
 3) Then the arch_init_sched_domains() can be moved comfortably inside
    the switch statement.

The end result would be a update_sched_domains() routine that looked
something like the following:

============================== begin ==============================
static int update_sched_domains(struct notifier_block *nfb,
                                unsigned long action, void *hcpu)
{
        switch (action) {
        case CPU_UP_PREPARE:
        case CPU_UP_PREPARE_FROZEN:
        case CPU_DOWN_PREPARE:
        case CPU_DOWN_PREPARE_FROZEN:
                detach_destroy_domains(&cpu_online_map);
                free_sched_domains();
                return NOTIFY_OK;
        case CPU_UP_CANCELED:
        case CPU_UP_CANCELED_FROZEN:
        case CPU_DOWN_FAILED:
        case CPU_DOWN_FAILED_FROZEN:
        case CPU_ONLINE:
        case CPU_ONLINE_FROZEN:
        case CPU_DEAD:
        case CPU_DEAD_FROZEN:
                arch_init_sched_domains(&cpu_online_map);
                return NOTIFY_OK;
        default:
                return NOTIFY_DONE;
        }
}
=============================== end ===============================


===

This routine:

static void free_sched_domains(void)
{
        ndoms_cur = 0;
        if (doms_cur != &fallback_doms)
                kfree(doms_cur);
        doms_cur = &fallback_doms;
}

might be easier to read as:

static void free_sched_domains(void)
{
        ndoms_cur = 0;
        if (doms_cur != &fallback_doms) {
                kfree(doms_cur);
	        doms_cur = &fallback_doms;
	}
}


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
