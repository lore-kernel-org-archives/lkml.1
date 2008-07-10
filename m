Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYGJLLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYGJLLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 07:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYGJLLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 07:11:43 -0400
Received: from saeurebad.de ([85.214.36.134]:51472 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbYGJLLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 07:11:42 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       ego@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
       davej@codemonkey.org.uk, pzijlstr@redhat.com
Subject: Re: [BUG] While changing the cpufreq governor, kernel hits a bug in workqueue.c
References: <485F8028.1070302@linux.vnet.ibm.com>
	<87y74w41fp.fsf@skyscraper.fehenstaub.lan>
	<4860BB8E.2070505@linux.vnet.ibm.com>
	<87tzfh2t5l.fsf@skyscraper.fehenstaub.lan>
	<48638906.4090308@linux.vnet.ibm.com>
	<87y74l4scd.fsf@skyscraper.fehenstaub.lan>
	<87fxqp7nye.fsf@skyscraper.fehenstaub.lan>
	<4871E657.3040403@linux.vnet.ibm.com> <87d4lqq7ec.fsf@saeurebad.de>
	<487300B1.4040300@linux.vnet.ibm.com>
Date: Thu, 10 Jul 2008 13:11:23 +0200
In-Reply-To: <487300B1.4040300@linux.vnet.ibm.com> (Nageswara R. Sastry's
	message of "Tue, 08 Jul 2008 11:22:49 +0530")
Message-ID: <877ibukn8k.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[added Peter on CC, lockdep confuses me]

Nageswara R Sastry <rnsastry@linux.vnet.ibm.com> writes:

> Hi Johannes,
>
> Johannes Weiner wrote:
>
>>> * I am seeing the circular locking dependency with the above patch
>>> too.
>>
>> Uhm.  Failure or no failure?  A possible dead-lock report _is_ a
>> failure.  So, do you get one or not?  And if so, could you send me the
>> dmesg parts?
>>
>> Thanks a lot,
>>
>> 	Hannes
>
> I could see a circular locking dependency and sysfs hang with the new
> patch named "cpufreq: cancel self-rearming work synchroneously"
> also. Please find the dmesg output. Please let me know if you need
> more information. Thank a lot for your coordination.
>
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.25.9.cpufreq #2
> -------------------------------------------------------
> S06cpuspeed/3427 is trying to acquire lock:
>  (&(&dbs_info->work)->work){--..}, at: [<c012f46c>]
> __cancel_work_timer+0x80/0x177
>
> but task is already holding lock:
>  (dbs_mutex){--..}, at: [<c041e7db>] cpufreq_governor_dbs+0x26a/0x2f7

Hmmm, it's weird.  This path should be okay.  I wonder where the
dependency work -> dbs_mutex comes from.  The mutex is nowhere taken
with the work lock held (I removed this in the new version of the patch,
can you double-check you applied to correct patch?).

So the chain should really be dbs_mutex -> work-lock.

> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #2 (dbs_mutex){--..}:
>        [<c013aa76>] add_lock_to_list+0x61/0x83
>        [<c013cfa3>] __lock_acquire+0x953/0xb05
>        [<c041e5e3>] cpufreq_governor_dbs+0x72/0x2f7
>        [<c013d1b4>] lock_acquire+0x5f/0x79
>        [<c041e5e3>] cpufreq_governor_dbs+0x72/0x2f7
>        [<c04cdaa7>] mutex_lock_nested+0xce/0x222
>        [<c041e5e3>] cpufreq_governor_dbs+0x72/0x2f7
>        [<c041e5e3>] cpufreq_governor_dbs+0x72/0x2f7
>        [<c041e5e3>] cpufreq_governor_dbs+0x72/0x2f7
>        [<c041c87e>] __cpufreq_governor+0x73/0xa6
>        [<c041c9ec>] __cpufreq_set_policy+0x13b/0x19e
>        [<c041d6b9>] cpufreq_add_dev+0x3b4/0x4aa
>        [<c041d29a>] handle_update+0x0/0x21
>        [<c02ee310>] sysdev_driver_register+0x48/0x9a
>        [<c041c75f>] cpufreq_register_driver+0x9b/0x147
>        [<c06b742c>] kernel_init+0x130/0x26f
>        [<c06b72fc>] kernel_init+0x0/0x26f
>        [<c06b72fc>] kernel_init+0x0/0x26f
>        [<c0105527>] kernel_thread_helper+0x7/0x10
>        [<ffffffff>] 0xffffffff
>
> -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){----}:
>        [<c013cfa3>] __lock_acquire+0x953/0xb05
>        [<c041d198>] lock_policy_rwsem_write+0x30/0x56
>        [<c010a83b>] save_stack_trace+0x1a/0x35
>        [<c013d1b4>] lock_acquire+0x5f/0x79
>        [<c041d198>] lock_policy_rwsem_write+0x30/0x56
>        [<c04cdfd9>] down_write+0x2b/0x44
>        [<c041d198>] lock_policy_rwsem_write+0x30/0x56
>        [<c041d198>] lock_policy_rwsem_write+0x30/0x56
>        [<c041e362>] do_dbs_timer+0x40/0x24f
>        [<c012ee7f>] run_workqueue+0x81/0x187
>        [<c012eeba>] run_workqueue+0xbc/0x187
>        [<c012ee7f>] run_workqueue+0x81/0x187
>        [<c041e322>] do_dbs_timer+0x0/0x24f
>        [<c012f6fa>] worker_thread+0x0/0xbd
>        [<c012f7ad>] worker_thread+0xb3/0xbd
>        [<c0131acc>] autoremove_wake_function+0x0/0x2d
>        [<c0131a1b>] kthread+0x38/0x5d
>        [<c01319e3>] kthread+0x0/0x5d
>        [<c0105527>] kernel_thread_helper+0x7/0x10
>        [<ffffffff>] 0xffffffff
>
> -> #0 (&(&dbs_info->work)->work){--..}:
>        [<c013b6a2>] print_circular_bug_tail+0x2a/0x61
>        [<c013cec8>] __lock_acquire+0x878/0xb05
>        [<c013d1b4>] lock_acquire+0x5f/0x79
>        [<c012f46c>] __cancel_work_timer+0x80/0x177
>        [<c012f497>] __cancel_work_timer+0xab/0x177
>        [<c012f46c>] __cancel_work_timer+0x80/0x177
>        [<c013c0ee>] mark_held_locks+0x39/0x53
>        [<c04cdbe8>] mutex_lock_nested+0x20f/0x222
>        [<c013c277>] trace_hardirqs_on+0xe7/0x10e
>        [<c04cdbf3>] mutex_lock_nested+0x21a/0x222
>        [<c041e7db>] cpufreq_governor_dbs+0x26a/0x2f7
>        [<c041e7ed>] cpufreq_governor_dbs+0x27c/0x2f7
>        [<c041c87e>] __cpufreq_governor+0x73/0xa6
>        [<c041c9da>] __cpufreq_set_policy+0x129/0x19e
>        [<c041ce0f>] store_scaling_governor+0x112/0x135
>        [<c041d29a>] handle_update+0x0/0x21
>        [<c0410065>] atkbd_set_leds+0x5/0xcf
>        [<c041ccfd>] store_scaling_governor+0x0/0x135
>        [<c041d7eb>] store+0x3c/0x54
>        [<c01a09e8>] sysfs_write_file+0xa9/0xdd
>        [<c01a093f>] sysfs_write_file+0x0/0xdd
>        [<c016e45a>] vfs_write+0x83/0xf6
>        [<c016e9a0>] sys_write+0x3c/0x63
>        [<c0104816>] sysenter_past_esp+0x5f/0xa5
>        [<ffffffff>] 0xffffffff

