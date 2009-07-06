Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZGFRW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZGFRW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 13:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZGFRWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 13:22:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:56610 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbZGFRWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 13:22:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,357,1243839600"; 
   d="scan'208";a="530521850"
Subject: Re: cpufreq cleanups - .30 vs .31
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <200907061318.20839.trenn@suse.de>
References: <200907061318.20839.trenn@suse.de>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 10:20:25 -0700
Message-Id: <1246900825.11545.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 04:18 -0700, Thomas Renninger wrote:
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
> +                       if (lock_policy_rwsem_write(cpu) < 0) {
> +                               /* Should not go through policy unlock path */
> +                               if (cpufreq_driver->exit)
> +                                       cpufreq_driver->exit(policy);
> +                               ret = -EBUSY;
> +                               cpufreq_cpu_put(managed_policy);
> Shouldn't:
>  cpufreq_cpu_put(managed_policy);
> be called before:
>  cpufreq_driver->exit(policy);
> Just in case the driver itself wants to grab the policy of the
> managed cpu?
> 
> 
> about Venki's:
> [patch 3/4] cpufreq: Cleanup locking in ondemand governor
> Isn't it possible to use only one mutex(timer_mutex) to protect do_dbs_timer 
> against governor start, stop, limit?
> Then dbs_mutex would only be used to protect against concurrent sysfs access
> and can be thrown away as soon as ondemand only provides global sysfs files,
> not per cpu ones.
> 

dbs_mutex (or some other global lock) is also needed at the places where
dbs_enable is changed and used. Yes having dbs_mutex exclusively for
dbs_tuners makes code cleaner. I would say, making ondemand providing
global sysfs/debugfs files is a better thing to do sooner.

Thanks,
Venki

