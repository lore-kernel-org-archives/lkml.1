Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZF2TGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZF2TGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZF2TGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:06:36 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:45007 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbZF2TGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:06:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An0FANOrSEpMQWU3/2dsb2JhbACBUcx5gkyBQQU
Date: Mon, 29 Jun 2009 15:05:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>, davej@redhat.com
Subject: Re: [Bug #13424] possible deadlock when doing governor switching
Message-ID: <20090629190541.GA16719@Krystal>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.IOG.9jASKB@chimera> <20090629012558.GA22666@Krystal> <1246300665.4534.26170.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1246300665.4534.26170.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:00:42 up 121 days, 15:26,  4 users,  load average: 0.20, 0.15,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pallipadi, Venkatesh (venkatesh.pallipadi@intel.com) wrote:
> On Sun, 2009-06-28 at 18:25 -0700, Mathieu Desnoyers wrote:
> > * Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.29 and 2.6.30.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > > be listed and let me know (either way).
> > > 
> > 
> > Yep, it still exists. Venkatesh Pallipadi from Intel is working on it.
> > We need to figure out a proper way to fix policy rwlock vs dbs_mutex vs
> > timer mutex dependency.
> > 
> 
> Yes. Still working on it. I thought I had a fix for this. But, over the
> weekend test run resulted in a WARN_ON with sysfs_remove_group as below.
> Looks like I need a day or two more to work through the web of locks
> here..
> 

A quick fix I thought about is to add a mutex to cpufreq.c.

This mutex would be taken outside of the rwlock write lock each time
this lock is taken in cpufreq.c.

This mutex would also be taken from the ondemand and conservator module
sysfs operations.

We remove the dbs_mutexes, given they would now be replaced by this
new cpufreq.c mutex.

Note that the GOV_STOP call should be done while this new mutex is held,
but the rwlock is _not_ held.

I did not implement it because cpufreq.c:cpufreq_add_dev() first needs a
big cleanup for the error handling paths. They are currently completely
bogus and I don't want to add a lock into code that is not currently
correct.

If you find time to do this cleanup and lock implementation, I'll be
glad to review it and provide advice.

Thanks,

Mathieu


> Thanks,
> Venki
> 
> [10412.466195] ------------[ cut here ]------------
> [10412.466201] WARNING:
> at /home/venkip/src/linus/linux-2.6/fs/sysfs/group.c:138
> sysfs_remove_group+0x3e/0xa3()
> [10412.466204] Hardware name: Santa Rosa platform
> [10412.466206] sysfs group c16df3b0 not found for kobject 'cpufreq'
> [10412.466207] Modules linked in:
> [10412.466210] Pid: 20609, comm: write_syscpufre Not tainted 2.6.31-rc1
> #195
> [10412.466212] Call Trace:
> [10412.466217]  [<c102a0a4>] warn_slowpath_common+0x60/0x90
> [10412.466220]  [<c102a108>] warn_slowpath_fmt+0x24/0x27
> [10412.466223]  [<c10e0422>] sysfs_remove_group+0x3e/0xa3
> [10412.466227]  [<c131b7fc>] cpufreq_governor_dbs+0x1f7/0x25b
> [10412.466231]  [<c1319469>] __cpufreq_governor+0x7c/0xb3
> [10412.466234]  [<c1319608>] __cpufreq_set_policy+0x13f/0x1c3
> [10412.466238]  [<c1319e74>] store_scaling_governor+0x18a/0x1b2
> [10412.466241]  [<c131aa50>] ? handle_update+0x0/0x28
> [10412.466244]  [<c131a2a5>] ? lock_policy_rwsem_write+0x33/0x5b
> [10412.466247]  [<c1319cea>] ? store_scaling_governor+0x0/0x1b2
> [10412.466250]  [<c131a942>] store+0x48/0x61
> [10412.466254]  [<c10de532>] sysfs_write_file+0xb4/0xdf
> [10412.466265]  [<c10de47e>] ? sysfs_write_file+0x0/0xdf
> [10412.466269]  [<c10a0172>] vfs_write+0x84/0xdf
> [10412.466272]  [<c10a0266>] sys_write+0x3b/0x60
> [10412.466276]  [<c1002a04>] sysenter_do_call+0x12/0x22
> [10412.466278] ---[ end trace 31a730d96cbc1841 ]---
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