Uhm, this dependency is as new as the actual lockdep detection (the same
backtrace as the whole event, see below).  What is lockdep doing here?
Shouldn't this be the callpath where the lock was taken for the first
time?

I can not see where the chain is ever work-lock -> dbs_mutex, so how
does lockdep come to the conclusion this would be the correct order?

> other info that might help us debug this:
>
> 3 locks held by S06cpuspeed/3427:
>  #0:  (&buffer->mutex){--..}, at: [<c01a0963>] sysfs_write_file+0x24/0xdd
>  #1:  (&per_cpu(cpu_policy_rwsem, cpu)){----}, at: [<c041d198>]
> lock_policy_rwsem_write+0x30/0x56
>  #2:  (dbs_mutex){--..}, at: [<c041e7db>] cpufreq_governor_dbs+0x26a/0x2f7
>
> stack backtrace:
> Pid: 3427, comm: S06cpuspeed Not tainted 2.6.25.9.cpufreq #2
>  [<c013b6cf>] print_circular_bug_tail+0x57/0x61
>  [<c013cec8>] __lock_acquire+0x878/0xb05
>  [<c013d1b4>] lock_acquire+0x5f/0x79
>  [<c012f46c>] __cancel_work_timer+0x80/0x177
>  [<c012f497>] __cancel_work_timer+0xab/0x177
>  [<c012f46c>] __cancel_work_timer+0x80/0x177
>  [<c013c0ee>] mark_held_locks+0x39/0x53
>  [<c04cdbe8>] mutex_lock_nested+0x20f/0x222
>  [<c013c277>] trace_hardirqs_on+0xe7/0x10e
>  [<c04cdbf3>] mutex_lock_nested+0x21a/0x222
>  [<c041e7db>] cpufreq_governor_dbs+0x26a/0x2f7
>  [<c041e7ed>] cpufreq_governor_dbs+0x27c/0x2f7
>  [<c041c87e>] __cpufreq_governor+0x73/0xa6
>  [<c041c9da>] __cpufreq_set_policy+0x129/0x19e
>  [<c041ce0f>] store_scaling_governor+0x112/0x135
>  [<c041d29a>] handle_update+0x0/0x21
>  [<c0410065>] atkbd_set_leds+0x5/0xcf
>  [<c041ccfd>] store_scaling_governor+0x0/0x135
>  [<c041d7eb>] store+0x3c/0x54
>  [<c01a09e8>] sysfs_write_file+0xa9/0xdd
>  [<c01a093f>] sysfs_write_file+0x0/0xdd
>  [<c016e45a>] vfs_write+0x83/0xf6
>  [<c016e9a0>] sys_write+0x3c/0x63
>  [<c0104816>] sysenter_past_esp+0x5f/0xa5
>  =======================
>
> Thanks!!
> Regards
> R.Nageswara Sastry

	Hannes
