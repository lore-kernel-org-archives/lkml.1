Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbZGGW7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbZGGW7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 18:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZGGW7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 18:59:23 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:40746 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756017AbZGGW7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 18:59:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAE5wU0pMQWU3/2dsb2JhbACBUc5LhAcF
Date: Tue, 7 Jul 2009 18:59:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "rjw@sisk.pl" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "sven.wegener@stealer.net" <sven.wegener@stealer.net>
Subject: Re: [patch 2.6.30 3/4] cpufreq add gov mutex
Message-ID: <20090707225914.GA19217@Krystal>
References: <20090703152514.903448283@polymtl.ca> <20090703152714.953585501@polymtl.ca> <7E82351C108FA840AB1866AC776AEC4669BFF0DE@orsmsx505.amr.corp.intel.com> <20090703193655.GA20266@Krystal> <1246906203.11545.47.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1246906203.11545.47.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:50:41 up 129 days, 19:16,  3 users,  load average: 0.02, 0.12,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pallipadi, Venkatesh (venkatesh.pallipadi@intel.com) wrote:
> On Fri, 2009-07-03 at 12:36 -0700, Mathieu Desnoyers wrote:
> > * Pallipadi, Venkatesh (venkatesh.pallipadi@intel.com) wrote:
> > >  
> > > 
> > > >-----Original Message-----
> > > >From: Mathieu Desnoyers [mailto:mathieu.desnoyers@polymtl.ca] 
> > > >Sent: Friday, July 03, 2009 8:25 AM
> > > >To: linux-kernel@vger.kernel.org; Pallipadi, Venkatesh; Dave 
> > > >Jones; Thomas Renninger; cpufreq@vger.kernel.org; 
> > > >kernel-testers@vger.kernel.org; Ingo Molnar; rjw@sisk.pl; Dave 
> > > >Young; Pekka Enberg
> > > >Cc: Mathieu Desnoyers; Li, Shaohua; Rusty Russell; 
> > > >sven.wegener@stealer.net
> > > >Subject: [patch 2.6.30 3/4] cpufreq add gov mutex
> > > >
> > > >Using the cpufreq_gov_mutex to protect internal governor data 
> > > >structures. The
> > > >policy rwsem write lock nests inside this mutex. 
> > > 
> > > This makes the whole locking in cpufreq upside down. Takes away
> > > most of the reason for existence of rwsem lock. Taking a smaller
> > > Percpu rwsem lock inside a bigger global mutex doesn't seem right.
> > > 
> > 
> > It permits the timer handler to only take the rwsem write lock. My
> > understanding is that the most frequent operation is the timer handler
> > being executed, but maybe I'm wrong ?
> > 
> > I think it ends up being a questions of clearly identifying how
> > frequent each data structure access are, and why this per-governor rwsem
> > is needed at all. (does it bring any perceivable performance improvement
> > on a critical path ? Then maybe we should use RCU ?)
> > 
> > I really wonder if the fact that you switch the timer handler from rwsem
> > to a mutex in your patchset will not hurt performance in some way or
> > have some unforeseen side-effect. This is why I made my patchset as dumb
> > and simple as possible, because this is a bugfix for 2.6.30, not a
> > reingineering. Let's make it work, then make it fast.
> 
> timer handler is frequent and not short lived. I agree with 2.6.30
> solution to be simple and not worrying about performance. That is the
> reason I moved dbs_mutex into timer path., we need minimal and safe
> solution for .30. That was with
>  3 files changed, 24 insertions(+), 34 deletions(-)
> 
> Ones the rest of the cleanups gets enough testing and if they indeed
> make into later releases, it can always be backported to .30.something
> if timer locking causes some side effects.
> 
> The changes here is lot more and makes already complicated and ugly
> locking uglier. After some time no one will know why we have locks
> spread in so many different files getting called from some other file.
> 
> > > >The policy 
> > > >rwsem is taken in
> > > >the timer handler, and therefore cannot be held while doing a 
> > > >sync teardown of
> > > >the timer.  This cpufreq_gov_mutex lock protects init/teardown 
> > > >of governor
> > > >timers.
> > > 
> > > Why is the protection required for init/teardown of percpu
> > > timer with a global mutex? cpufreq rwsem (when held correctly)
> > > ensures that there can be only one store_scaling_governor for
> > > a cpu at any point in time. I don't see any reason why we need
> > > a global mutex to protect timer init teardown.
> > > 
> > 
> > rwsem was previously held in the timer handler. I am not yet convinced
> > that simply holding a local dbs_mutex will ensure proper synchronization
> > of *all* call paths in the timer handler.
> 
> All call paths of timer handler? May be I am missing something. It is
> only called from the delayed work. It gets sync stopped from GOV_STOP,
> so no need of locking there. It gets started from GOV_START where timer
> can never be active (STOP would have already stopped it if it was
> running before) and no need of any locking there.
> Or did you mean callpaths inside?

