Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbYGDN6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbYGDN6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbYGDN5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:57:47 -0400
Received: from saeurebad.de ([85.214.36.134]:36668 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbYGDN5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:57:43 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       ego@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
       davej@codemonkey.org.uk
Subject: Re: [BUG] While changing the cpufreq governor, kernel hits a bug in workqueue.c
References: <485F8028.1070302@linux.vnet.ibm.com>
	<87y74w41fp.fsf@skyscraper.fehenstaub.lan>
	<4860BB8E.2070505@linux.vnet.ibm.com>
	<87tzfh2t5l.fsf@skyscraper.fehenstaub.lan>
	<48638906.4090308@linux.vnet.ibm.com>
	<87y74l4scd.fsf@skyscraper.fehenstaub.lan>
Date: Fri, 04 Jul 2008 15:56:09 +0200
In-Reply-To: <87y74l4scd.fsf@skyscraper.fehenstaub.lan> (Johannes Weiner's
	message of "Tue, 01 Jul 2008 16:00:34 +0200")
Message-ID: <87fxqp7nye.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nageswara,

Johannes Weiner <hannes@saeurebad.de> writes:

> Hi,
>
> Nageswara R Sastry <rnsastry@linux.vnet.ibm.com> writes:
>
>> Hi,
>>
>> Johannes Weiner wrote:
>>
>>> From: Johannes Weiner <hannes@saeurebad.de>
>>> Subject: cpufreq: cancel self-rearming work synchroneuously
>>>
>>> The ondemand and conservative governor workers are self-rearming.
>>> Cancel them synchroneously to avoid nasty races.
>>>
>>> Reported-by: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
>>> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>>> ---
>>>
>>> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
>>> index 5d3a04b..78bac06 100644
>>> --- a/drivers/cpufreq/cpufreq_conservative.c
>>> +++ b/drivers/cpufreq/cpufreq_conservative.c
>>> @@ -467,7 +467,7 @@ static inline void dbs_timer_init(void)
>>>
>>>  static inline void dbs_timer_exit(void)
>>>  {
>>> -	cancel_delayed_work(&dbs_work);
>>> +	cancel_delayed_work_sync(&dbs_work);
>>>  	return;
>>>  }
>>>
>>> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
>>> index d2af20d..1eb8c58 100644
>>> --- a/drivers/cpufreq/cpufreq_ondemand.c
>>> +++ b/drivers/cpufreq/cpufreq_ondemand.c
>>> @@ -490,7 +490,7 @@ static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
>>>  static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
>>>  {
>>>  	dbs_info->enable = 0;
>>> -	cancel_delayed_work(&dbs_info->work);
>>> +	cancel_delayed_work_sync(&dbs_info->work);
>>>  }
>>>
>>>  static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>>
>> Applied the above patch only and compiled the kernel and seeing an
>> Circular lock related issue at the time of booting. First I am
>> checking this and will let you the results by applying both the
>> patches.
>>
>> =======================================================
>> [ INFO: possible circular locking dependency detected ]
>> 2.6.25.7.cpufreq_patch #2
>> -------------------------------------------------------
>> S06cpuspeed/3493 is trying to acquire lock:
>>  (&(&dbs_info->work)->work){--..}, at: [<c012f46c>]
>> __cancel_work_timer+0x80/0x177
>>
>> but task is already holding lock:
>>  (dbs_mutex){--..}, at: [<c041e7cb>] cpufreq_governor_dbs+0x25e/0x2ed
>>
>> which lock already depends on the new lock.
>>
>>
>> the existing dependency chain (in reverse order) is:
>>
>> -> #2 (dbs_mutex){--..}:
>>        [<c013aa76>] add_lock_to_list+0x61/0x83
>>        [<c013cfa3>] __lock_acquire+0x953/0xb05
>>        [<c041e5e1>] cpufreq_governor_dbs+0x74/0x2ed
>>        [<c013d1b4>] lock_acquire+0x5f/0x79
>>        [<c041e5e1>] cpufreq_governor_dbs+0x74/0x2ed
>>        [<c04cdaa7>] mutex_lock_nested+0xce/0x222
>>        [<c041e5e1>] cpufreq_governor_dbs+0x74/0x2ed
>>        [<c041e5e1>] cpufreq_governor_dbs+0x74/0x2ed
>>        [<c041e5e1>] cpufreq_governor_dbs+0x74/0x2ed
>>        [<c041c87a>] __cpufreq_governor+0x73/0xa6
>>        [<c041c9e8>] __cpufreq_set_policy+0x13b/0x19e
>>        [<c041d6b5>] cpufreq_add_dev+0x3b4/0x4aa
>>        [<c041d296>] handle_update+0x0/0x21
>>        [<c02ee310>] sysdev_driver_register+0x48/0x9a
>>        [<c041c75b>] cpufreq_register_driver+0x9b/0x147
>>        [<c06b742c>] kernel_init+0x130/0x26f
>>        [<c06b72fc>] kernel_init+0x0/0x26f
>>        [<c06b72fc>] kernel_init+0x0/0x26f
>>        [<c0105527>] kernel_thread_helper+0x7/0x10
>>        [<ffffffff>] 0xffffffff
>>
>> -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){----}:
>>        [<c013cfa3>] __lock_acquire+0x953/0xb05
>>        [<c041d194>] lock_policy_rwsem_write+0x30/0x56
>>        [<c010a83b>] save_stack_trace+0x1a/0x35
>>        [<c013d1b4>] lock_acquire+0x5f/0x79
>>        [<c041d194>] lock_policy_rwsem_write+0x30/0x56
>>        [<c04cdfd9>] down_write+0x2b/0x44
>>        [<c041d194>] lock_policy_rwsem_write+0x30/0x56
>>        [<c041d194>] lock_policy_rwsem_write+0x30/0x56
>>        [<c041e35e>] do_dbs_timer+0x40/0x24f
>>        [<c012ee7f>] run_workqueue+0x81/0x187
>>        [<c012eeba>] run_workqueue+0xbc/0x187
>>        [<c012ee7f>] run_workqueue+0x81/0x187
>>        [<c041e31e>] do_dbs_timer+0x0/0x24f
>>        [<c012f6fa>] worker_thread+0x0/0xbd
>>        [<c012f7ad>] worker_thread+0xb3/0xbd
>>        [<c0131acc>] autoremove_wake_function+0x0/0x2d
>>        [<c0131a1b>] kthread+0x38/0x5d
>>        [<c01319e3>] kthread+0x0/0x5d
>>        [<c0105527>] kernel_thread_helper+0x7/0x10
>>        [<ffffffff>] 0xffffffff
>>
>> -> #0 (&(&dbs_info->work)->work){--..}:
>>        [<c013b6a2>] print_circular_bug_tail+0x2a/0x61
>>        [<c013cec8>] __lock_acquire+0x878/0xb05
>>        [<c013d1b4>] lock_acquire+0x5f/0x79
>>        [<c012f46c>] __cancel_work_timer+0x80/0x177
>>        [<c012f497>] __cancel_work_timer+0xab/0x177
>>        [<c012f46c>] __cancel_work_timer+0x80/0x177
>>        [<c013c0ee>] mark_held_locks+0x39/0x53
>>        [<c04cdbe8>] mutex_lock_nested+0x20f/0x222
>>        [<c013c277>] trace_hardirqs_on+0xe7/0x10e
>>        [<c04cdbf3>] mutex_lock_nested+0x21a/0x222
>>        [<c041e7cb>] cpufreq_governor_dbs+0x25e/0x2ed
>>        [<c041e7dd>] cpufreq_governor_dbs+0x270/0x2ed
>>        [<c041c87a>] __cpufreq_governor+0x73/0xa6
>>        [<c041c9d6>] __cpufreq_set_policy+0x129/0x19e
>>        [<c041ce0b>] store_scaling_governor+0x112/0x135
>>        [<c041d296>] handle_update+0x0/0x21
>>        [<c0410065>] atkbd_set_leds+0x9/0xcf
>>        [<c041ccf9>] store_scaling_governor+0x0/0x135
>>        [<c041d7e7>] store+0x3c/0x54
>>        [<c01a09a0>] sysfs_write_file+0xa9/0xdd
>>        [<c01a08f7>] sysfs_write_file+0x0/0xdd
>>        [<c016e412>] vfs_write+0x83/0xf6
>>        [<c016e958>] sys_write+0x3c/0x63
>>        [<c0104816>] sysenter_past_esp+0x5f/0xa5
>>        [<ffffffff>] 0xffffffff
>>
>> other info that might help us debug this:
>>
>> 3 locks held by S06cpuspeed/3493:
>>  #0:  (&buffer->mutex){--..}, at: [<c01a091b>] sysfs_write_file+0x24/0xdd
>>  #1:  (&per_cpu(cpu_policy_rwsem, cpu)){----}, at: [<c041d194>]
>> lock_policy_rwsem_write+0x30/0x56
>>  #2:  (dbs_mutex){--..}, at: [<c041e7cb>] cpufreq_governor_dbs+0x25e/0x2ed
>>
>> stack backtrace:
>> Pid: 3493, comm: S06cpuspeed Not tainted 2.6.25.7.cpufreq_patch #2
>>  [<c013b6cf>] print_circular_bug_tail+0x57/0x61
>>  [<c013cec8>] __lock_acquire+0x878/0xb05
>>  [<c013d1b4>] lock_acquire+0x5f/0x79
>>  [<c012f46c>] __cancel_work_timer+0x80/0x177
>>  [<c012f497>] __cancel_work_timer+0xab/0x177
>>  [<c012f46c>] __cancel_work_timer+0x80/0x177
>>  [<c013c0ee>] mark_held_locks+0x39/0x53
>>  [<c04cdbe8>] mutex_lock_nested+0x20f/0x222
>>  [<c013c277>] trace_hardirqs_on+0xe7/0x10e
>>  [<c04cdbf3>] mutex_lock_nested+0x21a/0x222
>>  [<c041e7cb>] cpufreq_governor_dbs+0x25e/0x2ed
>>  [<c041e7dd>] cpufreq_governor_dbs+0x270/0x2ed
>>  [<c041c87a>] __cpufreq_governor+0x73/0xa6
>>  [<c041c9d6>] __cpufreq_set_policy+0x129/0x19e
>>  [<c041ce0b>] store_scaling_governor+0x112/0x135
>>  [<c041d296>] handle_update+0x0/0x21
>>  [<c0410065>] atkbd_set_leds+0x9/0xcf
>>  [<c041ccf9>] store_scaling_governor+0x0/0x135
>>  [<c041d7e7>] store+0x3c/0x54
>>  [<c01a09a0>] sysfs_write_file+0xa9/0xdd
>>  [<c01a08f7>] sysfs_write_file+0x0/0xdd
>>  [<c016e412>] vfs_write+0x83/0xf6
>>  [<c016e958>] sys_write+0x3c/0x63
>>  [<c0104816>] sysenter_past_esp+0x5f/0xa5
>>  =======================
>
> Okay, the problem is in cpufreq_conservative.c.  We
> cancel_delayed_work_sync() while holding the mutex, but the work itself
> tries to grab it and there it deadlocks; lockdep caught that right.
>
> The hunk for _ondemand is correct, but the one for _conservative is
> obviously wrong, sorry :/
>
> I will whip something up and get back to you.  Thanks a lot for
> testing!

