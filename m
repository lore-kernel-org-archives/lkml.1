Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096Ab0AWBeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab0AWBeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 20:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998Ab0AWBeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 20:34:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:8245 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab0AWBeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 20:34:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,327,1262592000"; 
   d="scan'208";a="486300651"
Subject: Re: 2.6.33-rc4-git7 -- head/6104 is trying to acquire lock:
 (cpuidle_lock){+.+.+.}, at: [<c129e2ec>] show_current_governor+0x12/0x4e
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Li, Shaohua" <shaohua.li@intel.com>, Dave Jones <davej@redhat.com>
In-Reply-To: <1264124005.16916.301.camel@localhost.localdomain>
References: <a44ae5cd1001210950h34d57a5cq8b484ec4d3dbb48b@mail.gmail.com>
	 <20100121191812.GA1840@redhat.com>
	 <1264124005.16916.301.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 22 Jan 2010 17:34:10 -0800
Message-Id: <1264210450.16916.321.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 17:33 -0800, Pallipadi, Venkatesh wrote:
> On Thu, 2010-01-21 at 11:18 -0800, Dave Jones wrote:
> > On Thu, Jan 21, 2010 at 12:50:09PM -0500, Miles Lane wrote:
> >  > I was scanning the first few characters of all the files in /proc and
> >  > /sys.  I will attempt to determine which file(s) triggered this.
> > 
> > 
> > Dropped cpufreq-list from Cc, added cpuidle maintainers.
> > While they sound similar, they are unrelated.
> 
> Thanks for reporting the problem. I am able to reproduce this locally.
> Will followup once I have some time to poke at it a bit more.
> 

This lockdep message started with Eric's
sysfs: Add lockdep annotations for the sysfs active reference
patch.

But, this looks like a false positive to me. Eric, can you please take a
look at this? I am not a sysfs expert, so I may be overlooking something
obvious here...


The sysfs usage is cpuidle is like below

/sys/devices/system/cpu/cpuidle
/sys/devices/system/cpu/cpuidle/current_driver
/sys/devices/system/cpu/cpuidle/current_governor_ro

/sys/devices/system/cpu/cpu0/cpuidle
/sys/devices/system/cpu/cpu0/cpuidle/state0
/sys/devices/system/cpu/cpu0/cpuidle/state0/desc
/sys/devices/system/cpu/cpu0/cpuidle/state0/latency
/sys/devices/system/cpu/cpu0/cpuidle/state0/name
/sys/devices/system/cpu/cpu0/cpuidle/state0/power
/sys/devices/system/cpu/cpu0/cpuidle/state0/time
/sys/devices/system/cpu/cpu0/cpuidle/state0/usage
: :
/sys/devices/system/cpu/cpu0/cpuidle/stateN
: :
/sys/devices/system/cpu/cpuM/cpuidle
: :

The lockdep complaint here happens when
#cat /sys/devices/system/cpu/cpuidle/current_governor_ro

as, the code there takes mutex_lock in .show
[  606.464855] -> #0 (cpuidle_lock){+.+.+.}:
[  606.464857]        [<ffffffff8106a16b>] __lock_acquire+0x11b3/0x17e5
[  606.464860]        [<ffffffff8106a861>] lock_acquire+0xc4/0xe1
[  606.464862]        [<ffffffff815f4825>] mutex_lock_nested+0x69/0x2dc
[  606.464866]        [<ffffffff814ff32c>] show_current_governor+0x1f/0x68
[  606.464868]        [<ffffffff81372408>] sysdev_class_show+0x25/0x27
[  606.464872]        [<ffffffff8112d6c6>] sysfs_read_file+0xbf/0x141
[  606.464875]        [<ffffffff810dec63>] vfs_read+0xb0/0x14c
[  606.464879]        [<ffffffff810dedcd>] sys_read+0x4c/0x74

and 
lockdep has already seen lock is held during add/remove
of /sys/devices/system/cpu/cpu0/cpuidle/state0/*
in other part of the code
[  606.464805] -> #1 (s_active){++++.+}:
[  606.464807]        [<ffffffff8106a446>] __lock_acquire+0x148e/0x17e5
[  606.464812]        [<ffffffff8106a861>] lock_acquire+0xc4/0xe1
[  606.464814]        [<ffffffff8112e933>] sysfs_addrm_finish+0xd2/0x15c
[  606.464816]        [<ffffffff8112ea85>] sysfs_remove_dir+0x7a/0x8d
[  606.464819]        [<ffffffff812194e7>] kobject_del+0x16/0x37
[  606.464823]        [<ffffffff81219546>] kobject_release+0x3e/0x67
[  606.464825]        [<ffffffff8121a389>] kref_put+0x43/0x4f
[  606.464827]        [<ffffffff81219462>] kobject_put+0x47/0x4b
[  606.464830]        [<ffffffff814ff030>] cpuidle_remove_state_sysfs+0x30/0x69
[  606.464832]        [<ffffffff814fe87a>] cpuidle_disable_device+0x4a/0x54
[  606.464835]        [<ffffffff814fec84>] cpuidle_switch_governor+0x40/0x15b
[  606.464837]        [<ffffffff814fef09>] cpuidle_register_governor+0xc0/0xdf
[  606.464839]        [<ffffffff81c6a884>] init_menu+0x10/0x12
[  606.464844]        [<ffffffff810001fa>] do_one_initcall+0x5f/0x154
[  606.464848]        [<ffffffff81c3c6a3>] kernel_init+0x198/0x1ed
[  606.464852]        [<ffffffff81003014>] kernel_thread_helper+0x4/0x10


lock is not held in the .show functions
of /sys/devices/system/cpu/cpu*/cpuidle/state*/*

And the add of /sys/devices/system/cpu/cpuidle/* happens in core_init
call without the lock held. And this dir never gets removed.

I don't seem to see any deadlock possibility across the two sysfs dirs
here. Am I missing something related to how sysfs works?

Thanks,
Venki



