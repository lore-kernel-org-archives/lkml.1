Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbZFYVde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbZFYVde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 17:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZFYVd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 17:33:26 -0400
Received: from wynq.bellnexxia.net ([209.226.175.27]:51253 "EHLO
	toq5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbZFYVdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 17:33:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhwFAPuIQ0pMQWRX/2dsb2JhbACBUdBwhA0F
Date: Thu, 25 Jun 2009 17:32:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Thomas Renninger <trenn@suse.de>
Subject: Re: [patch 2/3] cpufreq: Define dbs_mutex purpose and cleanup its
	usage
Message-ID: <20090625213219.GA27311@Krystal>
References: <20090625183354.491259000@intel.com> <20090625183601.493904000@intel.com> <20090625194648.GA24657@Krystal> <1245963285.4534.20542.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1245963285.4534.20542.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:27:53 up 117 days, 17:54,  3 users,  load average: 0.36, 0.19,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pallipadi, Venkatesh (venkatesh.pallipadi@intel.com) wrote:
> On Thu, 2009-06-25 at 12:46 -0700, Mathieu Desnoyers wrote:
> > * venkatesh.pallipadi@intel.com (venkatesh.pallipadi@intel.com) wrote:
> > > Commit b14893a62c73af0eca414cfed505b8c09efc613c although it was very
> > > much needed to cleanup ondemand timer cleanly, openup a can of worms
> > > related to locking dependencies in cpufreq.
> > > 
> > > Patch here defines the need for dbs_mutex and cleans up its usage in
> > > ondemand governor. This also resolves the lockdep warnings reported here
> > > 
> > > http://lkml.indiana.edu/hypermail/linux/kernel/0906.1/01925.html
> > > 
> 
> > > @@ -598,14 +593,16 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
> > >  				max(min_sampling_rate,
> > >  				    latency * LATENCY_MULTIPLIER);
> > >  		}
> > > +		mutex_unlock(&dbs_mutex);
> > > +
> > >  		dbs_timer_init(this_dbs_info);
> > >  
> > > -		mutex_unlock(&dbs_mutex);
> > >  		break;
> > >  
> > >  	case CPUFREQ_GOV_STOP:
> > > -		mutex_lock(&dbs_mutex);
> > >  		dbs_timer_exit(this_dbs_info);
> > 
> > Hrm, so.. how do we protect against concurrent :
> > 
> > CPUFREQ_GOV_START/CPUFREQ_GOV_STOP now ?
> 
> concurrent _START _STOP across CPUs does not matter for timer_init and
> timer_exit.

Given those are per-cpu anyway I guess. Hopefully it works OK with CPU
hotplug.

> On same CPU, there cannot be two concurrent _START as upper
> level cpufreq will have policy_rwsem in write mode.

Agreed.

> I cannot think of a
> flow where _START and _STOP on same CPU is possible.
> 

_STOP is not protected by any mutex now. So it could be preempted, and
then a _START executed, and there is your race.

> However two concurrent _STOP for same CPU is still possible, as we are
> releasing the rwsem lock before STOP callback. "Back to drawing board"
> time to figure this all out..

I fear that it is indeed the case. If you can come up with a document
explaining the expected interactions between :

- cpu hotplug
- policy lock
- cpufreq driver lock
- timer lock

that would be awesome. :)

Mathieu

> 
> Thanks,
> Venki
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
