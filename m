Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbZGFNp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbZGFNp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbZGFNpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:45:50 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:54063 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179AbZGFNps convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:45:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhoFAPecUUpMQWU3/2dsb2JhbACBUctFhBIF
Date: Mon, 6 Jul 2009 09:45:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Thomas Renninger <trenn@suse.de>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, kernel-testers@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: cpufreq cleanups - .30 vs .31
Message-ID: <20090706134531.GB7082@Krystal>
References: <200907061318.20839.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200907061318.20839.trenn@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:36:25 up 128 days, 10:02,  3 users,  load average: 1.79, 1.13,
	0.99
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Renninger (trenn@suse.de) wrote:
> Hi Dave,
> 
> this is about Venki's and Mathieu's recently sent cleanups.
> I'd like to summarize this to help finding a solution:
> 
> IMO Venki's approach (making .governor() always be called with
> rwsem held) is the cleaner one and this should be the way to
> go for .31 and future. This better separates locking responsibilities
> between cpufreq core and governors and brings back "design" into this.
> 
> One could argue that for .30 Mathieu's is better, because less
> intrusive. It's up to Dave in the end, but:
> [patch 2.6.30 1/4] remove rwsem lock from CPUFREQ_GOV_STOP call (second call 
> site)
> should not be the way to go for .31 and I'd vote for Venki's
> approach concerning locking .governor() against multiple calls (done by
> rwsem) and governor() vs do_dbs_timer calls (governor's job with a governor
> specific sem).
> 
> So if not find too intrusive, I'd say:
> Venkatesh's whole series of:
> [patch 0/4] Take care of cpufreq lockdep issues (take 2)
> should be seen in .31.
> 
> Depending on how intrusive this is seen, Venki's first patch:
> [patch 1/4] cpufreq: Eliminate the recent lockdep warnings in cpufreq
> should then go to .30 (after still waiting a bit?)
> or Mathieu's approach (I'd vote for Venki's to be consistent for .30 and .31).
> 
> The one patch from Mathieu:
> [patch 2.6.30 2/4] CPUFREQ: fix (utter) cpufreq_add_dev mess
> is a separate, general cleanup which should show up in .31.
> 
> 
> 
> I still have two patch specific questions:
> about Mathieu's (it's a minor issue in the error path):
> [patch 2.6.30 2/4] CPUFREQ: fix (utter) cpufreq_add_dev mess
> 
> +                       if (lock_policy_rwsem_write(cpu) < 0) {
> +                               /* Should not go through policy unlock path */
> +                               if (cpufreq_driver->exit)
> +                                       cpufreq_driver->exit(policy);
> +                               ret = -EBUSY;
> +                               cpufreq_cpu_put(managed_policy);
> Shouldn't:
>  cpufreq_cpu_put(managed_policy);
> be called before:
>  cpufreq_driver->exit(policy);
> Just in case the driver itself wants to grab the policy of the
> managed cpu?
> 

If we want to make it perfectly similar to the error path:

(note : this is a success path if ret = 0, and error path if ret != 0)

ret != 0 :
                        if (!ret)
                              cpufreq_cpu_put(managed_policy);
                        /*
                         * Success. We only needed to be added to the mask.
                         * Call driver->exit() because only the cpu parent of
                         * the kobj needed to call init().
                         */
                        goto out_driver_exit; /* call driver->exit() */

Then yes, we might be tempted to flip the cpu_put and exit.

But given cpu_put just decrements a reference counter (and performs
cleanup if needed), then even if ->exit() takes a reference count
somehow, this will just make the code hold 2 refcounts temporarily.

And I prefer to keep this refcount thorough ->exit() call, because we
don't hold any policy_rwsem at this point : we are in a lock acquisition
error path. It's therefore safer to keep the refcount to ensure that
data won't vanish.

Mathieu

> 
> about Venki's:
> [patch 3/4] cpufreq: Cleanup locking in ondemand governor
> Isn't it possible to use only one mutex(timer_mutex) to protect do_dbs_timer 
> against governor start, stop, limit?
> Then dbs_mutex would only be used to protect against concurrent sysfs access
> and can be thrown away as soon as ondemand only provides global sysfs files,
> not per cpu ones.
> 
> Hmm, maybe this should just go in? It eases up things, but it's still hard
> to follow up each detail. Fixes/enhancements can still be put on top
> for .31.
> 
>   Thomas
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