Yep, see below,

> ondemand will not depend on anythong
> from cpufreq core other than policy limit changes. It obviously cannot
> be running when add_dev or remove_dev stuff is going on.

I am worried about potential races between add_dev/remove_dev, which
currently lock the rwsem as mean of protection, and execution of timer
handler that would not take the rwsem to protect itself anymore, due to
your changes.

I'm especially worried about the call to 

              __cpufreq_driver_target(dbs_info->cur_policy,
                        dbs_info->freq_lo, CPUFREQ_RELATION_H);

which seems to depend on policy-level information, protected at the
rwsem-level.

By removing the rwsem from the timer handler, I don't see how you plan
to protect this information from add_dev/remove_dev execution.

> It doesn't
> really care about someone reading scaling_available_frequencies or
> scaling_available_governors etc from cpufreq core.
> dbs_mutex in timer is just the simple and dumb fix to resolve the
> deadlock that we have now.
> 
> > So given I prefer to do the least intrusive modification, I leave the
> > rwsem write lock in the timer handler, but it leaves no choice but to
> > take a mutex _outside_ of the rwsem lock to synchronize timer
> > init/teardown.
> > 
> > > 
> > > > This is why this lock, although it protects a data 
> > > >structure located
> > > >within the governors, is located in cpufreq.c.
> > > 
> > > I think this is taking a step back in terms of locking. A system
> > > wide Cpufreq_gov_mutex is being held more frequently now and seems
> > > to be providing all the serialization needed. The locks crossing
> > > layers of cpufreq core and governor is just going to make
> > > situation worse IMO.
> > 
> > Can you prove that my simple bugfix will cause a significant performance
> > regression ?
> 
> I am not saying it is a performance regression. I am saying it is making
> things more messy and confusing and can only add to the complications we
> have. Given the other simple alternative patch we have...
> 
> > > 
> > > If we really want to pursue this option, we should get rid
> > > of rwsem altogether. It is not adding much value
> > > and just providing lot more confusion with things like rwsem
> > > should be held everywhere else other than CPUFREQ_GOV_STOP.
> > > 
> > 
> > I agree that this rwsem is just odd. But please keep its removal for
> > 2.6.32, and consider using RCU then if performance really matters.
> > 
> > And please don't try to overengineer a simple bugfix. The bogus mutex
> > removal you proposed a few weeks ago turned me into the "cautious" mode.
> 
> <finger_pointing>
> The whole deadlock problem started from this incomplete/bogus bug fix
> 
> commit b14893a62c73af0eca414cfed505b8c09efc613c
> [CPUFREQ] fix timer teardown in ondemand governor
> 
> which created more problems than it fixed.
> </finger_pointing>

My laptop stopped crashing randomly each week after this fix, but a
reverse locking dependency chain was created. To me, it fixed problems
and caused rarer problems for which warnings were clearer. Please let's
not fight on this, it's useless.  I'm just stating why I'm being
cautious here, and this is mainly because the code seems to be
spaghetti-like fragile. :-)

> 
> > And looking at the general code quality of cpufreq (timer teardown
> > races, error path not handled, unbalanced locks, cpu hotplug support
> > broken) makes me vote for the most utterly simple solution. I currently
> > don't care about performance _at all_. I care about something as simple
> > as making sure this thing stop blowing up.
> > 
> 
> I think we are on the same page with respect to simple fix and not
> bothering about performance for now. But, our opinions differ on what
> simple bug fix is in this case. Anyways, we have two alternatives here
> and I will be happy to let Dave pick the solution he likes the best.
> 

Yep.

Thanks,

Mathieu

