Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZFRFqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZFRFqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 01:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZFRFqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 01:46:35 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:48537 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbZFRFqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 01:46:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZiGMWL1tR5MnGy7ZroLkQCGSR/IycWxqiG5z6V4fvyEFasti/Z8e064oPZyL4rYTzZ
         Uq7HEE8RsrKtPaF9GNhz/9eH5cL56BXIN1bJZ6NxvxIiFrn52v+1Zztlc1uW98D8o/Jv
         +q5wLO7EGrVOeHV6DNMC+juvAEYOA9h/vjA9I=
MIME-Version: 1.0
In-Reply-To: <20090617003925.GA3900@linux-os.sc.intel.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.7vF.2Y7KKB@chimera>
	 <84144f020906070621r1f480eaeief026d23662df380@mail.gmail.com>
	 <a8e1da0906080035j9f8b38drb46132de5a515915@mail.gmail.com>
	 <1244447366.13471.4.camel@penberg-laptop>
	 <20090608124844.GA17588@Krystal> <20090608143220.GC2516@redhat.com>
	 <1244727561.5350.32.camel@odie.local> <20090611152329.GB28099@Krystal>
	 <20090617003925.GA3900@linux-os.sc.intel.com>
Date: Thu, 18 Jun 2009 13:46:33 +0800
Message-ID: <a8e1da0906172246n5553a698x82d8ec1707bed56f@mail.gmail.com>
Subject: Re: [Bug #13475] suspend/hibernate lockdep warning
From: Dave Young <hidave.darkstar@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       =?UTF-8?Q?Simon_Holm_Th=C3=B8gersen?= <odie@cs.aau.dk>,
       Dave Jones <davej@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "trenn@suse.de" <trenn@suse.de>,
       "sven.wegener@stealer.net" <sven.wegener@stealer.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 8:39 AM, Pallipadi,
Venkatesh<venkatesh.pallipadi@intel.com> wrote:
> On Thu, Jun 11, 2009 at 08:23:29AM -0700, Mathieu Desnoyers wrote:
>> * Simon Holm Thøgersen (odie@cs.aau.dk) wrote:
>> > man, 08 06 2009 kl. 10:32 -0400, skrev Dave Jones:
>> > > On Mon, Jun 08, 2009 at 08:48:45AM -0400, Mathieu Desnoyers wrote:
>> > >
>> > >  > > > >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13475
>> > >  > > > >> Subject         : suspend/hibernate lockdep warning
>> > >  > > > >> References      : http://marc.info/?l=linux-kernel&m=124393723321241&w=4
>> > >  > > >
>> > >  > > > I suspect the following commit, after revert this patch I test 5 times
>> > >  > > > without lockdep warnings.
>> > >  > > >
>> > >  > > > commit b14893a62c73af0eca414cfed505b8c09efc613c
>> > >  > > > Author: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>> > >  > > > Date:   Sun May 17 10:30:45 2009 -0400
>> > >  > > >
>> > >  > > >    [CPUFREQ] fix timer teardown in ondemand governor
>> > >  > >
>> > >  > > The patch is probably not at fault here. I suspect it's some latent bug
>> > >  > > that simply got exposed by the change to cancel_delayed_work_sync(). In
>> > >  > > any case, Mathieu, can you take a look at this please?
>> > >  >
>> > >  > Yes, it's been looked at and discussed on the cpufreq ML. The short
>> > >  > answer is that they plan to re-engineer cpufreq and remove the policy
>> > >  > rwlock taken around almost every operations at the cpufreq level.
>> > >  >
>> > >  > The short-term solution, which is recognised as ugly, would be do to the
>> > >  > following before doing the cancel_delayed_work_sync() :
>> > >  >
>> > >  > unlock policy rwlock write lock
>> > >  >
>> > >  > lock policy rwlock write lock
>> > >  >
>> > >  > It basically works because this rwlock is unneeded for teardown, hence
>> > >  > the future re-work planned.
>> > >  >
>> > >  > I'm sorry I cannot prepare a patch current... I've got quite a few pages
>> > >  > of Ph.D. thesis due for the beginning of July.
>> > >
>> > > I'm kinda scared to touch this code at all for .30 due to the number of
>> > > unexpected gotchas we seem to run into every time we touch something
>> > > locking related.  So I'm inclined to just live with the lockdep warning
>> > > for .30, and see how the real fixes look for .31, and push them back
>> > > as -stable updates if they work out.
>> >
>> > Unfortunately I don't think it is just theoretical, I've actually hit
>> > the following (that haven't got anything to do with suspend/hibernate)
>> >
>> > INFO: task cpufreqd:4676 blocked for more than 120 seconds.
>> >  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >  cpufreqd      D eee2ac60     0  4676      1
>> >   ee01bd68 00000086 eee2aad0 eee2ac60 00000533 eee2aad0 eee2ac60 0002b16f
>> >   00000000 eee2ac60 7fffffff 7fffffff eee2ac60 7fffffff 7fffffff 00000000
>> >   ee01bd70 c03117ee ee01bdbc c0311c0c eee2aad0 eecf6900 eee2aad0 eecf6900
>> >  Call Trace:
>> >   [<c03117ee>] schedule+0x12/0x24
>> >   [<c0311c0c>] schedule_timeout+0x17/0x170
>> >   [<c011a4f7>] ? __wake_up+0x2b/0x51
>> >   [<c0311afd>] wait_for_common+0xc4/0x135
>> >   [<c011a694>] ? default_wake_function+0x0/0xd
>> >   [<c0311be0>] wait_for_completion+0x12/0x14
>> >   [<c012bc6a>] __cancel_work_timer+0xfe/0x129
>> >   [<c012b635>] ? wq_barrier_func+0x0/0xd
>> >   [<c012bca0>] cancel_delayed_work_sync+0xb/0xd
>> >   [<f20948f9>] cpufreq_governor_dbs+0x22e/0x291 [cpufreq_ondemand]
>> >   [<c02af857>] __cpufreq_governor+0x65/0x9d
>> >   [<c02af960>] __cpufreq_set_policy+0xd1/0x11f
>> >   [<c02b02ae>] store_scaling_governor+0x18a/0x1b2
>> >   [<c02b09a5>] ? handle_update+0x0/0xd
>> >   [<c02b0124>] ? store_scaling_governor+0x0/0x1b2
>> >   [<c02b08c9>] store+0x48/0x61
>> >   [<c01acbf4>] sysfs_write_file+0xb4/0xdf
>> >   [<c01acb40>] ? sysfs_write_file+0x0/0xdf
>> >   [<c0175535>] vfs_write+0x8a/0x104
>> >   [<c0175648>] sys_write+0x3b/0x60
>> >   [<c0103110>] sysenter_do_call+0x12/0x2c
>> >  INFO: task kondemand/0:4956 blocked for more than 120 seconds.
>> >  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >  kondemand/0   D 00000533     0  4956      2
>> >   ee1d9efc 00000046 c011815f 00000533 071148de ee1e0080 ee1e0210 00000000
>> >   c03ff478 9189e633 00000082 c03ff478 ee1e0210 c04159f4 c04159f0 00000000
>> >   ee1d9f04 c03117ee ee1d9f28 c0313104 ee1d9f30 c04159f4 ee1e0080 c01183be
>> >  Call Trace:
>> >   [<c011815f>] ? update_curr+0x6c/0x14b
>> >   [<c03117ee>] schedule+0x12/0x24
>> >   [<c0313104>] rwsem_down_failed_common+0x150/0x16e
>> >   [<c01183be>] ? dequeue_task_fair+0x51/0x56
>> >   [<c031313d>] rwsem_down_write_failed+0x1b/0x23
>> >   [<c031317e>] call_rwsem_down_write_failed+0x6/0x8
>> >   [<c03125dd>] ? down_write+0x14/0x16
>> >   [<c02b0460>] lock_policy_rwsem_write+0x1d/0x33
>> >   [<f20944aa>] do_dbs_timer+0x45/0x266 [cpufreq_ondemand]
>> >   [<c012b8f7>] worker_thread+0x165/0x212
>> >   [<f2094465>] ? do_dbs_timer+0x0/0x266 [cpufreq_ondemand]
>> >   [<c012e639>] ? autoremove_wake_function+0x0/0x33
>> >   [<c012b792>] ? worker_thread+0x0/0x212
>> >   [<c012e278>] kthread+0x42/0x67
>> >   [<c012e236>] ? kthread+0x0/0x67
>> >   [<c01038eb>] kernel_thread_helper+0x7/0x10
>> >
>> > I've only seen it once in 5 boots and CONFIG_PROVELOCKING does not give any
>> > warnings about this, though it does yell when switching governor as reported
>> > by others in bug #13493.
>> >
>> > Let's hope Mathieu nails it, though I know he's busy with his thesis.
>> >
>>
>> Thanks for the lockdep reports,
>>
>> I'm currently looking into it, and it's not pretty. Basically we have :
>>
>> A
>>   B
>> (means B nested in A)
>>
>> work
>>   read rwlock policy
>>
>> dbs_mutex
>>   work
>>     read rwlock policy
>>
>> write rwlock policy
>>   dbs_mutex
>>
>> So the added dbs_mutex <- work <- rwlock policy dependency (for proper
>> teardown) is firing the reverse dependency between policy rwlock and
>> dbs_mutex.
>>
>> The real way to fix this is to do not take the rwlock policy around
>> non-policy-related actions, like governor START/STOP doing worker
>> creation/teardown.
>>
>> One simple short-term solution would be to take a mutex outside of the
>> policy rwlock write lock in cpufreq.c. This mutex would be the
>> equivalent of dbs_mutex "lifted" outside of the rwlock write lock. For
>> teardown, we only need to hold this mutex, not the rwlock write lock.
>> Then we can remove the dbs_mutex from the governors.
>>
>> But looking at cpufreq.c's cpufreq_add_dev() is very much like kicking a
>> wasp nest: a lot of error paths are not handled properly, and I fear
>> someone will have to go through the code, fix the currently incorrect
>> code paths, and then add the lifted mutex.
>>
>> I currently have no time for implementation due to my thesis, but I'll
>> be happy to review a patch.
>>
>
> How about below patch on top of Mathieu's patch here
> http://marc.info/?l=linux-kernel&m=124448150529838&w=2
>
> [PATCH] cpufreq: Eliminate lockdep issue with dbs_mutex and policy_rwsem
>
> This removes the unneeded dependency of
> write rwlock policy
>  dbs_mutex
>
> dbs_mutex does not have anything to do with timer_init and timer_exit. It
> is just to protect dbs tunables in sysfs cpufreq/ondemand and is not
> needed to be held during timer init, exit as well as during governor limit
> changes.
>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---
>  drivers/cpufreq/cpufreq_ondemand.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)

latest linux-2.6 git + this patch, hibernate test result:

[  221.956815]
[  221.956817] =======================================================
[  221.957017] [ INFO: possible circular locking dependency detected ]
[  221.957173] 2.6.30-06692-g3fe0344-dirty #77
[  221.957276] -------------------------------------------------------
[  221.957431] 94cpufreq/1914 is trying to acquire lock:
[  221.957561]  (&(&dbs_info->work)->work){+.+...}, at: [<c1037f46>]
__cancel_work_timer+0x8c/0x18c
[  221.958034]
[  221.958036] but task is already holding lock:
[  221.958336]  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at:
[<c1284528>] lock_policy_rwsem_write+0x33/0x5b
[  221.958850]
[  221.958852] which lock already depends on the new lock.
[  221.958855]
[  221.959258]
[  221.959260] the existing dependency chain (in reverse order) is:
[  221.959625]
[  221.959627] -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
[  221.959994]        [<c1049d0f>] __lock_acquire+0x91e/0xaa9
[  221.959994]        [<c1049f35>] lock_acquire+0x9b/0xbe
[  221.959994]        [<c1335fed>] down_write+0x2f/0x4b
[  221.959994]        [<c1284528>] lock_policy_rwsem_write+0x33/0x5b
[  221.959994]        [<c1286097>] do_dbs_timer+0x45/0x23b
[  221.959994]        [<c103851e>] worker_thread+0x170/0x23c
[  221.959994]        [<c103ad8b>] kthread+0x45/0x6e
[  221.959994]        [<c1003dc7>] kernel_thread_helper+0x7/0x10
[  221.959994]        [<ffffffff>] 0xffffffff
[  221.959994]
[  221.959994] -> #0 (&(&dbs_info->work)->work){+.+...}:
[  221.959994]        [<c1049c1f>] __lock_acquire+0x82e/0xaa9
[  221.959994]        [<c1049f35>] lock_acquire+0x9b/0xbe
[  221.959994]        [<c1037f71>] __cancel_work_timer+0xb7/0x18c
[  221.959994]        [<c1038051>] cancel_delayed_work_sync+0xb/0xd
[  221.959994]        [<c1286484>] cpufreq_governor_dbs+0x1f7/0x263
[  221.959994]        [<c1283b13>] __cpufreq_governor+0x66/0x9d
[  221.959994]        [<c1283c89>] __cpufreq_set_policy+0x13f/0x1c3
[  221.959994]        [<c1284151>] store_scaling_governor+0x159/0x188
[  221.959994]        [<c1284d12>] store+0x42/0x5b
[  221.959994]        [<c10d783d>] sysfs_write_file+0xb8/0xe3
[  221.959994]        [<c109937e>] vfs_write+0x82/0xdc
[  221.959994]        [<c109946d>] sys_write+0x3b/0x5d
[  221.959994]        [<c100331d>] syscall_call+0x7/0xb
[  221.959994]        [<ffffffff>] 0xffffffff
[  221.959994]
[  221.959994] other info that might help us debug this:
[  221.959994]
[  221.959994] 2 locks held by 94cpufreq/1914:
[  221.959994]  #0:  (&buffer->mutex){+.+.+.}, at: [<c10d77aa>]
sysfs_write_file+0x25/0xe3
[  221.959994]  #1:  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at:
[<c1284528>] lock_policy_rwsem_write+0x33/0x5b
[  221.959994]
[  221.959994] stack backtrace:
[  221.959994] Pid: 1914, comm: 94cpufreq Not tainted
2.6.30-06692-g3fe0344-dirty #77
[  221.959994] Call Trace:
[  221.959994]  [<c1048895>] print_circular_bug_tail+0x5d/0x68
[  221.959994]  [<c1049c1f>] __lock_acquire+0x82e/0xaa9
[  221.959994]  [<c1048415>] ? mark_lock+0x1e/0x1c7
[  221.959994]  [<c1049f35>] lock_acquire+0x9b/0xbe
[  221.959994]  [<c1037f46>] ? __cancel_work_timer+0x8c/0x18c
[  221.959994]  [<c1037f71>] __cancel_work_timer+0xb7/0x18c
[  221.959994]  [<c1037f46>] ? __cancel_work_timer+0x8c/0x18c
[  221.959994]  [<c1048601>] ? mark_held_locks+0x43/0x5b
[  221.959994]  [<c1335972>] ? __mutex_unlock_slowpath+0xf1/0x101
[  221.959994]  [<c104876a>] ? trace_hardirqs_on+0xb/0xd
[  221.959994]  [<c1038051>] cancel_delayed_work_sync+0xb/0xd
[  221.959994]  [<c1286484>] cpufreq_governor_dbs+0x1f7/0x263
[  221.959994]  [<c103e02b>] ? up_read+0x16/0x29
[  221.959994]  [<c1283b13>] __cpufreq_governor+0x66/0x9d
[  221.959994]  [<c1283c89>] __cpufreq_set_policy+0x13f/0x1c3
[  221.959994]  [<c1283ff8>] ? store_scaling_governor+0x0/0x188
[  221.959994]  [<c1284151>] store_scaling_governor+0x159/0x188
[  221.959994]  [<c1284659>] ? handle_update+0x0/0x28
[  221.959994]  [<c1284528>] ? lock_policy_rwsem_write+0x33/0x5b
[  221.959994]  [<c1283ff8>] ? store_scaling_governor+0x0/0x188
[  221.959994]  [<c1284d12>] store+0x42/0x5b
[  221.959994]  [<c10d783d>] sysfs_write_file+0xb8/0xe3
[  221.959994]  [<c109937e>] vfs_write+0x82/0xdc
[  221.959994]  [<c10d7785>] ? sysfs_write_file+0x0/0xe3
[  221.959994]  [<c109946d>] sys_write+0x3b/0x5d
[  221.959994]  [<c100331d>] syscall_call+0x7/0xb
[  222.336101] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[  222.340205] PM: Basic memory bitmaps created
[  222.344226] PM: Syncing filesystems ... done.
>
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index e741c33..1c94ff5 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -352,8 +352,8 @@ static ssize_t store_powersave_bias(struct cpufreq_policy *unused,
>
>        mutex_lock(&dbs_mutex);
>        dbs_tuners_ins.powersave_bias = input;
> -       ondemand_powersave_bias_init();
>        mutex_unlock(&dbs_mutex);
> +       ondemand_powersave_bias_init();
>
>        return count;
>  }
> @@ -626,14 +626,14 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>
>                        dbs_tuners_ins.sampling_rate = def_sampling_rate;
>                }
> +               mutex_unlock(&dbs_mutex);
>                dbs_timer_init(this_dbs_info);
>
> -               mutex_unlock(&dbs_mutex);
>                break;
>
>        case CPUFREQ_GOV_STOP:
> -               mutex_lock(&dbs_mutex);
>                dbs_timer_exit(this_dbs_info);
> +               mutex_lock(&dbs_mutex);
>                sysfs_remove_group(&policy->kobj, &dbs_attr_group);
>                dbs_enable--;
>                mutex_unlock(&dbs_mutex);
> @@ -641,14 +641,12 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>                break;
>
>        case CPUFREQ_GOV_LIMITS:
> -               mutex_lock(&dbs_mutex);
>                if (policy->max < this_dbs_info->cur_policy->cur)
>                        __cpufreq_driver_target(this_dbs_info->cur_policy,
>                                policy->max, CPUFREQ_RELATION_H);
>                else if (policy->min > this_dbs_info->cur_policy->cur)
>                        __cpufreq_driver_target(this_dbs_info->cur_policy,
>                                policy->min, CPUFREQ_RELATION_L);
> -               mutex_unlock(&dbs_mutex);
>                break;
>        }
>        return 0;
> --
> 1.6.0.6
>
>



-- 
Regards
dave