Could you try the attached patch instead of the one above?

Dave, I dropped the mutex-grabbing from the conservative worker function
as well as I don't see a reason for it, please correct me if I'm wrong.

	Hannes

--
From: Johannes Weiner <hannes@saeurebad.de>
Subject: cpufreq: cancel self-rearming work synchroneously

The ondemand and conservative governor workers are self-rearming.
Cancel them synchroneously to avoid nasty races.

This patch also removes taking a mutex in the conservative worker
function as the locking is dbs_mutex -> work and not the
other way round.

Reported-by: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 drivers/cpufreq/cpufreq_conservative.c |    4 +---
 drivers/cpufreq/cpufreq_ondemand.c     |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -450,12 +450,10 @@ static void dbs_check_cpu(int cpu)
 static void do_dbs_timer(struct work_struct *work)
 {
 	int i;
-	mutex_lock(&dbs_mutex);
 	for_each_online_cpu(i)
 		dbs_check_cpu(i);
 	schedule_delayed_work(&dbs_work,
 			usecs_to_jiffies(dbs_tuners_ins.sampling_rate));
-	mutex_unlock(&dbs_mutex);
 }
 
 static inline void dbs_timer_init(void)
@@ -467,7 +465,7 @@ static inline void dbs_timer_init(void)
 
 static inline void dbs_timer_exit(void)
 {
-	cancel_delayed_work(&dbs_work);
+	cancel_delayed_work_sync(&dbs_work);
 	return;
 }
 
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -490,7 +490,7 @@ static inline void dbs_timer_init(struct
 static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
 {
 	dbs_info->enable = 0;
-	cancel_delayed_work(&dbs_info->work);
+	cancel_delayed_work_sync(&dbs_info->work);
 }
 
 static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