> Thanks,
> Venki
> 
> > > >
> > > >Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > > >CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > > >CC: rjw@sisk.pl
> > > >CC: mingo@elte.hu
> > > >CC: Shaohua Li <shaohua.li@intel.com>
> > > >CC: Pekka Enberg <penberg@cs.helsinki.fi>
> > > >CC: Dave Young <hidave.darkstar@gmail.com>
> > > >CC: "Rafael J. Wysocki" <rjw@sisk.pl>
> > > >CC: Rusty Russell <rusty@rustcorp.com.au>
> > > >CC: sven.wegener@stealer.net
> > > >CC: cpufreq@vger.kernel.org
> > > >CC: Thomas Renninger <trenn@suse.de>
> > > >---
> > > > drivers/cpufreq/cpufreq.c |   38 
> > > >+++++++++++++++++++++++++++++++++++---
> > > > 1 file changed, 35 insertions(+), 3 deletions(-)
> > > >
> > > >Index: linux-2.6-lttng/drivers/cpufreq/cpufreq.c
> > > >===================================================================
> > > >--- linux-2.6-lttng.orig/drivers/cpufreq/cpufreq.c	
> > > >2009-07-03 09:48:35.000000000 -0400
> > > >+++ linux-2.6-lttng/drivers/cpufreq/cpufreq.c	2009-07-03 
> > > >10:12:44.000000000 -0400
> > > >@@ -133,6 +133,17 @@ pure_initcall(init_cpufreq_transition_no
> > > > static LIST_HEAD(cpufreq_governor_list);
> > > > static DEFINE_MUTEX(cpufreq_governor_mutex);
> > > > 
> > > >+/*
> > > >+ * Using the cpufreq_gov_mutex to protect internal governor
> > > >+ * data structures. The policy rwsem write lock nests inside 
> > > >this mutex.
> > > >+ * The policy rwsem is taken in the timer handler, and 
> > > >therefore cannot be
> > > >+ * held while doing a sync teardown of the timer.
> > > >+ * This cpufreq_gov_mutex lock protects init/teardown of 
> > > >governor timers.
> > > >+ * This is why this lock, although it protects a data 
> > > >structure located within
> > > >+ * the governors, is here.
> > > >+ */
> > > >+static DEFINE_MUTEX(cpufreq_gov_mutex);
> > > >+
> > > > struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
> > > > {
> > > > 	struct cpufreq_policy *data;
> > > >@@ -725,6 +736,7 @@ static ssize_t store(struct kobject *kob
> > > > 	if (!policy)
> > > > 		goto no_policy;
> > > > 
> > > >+	mutex_lock(&cpufreq_gov_mutex);
> > > > 	if (lock_policy_rwsem_write(policy->cpu) < 0)
> > > > 		goto fail;
> > > > 
> > > >@@ -735,6 +747,7 @@ static ssize_t store(struct kobject *kob
> > > > 
> > > > 	unlock_policy_rwsem_write(policy->cpu);
> > > > fail:
> > > >+	mutex_unlock(&cpufreq_gov_mutex);
> > > > 	cpufreq_cpu_put(policy);
> > > > no_policy:
> > > > 	return ret;
> > > >@@ -823,6 +836,7 @@ static int cpufreq_add_dev(struct sys_de
> > > > 
> > > > 	/* Initially set CPU itself as the policy_cpu */
> > > > 	per_cpu(policy_cpu, cpu) = cpu;
> > > >+	mutex_lock(&cpufreq_gov_mutex);
> > > > 	ret = (lock_policy_rwsem_write(cpu) < 0);
> > > > 	WARN_ON(ret);
> > > > 
> > > >@@ -875,7 +889,7 @@ static int cpufreq_add_dev(struct sys_de
> > > > 					cpufreq_driver->exit(policy);
> > > > 				ret = -EBUSY;
> > > > 				cpufreq_cpu_put(managed_policy);
> > > >-				goto err_free_cpumask;
> > > >+				goto err_unlock_gov_mutex;
> > > > 			}
> > > > 
> > > > 			spin_lock_irqsave(&cpufreq_driver_lock, flags);
> > > >@@ -964,6 +978,7 @@ static int cpufreq_add_dev(struct sys_de
> > > > 	}
> > > > 
> > > > 	unlock_policy_rwsem_write(cpu);
> > > >+	mutex_unlock(&cpufreq_gov_mutex);
> > > > 
> > > > 	kobject_uevent(&policy->kobj, KOBJ_ADD);
> > > > 	module_put(cpufreq_driver->owner);
> > > >@@ -989,6 +1004,8 @@ out_driver_exit:
> > > > 
> > > > err_unlock_policy:
> > > > 	unlock_policy_rwsem_write(cpu);
> > > >+err_unlock_gov_mutex:
> > > >+	mutex_unlock(&cpufreq_gov_mutex);
> > > > err_free_cpumask:
> > > > 	free_cpumask_var(policy->cpus);
> > > > err_free_policy:
> > > >@@ -1028,6 +1045,7 @@ static int __cpufreq_remove_dev(struct s
> > > > 		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
> > > > 		cpufreq_debug_enable_ratelimit();
> > > > 		unlock_policy_rwsem_write(cpu);
> > > >+		mutex_unlock(&cpufreq_gov_mutex);
> > > > 		return -EINVAL;
> > > > 	}
> > > > 	per_cpu(cpufreq_cpu_data, cpu) = NULL;
> > > >@@ -1045,6 +1063,7 @@ static int __cpufreq_remove_dev(struct s
> > > > 		cpufreq_cpu_put(data);
> > > > 		cpufreq_debug_enable_ratelimit();
> > > > 		unlock_policy_rwsem_write(cpu);
> > > >+		mutex_unlock(&cpufreq_gov_mutex);
> > > > 		return 0;
> > > > 	}
> > > > #endif
> > > >@@ -1088,9 +1107,13 @@ static int __cpufreq_remove_dev(struct s
> > > > #endif
> > > > 
> > > > 	unlock_policy_rwsem_write(cpu);
> > > >-
> > > >+	/*
> > > >+	 * Calling only with the cpufreq_gov_mutex held because
> > > >+	 * sync timer teardown has locking dependency with policy rwsem.
> > > >+	 */
> > > > 	if (cpufreq_driver->target)
> > > > 		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
> > > >+	mutex_unlock(&cpufreq_gov_mutex);
> > > > 
> > > > 	kobject_put(&data->kobj);
> > > > 
> > > >@@ -1123,6 +1146,7 @@ static int cpufreq_remove_dev(struct sys
> > > > 	if (cpu_is_offline(cpu))
> > > > 		return 0;
> > > > 
> > > >+	mutex_lock(&cpufreq_gov_mutex);
> > > > 	if (unlikely(lock_policy_rwsem_write(cpu)))
> > > > 		BUG();
> > > > 
> > > >@@ -1506,12 +1530,16 @@ int cpufreq_driver_target(struct cpufreq
> > > > 	if (!policy)
> > > > 		goto no_policy;
> > > > 
> > > >-	if (unlikely(lock_policy_rwsem_write(policy->cpu)))
> > > >+	mutex_lock(&cpufreq_gov_mutex);
> > > >+	if (unlikely(lock_policy_rwsem_write(policy->cpu))) {
> > > >+		mutex_unlock(&cpufreq_gov_mutex);
> > > > 		goto fail;
> > > >+	}
> > > > 
> > > > 	ret = __cpufreq_driver_target(policy, target_freq, relation);
> > > > 
> > > > 	unlock_policy_rwsem_write(policy->cpu);
> > > >+	mutex_unlock(&cpufreq_gov_mutex);
> > > > 
> > > > fail:
> > > > 	cpufreq_cpu_put(policy);
> > > >@@ -1769,7 +1797,9 @@ int cpufreq_update_policy(unsigned int c
> > > > 		goto no_policy;
> > > > 	}
> > > > 
> > > >+	mutex_lock(&cpufreq_gov_mutex);
> > > > 	if (unlikely(lock_policy_rwsem_write(cpu))) {
> > > >+		mutex_unlock(&cpufreq_gov_mutex);
> > > > 		ret = -EINVAL;
> > > > 		goto fail;
> > > > 	}
> > > >@@ -1798,6 +1828,7 @@ int cpufreq_update_policy(unsigned int c
> > > > 	ret = __cpufreq_set_policy(data, &policy);
> > > > 
> > > > 	unlock_policy_rwsem_write(cpu);
> > > >+	mutex_unlock(&cpufreq_gov_mutex);
> > > > 
> > > > fail:
> > > > 	cpufreq_cpu_put(data);
> > > >@@ -1821,6 +1852,7 @@ static int __cpuinit cpufreq_cpu_callbac
> > > > 			break;
> > > > 		case CPU_DOWN_PREPARE:
> > > > 		case CPU_DOWN_PREPARE_FROZEN:
> > > >+			mutex_lock(&cpufreq_gov_mutex);
> > > > 			if (unlikely(lock_policy_rwsem_write(cpu)))
> > > > 				BUG();
> > > > 
> > > >
> > > >-- 
> > > >Mathieu Desnoyers
> > > >OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 
> > > >A8FE 3BAE 9A68
> > > >
> > 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
